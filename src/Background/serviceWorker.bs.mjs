// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Table from "../Data/Table.bs.mjs";
import Dexie from "dexie";
import * as Schema from "../Data/Schema.bs.mjs";
import * as Description from "../Content/Widget/Description.bs.mjs";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import * as Version$Dexie from "@dusty-phillips/rescript-dexie/src/Version.bs.mjs";

var dexie = new Dexie("hello dexie 1");

var schema = [
  Schema.DescriptionSnippet.Category.schema,
  Schema.DescriptionSnippet.schema
];

Version$Dexie.stores(dexie.version(1), schema);

dexie.open();

var x = Table.DescriptionSnippetCategory.put(dexie, {
      id: 0,
      name: "default"
    });

var p = Table.DescriptionSnippet.put(dexie, {
      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      category_id: 0,
      date: new Date(),
      id: 41,
      name: "fake"
    });

var listeners = new Map();

chrome.runtime.onConnect.addListener(function (port) {
      listeners.set(port.name, port);
      Js_promise2.then(Table.DescriptionSnippet.toArray(dexie), (function (descriptionSnippets) {
              console.log("from db", descriptionSnippets);
              var message = {
                payload: descriptionSnippets,
                tag: "init"
              };
              port.postMessage(message);
              return Promise.resolve();
            }));
      console.log("connected", port);
    });

export {
  dexie ,
  schema ,
  x ,
  p ,
  listeners ,
}
/* dexie Not a pure module */
