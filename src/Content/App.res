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

type model = {currentPage: page}

let update = (state: model, action: msg) => {
  switch action {
  | SetPage(thePage) => {...state, currentPage: thePage}
  }
}

let app = Document.querySelector(document, "title")->Option.map(titleEl => {
  module App = {
    @react.component
    let make = () => {
      let initialState = {currentPage: Other}
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
      React.useEffect0(() => {
        let titleObserver = MutationObserver.make(titleElWatcher)
        MutationObserver.observe(titleObserver, titleEl, observerConfig)
        let cleanup = () => {
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
