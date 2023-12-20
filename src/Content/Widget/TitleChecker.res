open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
type model = OverLimit(float) | UnderLimit(float)
type props = {text: string}

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
let make = (props: props): React.element => {
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

  switch (maybeVideoTitleEl, maybeVideoTitleInput) {
  | (Some(videoTitleEl), Some(videoTitleInput)) => {
      MutationObserver.observe(observer, videoTitleInput, observerConfig)
      ReactDOM.createPortal(view, videoTitleEl)
    }
  | _ => <> </>
  }
}
