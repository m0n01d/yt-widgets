open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
module TitleChecker = {
  type model = OverLimit(float) | UnderLimit(float)

  let viewOverLimit =
    <div
      id="TitleChecker.viewOverLimit"
      style={ReactDOM.Style.make(
        ~color="#dc3545",
        ~fontSize="12px",
        ~padding="0.2rem 1rem",
        ~textAlign="right",
        (),
      )}>
      {React.string("Your title is a little long there, pal...")} // nice passive aggressive tone
    </div>
  @react.component
  let make = (): React.element => {
    let maybeVideoTitleEl = Document.querySelector(Webapi.Dom.document, "ytcp-video-title")
    let maybeVideoTitleInput =
      maybeVideoTitleEl->Belt.Option.flatMap(el =>
        Element.querySelector(el, "ytcp-social-suggestion-input")
      )

    let initialState = maybeVideoTitleInput->Belt.Option.mapWithDefault(
      UnderLimit(0.0),
      videoTitleEl => {
        let len = Belt.Int.toFloat(String.length(Element.innerText(videoTitleEl)))
        if len > 60.0 {
          OverLimit(len)
        } else {
          UnderLimit(len)
        }
      },
    )
    let (state, setState) = React.useState(_ => initialState)

    let viewProgress = (len: float) => {
      let w_ = len /. 60.0 *. 100.0
      let w = Js.Math.min_float(w_, 100.0)
      let width = Belt.Float.toString(w) ++ "%"
      let backgroundColor = if len > 60.0 {
        "red"
      } else if len > 42.0 {
        "yellow"
      } else {
        "green"
      }

      <div id="TitleChecker.progress">
        <div style={ReactDOM.Style.make(~height="2px", ~width, ~backgroundColor, ())} />
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
        ->Belt.Array.get(0) // get the Head of the mutations returns a MutationRecord
        ->Belt.Option.map(mutation => MutationRecord.target(mutation)) // returns a Node
        ->Belt.Option.map(el => Node.innerText(el)) // get the text from the Node
        ->Belt.Option.mapWithDefault(0.0, text => Belt.Int.toFloat(String.length(text)))

      if textboxLen > 60.0 {
        setState(_ => OverLimit(textboxLen))
      } else {
        setState(_ => UnderLimit(textboxLen))
      }
    }
    let observer = MutationObserver.make(watcher)

    React.useEffect(() => {
      let cleanup = () => {
        MutationObserver.disconnect(observer)
      }

      Some(cleanup)
    })

    let asyncTimeout = () => {
      Js.Promise2.make((~resolve, ~reject) => {
        let x = Js.Global.setTimeout(_ => resolve(. None), 1000)
      })
    }

    let rec queryDomHelp = async (n): promise<Dom.element> => {
      Js.log("waiting...")
      let x = await asyncTimeout()
      Js.log("querying...")
      let maybeVideoTitleEl: option<Dom.element> = Document.querySelector(
        Webapi.Dom.document,
        "ytcp-video-title",
      )
      switch maybeVideoTitleEl {
      | Some(el) => Js.Promise2.resolve(el)
      | None => await queryDomHelp(n - 1)
      }
    }

    let queryDom = _ => {
      queryDomHelp(3)->Js.Promise2.then(el => el)
    }
    let queryResult = ReactQuery.useQuery({
      queryFn: queryDom,
      queryKey: ["todos"],
      /*
       * Helper functions to convert unsupported TypeScript types in ReScript
       * Check out the module ReactQuery_Utils.res
       */
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
    })
    Js.log2("query", queryResult)
    <div>
      {switch queryResult {
      | {isLoading: true} => "Loading..."->React.string
      | {data: Some(videoTitleEl), isLoading: false, isError: false} => {
          let maybeVideoTitleInput = Element.querySelector(
            videoTitleEl,
            "ytcp-social-suggestion-input",
          )

          switch maybeVideoTitleInput {
          | Some(videoTitleInput) => {
              MutationObserver.observe(observer, videoTitleInput, observerConfig)
              ReactDOM.createPortal(view, videoTitleEl)
            }
          | _ => <> </>
          }
        }
      | _ => `Unexpected error...`->React.string
      }}
    </div>
  }
}

let client = ReactQuery.Provider.createClient()

@react.component
let make = () => {
  Js.log("title check me pls")
  <ReactQuery.Provider client>
    <TitleChecker />
  </ReactQuery.Provider>
}
