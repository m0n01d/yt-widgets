@react.component
let make = () => {
  let (count, setCount) = React.useState(_ => 0)

  let onIncrement = _event => {
    setCount(_count => _count + 1)
  }
  <div>
    <button onClick=onIncrement> {React.string("Add")} </button>
    {React.string(Belt.Int.toString(count))}
  </div>
}
