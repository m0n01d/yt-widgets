open Webapi.Dom
open Belt

// menu for switching between 3rds and swatch
let sidePanelSelector = "ytcp-video-metadata-editor-sidepanel"
let thumbnailImgSelector = "ytcp-thumbnail-uploader img#img-with-fallback"
let stillPickerSelector = "#still-picker"

let query = _ => {
  [sidePanelSelector, stillPickerSelector, thumbnailImgSelector]
  ->Js.Array2.map(selector => Ui.queryDom(None, selector, 3)->Js.Promise2.then(el => el))
  ->Js.Promise2.all
}

type msg = SetThumbnailEl(Dom.element) | SetImgSrc(string) | NoOp
type model = {maybeThumbnailEl: option<Dom.element>, maybeImgSrc: option<string>}

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
  <div>
    {switch state.maybeImgSrc {
    | Some(src) => <img src />
    | None => React.null
    }}
  </div>
}

let update = (state: model, msg) =>
  switch msg {
  | NoOp => state
  | SetThumbnailEl(el) => {...state, maybeThumbnailEl: Some(el)}
  | SetImgSrc(src) => {...state, maybeImgSrc: Some(src)}
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
    let stillPickerWatcher = (mutationList, obs) => {
      mutationList->Js.Array2.forEach(mutation => {
        let target = MutationRecord.target(mutation)
        let node = Element.ofNode(target)
        let name = target->Node.nodeName
        let attr = MutationRecord.attributeName(mutation)
        let uploaderIsSelected = node->Option.flatMap(el => el->Element.getAttribute("selected"))
        let isSelected = node->Option.flatMap(node => node->Element.getAttribute("aria-selected"))
        switch (name, uploaderIsSelected, attr, node == state.maybeThumbnailEl, isSelected) {
        | ("YTCP-THUMBNAIL-UPLOADER", Some(""), Some("selected"), _, _) =>
          let src =
            node
            ->Option.flatMap(el => Element.querySelector(el, "img"))
            ->Option.flatMap(img => img->Element.getAttribute("src"))
          src->Option.mapWithDefault((), src => dispatch(SetImgSrc(src)))
        | (_, _, _, _, Some("true")) => {
            let src =
              node
              ->Option.flatMap(el => Element.querySelector(el, "img"))
              ->Option.flatMap(img => img->Element.getAttribute("src"))
            src->Option.mapWithDefault((), src => dispatch(SetImgSrc(src)))
          }
        | (_, _, Some("src"), true, _) =>
          state.maybeThumbnailEl
          ->Option.flatMap(el => el->Element.getAttribute("src"))
          ->Option.mapWithDefault((), src => dispatch(SetImgSrc(src)))
        | _ => ()
        }
      })
    }

    React.useEffect0(() => {
      None
    })

    let view = state => {
      <div>
        {switch state.maybeImgSrc {
        | Some(src) => viewThumbnail(src)
        | None => React.null
        }}
      </div>
    }
    Js.log2("q", queryResult)
    switch queryResult {
    | {data: Some([sidePanelEl, stillPickerEl, thumbnailImgEl]), _} => {
        if None == state.maybeThumbnailEl {
          dispatch(SetThumbnailEl(thumbnailImgEl))
        }
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
