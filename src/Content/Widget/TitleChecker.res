open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}

let query = maybeUploadDialog => _ => {
  let videoTitleElQuery =
    Ui.queryDom(maybeUploadDialog, "ytcp-video-title", 5)->Js.Promise2.then(el => el)
  let videoTitleInputElQuery =
    Ui.queryDom(maybeUploadDialog, "ytcp-social-suggestion-input", 5)->Js.Promise2.then(el => el)
  Js.Promise2.all([videoTitleElQuery, videoTitleInputElQuery])
}
let ytSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />
type model = OverLimit(float) | UnderLimit(float)

let viewOverLimit =
  <div
    id="TitleChecker.view"
    style={ReactDOM.Style.make(
      ~color="#dc3545",
      ~fontSize="12px",
      ~padding="0.2rem 1rem",
      ~textAlign="right",
      (),
    )}>
    {React.string("Your title is a little long there, pal...")} // nice passive aggressive tone
  </div>

module TitleChecker = {
  @react.component
  let make = (~maybeUploadDialog: option<Dom.element>): React.element => {
    let (state, setState) = React.useState(_ => UnderLimit(0.0))

    let viewProgress = (len: float) => {
      let w_ = len /. 60.0 *. 100.0
      let w = Js.Math.min_float(w_, 100.0)
      let backgroundColor: string = if len > 60.0 {
        Mui.Colors.red["500"]
      } else if len > 42.0 {
        Mui.Colors.yellow["300"]
      } else {
        Mui.Colors.green["300"]
      }
      <Mui.LinearProgress
        sx={Mui.Sx.array([
          Mui.Sx.Array.obj({
            color: Mui.System.Value.String(backgroundColor),
          }),
        ])}
        color=Inherit
        value={Float.toInt(w)}
        variant=Determinate
      />
    }

    let view = {
      let children = switch state {
      | OverLimit(len) => [viewProgress(len), viewOverLimit]
      | UnderLimit(len) => [viewProgress(len)]
      }
      React.array(children)
    }

    let watcher = (mutationList, observer) => {
      let textboxLen: float =
        mutationList
        ->Array.get(0) // get the Head of the mutations returns a MutationRecord
        ->Option.map(mutation => MutationRecord.target(mutation)) // returns a Node
        ->Option.map(el => Node.innerText(el)) // get the text from the Node
        ->Option.mapWithDefault(0, text => String.length(text))
        ->Int.toFloat

      if textboxLen > 60.0 {
        setState(_ => OverLimit(textboxLen))
      } else {
        setState(_ => UnderLimit(textboxLen))
      }
    }
    let observer = MutationObserver.make(watcher)

    let queryResult = ReactQuery.useQuery({
      queryFn: query(maybeUploadDialog),
      queryKey: ["titlechecker"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
    })

    switch queryResult {
    | {isLoading: true} => "Loading..."->React.string
    | {data: Some([videoTitleEl, videoTitleInput]), isLoading: false, isError: false} => {
        let initialState = {
          let len: float = Int.toFloat(String.length(Element.innerText(videoTitleInput)))
          if len > 60.0 {
            OverLimit(len)
          } else {
            UnderLimit(len)
          }
        }
        if initialState != state {
          setState(_ => initialState)
        }

        MutationObserver.observe(observer, videoTitleInput, observerConfig)
        ReactDOM.createPortal(view, videoTitleEl)
      }
    }
  }
}

let client = ReactQuery.Provider.createClient()

@react.component
let make = (~maybeUploadDialog) => {
  <ReactQuery.Provider client>
    <TitleChecker maybeUploadDialog />
  </ReactQuery.Provider>
}
