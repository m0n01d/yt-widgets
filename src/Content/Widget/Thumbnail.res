open Webapi.Dom
open Belt

let sidePanelSelector = "ytcp-video-metadata-editor-sidepanel"
let thumbnailImgSelector = "ytcp-thumbnail-uploader img#img-with-fallback"
let stillPickerSelector = "#still-picker"

let query = _ => {
  [sidePanelSelector, stillPickerSelector, thumbnailImgSelector]
  ->Js.Array2.map(selector => Ui.queryDom(None, selector, 3)->Js.Promise2.then(el => el))
  ->Js.Promise2.all
}

type msg = SetImgSrc(string) | NoOp
type model = {maybeImgSrc: option<string>}
let update = (state: model, msg) =>
  switch msg {
  | NoOp => state
  | SetImgSrc(src) => {...state, maybeImgSrc: Some(src)}
  }
module Preview = {
  @react.component
  let make = () => {
    let initialState = {maybeImgSrc: None}
    let (state, dispatch) = React.useReducer(update, initialState)
    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: ["Thumbnail.Preview"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
    })

    let stillPickerWatcher = (mutationList, obs) => {
      //watch for stills to change `selected`
      Js.log2("still", mutationList)
      let maybeSelectedStill =
        mutationList
        ->Js.Array2.map(MutationRecord.target)
        ->Js.Array2.find(target => {
          let attribute =
            target
            ->Element.ofNode
            ->Option.flatMap(node => node->Element.getAttribute("aria-selected"))
          attribute == Some("true")
        })
        ->Option.flatMap(target => {
          target
          ->Element.ofNode
          ->Option.flatMap(el => Element.querySelector(el, "img"))
          ->Option.flatMap(img => img->Element.getAttribute("src"))
        })

      switch maybeSelectedStill {
      | Some(img) => dispatch(SetImgSrc(img))
      | None => ()
      }
      // if Some(selected) // query for nested img src
      // dispatch SetImgSrc
      Js.log2("att", maybeSelectedStill)

      //   MutationObserver.disconnect(obs)
    }
    React.useEffect0(() => {
      None
    })

    let view = state => {
      <div>
        {switch state.maybeImgSrc {
        | Some(src) => <img src />
        | None => React.null
        }}
      </div>
    }
    switch queryResult {
    | {data: Some([sidePanelEl, stillPickerEl, thumbnailImgEl]), _} => {
        Js.log("got em")
        let stillPickerObserver = MutationObserver.make(stillPickerWatcher)

        MutationObserver.observe(
          stillPickerObserver,
          stillPickerEl,
          {"attributes": true, "childList": true, "subtree": true},
        )

        ReactDOM.createPortal(view(state), sidePanelEl)
      }
    | _ => React.null
    }
  }
}

let client = ReactQuery.Provider.createClient()

@react.component
let make = () => {
  <ReactQuery.Provider client>
    <Preview />
  </ReactQuery.Provider>
}
