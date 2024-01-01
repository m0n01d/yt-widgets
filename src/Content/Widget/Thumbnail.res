open Webapi.Dom
open Belt

let query = _ => {
  let sidePanelEl =
    Ui.queryDom(None, "ytcp-video-metadata-editor-sidepanel", 3)->Js.Promise2.then(el => el)
  Js.Promise2.all([sidePanelEl])
}

module Preview = {
  @react.component
  let make = () => {
    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: ["Thumbnail.Preview"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
    })

    let view = <div> {"This is a thumb"->React.string} </div>

    switch queryResult {
    | {data: Some([sidePanelEl]), _} => ReactDOM.createPortal(view, sidePanelEl)
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
