open Webapi
open Webapi.Dom

@module("@mui/material/colors")
external pink: 'a = "pink"

let theme = outerTheme =>
  Mui.Theme.create({
    ...outerTheme,
    palette: {
      primary: {
        main: pink["500"],
      },
      secondary: {
        main: "#9c27b0",
      },
    },
    typography: {fontSize: 16.0},
  })

let observerConfig = {
  "attributes": true,
  "childList": true,
  "subtree": true,
}
let document = Window.document(Dom.window)
let dummy = Document.createElement(document, "div")

type page = Details | Other

type msg = RemovedDialog | SetDialog(Dom.Node.t) | SetPage(page)

type model = {currentPage: page, maybeUploadDialog: option<Dom.Node.t>}

let update = (state: model, action: msg) => {
  switch action {
  | RemovedDialog => {...state, maybeUploadDialog: None}
  | SetDialog(dialog) => {...state, maybeUploadDialog: Some(dialog)}
  | SetPage(thePage) => {...state, currentPage: thePage}
  }
}

let app = Document.querySelector(document, "title")->Option.map(titleEl => {
  let bodyEl =
    document
    ->Document.asHtmlDocument
    ->Option.flatMap(HtmlDocument.body)
    ->Option.getWithDefault(dummy) // unwrap

  module App = {
    @react.component
    let make = () => {
      let pageTitle = titleEl->Element.textContent
      let route = Js.String.split(" - ", pageTitle)
      let initialPage = switch route {
      | ["Video details", _] => Details
      | _ => Other
      }
      let initialState = {
        currentPage: initialPage,
        maybeUploadDialog: None,
      }
      let (state, dispatch) = React.useReducer(update, initialState)

      let bodyWatcher = (mutationList, observer) => {
        let dialog = mutationList->Array.forEach(mutation => {
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
            let target = MutationRecord.target(mutation)
            let name = target->Node.nodeName->Js.String.toLocaleLowerCase->Some
            let attributeName = MutationRecord.attributeName(mutation)
            let attribute =
              target
              ->Element.ofNode
              ->Option.flatMap(node => node->Element.getAttribute("workflow-step"))

            switch [name, attributeName, attribute] {
            | [Some("ytcp-uploads-dialog"), Some("workflow-step"), Some("DETAILS")] => {
                Js.log("uploading!")
                dispatch(SetDialog(target))
              }
            | _ => ()
            }
          }
        })
      }

      let titleElWatcher = (mutationList: array<MutationRecord.t>, observer) => {
        let title =
          mutationList
          ->Array.get(0)
          ->Option.map(MutationRecord.target)
          ->Option.mapWithDefault("", Node.textContent)

        let route = Js.String.split(" - ", title)

        switch route {
        | ["Video details", _] => dispatch(SetPage(Details))
        | _ => dispatch(SetPage(Other))
        }
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
        let cleanup = () => {
          MutationObserver.disconnect(bodyObserver)
          MutationObserver.disconnect(titleObserver)
        }

        Some(cleanup)
      })
      let detailsPage = () => [
        <TitleChecker maybeUploadDialog=None key="details-page" />,
        <Thumbnail />,
        <Description />,
      ]
      let dialogWidgets = dialog => [
        <TitleChecker maybeUploadDialog={Element.ofNode(dialog)} key="upload-dialog" />,
        <Thumbnail />,
        <Description />,
      ]
      let widgets = switch (state.currentPage, state.maybeUploadDialog) {
      | (Details, None) => detailsPage()
      | (_, Some(dialog)) => dialogWidgets(dialog)
      | _ => []
      }

      React.array(widgets)
    }
  }

  let root = ReactDOM.Client.createRoot(dummy)
  ReactDOM.Client.Root.render(
    root,
    <Mui.ThemeProvider theme=Func(theme)>
      <App />
    </Mui.ThemeProvider>,
  )
})
