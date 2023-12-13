open Webapi.Dom

let ytSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />
type props = {text: string}
let make = (props: props) => {
  let maybeVideoTitleEl = Document.querySelector(Webapi.Dom.document, ytSelector)
  //   let maybeVideoTitleInput = Document.querySelector("")
  let view = <div id="TitleChecker.view"> {React.string(props.text)} </div>

  //   let maybeVideoTitleInput = maybeVideoTitleEl
  //    -> Belt.Option.flatMap()

  let moConfig = {"attributes": false, "childList": true, "subtree": true}
  let watcher = (mutationList, observer) => {
    Js.log(mutationList)
  }
  let observer = MutationObserver.make(watcher)

  maybeVideoTitleEl->Belt.Option.mapWithDefault(<> </>, videoTitleEl => {
    // add mutation observer to watch videoTitleEl
    MutationObserver.observe(observer, videoTitleEl, moConfig)
    //ReactDOM.createPortal(view, videoTitleEl)
    <> </>
  })
}
