open Webapi.Dom

let query = _ => {
  Document.querySelectorAll(document, "ytd-browse #contents ytd-rich-grid-media")
  ->NodeList.toArray
  ->Array.map(el => Element.ofNode(el))
  ->Array.map(maybeEl => {
    switch maybeEl {
    | Some(el) => Promise.resolve(el)
    | None => Promise.reject(Error.make("Not Found")->Error.toException)
    }
  })
  ->Promise.all
  ->Promise.then(els => {
    if Array.length(els) == 0 {
      Promise.reject(Error.make("Not Found")->Error.toException)
    } else {
      Promise.resolve(els)
    }
  })
}

type model =
  | FlushedWithElements({thumbEl: Element.t, titleEl: Element.t})
  | GotElements({thumbEl: Element.t, titleEl: Element.t})
  | NoElements
module ThumbnailPreview = {
  @react.component
  let make = () => {
    let {maybePort, maybeThumbnailData} = Hooks.Preview.usePort("Home.Thumbnail.Preview")
    let (state, setState) = React.useState(_ => NoElements)
    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: ["Home.Thumbnail.Preview"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
      retry: ReactQuery.retry(#number(69)),
      retryDelay: ReactQuery.retryDelay(#number(333)),
    })

    React.useEffectOnEveryRender(() => {
      switch (state, maybeThumbnailData) {
      | (GotElements({thumbEl, titleEl}), Some(thumbnailData)) => {
          thumbEl->Element.setAttribute("src", thumbnailData.src)
          titleEl->Element.setInnerText(thumbnailData.title)
          setState(_ => FlushedWithElements({thumbEl, titleEl}))
        }
      | _ => ()
      }

      None
    })

    switch (state, queryResult) {
    | (_, {isError: true, error, _}) => Console.log(error)
    | (NoElements, {data: Some(videoElements)}) => {
        let index = Math.floor(Math.random() *. 4.0)->Float.toInt
        let videoElement = videoElements->Array.getUnsafe(index)
        let thumbEl = videoElement->Element.querySelector("ytd-thumbnail img")->Option.getExn
        let titleEl =
          videoElement
          ->Element.querySelector("#video-title-link yt-formatted-string")
          ->Option.getExn
        setState(_ => GotElements({thumbEl, titleEl}))
      }

    | _ => ()
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
