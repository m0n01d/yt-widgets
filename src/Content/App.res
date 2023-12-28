open Webapi
open Webapi.Dom
open Belt
let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
let document = Window.document(Dom.window)
let dummy = Document.createElement(document, "div")

type page = Details | Other

type msg = SetPage(page)

//ytcp-uploads-dialog
type model = {currentPage: page, maybeUploadDialog: option<Dom.Element.t>}

let update = (state: model, action: msg) => {
  switch action {
  | SetPage(thePage) => {...state, currentPage: thePage}
  }
}
let bodyEl =
  document->Document.asHtmlDocument->Option.flatMap(HtmlDocument.body)->Option.getWithDefault(dummy)

let app = Document.querySelector(document, "title")->Option.map(titleEl => {
  module App = {
    @react.component
    let make = () => {
      let initialState = {currentPage: Other, maybeUploadDialog: None}
      let (state, dispatch) = React.useReducer(update, initialState)

      let onMessageListener = port => {
        Js.log(port)
      }
      let port = Chrome.Runtime.connect({name: "yt-widgets-content"})
      Chrome.Runtime.Port.addListener(port, onMessageListener)

      let titleElWatcher = (mutationList: array<MutationRecord.t>, observer) => {
        Js.log2("title changed", mutationList)
        let title =
          mutationList
          ->Array.get(0)
          ->Option.map(MutationRecord.target)
          ->Option.mapWithDefault("", Node.textContent)

        let route = Js.String.split(" - ", title)
        Js.log2("route", route)

        switch route {
        | ["Video details", _] => dispatch(SetPage(Details))
        | _ => dispatch(SetPage(Other))
        }
      }
      let bodyWatcher = (mutationList, observer) => {
        let dialog_ = mutationList->Array.get(0)
        let dialog = mutationList->Array.some(mutation => {
          let node = MutationRecord.target(mutation)
          let name = node->Node.nodeName->Js.String.toLowerCase

          "ytcp-uploads-dialog" == name
        })

        Js.log2("body", dialog)
      }

      React.useEffect0(() => {
        let bodyObserver = MutationObserver.make(bodyWatcher)
        let titleObserver = MutationObserver.make(titleElWatcher)
        MutationObserver.observe(bodyObserver, bodyEl, observerConfig)
        MutationObserver.observe(titleObserver, titleEl, observerConfig)
        let cleanup = () => {
          MutationObserver.disconnect(bodyObserver)
          MutationObserver.disconnect(titleObserver)
        }

        Some(cleanup)
      })
      let detailsPage = () => [<TitleChecker />]
      let widgets = switch state.currentPage {
      | Details => detailsPage()
      | _ => []
      }
      Js.log2("which widgets", widgets)

      React.array(widgets)
    }
  }

  let root = ReactDOM.Client.createRoot(dummy)
  ReactDOM.Client.Root.render(root, <App />)
})
