// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Table from "../Data/Table.bs.mjs";
import Dexie from "dexie";
import * as Schema from "../Data/Schema.bs.mjs";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import * as Core__Promise from "@rescript/core/src/Core__Promise.bs.mjs";
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

var body = "Subscribe if youre new!\nhttps://www.patreon.com/ElmForReactDevs\nhttps://elmforreactdevs.com\n";

Table.DescriptionSnippet.put(dexie, {
      body: body,
      category_id: 0,
      date: new Date(),
      id: 1,
      name: "Subscribe!",
      order: 2
    });

var listeners = new Map();

chrome.runtime.onConnect.addListener(function (port) {
      port.onDisconnect.addListener(function () {
            port.disconnect();
            listeners.delete(port.name);
          });
      var match = port.name;
      switch (match) {
        case "Description.Snippets" :
            listeners.set(port.name, port);
            Js_promise2.then(Table.DescriptionSnippet.toArray(dexie), (function (descriptionSnippets) {
                    var message = {
                      TAG: "GotSnippets",
                      _0: descriptionSnippets
                    };
                    port.postMessage(message);
                    return Promise.resolve();
                  }));
            return ;
        case "SnippetEditor" :
            listeners.set(port.name, port);
            port.onMessage.addListener(function (tag) {
                  if (tag.TAG === "SaveNewSnippet") {
                    var snippet = Schema.DescriptionSnippet.dateFix(tag._0);
                    Core__Promise.$$catch(Table.DescriptionSnippet.add(dexie, snippet).then(function (d) {
                                return Table.DescriptionSnippet.toArray(dexie);
                              }).then(function (descriptionSnippets) {
                              listeners.forEach(function (port_) {
                                    var message = {
                                      TAG: "GotSnippets",
                                      _0: descriptionSnippets
                                    };
                                    port_.postMessage(message);
                                  });
                              return Promise.resolve();
                            }), (function (err) {
                            console.log("err", err);
                            return Promise.resolve();
                          }));
                    return ;
                  }
                  var snippet$1 = Schema.DescriptionSnippet.dateFix(tag._0);
                  Table.DescriptionSnippet.put(dexie, snippet$1).then(function (d) {
                          return Table.DescriptionSnippet.toArray(dexie);
                        }).then(function (descriptionSnippets) {
                        listeners.forEach(function (port_) {
                              var message = {
                                TAG: "GotSnippets",
                                _0: descriptionSnippets
                              };
                              port_.postMessage(message);
                            });
                        return Promise.resolve();
                      });
                });
            Js_promise2.then(Table.DescriptionSnippet.toArray(dexie), (function (descriptionSnippets) {
                    var message = {
                      TAG: "GotSnippets",
                      _0: descriptionSnippets
                    };
                    port.postMessage(message);
                    return Promise.resolve();
                  }));
            return ;
        default:
          throw {
                RE_EXN_ID: "Match_failure",
                _1: [
                  "serviceWorker.res",
                  35,
                  2
                ],
                Error: new Error()
              };
      }
    });

var p;

export {
  dexie ,
  schema ,
  x ,
  body ,
  p ,
  listeners ,
}
/* dexie Not a pure module */
