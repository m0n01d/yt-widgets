open Webapi.Dom

let ytSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />
type props = {text: string}
let moConfig = {"attributes": true, "childList": true, "subtree": true}

type model = UnderLimit | OverLimit

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
let make = (props: props) => {
  let maybeVideoTitleEl = Document.querySelector(Webapi.Dom.document, ytSelector)

  let maybeVideoTitleInput =
    maybeVideoTitleEl->Belt.Option.flatMap(el =>
      Element.querySelector(el, "ytcp-social-suggestion-input")
    )
  let initialModel = maybeVideoTitleInput->Belt.Option.mapWithDefault(UnderLimit, videoTitleEl => {
    if String.length(Element.innerText(videoTitleEl)) > 60 {
      OverLimit
    } else {
      UnderLimit
    }
  })
  let (state, setState) = React.useState(_ => initialModel)

  let view = switch state {
  | UnderLimit => <> </>
  | OverLimit => viewOverLimit
  }

  let watcher = (mutationList, observer) => {
    let textboxValue =
      mutationList
      ->Belt.Array.get(0)
      ->Belt.Option.map(mutation => MutationRecord.target(mutation))
      ->Belt.Option.map(el => Node.innerText(el))

    switch textboxValue {
    | Some(text) =>
      if String.length(text) > 60 {
        setState(_ => OverLimit)
        //Window.alert(Webapi.Dom.window, "title is too long")
      } else {
        setState(_ => UnderLimit)
      }
    //Js.log2("the text", text)
    | _ => Js.log("no")
    }

    Js.log2("from res", mutationList)
  }
  let observer = MutationObserver.make(watcher)

  switch (maybeVideoTitleEl, maybeVideoTitleInput) {
  | (Some(videoTitleEl), Some(videoTitleInput)) => {
      observer->MutationObserver.observe(videoTitleInput, moConfig)

      ReactDOM.createPortal(view, videoTitleEl)
    }
  | _ => <> </>
  }
}
