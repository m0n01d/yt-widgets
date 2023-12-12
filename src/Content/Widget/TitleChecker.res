let ytSelector = "ytcp-video-title"
type props = {text: string}
let make = (props: props) => {
  let maybeVideoTitleEl = ReactDOM.querySelector(ytSelector)
  let view = <div id="TitleChecker.view"> {React.string(props.text)} </div>

  maybeVideoTitleEl->Belt.Option.mapWithDefault(<> </>, videoTitleEl =>
    ReactDOM.createPortal(view, videoTitleEl)
  )
}
