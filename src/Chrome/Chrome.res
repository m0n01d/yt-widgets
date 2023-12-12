module Runtime = {
  module Port = {
    type t

    //@send external onMessage: (t, unit => unit) => unit = "onMessage.addListener"
    @send @scope("onMessage") external addListener: (t, t => unit) => unit = "addListener"
    //@val external port: t = "port"
  }
  type config = {name: string}
  @val @scope(("chrome", "runtime"))
  external connect: config => Port.t = "connect"
  module OnMessage = {
    @val @scope(("chrome", "runtime", "onMessage"))
    external addListener: (Port.t => unit) => unit = "addListener"
  }
}
