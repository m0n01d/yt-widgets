@val @scope(("window", "document"))
external createElement: string => Dom.element = "createElement"

module App = {
  @react.component
  let make = () => {
    <div>
      <TitleChecker text="Video Title Checker goes here" />
    </div>
  }
}
let onMessageListener = port => {
  Js.log2("App is listening", port)

  let dummy = createElement("div")
  let root = ReactDOM.Client.createRoot(dummy)
  ReactDOM.Client.Root.render(root, <App />)
}

let port = Chrome.Runtime.connect({name: "yt-widgets-content"})
Chrome.Runtime.Port.addListener(port, onMessageListener)
