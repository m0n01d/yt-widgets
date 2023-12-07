// Connect to chrome runtime
// listen for messages from Background
// load/unload Widgets as requested by Background

open Inject
type mConfig = {attributes: bool, childList: bool, subtree: bool}
@new external mutationObserver: 'a => 'b = "MutationObserver"

let config = {attributes: false, childList: true, subtree: true}

type page =
  | Dashboard
  | Content
  | Details

let pageFromString = str => {
  let s = Js.String.replace(" - YouTube Studio", "", str)

  switch s {
  | "Channel content" => Content
  }
}

let pageToString = page => {
  switch page {
  | Dashboard => "Dashboard"
  | Content => "Content"
  | Details => "Details"
  }
}

let pageToInt = page => {
  switch page {
  | Dashboard => 1
  | Content => 2
  | Details => 3
  }
}

type pageStatus =
  | Waiting // page hasn't loaded YTStudio app yet
  | AppReady(Dom.element)

type dialog = Upload

module StrCmp = Belt.Id.MakeComparable({
  type t = page
  let cmp = (a, b) => Pervasives.compare(pageToInt(a), pageToInt(b))
})
module Widget = {
  type t = Counter
}
let widgetToComponent = widget => {
  switch widget {
  | Widget.Counter => <Counter />
  }
}
type widgets = Js.Dict.t<array<Widget.t>>

type model = {
  currentPage: page,
  pageStatus: pageStatus,
  dialog: option<dialog>,
  widgets: widgets,
}

type msg =
  | ChangedPage(string)
  | YTStudioAppWasLoaded(Dom.element)

let reducer = (state, action: msg) => {
  switch action {
  | ChangedPage(page) => {...state, currentPage: pageFromString(page)}
  | YTStudioAppWasLoaded(titleEl) => {...state, pageStatus: AppReady(titleEl)}
  }
}

type appWasLoadedMeta = option<string>
module ViewWaiting = {
  @react.component
  let make = (~dispatch, ~el) => {
    let observer = mutationObserver((mutations, observer) => {
      let appWasLoaded: appWasLoadedMeta = Js.Array.reduce((acc, m) => {
        if m["target"]["nodeName"] == "YTCP-APP" {
          Some(m["target"]["nodeName"])
        } else {
          None
        }
      }, None, mutations)
      let foo = ReactDOM.querySelector("title")
      switch foo {
      | None => ()
      | Some(titleEl) =>
        observer["disconnect"](.)
        dispatch(YTStudioAppWasLoaded(titleEl))
      }
    })
    let watcher = observer["observe"](. el, config)
    <> </>
  }
}

module ViewWidgets = {
  @react.component
  let make = (~titleEl, ~dispatch, ~state) => {
    let observer = mutationObserver((mutations, observer) => {
      Js.log2("view title mutations", mutations)
      switch mutations {
      | [] => ()
      | [mutation] => dispatch(ChangedPage(mutation["target"]["text"]))
      }
    })
    let watcher = observer["observe"](.
      titleEl,
      {
        attributes: true,
        childList: true,
        subtree: false,
      },
    )
    switch Js.Dict.get(state.widgets, pageToString(state.currentPage)) {
    | None => <div> {React.string("LoadingWidgets")} </div>
    | Some(widgets) => {
        let components = widgets->Belt.Array.map(widgetToComponent)
        Js.log(components)
        {React.array(components)}
      }
    }
  }
}

module App = {
  @react.component
  let make = (~el) => {
    let x = pageToString(Dashboard)
    let widgets = Js.Dict.empty()
    widgets->Js.Dict.set(x, [Widget.Counter])

    let (state, dispatch) = React.useReducer(
      reducer,
      {
        currentPage: Dashboard,
        pageStatus: Waiting,
        dialog: None,
        widgets,
      },
    )

    <div>
      {switch state.pageStatus {
      | Waiting => <ViewWaiting dispatch el />
      | AppReady(titleEl) => <ViewWidgets titleEl dispatch state />
      }}
    </div>
  }
}

switch ReactDOM.querySelector("body") {
| Some(rootElement) =>
  let dummyEl = Inject.createInjectElement()
  let root = ReactDOM.Client.createRoot(dummyEl)
  ReactDOM.Client.Root.render(root, <App el=rootElement />)
| None => ()
}

/// long polling
/// watch for app to load
/// watch for title to change
/// filter apps based on title/page eg : 'Dashboard'

// filter apps to 'Dashboard'
// each compontnet start long pollling and mount if found after 3 tries to find parent

// does that cause memory leaks? can i unmount if parent is removed?
// store a dictionary of widgets based on Page, and render the current Page's widget
