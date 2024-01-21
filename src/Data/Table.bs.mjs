// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Schema from "./Schema.bs.mjs";
import * as Table$Dexie from "@dusty-phillips/rescript-dexie/src/Table.bs.mjs";

var DescriptionSnippetCategory = Table$Dexie.MakeTable(Schema.DescriptionSnippet.Category);

var DescriptionSnippet = Table$Dexie.MakeTable({
      tableName: Schema.DescriptionSnippet.tableName
    });

export {
  DescriptionSnippetCategory ,
  DescriptionSnippet ,
}
/* DescriptionSnippetCategory Not a pure module */