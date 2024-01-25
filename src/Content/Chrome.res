module Runtime = {
  module Port = {
    type t = {name: string}

    type message<'a> = 'a

    @send @scope("onMessage") external addListener: (t, message<'a> => unit) => unit = "addListener"
    @send external postMessage: (t, message<'a>) => unit = "postMessage"
    @send external disconnect: (t, unit) => unit = "disconnect"
    module OnDisconnect = {
      @send @scope("onDisconnect") external addListener: (t, unit => unit) => unit = "addListener"
    }
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
