open Belt
open Webapi
open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
let document = Window.document(Dom.window)

module IntCmp = Belt.Id.MakeComparable({
  type t = int
  let cmp = (a, b) => Pervasives.compare(a, b)
})
let m = Belt.Map.make(~id=module(IntCmp))

let dummy = Document.createElement(document, "div")
let documentTitle_ = Document.querySelector(document, "title")
let documentTitle = documentTitle_->Belt.Option.getWithDefault(dummy)

type page = Details | Other
type widgies = Belt.Map.t<int, React.element, IntCmp.identity>

type model = {currentPage: page, widgetContainers: widgies}

type msg = AddWidgets(widgies) | SetPage(page) | NoOp

let update = (state: model, action: msg) => {
  switch action {
  | SetPage(thePage) => {...state, currentPage: thePage}
  | AddWidgets(parents) => {
      let ws: widgies = Belt.Map.merge(state.widgetContainers, parents, (key, maybeA, maybeB) => {
        maybeB
      })

      {
        ...state,
        widgetContainers: ws,
      }
    }
  | NoOp => state
  }
}

let app =
  document
  ->Document.asHtmlDocument
  ->Option.flatMap(document => document->HtmlDocument.body)
  ->Option.map(body => {
    module App = {
      @react.component
      let make = () => {
        let initialState = {currentPage: Other, widgetContainers: m}
        let (state, dispatch) = React.useReducer(update, initialState)
        let onMessageListener = port => {
          Js.log2("App is listening for Chrome Messages", port)
        }
        let port = Chrome.Runtime.connect({name: "yt-widgets-content"})
        Chrome.Runtime.Port.addListener(port, onMessageListener)

        let bodyWatcher = (mutationList, obsever) => {
          // Js.log(mutationList)
          // let x = mutationList->Belt.Array.map(el => Js.log2("el", el))
          let addedNodes = mutationList->Array.map(el => {
            el->MutationRecord.addedNodes->NodeList.toArray
          })
          let allNodes = Array.concatMany(addedNodes)
          let xs: widgies = allNodes->Js.Array2.reduce((widgets: widgies, node) => {
            // reduce here and match name to Widget
            let name = Js.String2.toLowerCase(Node.nodeName(node))
            switch name {
            | "ytcp-video-title" => {
                Js.log("hi")
                let w = Belt.Map.set(widgets, 0, <TitleChecker />)
                Js.log(w)
                w
              }

            // Js.log2("widget added", widgets)
            | _ => widgets
            }
          }, Belt.Map.make(~id=module(IntCmp)))

          if Belt.Map.size(xs) > 0 {
            dispatch(AddWidgets(xs))
          }
        }

        React.useEffect(() => {
          let bodyObserver = MutationObserver.make(bodyWatcher)
          MutationObserver.observe(bodyObserver, body, observerConfig)
          let cleanup = () => {
            MutationObserver.disconnect(bodyObserver)
          }

          Some(cleanup)
        })

        let widgets = Belt.Map.valuesToArray(state.widgetContainers)
        Js.log2("widigies", widgets)

        React.array(widgets)
      }
    }

    let root = ReactDOM.Client.createRoot(dummy)
    ReactDOM.Client.Root.render(root, <App />)
  })
