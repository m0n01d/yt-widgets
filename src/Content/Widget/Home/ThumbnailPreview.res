open Webapi.Dom
// let query = _ => {
//   ["ytd-browse #contents ytd-rich-item-renderer"]
//   ->Js.Array2.map(selector => Document.querySelectorAll(selector))->Js.Promise2.then(el => el))
//   ->Js.Promise2.all
// }
let query = _ => {
  Document.querySelectorAll(document, "ytd-browse #contents ytd-rich-item-renderer")
  ->NodeList.toArray
  ->Array.map(el => Element.ofNode(el))
  ->Array.map(maybeEl => {
    switch maybeEl {
    | Some(el) => Promise.resolve(el)
    | None => Promise.reject(Error.make("Not Found")->Error.toException)
    }
  })
  ->Promise.all
}
module ThumbnailPreview = {
  @react.component
  let make = () => {
    let {maybePort, maybeThumbnailData} = Hooks.Preview.usePort("Home.Thumbnail.Preview")
    let index = Math.floor(Math.random() *. 5.0)->Float.toInt
    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: ["Home.Thumbnail.Preview"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
      retry: ReactQuery.retry(#number(5)),
      retryDelay: ReactQuery.retryDelay(#number(1000)),
    })

    switch (maybeThumbnailData, queryResult) {
    | (_, {isError: true, error, _}) => Console.log(error)
    | (Some(thumbnailData), {data: Some(videoElements)}) => {
        let videoElement = videoElements->Array.getUnsafe(index)
        let thumb = videoElement->Element.querySelector("ytd-thumbnail img")->Option.getExn
        let title =
          videoElement
          ->Element.querySelector("#video-title-link yt-formatted-string")
          ->Option.getExn

        // move to useEffect

        Console.log2(thumbnailData, (thumb, title))
        thumb->Element.setAttribute("src", thumbnailData.src)
        title->Element.setInnerText(thumbnailData.title)
      }

    | _ => Console.log("no data")
    }
    React.null
  }
}

let client = ReactQuery.Provider.createClient()

@react.component
let make = () => {
  <ReactQuery.Provider client>
    <ThumbnailPreview />
  </ReactQuery.Provider>
}

// ytd-browse #contents ytd-rich-item-renderer ytd-thumbnail img
// ytd-browse #contents ytd-rich-item-renderer #video-title-link yt-formatted-string
//
// query for all  "ytd-browse #contents ytd-rich-item-renderer"
// randomly select one of the first 5 and swap its thumb and title
