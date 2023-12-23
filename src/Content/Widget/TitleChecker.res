open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
let parentVideoTitleSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />
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
  let make = () => {
    Js.log("init title checker")
    let maybeVideoTitleEl = Document.querySelector(Webapi.Dom.document, parentVideoTitleSelector)
    let maybeVideoTitleInput =
      maybeVideoTitleEl->Belt.Option.flatMap(el =>
        Element.querySelector(el, "ytcp-social-suggestion-input")
      )

    Js.log2(maybeVideoTitleEl, maybeVideoTitleInput)

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

      <div>
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

    switch (maybeVideoTitleEl, maybeVideoTitleInput) {
    | (Some(videoTitleEl), Some(videoTitleInput)) => {
        MutationObserver.observe(observer, videoTitleInput, observerConfig)
        ReactDOM.createPortal(view, videoTitleEl)
      }
    | _ => <> </>
    }
  }
}
let pause = () => {
  Js.Promise2.make((~resolve, ~reject) => {
    let x = Js.Global.setTimeout(_ => resolve(. None), 333)
  })
}
exception TestError(string)

let rec queryDomHelp = async (selector, n): promise<Dom.element> => {
  Js.log3("n", n, selector)

  if n < 0 {
    Js.log3("n", n, selector)
    Promise.reject(TestError("huh"))
  } else {
    Js.log("waiting...")
    let wait = await pause()
    Js.log("querying...")
    let maybeVideoTitleEl: option<Dom.element> = Document.querySelector(
      Webapi.Dom.document,
      selector,
    )
    Console.log2(n, maybeVideoTitleEl)
    switch maybeVideoTitleEl {
    | Some(el) => Promise.resolve(el)
    | None => await queryDomHelp(selector, n - 1)
    }
  }
}

let videoTitleElQuery = queryDomHelp(parentVideoTitleSelector, 3)
let videoTitleInputQuery = queryDomHelp("ytcp-social-suggestion-input", 3)

let querySelectors = Promise.all([videoTitleElQuery, videoTitleInputQuery])

let queryAndLoad = querySelectors->Promise.then(_ => Promise.resolve(TitleChecker.make))
// let queryAndLoad = async () => {
//   let waiti = await asyncTimeout()

//   // Promise.resolve(TitleChecker.make)
//   TitleChecker.make
// }

let make = React.lazy_(() => queryAndLoad)
