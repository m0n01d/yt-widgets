open Belt
type template = {body: string}
module Templates = {
  module IntCmp = Belt.Id.MakeComparable({
    type t = string
    let cmp = (a, b) => Pervasives.compare(a, b)
  })

  type t = Map.Dict.t<string, template, IntCmp.t>

  @react.component
  let make = (~model) => {
    React.null
  }
}
