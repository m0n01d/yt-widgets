open Belt
module IntCmp = Id.MakeComparable({
  type t = string
  let cmp = (a, b) => Pervasives.compare(a, b)
})

let listeners = Map.make(~id=module(IntCmp))

Chrome.Runtime.OnConnect.addListener(port => {
  switch port.name {
  | "yt-widgets-content" => {
      listeners->Map.set(port.name, port)->ignore
      port->Chrome.Runtime.Port.addListener(portMsg => {
        switch portMsg {
        | {body: "ready"} => {
            // async fetch and then post message with data
            let message: Chrome.Runtime.Port.message = {body: "testing 123"}
            port->Chrome.Runtime.Port.postMessage(message)
          }
        }
        Js.log("msg")
        Js.log(portMsg)
      })
    }
  }
  Js.log2("connected", port)
})
