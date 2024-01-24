module DescriptionSnippet = {
  let useWhatever = name => {
    let (snippets, setState) = React.useState(_ => [])

    React.useEffect0(() => {
      let onMessageListener: Chrome.Runtime.Port.message<'a> => unit = ({payload, tag}) => {
        switch tag {
        | "init" => {
            let snippets = payload->Js.Array2.map((snippet: Schema.DescriptionSnippet.t) => {
              let d = snippet.date->Js.Date.toString
              let date = Js.Date.fromString(d)
              // Hack to get around the fact that it type checks
              // but the `date` field gets converted to a string when coming over the Port
              // create a new date from the old stringified date so that
              // date functions work properly

              {...snippet, date}
            })
            setState(_ => snippets)
          }
        }
        Js.log2("app chrome port inbound", tag)
      }
      let port = Chrome.Runtime.connect({name: name})
      Chrome.Runtime.Port.addListener(port, onMessageListener)

      // @TODO figure out clean up

      None
    })
    snippets
  }
}
