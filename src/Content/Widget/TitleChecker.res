open Webapi.Dom
open Belt
@module external colors: 'a = "@mui/material/colors"

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
let pause = () => {
  Js.Promise2.make((~resolve, ~reject) => {
    let wait = Js.Global.setTimeout(_ => resolve(. None), 500)
  })
}

exception TestError(string)

let rec queryDomHelp = async (maybeAncestor, selector, n): promise<Dom.element> => {
  if n < 0 {
    Js.Promise2.reject(TestError("Not Found"))
  } else {
    let wait = await pause()
    let maybeEl: option<Dom.element> = maybeAncestor->Option.mapWithDefault(
      Document.querySelector(document, selector),
      dialog => {
        dialog->Element.querySelector(selector)
      },
    )
    switch maybeEl {
    | None => await queryDomHelp(maybeAncestor, selector, n - 1)
    | Some(el) => Js.Promise2.resolve(el)
    }
  }
}
let query = (maybeUploadDialog, _) => {
  let videoTitleElQuery =
    queryDomHelp(maybeUploadDialog, "ytcp-video-title", 5)->Js.Promise2.then(el => el)
  let videoTitleInputElQuery =
    queryDomHelp(maybeUploadDialog, "ytcp-social-suggestion-input", 5)->Js.Promise2.then(el => el)
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
      let width = Float.toString(w) ++ "%"
      let backgroundColor = if len > 60.0 {
        colors["red"]["500"]
      } else if len > 42.0 {
        colors["yellow"]["300"]
      } else {
        colors["green"]["300"]
      }
      <div style={ReactDOM.Style.make(~color=backgroundColor, ())}>
        <Ui.LinearProgress color="inherit" value=w variant="determinate" />
      </div>
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
