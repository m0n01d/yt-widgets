module DescriptionSnippet = {
  let useWhatever = name => {
    let (snippets, setState) = React.useState(_ => ([], None))

    React.useEffect0(() => {
      let port = Chrome.Runtime.connect({name: name})
      Js.log("DescriptionSnippet.hook called")
      let onMessageListener: Chrome.Runtime.Port.message<'a> => unit = ({payload, tag}) => {
        switch tag {
        | "init" => {
            Js.log2("HOOKS: snippets", payload)
            let snippets = payload->Js.Array2.map(Schema.DescriptionSnippet.dateFix)
            setState(_ => (snippets, Some(port)))
          }
        }
        Js.log2("app chrome port inbound", tag)
      }

      Chrome.Runtime.Port.addListener(port, onMessageListener)

      // @TODO figure out clean up
      Some(
        () => {
          Js.log("cleanup hook")
          port->Chrome.Runtime.Port.disconnect()
        },
      )
    })
    snippets
  }
}
