module DescriptionTemplate = {
  type id = int
  /*
     {
        body: "This is  multiline string\n with #tags",
        date: "04/20/2024",
        id: 69,
        name: "default"
     }
 */
  type t = {
    body: string,
    date: Js.Date.t,
    id: option<int>,
    name: string,
  }
  let tableName = "description-template"
  let fields = "++id,body,date,name"

  let schema = (tableName, fields)
}
