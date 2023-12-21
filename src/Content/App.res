open Webapi
open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
let document = Window.document(Dom.window)

let dummy = Document.createElement(document, "div")
let documentTitle_ = Document.querySelector(document, "title")
let documentTitle = documentTitle_->Belt.Option.getWithDefault(dummy)

type page = Details | Other
type model = {currentPage: page}

type msg = SetPage(page) | NoOp

let update = (state: model, action: msg) => {
  switch action {
  | SetPage(thePage) => {currentPage: thePage}
  | NoOp => state
  }
}
module App = {
  @react.component
  let make = () => {
    let initialState = {currentPage: Other}
    let (state, dispatch) = React.useReducer(update, initialState)
    let onMessageListener = port => {
      Js.log2("App is listening for Chrome Messages", port)
    }
    let watcher = (mutationList, observer) => {
      let title =
        mutationList
        ->Belt.Array.get(0)
        ->Belt.Option.map(MutationRecord.target)
        ->Belt.Option.mapWithDefault("", Node.textContent)

      let t = Js.String.split(" - ", title)

      switch t {
      | ["Video details", _] => {
          let x = Js.Global.setTimeout(() => dispatch(SetPage(Details)), 1000)
        }
      | _ => ()
      }
    }

    let port = Chrome.Runtime.connect({name: "yt-widgets-content"})
    Chrome.Runtime.Port.addListener(port, onMessageListener)

    let observer = MutationObserver.make(watcher)
    React.useEffect(() => {
      let cleanup = () => {
        MutationObserver.disconnect(observer)
      }

      Some(cleanup)
    })

    let widgets = switch state.currentPage {
    | Details => {
        Js.log("details")
        [<TitleChecker />]
      }
    | _ => []
    }
    MutationObserver.observe(observer, documentTitle, observerConfig)

    React.array(widgets)
  }
}

let root = ReactDOM.Client.createRoot(dummy)
ReactDOM.Client.Root.render(root, <App />)
