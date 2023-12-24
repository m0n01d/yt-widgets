open Webapi.Dom
open Belt

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}

let pause = () => {
  Js.Promise2.make((~resolve, ~reject) => {
    let x = Js.Global.setTimeout(_ => resolve(. None), 333)
  })
}
exception TestError(string)

let rec queryDomHelp = async (selector, n): promise<Dom.element> => {
  if n < 0 {
    Js.Promise2.reject(TestError("huh"))
  } else {
    let wait = await pause()
    let maybeEl: option<Dom.element> = Document.querySelector(Webapi.Dom.document, selector)
    switch maybeEl {
    | Some(el) => Js.Promise2.resolve(el)
    | None => await queryDomHelp(selector, n - 1)
    }
  }
}

let query = _ => {
  let videoTitleElQuery = queryDomHelp("ytcp-video-title", 5)->Js.Promise2.then(el => el)
  let videoTitleInputQuery =
    queryDomHelp("ytcp-social-suggestion-input", 5)->Js.Promise2.then(el => el)

  Js.Promise2.all([videoTitleElQuery, videoTitleInputQuery])
}
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

  <div>
    <div style={ReactDOM.Style.make(~height="2px", ~width, ~backgroundColor, ())} />
  </div>
}
module TitleChecker = {
  type model = OverLimit(float) | UnderLimit(float)

  @react.component
  let make = () => {
    let (state, setState) = React.useState(_ => UnderLimit(0.0))

    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: ["todos"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
    })

    let view = {
      let children = switch state {
      | OverLimit(len) => [viewProgress(len), viewOverLimit]
      | UnderLimit(len) => [viewProgress(len)]
      }
      React.array(children)
    }
    switch queryResult {
    | {isLoading: true} => "Loading..."->React.string
    | {data: Some([videoTitleEl, videoTitleInput]), isLoading: false, isError: false} => {
        let text = Element.innerText(videoTitleInput)
        let initialState = {
          let len = Belt.Int.toFloat(String.length(text))
          if len > 60.0 {
            OverLimit(len)
          } else {
            UnderLimit(len)
          }
        }

        if initialState != state {
          setState(_ => initialState)
        }
        let watcher = (mutationList, observer) => {
          let text = Element.innerText(videoTitleInput)

          let textboxLen = Belt.Int.toFloat(String.length(text))
          if textboxLen > 60.0 {
            setState(_ => OverLimit(textboxLen))
          } else {
            setState(_ => UnderLimit(textboxLen))
          }
          MutationObserver.disconnect(observer)
        }
        let observer = MutationObserver.make(watcher)
        MutationObserver.observe(observer, videoTitleInput, observerConfig)

        ReactDOM.createPortal(view, videoTitleEl)
      }
    | _ => <> </>
    }
  }
}

let client = ReactQuery.Provider.createClient()

@react.component
let make = () => {
  <ReactQuery.Provider client>
    <TitleChecker />
  </ReactQuery.Provider>
}
