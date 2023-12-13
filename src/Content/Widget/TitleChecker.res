open Webapi.Dom

@get external outerText: Webapi.Dom.Element.t => string = "outerText"

let ytSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />
type props = {text: string}
let make = (props: props) => {
  let maybeVideoTitleEl = Document.querySelector(Webapi.Dom.document, ytSelector)
  //   let maybeVideoTitleInput = Document.querySelector("")
  let view = <div id="TitleChecker.view"> {React.string(props.text)} </div>

  let maybeVideoTitleInput =
    maybeVideoTitleEl->Belt.Option.flatMap(el =>
      Element.querySelector(el, "ytcp-social-suggestion-input")
    )

  let moConfig = {"attributes": true, "childList": true, "subtree": true}
  let watcher = (mutationList, observer) => {
    let textboxValue =
      mutationList
      ->Belt.Array.get(0)
      ->Belt.Option.map(mutation => MutationRecord.target(mutation))
      ->Belt.Option.map(el => Node.innerText(el))

    switch textboxValue {
    | Some(text) => {
        if String.length(text) > 60 {
          Window.alert(Webapi.Dom.window, "title is too long")
        }
        Js.log2("the text", text)
      }
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
