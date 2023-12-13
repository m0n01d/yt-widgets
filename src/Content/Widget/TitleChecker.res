let ytSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />
type props = {text: string}
let make = (props: props) => {
  let maybeVideoTitleEl = ReactDOM.querySelector(ytSelector)
  let view = <div id="TitleChecker.view"> {React.string(props.text)} </div>

  maybeVideoTitleEl->Belt.Option.mapWithDefault(<> </>, videoTitleEl =>
    // add mutation observer to watch videoTitleEl
    ReactDOM.createPortal(view, videoTitleEl)
  )
}
