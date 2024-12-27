module File = {
  type file

  module Reader = {
    type reader
    type event = [
      | #load
      | #abort
    ]

    @new external make: unit => reader = "FileReader"
    @send external readAsDataURL: (reader, file) => unit = "readAsDataURL"
    @send external addEventListener: (reader, event, unit => unit) => unit = "addEventListener"

    @get external result: reader => string = "result"
  }
}

type evType = [#change]

module InputElement = {
  open Webapi.Dom
  type t = HtmlInputElement.t

  @get external files: t => array<File.file> = "files"

  module Event = {
    type event
    @get external target: event => t = "target"
    @get external currentTarget: event => t = "currentTarget"
  }
  @send external addEventListener: (t, evType, Event.event => unit) => unit = "addEventListener"
  @send
  external removeEventListener: (t, evType, Event.event => unit) => unit = "removeEventListener"
}
