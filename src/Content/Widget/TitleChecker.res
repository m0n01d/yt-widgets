let ytSelector = "ytcp-video-title"
type props = {foo: string}
let make = (props: props) => {
  let maybeVideoTitleEl = ReactDOM.querySelector(ytSelector)
  let view = <div id="TitleChecker.view"> {React.string(props.foo)} </div>
  switch maybeVideoTitleEl {
  | Some(videoTitleEl) => ReactDOM.createPortal(view, videoTitleEl)
  | None => <> </>
  }
}
