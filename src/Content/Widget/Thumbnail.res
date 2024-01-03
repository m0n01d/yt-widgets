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
  | SetImgSrc(src) => {...state, maybeImgSrc: Some(src)}
  }
module Preview = {
  @react.component
  let make = () => {
    let initialImgSrc =
      document
      ->Document.querySelector(thumbnailImgSelector)
      ->Option.flatMap(img => img->Element.getAttribute("src"))
    let initialState = {maybeImgSrc: initialImgSrc}
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
      // if nodename == 'TCP-THUMBNAIL-UPLOADER' and 'selected
      let hasSelectedUserThumbnail: bool = mutationList->Js.Array2.some(mutation => {
        let target = MutationRecord.target(mutation)
        let name = target->Node.nodeName->Js.String2.toLocaleLowerCase
        let attr = MutationRecord.attributeName(mutation)
        let isSelected =
          target->Element.ofNode->Option.map(el => el->Element.hasAttribute("selected"))
        Js.log3("asdf", name, isSelected)
        attr == Some("selected") && name == "ytcp-thumbnail-uploader" && isSelected == Some(true)
      })
      Js.log2("hasuserthumb", hasSelectedUserThumbnail)
      let maybeSelectedStill = if hasSelectedUserThumbnail {
        document
        ->Document.querySelector(thumbnailImgSelector)
        ->Option.flatMap(img => img->Element.getAttribute("src"))
      } else {
        mutationList
        ->Js.Array2.map(MutationRecord.target)
        ->Js.Array2.find(target => {
          let attribute =
            target
            ->Element.ofNode
            ->Option.flatMap(node => node->Element.getAttribute("aria-selected"))
          attribute == Some("true")
        })
        ->Option.flatMap(Element.ofNode)
        ->Option.flatMap(el => Element.querySelector(el, "img"))
        ->Option.flatMap(img => img->Element.getAttribute("src"))
      }

      switch (maybeSelectedStill: option<string>) {
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
        | Some(src) => viewThumbnail(src)
        | None => React.null
        }}
      </div>
    }
    switch queryResult {
    | {data: Some([sidePanelEl, stillPickerEl, thumbnailImgEl]), _} => {
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
