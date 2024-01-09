open Webapi.Dom
open Belt

let sidePanelSelector = "ytcp-video-metadata-editor-sidepanel"
let stillPickerSelector = "#still-picker"
let thumbnailImgSelector = "ytcp-thumbnail-uploader img#img-with-fallback"

let query = _ => {
  [sidePanelSelector, stillPickerSelector, thumbnailImgSelector]
  ->Js.Array2.map(selector => Ui.queryDom(None, selector, 3)->Js.Promise2.then(el => el))
  ->Js.Promise2.all
}

type model = {maybeThumbnailEl: option<Dom.element>, maybeImgSrc: option<string>}

type msg = SetImgSrc(string) | SetThumbnailEl(Dom.element)
let update = (state: model, action: msg) => {
  switch action {
  | SetImgSrc(src) => {...state, maybeImgSrc: Some(src)}
  | SetThumbnailEl(el) => {...state, maybeThumbnailEl: Some(el)}
  }
}

let viewThumbnail = src => {
  <div
    style={ReactDOM.Style.make(
      ~position="relative",
      ~width="320px",
      ~height="180px",
      ~margin="0 auto",
      (),
    )}>
    <img src />
    <span
      style={ReactDOM.Style.make(
        ~background="white",
        ~border="1px solid black",
        ~bottom="0",
        ~left="33%",
        ~position="absolute",
        ~top="0",
        ~width="2px",
        ~zIndex="1",
        (),
      )}
    />
    <span
      style={ReactDOM.Style.make(
        ~background="white",
        ~border="1px solid black",
        ~bottom="0",
        ~left="66%",
        ~position="absolute",
        ~top="0",
        ~width="2px",
        ~zIndex="1",
        (),
      )}
    />
    <span
      style={ReactDOM.Style.make(
        ~background="white",
        ~border="1px solid black",
        ~height="2px",
        ~left="0",
        ~position="absolute",
        ~right="0",
        ~top="33%",
        ~zIndex="1",
        (),
      )}
    />
    <span
      style={ReactDOM.Style.make(
        ~background="white",
        ~border="1px solid black",
        ~height="2px",
        ~left="0",
        ~position="absolute",
        ~right="0",
        ~top="66%",
        ~zIndex="1",
        (),
      )}
    />
  </div>
}
let view = state => {
  switch state.maybeImgSrc {
  | Some(src) => viewThumbnail(src)
  | None => React.null
  }
}

module Preview = {
  @react.component
  let make = () => {
    let initialImgSrc =
      document
      ->Document.querySelector(thumbnailImgSelector)
      ->Option.flatMap(img => img->Element.getAttribute("src"))

    let initialState = {maybeImgSrc: initialImgSrc, maybeThumbnailEl: None}
    let (state, dispatch) = React.useReducer(update, initialState)
    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: ["Thumbnail.Preview"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
    })

    let stillPickerWatcher = (mutationList, observer) => {
      mutationList->Js.Array2.forEach(mutation => {
        let target = mutation->MutationRecord.target
        let node = Element.ofNode(target)
        let name = target->Node.nodeName->Js.String2.toLocaleLowerCase
        let attrName = MutationRecord.attributeName(mutation)
        let isSelected = node->Option.flatMap(node => node->Element.getAttribute("aria-selected"))
        let uploaderIsSelected = node->Option.flatMap(el => el->Element.getAttribute("selected"))

        switch (name, attrName, uploaderIsSelected, node == state.maybeThumbnailEl, isSelected) {
        | ("ytcp-thumbnail-uploader", Some("selected"), Some(""), _, _)
        | (_, _, _, _, Some("true")) => {
            let src =
              node
              ->Option.flatMap(el => Element.querySelector(el, "img"))
              ->Option.flatMap(img => img->Element.getAttribute("src"))
            src->Option.mapWithDefault((), src => dispatch(SetImgSrc(src)))
          }
        | (_, Some("src"), _, true, _) =>
          state.maybeThumbnailEl
          ->Option.flatMap(el => el->Element.getAttribute("src"))
          ->Option.mapWithDefault((), src => dispatch(SetImgSrc(src)))
        | _ => ()
        }
      })
    }

    switch queryResult {
    | {data: Some([sidePanelEl, stillPickerEl, thumbnailImgEl]), _} => {
        if None == state.maybeThumbnailEl {
          dispatch(SetThumbnailEl(thumbnailImgEl))
        }
        Js.log("Hello thumbnail")
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
