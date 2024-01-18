// Generated by ReScript, PLEASE EDIT WITH CARE


var tableName = "DescriptionTemplate.Category";

var fields = "++id,name";

var schema = [
  tableName,
  fields
];

var Category = {
  tableName: tableName,
  fields: fields,
  schema: schema
};

var tableName$1 = "DescriptionTemplate";

var fields$1 = "++id,body,category_id,date,name";

var schema$1 = [
  tableName$1,
  fields$1
];

var DescriptionTemplate = {
  Category: Category,
  tableName: tableName$1,
  fields: fields$1,
  schema: schema$1
};

export {
  DescriptionTemplate ,
}
/* No side effect */
