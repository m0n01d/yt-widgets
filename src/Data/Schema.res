module DescriptionSnippet = {
  module Category = {
    type id = int
    type t = {
      id: option<int>,
      name: string,
    }
    let tableName = "DescriptionSnippet.Category"
    let fields = "++id,name"
    let schema = (tableName, fields)
  }
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
    category_id: Category.id,
    date: Js.Date.t,
    id: option<int>,
    name: string,
  }
  let tableName = "DescriptionSnippet"
  let fields = "++id,body,category_id,date,name"

  let schema = (tableName, fields)
}
