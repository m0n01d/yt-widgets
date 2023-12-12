@val @scope(("window", "document"))
external createElement: string => Dom.element = "createElement"

module App = {
  @react.component
  let make = () => {
    Js.log("Hello ReScript")
    <div>
      <TitleChecker foo="bar" />
    </div>
  }
}
let onMessageListener = x => {
  Js.log(x)
  let dummy = createElement("div")
  let root = ReactDOM.Client.createRoot(dummy)
  ReactDOM.Client.Root.render(root, <App />)
}
let port = Chrome.Runtime.connect({name: "yt-widgets-content"})

Chrome.Runtime.Port.addListener(port, onMessageListener)
