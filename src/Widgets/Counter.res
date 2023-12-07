module Counter = {
  @react.component
  let make = () => {
    let (count, setCount) = React.useState(_ => 0)
    Js.log(count)

    let onIncrement = _event => {
      setCount(_count => _count + 1)
    }
    <div className="yt-widgets-Counter">
      <button onClick=onIncrement> {React.string("Add")} </button>
      {React.string(Belt.Int.toString(count))}
    </div>
  }
}
@react.component
let make = () => {
  open Inject
  let counter = <Counter />
  let x = Js.Global.setTimeout(() => {
    // inject
    switch ReactDOM.querySelector("ytcd-channel-facts-item") {
    | Some(rootElement) => {
        // inject counter to div
        // append div to rootElement
        let y = Inject.mount(rootElement, counter)
      }
    | None => ()
    }
  }, 1000)
  counter
}
