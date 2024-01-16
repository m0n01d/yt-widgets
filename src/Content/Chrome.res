module Runtime = {
  module Port = {
    type t = {name: string}

    type message = {body: string}

    @send @scope("onMessage") external addListener: (t, message => unit) => unit = "addListener"
    @send external postMessage: (t, message) => unit = "postMessage"
  }
  type config = {name: string}
  @val @scope(("chrome", "runtime"))
  external connect: config => Port.t = "connect"

  module OnConnect = {
    @val @scope(("chrome", "runtime", "onConnect"))
    external addListener: (Port.t => unit) => unit = "addListener"
  }
  module OnMessage = {
    @val @scope(("chrome", "runtime", "onMessage"))
    external addListener: (Port.t => unit) => unit = "addListener"
  }
}
