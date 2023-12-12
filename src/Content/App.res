@val @scope(("window", "document"))
external createElement: string => Dom.element = "createElement"

module App = {
  @react.component
  let make = () => {
    let onMessageListener = x => {
      Js.log(x)
    }
    let port = Chrome.Runtime.connect({name: "yt-widgets-content"})

    Chrome.Runtime.Port.addListener(port, onMessageListener)

    Js.log("Hello ReScript")
    <div> {React.string("Hello ReScript!")} </div>
  }
}

let dummy = createElement("div")
let root = ReactDOM.Client.createRoot(dummy)
ReactDOM.Client.Root.render(root, <App />)
