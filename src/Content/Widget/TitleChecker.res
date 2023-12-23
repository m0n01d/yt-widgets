open Webapi.Dom

let observerConfig = {
  "attributes": false,
  "childList": true,
  "subtree": true,
}
type sharedProps = {children: React.element}

let parentVideoTitleSelector = "ytcp-video-title" // element where we'll inject <TitleChecker />

let pause = () => {
  Js.Promise2.make((~resolve, ~reject) => {
    let x = Js.Global.setTimeout(_ => resolve(. None), 1333)
  })
}
exception TestError(string)

let rec queryDomHelp = async (selector, n): promise<Dom.element> => {
  let wait = await pause()

  if n < 0 {
    Promise.reject(TestError("huh"))
  } else {
    let maybeEl: option<Dom.element> = Document.querySelector(Webapi.Dom.document, selector)
    switch maybeEl {
    | Some(el) => Promise.resolve(el)
    | None => await queryDomHelp(selector, n - 1)
    }
  }
}

let query = () => {
  let videoTitleElQuery = queryDomHelp(parentVideoTitleSelector, 3)->Promise.then(el => el)
  let videoTitleInputQuery = queryDomHelp("ytcp-social-suggestion-input", 3)->Promise.then(el => el)

  Promise.all([videoTitleElQuery, videoTitleInputQuery])
}

type model = OverLimit(float) | UnderLimit(float)

let viewOverLimit =
  <div
    id="TitleChecker.viewOverLimit"
    style={ReactDOM.Style.make(
      ~color="#dc3545",
      ~fontSize="12px",
      ~padding="0.2rem 1rem",
      ~textAlign="right",
      (),
    )}>
    {React.string("Your title is a little long there, pal...")} // nice passive aggressive tone
  </div>

@react.component
let make = () => {
  let (state, setState) = React.useState(_ => UnderLimit(0.0))
  let ((maybeVideoTitleEl, maybeVideoTitleInput), setEls) = React.useState(_ => (None, None))
  React.useEffect0(() => {
    query()
    ->Promise.then(([videoTitleEl, videoTitleInput]) => {
      setEls(_ => (Some(videoTitleEl), Some(videoTitleInput)))
      let text = Element.innerText(videoTitleInput)
      let initialState = {
        let len = Belt.Int.toFloat(String.length(text))
        if len > 60.0 {
          OverLimit(len)
        } else {
          UnderLimit(len)
        }
      }

      setState(_ => initialState)
      Promise.resolve()
    })
    ->ignore

    None
  })

  let viewProgress = (len: float) => {
    let w_ = len /. 60.0 *. 100.0
    let w = Js.Math.min_float(w_, 100.0)
    let width = Belt.Float.toString(w) ++ "%"
    let backgroundColor = if len > 60.0 {
      "red"
    } else if len > 42.0 {
      "yellow"
    } else {
      "green"
    }

    <div>
      <div style={ReactDOM.Style.make(~height="2px", ~width, ~backgroundColor, ())} />
    </div>
  }
  let view = {
    let children = switch state {
    | OverLimit(len) => [viewProgress(len), viewOverLimit]
    | UnderLimit(len) => [viewProgress(len)]
    }
    React.array(children)
  }

  switch (maybeVideoTitleEl, maybeVideoTitleInput) {
  | (Some(videoTitleEl), Some(videoTitleInput)) => {
      let watcher = (mutationList, observer) => {
        let text = Element.innerText(videoTitleInput)

        let textboxLen = Belt.Int.toFloat(String.length(text))
        if textboxLen > 60.0 {
          setState(_ => OverLimit(textboxLen))
        } else {
          setState(_ => UnderLimit(textboxLen))
        }
        MutationObserver.disconnect(observer)
      }
      let observer = MutationObserver.make(watcher)
      MutationObserver.observe(observer, videoTitleInput, observerConfig)
      ReactDOM.createPortal(view, videoTitleEl)
    }
  | _ => <> </>
  }
}
