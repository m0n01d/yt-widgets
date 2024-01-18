let dexie = Dexie.Database.make(`hello dexie 1`)
let schema = [Schema.DescriptionSnippet.Category.schema, Schema.DescriptionSnippet.schema]
dexie->Dexie.Database.version(1)->Dexie.Version.stores(schema)->ignore

dexie->Dexie.Database.opendb->ignore

let x = dexie->Table.DescriptionSnippetCategory.put({
  id: Some(0),
  name: "default",
})

let p = dexie->Table.DescriptionSnippet.put({
  id: Some(41),
  body: "test",
  category_id: 0,
  name: "fake",
  date: Js.Date.make(),
})

let listeners = Map.make()

Chrome.Runtime.OnConnect.addListener(port => {
  let descriptionSnippetsPort = Description.Snippets.name
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
  }
  Js.log2("connected", port)
})
