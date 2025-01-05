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

module YouTubeStudioApp = {
  // @TODO add Upload module
  // basically same as video edit
  module VideoEdit = {
    type model = {maybeUploadDialog: option<Dom.Node.t>}
    type msg = RemovedDialog | SetDialog(Dom.Node.t)
    @react.component
    let make = () => {
      let bodyEl =
        document
        ->Document.asHtmlDocument
        ->Option.flatMap(HtmlDocument.body)
        ->Option.getWithDefault(dummy) // unwrap

      let update = (state: model, action: msg) => {
        switch action {
        | RemovedDialog => {...state, maybeUploadDialog: None}
        | SetDialog(dialog) => {...state, maybeUploadDialog: Some(dialog)}
        }
      }
      let initialState = {
        maybeUploadDialog: None,
      }
      let (state, dispatch) = React.useReducer(update, initialState)

      let bodyWatcher = (mutationList, observer) => {
        let dialog = mutationList->Array.forEach(mutation => {
          let hasRemovedDialog =
            MutationRecord.removedNodes(mutation)
            ->Dom.NodeList.toArray
            ->Js.Array2.some(el => {
              let name = el->Node.nodeName->Js.String.toLowerCase
              name == "ytcp-uploads-dialog"
            })

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

      React.useEffect0(() => {
        let bodyObserver = MutationObserver.make(bodyWatcher)
        MutationObserver.observe(
          bodyObserver,
          bodyEl,
          {"attributes": true, "childList": true, "subtree": true},
        )

        let cleanup = () => {
          MutationObserver.disconnect(bodyObserver)
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
      let widgets = switch state.maybeUploadDialog {
      // @TODO fix
      | None => detailsPage()
      | Some(dialog) => dialogWidgets(dialog)
      | _ => []
      }

      React.array(widgets)
    }
  }
}

module App = {
  type studioPage = VideoEdit | StudioRoot
  type consumerPage = ConsumerRoot
  type app = Studio(studioPage) | Consumer(consumerPage)
  @react.component
  let make = () => {
    let (page, setPage) = React.useState(_ => Consumer(ConsumerRoot))
    let app =
      window->Window.location->Location.host->String.includes("studio")
        ? Studio(StudioRoot)
        : Consumer(ConsumerRoot)
    let youtubeUrl = RescriptReactRouter.useUrl()
    let watcher = RescriptReactRouter.watchUrl(youtubeUrl => {
      switch (app, youtubeUrl) {
      | (Consumer(_), {path: list{""}, _}) => setPage(_ => Consumer(ConsumerRoot))
      | (Studio(_), {path: list{""}, _}) => setPage(_ => Studio(StudioRoot))
      | (Studio(_), {path: list{"video", _, "edit"}}) => setPage(_ => Studio(VideoEdit))
      | _ => ()
      }
    })

    switch app {
    | Consumer(_) => <Home.ThumbnailPreview />
    | Studio(StudioRoot) => <YouTubeStudioApp.VideoEdit />
    | Studio(VideoEdit) => <YouTubeStudioApp.VideoEdit />
    | _ => React.null
    }
  }
}

let root = ReactDOM.Client.createRoot(dummy)
ReactDOM.Client.Root.render(
  root,
  <Mui.ThemeProvider theme=Func(theme)>
    <App />
  </Mui.ThemeProvider>,
)
