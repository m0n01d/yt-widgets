open Belt

type template = {body: string}
module Templates = {
  let name = "Description.Templates"
  module IntCmp = Belt.Id.MakeComparable({
    type t = string
    let cmp = (a, b) => Pervasives.compare(a, b)
  })

  type t = Map.Dict.t<string, template, IntCmp.t>

  @react.component
  let make = (~model) => {
    let (state, setState) = React.useState(() => [])
    React.useEffect0(() => {
      let onMessageListener: Chrome.Runtime.Port.message<'a> => unit = ({payload, tag}) => {
        switch tag {
        | "init" => setState(_ => payload)
        }
        Js.log2("app chrome port inbound", tag)
      }
      let port = Chrome.Runtime.connect({name: name})
      Chrome.Runtime.Port.addListener(port, onMessageListener)

      //   let message: Chrome.Runtime.Port.message<'a> = {payload: None, tag: "ready"}
      //   port->Chrome.Runtime.Port.postMessage(message)

      None
    })
    let view =
      <pre> {state->Js.Json.stringifyAny->Option.getWithDefault("nopoe")->React.string} </pre>
    switch ReactDOM.querySelector("body") {
    | Some(el) => ReactDOM.createPortal(view, el)
    | None => React.null
    }
  }
}

@react.component
let make = (~model) => {
  <Templates model />
}
