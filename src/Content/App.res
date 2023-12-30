open Webapi
open Webapi.Dom
open Belt
let observerConfig = {
  "attributes": false,
  "childList": false,
  "subtree": false,
}
let document = Window.document(Dom.window)
let dummy = Document.createElement(document, "div")

type page = Details | Other

type msg = RemovedDialog | SetDialog(Dom.Node.t) | SetPage(page)

//ytcp-uploads-dialog
type model = {currentPage: page, maybeUploadDialog: option<Dom.Node.t>}

let update = (state: model, action: msg) => {
  switch action {
  | RemovedDialog => {...state, maybeUploadDialog: None}
  | SetDialog(dialog) => {...state, maybeUploadDialog: Some(dialog)}
  | SetPage(thePage) => {...state, maybeUploadDialog: None, currentPage: thePage}
  }
}

let app = Document.querySelector(document, "title")->Option.map(titleEl => {
  module App = {
    let bodyEl =
      document
      ->Document.asHtmlDocument
      ->Option.flatMap(HtmlDocument.body)
      ->Option.getWithDefault(dummy)

    @react.component
    let make = () => {
      let title = titleEl->Element.textContent
      let route = Js.String.split(" - ", title)
      let initialPage = switch route {
      | ["Video details", _] => Details
      | _ => Other
      }
      let initialState = {currentPage: initialPage, maybeUploadDialog: None}
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
        mutationList->Array.forEach(mutation => {
          let hasRemovedDialog =
            MutationRecord.removedNodes(mutation)
            ->Dom.NodeList.toArray
            ->Js.Array2.some(
              el => {
                let name = el->Node.nodeName->Js.String.toLowerCase
                name == "ytcp-uploads-dialog"
              },
            )
          if hasRemovedDialog {
            dispatch(RemovedDialog)
          } else {
            let target = MutationRecord.target(mutation) // it can only be the target if its added to the dom
            let name = target->Node.nodeName->Js.String.toLowerCase->Some

            let attributeName = MutationRecord.attributeName(mutation)
            let attribute =
              target
              ->Element.ofNode
              ->Option.flatMap(node => node->Element.getAttribute("workflow-step"))

            switch [name, attributeName, attribute] {
            | [Some("ytcp-uploads-dialog"), Some("workflow-step"), Some("DETAILS")] =>
              dispatch(SetDialog(target))
            | _ => ()
            }
          }
        })

        // add listener for when dialog is closed.... to unset maybeDialog
      }

      React.useEffect0(() => {
        let bodyObserver = MutationObserver.make(bodyWatcher)
        let titleObserver = MutationObserver.make(titleElWatcher)
        MutationObserver.observe(
          bodyObserver,
          bodyEl,
          {"attributes": true, "childList": true, "subtree": true},
        )
        MutationObserver.observe(
          titleObserver,
          titleEl,
          {"attributes": false, "childList": true, "subtree": false},
        )

        // setup watcher for dialog....
        let cleanup = () => {
          MutationObserver.disconnect(bodyObserver)
          MutationObserver.disconnect(titleObserver)
        }

        Some(cleanup)
      })
      let detailsPage = () => [<TitleChecker maybeUploadDialog=None key="details-page" />]
      let widgets = switch (state.currentPage, state.maybeUploadDialog) {
      | (Details, None) => detailsPage()
      | (_, Some(d)) => [<TitleChecker maybeUploadDialog={Element.ofNode(d)} key="upload-dialog" />]
      | _ => []
      }

      React.array(widgets)
    }
  }

  let root = ReactDOM.Client.createRoot(dummy)
  ReactDOM.Client.Root.render(root, <App />)
})
