open Webapi.Dom
open Belt

module LinearProgress = {
  @module("@mui/material") @react.component
  external make: (~variant: string, ~color: string, ~value: float) => React.element =
    "LinearProgress"
}

let pause = () => {
  Js.Promise2.make((~resolve, ~reject) => {
    let wait = Js.Global.setTimeout(_ => resolve(. None), 500)
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
