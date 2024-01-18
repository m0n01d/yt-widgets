open Belt

let dexie = Dexie.Database.make(`hello dexie 1`)
let schema = [Schema.DescriptionTemplate.Category.schema, Schema.DescriptionTemplate.schema]
dexie->Dexie.Database.version(1)->Dexie.Version.stores(schema)->ignore

dexie->Dexie.Database.opendb->ignore

let x = dexie->Table.DescriptionTemplateCategory.put({
  id: Some(0),
  name: "default",
})

let p = dexie->Table.DescriptionTemplate.put({
  id: Some(41),
  body: "test",
  category_id: 0,
  name: "fake",
  date: Js.Date.make(),
})

module IntCmp = Id.MakeComparable({
  type t = string
  let cmp = (a, b) => Pervasives.compare(a, b)
})

let listeners = Map.make(~id=module(IntCmp))

Chrome.Runtime.OnConnect.addListener(port => {
  let descriptionTemplatesPort = Description.Templates.name
  switch port.name {
  | descriptionTemplatesPort => {
      // on connect - send data to widget
      listeners->Map.set(port.name, port)->ignore
      Table.DescriptionTemplate.toArray(dexie)
      ->Js.Promise2.then(descriptionTemplates => {
        Js.log2("from db", descriptionTemplates)
        let message: Chrome.Runtime.Port.message<'a> = {
          payload: descriptionTemplates,
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
