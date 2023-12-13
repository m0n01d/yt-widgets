module Runtime = {
  module Port = {
    type t

    @send @scope("onMessage") external addListener: (t, t => unit) => unit = "addListener"
  }
  type config = {name: string}
  @val @scope(("chrome", "runtime"))
  external connect: config => Port.t = "connect"
  module OnMessage = {
    @val @scope(("chrome", "runtime", "onMessage"))
    external addListener: (Port.t => unit) => unit = "addListener"
  }
}
