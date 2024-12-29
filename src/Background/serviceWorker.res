let dexie = Dexie.Database.make(`hello dexie 1`)
let schema = [Schema.DescriptionSnippet.Category.schema, Schema.DescriptionSnippet.schema]
dexie->Dexie.Database.version(1)->Dexie.Version.stores(schema)->ignore

dexie->Dexie.Database.opendb->ignore

let x = dexie->Table.DescriptionSnippetCategory.put({
  id: Some(0),
  name: "default",
})

let body = `Subscribe if youre new!
https://www.patreon.com/ElmForReactDevs
https://elmforreactdevs.com
`
let p =
  dexie
  ->Table.DescriptionSnippet.put({
    body,
    category_id: 0,
    date: Js.Date.make(),
    id: Some(1),
    name: "Subscribe!",
    order: 2,
  })
  ->ignore

let listeners = Map.make()

Chrome.Runtime.OnConnect.addListener(port => {
  Console.log3("chrome port", port.name, port)
  port->Chrome.Runtime.Port.OnDisconnect.addListener(() => {
    Console.log3("chrome port dissonncted", port.name, port)
    port->Chrome.Runtime.Port.disconnect()
    listeners->Map.delete(port.name)->ignore
  })
  switch port.name {
  | "Description.Snippets" => {
      // on connect - send data to widget
      listeners->Map.set(port.name, port)->ignore
      Table.DescriptionSnippet.toArray(dexie)
      ->Js.Promise2.then(descriptionSnippets => {
        let message: Chrome.Runtime.Port.message<
          Hooks.DescriptionSnippet.tag,
        > = Hooks.DescriptionSnippet.GotSnippets(descriptionSnippets)
        port->Chrome.Runtime.Port.postMessage(message)
        Js.Promise2.resolve()
      })
      ->ignore
      // async fetch and then post message with data
    }
  | "SnippetEditor" => {
      // on connect - send data to widget
      listeners->Map.set(port.name, port)->ignore
      port->Chrome.Runtime.Port.addListener((tag: SnippetEditor.tag) => {
        switch tag {
        | SnippetEditor.SaveNewSnippet(snippy: Schema.DescriptionSnippet.t) => {
            let snippet: Schema.DescriptionSnippet.t = snippy->Schema.DescriptionSnippet.dateFix
            dexie
            ->Table.DescriptionSnippet.add(snippet)
            ->Promise.then(
              d => {
                dexie->Table.DescriptionSnippet.toArray
              },
            )
            ->Promise.then(
              descriptionSnippets => {
                listeners->Map.forEach(
                  port_ => {
                    let message: Chrome.Runtime.Port.message<
                      'a,
                    > = Hooks.DescriptionSnippet.GotSnippets(descriptionSnippets)

                    port_->Chrome.Runtime.Port.postMessage(message)
                  },
                )
                Js.Promise2.resolve()
              },
            )
            ->Promise.catch(
              err => {
                Js.log2("err", err)
                Promise.resolve()
              },
            )
            ->ignore
          }
        | SnippetEditor.EditSnippet(snippy: Schema.DescriptionSnippet.t) => {
            let snippet = snippy->Schema.DescriptionSnippet.dateFix
            dexie
            ->Table.DescriptionSnippet.put(snippet)
            ->Promise.then(
              d => {
                dexie->Table.DescriptionSnippet.toArray
              },
            )
            ->Promise.then(
              descriptionSnippets => {
                listeners->Map.forEach(
                  port_ => {
                    let message: Chrome.Runtime.Port.message<
                      Hooks.DescriptionSnippet.tag,
                    > = Hooks.DescriptionSnippet.GotSnippets(descriptionSnippets)

                    port_->Chrome.Runtime.Port.postMessage(message)
                  },
                )
                Js.Promise2.resolve()
              },
            )
            ->ignore
          }
        }
      })

      Table.DescriptionSnippet.toArray(dexie)
      ->Js.Promise2.then(descriptionSnippets => {
        let message: Chrome.Runtime.Port.message<
          Hooks.DescriptionSnippet.tag,
        > = Hooks.DescriptionSnippet.GotSnippets(descriptionSnippets)
        port->Chrome.Runtime.Port.postMessage(message)
        Js.Promise2.resolve()
      })
      ->ignore
    }
  | "Thumbnail.Preview" => {
      listeners->Map.set(port.name, port)->ignore
      port->Chrome.Runtime.Port.addListener((tag: Thumbnail.Preview.tag) => {
        Console.log2("thumbnil", tag)
        switch tag {
        | SavePreview(details) => {
            Console.log("open new tab")

            %raw(`chrome.storage.local.set({ src: tag.src, title: tag.title })`)
            %raw(`chrome.tabs.create({url: "https://youtube.com/?ytwidget-preview"})`)
          }
        }
      })
    }
  }
})
