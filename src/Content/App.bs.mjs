// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Id from "rescript/lib/es6/belt_Id.js";
import * as Belt_Map from "rescript/lib/es6/belt_Map.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as TitleChecker from "./Widget/TitleChecker.bs.mjs";
import * as Client from "react-dom/client";

var observerConfig = {
  attributes: false,
  childList: true,
  subtree: true
};

var $$document = window.document;

var cmp = Caml_obj.compare;

var IntCmp = Belt_Id.MakeComparable({
      cmp: cmp
    });

var m = Belt_Map.make(IntCmp);

var dummy = $$document.createElement("div");

var documentTitle_ = $$document.querySelector("title");

var documentTitle_$1 = (documentTitle_ == null) ? undefined : Caml_option.some(documentTitle_);

var documentTitle = Belt_Option.getWithDefault(documentTitle_$1, dummy);

function update(state, action) {
  if (typeof action === "number") {
    return state;
  }
  if (action.TAG !== /* AddWidgets */0) {
    return {
            currentPage: action._0,
            widgetContainers: state.widgetContainers
          };
  }
  var ws = Belt_Map.merge(state.widgetContainers, action._0, (function (key, maybeA, maybeB) {
          return maybeB;
        }));
  return {
          currentPage: state.currentPage,
          widgetContainers: ws
        };
}

var app = Belt_Option.map(Caml_option.nullable_to_opt($$document.querySelector("title")), (function (titleEl) {
        var App = function (props) {
          var initialState = {
            currentPage: /* Other */1,
            widgetContainers: m
          };
          var match = React.useReducer(update, initialState);
          var dispatch = match[1];
          var state = match[0];
          var onMessageListener = function (port) {
            console.log("App is listening for Chrome Messages", port);
          };
          var port = chrome.runtime.connect({
                name: "yt-widgets-content"
              });
          port.onMessage.addListener(onMessageListener);
          var titleWatcher = function (mutationList, obsever) {
            console.log("body");
            var title = Belt_Option.mapWithDefault(Belt_Option.map(Belt_Array.get(mutationList, 0), (function (prim) {
                        return prim.target;
                      })), "", (function (prim) {
                    return prim.textContent;
                  }));
            var t = Js_string.split(" - ", title);
            console.log("page", t);
            if (t.length !== 2) {
              return Curry._1(dispatch, {
                          TAG: /* SetPage */1,
                          _0: /* Other */1
                        });
            }
            var match = t[0];
            if (match === "Video details") {
              return Curry._1(dispatch, {
                          TAG: /* SetPage */1,
                          _0: /* Details */0
                        });
            } else {
              return Curry._1(dispatch, {
                          TAG: /* SetPage */1,
                          _0: /* Other */1
                        });
            }
          };
          React.useEffect((function () {
                  var titleObserver = new MutationObserver(titleWatcher);
                  titleObserver.observe(titleEl, observerConfig);
                  return (function (param) {
                            titleObserver.disconnect();
                          });
                }), []);
          console.log("widgets", state.currentPage);
          var match$1 = state.currentPage;
          var widgets = match$1 ? [] : [React.createElement(TitleChecker.make, {})];
          console.log("widigies", widgets);
          return widgets;
        };
        var root = Client.createRoot(dummy);
        root.render(React.createElement(App, {}));
      }));

export {
  observerConfig ,
  $$document ,
  IntCmp ,
  m ,
  dummy ,
  documentTitle_$1 as documentTitle_,
  documentTitle ,
  update ,
  app ,
}
/* document Not a pure module */
