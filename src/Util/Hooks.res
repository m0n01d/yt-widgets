module DescriptionSnippet = {
  type tag = GotSnippets(array<Schema.DescriptionSnippet.t>)

  let usePort = name => {
    let (snippets, setState) = React.useState(_ => ([], None))

    React.useEffect0(() => {
      let port = Chrome.Runtime.connect({name: name})
      let onMessageListener: Chrome.Runtime.Port.message<'a> => unit = tag => {
        switch tag {
        | GotSnippets(payload) => {
            let snippets = payload->Js.Array2.map(Schema.DescriptionSnippet.dateFix)
            setState(_ => (snippets, Some(port)))
          }
        }
        Js.log2("app chrome port inbound", tag)
      }

      Chrome.Runtime.Port.addListener(port, onMessageListener)

      Some(
        () => {
          port->Chrome.Runtime.Port.disconnect()
        },
      )
    })
    snippets
  }
}
module Preview = {
  type thumbnailData = {
    title: string,
    src: string,
  }
  type tag = GotThumbnailPreview(thumbnailData)
  type state = {maybeThumbnailData: option<thumbnailData>, maybePort: option<Chrome.Runtime.Port.t>}

  let usePort = name => {
    let (state, setState) = React.useState(_ => {maybeThumbnailData: None, maybePort: None})

    React.useEffect0(() => {
      let port = Chrome.Runtime.connect({name: name})
      setState(state => {...state, maybePort: Some(port)})
      Console.log2("effect", port)
      let onMessageListener: Chrome.Runtime.Port.message<'a> => unit = tag => {
        Js.log2("Preview onmessaglister: app chrome port inbound", tag)
        switch tag {
        | GotThumbnailPreview(payload) =>
          setState(_ => {maybeThumbnailData: Some(payload), maybePort: Some(port)})
        }
      }

      Chrome.Runtime.Port.addListener(port, onMessageListener)

      Some(
        () => {
          Console.log2("disconnected hook", port)
          port->Chrome.Runtime.Port.disconnect()
        },
      )
    })
    state
  }
}
