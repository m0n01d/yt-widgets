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
  type id = option<int>
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
    id: id,
    name: string,
    order: int,
  }
  let tableName = "DescriptionSnippet"
  let fields = "++id,body,category_id,date,name"

  let schema = (tableName, fields)

  /// util

  let dateFix = (snippet: t) => {
    let d = snippet.date->Js.Date.toString
    let date = Js.Date.fromString(d)
    // Hack to get around the fact that it type checks
    // but the `date` field gets converted to a string when coming over the Port
    // create a new date from the old stringified date so that
    // date functions work properly

    {...snippet, date}
  }
}
