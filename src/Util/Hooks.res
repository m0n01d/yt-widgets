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
