// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Table from "../Data/Table.bs.mjs";
import Dexie from "dexie";
import * as Schema from "../Data/Schema.bs.mjs";
import * as Belt_Id from "rescript/lib/es6/belt_Id.js";
import * as Belt_Map from "rescript/lib/es6/belt_Map.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Description from "../Content/Widget/Description.bs.mjs";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import * as Version$Dexie from "@dusty-phillips/rescript-dexie/src/Version.bs.mjs";

var dexie = new Dexie("hello dexie 1");

var schema = [
  Schema.DescriptionTemplate.Category.schema,
  Schema.DescriptionTemplate.schema
];

Version$Dexie.stores(dexie.version(1), schema);

dexie.open();

var x = Curry._2(Table.DescriptionTemplateCategory.put, dexie, {
      id: 0,
      name: "default"
    });

var p = Curry._2(Table.DescriptionTemplate.put, dexie, {
      body: "test",
      category_id: 0,
      date: new Date(),
      id: 41,
      name: "fake"
    });

var cmp = Caml_obj.compare;

var IntCmp = Belt_Id.MakeComparable({
      cmp: cmp
    });

var listeners = Belt_Map.make(IntCmp);

chrome.runtime.onConnect.addListener(function (port) {
      Belt_Map.set(listeners, port.name, port);
      Js_promise2.then(Curry._1(Table.DescriptionTemplate.toArray, dexie), (function (descriptionTemplates) {
              console.log("from db", descriptionTemplates);
              var message = {
                payload: descriptionTemplates,
                tag: "init"
              };
              port.postMessage(message);
              return Promise.resolve(undefined);
            }));
      console.log("connected", port);
    });

export {
  dexie ,
  schema ,
  x ,
  p ,
  IntCmp ,
  listeners ,
}
/* dexie Not a pure module */
