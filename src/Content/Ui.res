open Webapi.Dom
open Belt

module Icon = {
  module Description = {
    @module("@mui/icons-material/Description") @react.component
    external make: unit => React.element = "default"
  }
  module EditNote = {
    @module("@mui/icons-material/EditNote") @react.component
    external make: unit => React.element = "default"
  }
  module Expand = {
    module Less = {
      @module("@mui/icons-material/ExpandLess") @react.component
      external make: unit => React.element = "default"
    }
    module More = {
      @module("@mui/icons-material/ExpandMore") @react.component
      external make: unit => React.element = "default"
    }
  }
  module Input = {
    @module("@mui/icons-material/Input") @react.component
    external make: unit => React.element = "default"
  }
  module NoteAdd = {
    @module("@mui/icons-material/NoteAdd") @react.component
    external make: unit => React.element = "default"
  }
  module Preview = {
    @module("@mui/icons-material/Preview") @react.component
    external make: unit => React.element = "default"
  }
}

let pause = () => {
  Js.Promise2.make((~resolve, ~reject) => {
    let wait = Js.Global.setTimeout(_ => resolve(None), 500)
  })
}

exception TestError(string)

let rec queryDom = async (maybeAncestor, selector, n): promise<Dom.element> => {
  if n < 0 {
    Js.Promise2.reject(TestError("Not Found"))
  } else {
    let wait = await pause()
    let maybeEl: option<Dom.element> = maybeAncestor->Option.mapWithDefault(
      Document.querySelector(document, selector),
      dialog => {
        dialog->Element.querySelector(selector)
      },
    )
    switch maybeEl {
    | None => await queryDom(maybeAncestor, selector, n - 1)
    | Some(el) => Js.Promise2.resolve(el)
    }
  }
}
