@val @scope(("window", "document"))
external createElement: string => Dom.element = "createElement"

module App = {
  @react.component
  let make = () => {
    Js.log("Hello ReScript")
    <div> {React.string("Hello ReScript!")} </div>
  }
}

let dummy = createElement("div")
let root = ReactDOM.Client.createRoot(dummy)
ReactDOM.Client.Root.render(root, <App />)
