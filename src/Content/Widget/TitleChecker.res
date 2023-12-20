open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
let ytSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />
type model = OverLimit | UnderLimit
type props = {text: string}

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
let make = (props: props): React.element => {
  let maybeVideoTitleEl = Document.querySelector(Webapi.Dom.document, ytSelector)
  let maybeVideoTitleInput =
    maybeVideoTitleEl->Belt.Option.flatMap(el =>
      Element.querySelector(el, "ytcp-social-suggestion-input")
    )

  Js.log2(maybeVideoTitleEl, maybeVideoTitleInput)

  let initialState = maybeVideoTitleInput->Belt.Option.mapWithDefault(UnderLimit, videoTitleEl => {
    if String.length(Element.innerText(videoTitleEl)) > 60 {
      OverLimit
    } else {
      UnderLimit
    }
  })
  let (state, setState) = React.useState(_ => initialState)

  let view = switch state {
  | OverLimit => viewOverLimit
  | UnderLimit => <> </>
  }

  let watcher = (mutationList, observer) => {
    let textboxLen =
      mutationList
      ->Belt.Array.get(0) // get the Head of the mutations returns a MutationRecord
      ->Belt.Option.map(mutation => MutationRecord.target(mutation)) // returns a Node
      ->Belt.Option.map(el => Node.innerText(el)) // get the text from the Node
      ->Belt.Option.mapWithDefault(0, text => String.length(text))

    if textboxLen > 60 {
      setState(_ => OverLimit)
    } else {
      setState(_ => UnderLimit)
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
