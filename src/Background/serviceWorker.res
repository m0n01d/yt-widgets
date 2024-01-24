let dexie = Dexie.Database.make(`hello dexie 1`)
let schema = [Schema.DescriptionSnippet.Category.schema, Schema.DescriptionSnippet.schema]
dexie->Dexie.Database.version(1)->Dexie.Version.stores(schema)->ignore

dexie->Dexie.Database.opendb->ignore

let x = dexie->Table.DescriptionSnippetCategory.put({
  id: Some(0),
  name: "default",
})

let p = dexie->Table.DescriptionSnippet.put({
  body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  category_id: 0,
  date: Js.Date.make(),
  id: Some(41),
  name: "Lorem Ipsum generator",
  order: 1,
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
  let descriptionSnippetsPort = Description.Snippets.name
  let descriptionSnippetsEditorPort = SnippetEditor.name
  switch port.name {
  | descriptionSnippetsPort => {
      // on connect - send data to widget
      listeners->Map.set(port.name, port)->ignore
      Table.DescriptionSnippet.toArray(dexie)
      ->Js.Promise2.then(descriptionSnippets => {
        Js.log2("from db", descriptionSnippets)
        let message: Chrome.Runtime.Port.message<'a> = {
          payload: descriptionSnippets,
          tag: "init",
        }
        port->Chrome.Runtime.Port.postMessage(message)
        Js.Promise2.resolve()
      })
      ->ignore
      // async fetch and then post message with data
    }
  | descriptionSnippetsEditorPort => {
      // on connect - send data to widget
      listeners->Map.set(port.name, port)->ignore
      Table.DescriptionSnippet.toArray(dexie)
      ->Js.Promise2.then(descriptionSnippets => {
        Js.log2("from db", descriptionSnippets)
        let message: Chrome.Runtime.Port.message<'a> = {
          payload: descriptionSnippets,
          tag: "init",
        }
        port->Chrome.Runtime.Port.postMessage(message)
        Js.Promise2.resolve()
      })
      ->ignore
      // async fetch and then post message with data
    }
  }
  Js.log2("connected", port)
})
