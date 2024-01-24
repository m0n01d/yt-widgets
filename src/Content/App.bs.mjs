// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Thumbnail from "./Widget/Thumbnail.bs.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Description from "./Widget/Description.bs.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.bs.mjs";
import * as TitleChecker from "./Widget/TitleChecker.bs.mjs";
import * as Client from "react-dom/client";
import * as JsxRuntime from "react/jsx-runtime";
import * as Colors from "@mui/material/colors";
import * as Styles from "@mui/material/styles";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.bs.mjs";
import * as Webapi__Dom__Document from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Document.bs.mjs";

function theme(outerTheme) {
  var newrecord = Caml_obj.obj_dup(outerTheme);
  return Styles.createTheme((newrecord.typography = {
                fontSize: 16.0
              }, newrecord.palette = {
                primary: {
                  main: Colors.pink[500]
                },
                secondary: {
                  main: "#9c27b0"
                }
              }, newrecord));
}

var observerConfig = {
  attributes: true,
  childList: true,
  subtree: true
};

var $$document = window.document;

var dummy = $$document.createElement("div");

function update(state, action) {
  if (typeof action !== "object") {
    return {
            currentPage: state.currentPage,
            maybeUploadDialog: undefined
          };
  } else if (action.TAG === "SetDialog") {
    return {
            currentPage: state.currentPage,
            maybeUploadDialog: Caml_option.some(action._0)
          };
  } else {
    return {
            currentPage: action._0,
            maybeUploadDialog: state.maybeUploadDialog
          };
  }
}

var app = Core__Option.map(Caml_option.nullable_to_opt($$document.querySelector("title")), (function (titleEl) {
        var bodyEl = Core__Option.getWithDefault(Core__Option.flatMap(Webapi__Dom__Document.asHtmlDocument($$document), (function (prim) {
                    return Caml_option.nullable_to_opt(prim.body);
                  })), dummy);
        var App = function (props) {
          var pageTitle = titleEl.textContent;
          var route = Js_string.split(" - ", pageTitle);
          var initialPage;
          if (route.length !== 2) {
            initialPage = "Other";
          } else {
            var match = route[0];
            initialPage = match === "Video details" ? "Details" : "Other";
          }
          var initialState = {
            currentPage: initialPage,
            maybeUploadDialog: undefined
          };
          var match$1 = React.useReducer(update, initialState);
          var dispatch = match$1[1];
          var state = match$1[0];
          React.useEffect((function () {
                  var onMessageListener = function (portMsg) {
                    console.log("app chrome port inbound", portMsg);
                  };
                  var port = chrome.runtime.connect({
                        name: "yt-widgets-content"
                      });
                  port.onMessage.addListener(onMessageListener);
                  port.postMessage({
                        payload: undefined,
                        tag: "ready"
                      });
                }), []);
          var bodyWatcher = function (mutationList, observer) {
            mutationList.forEach(function (mutation) {
                  var hasRemovedDialog = Array.prototype.slice.call(mutation.removedNodes).some(function (el) {
                        var name = el.nodeName.toLowerCase();
                        return name === "ytcp-uploads-dialog";
                      });
                  if (hasRemovedDialog) {
                    return dispatch("RemovedDialog");
                  }
                  var target = mutation.target;
                  var name = target.nodeName.toLocaleLowerCase();
                  var attributeName = mutation.attributeName;
                  var attribute = Core__Option.flatMap(Webapi__Dom__Element.ofNode(target), (function (node) {
                          return Caml_option.nullable_to_opt(node.getAttribute("workflow-step"));
                        }));
                  var match = [
                    name,
                    (attributeName == null) ? undefined : Caml_option.some(attributeName),
                    attribute
                  ];
                  if (match.length !== 3) {
                    return ;
                  }
                  var match$1 = match[0];
                  if (match$1 === undefined) {
                    return ;
                  }
                  if (match$1 !== "ytcp-uploads-dialog") {
                    return ;
                  }
                  var match$2 = match[1];
                  if (match$2 === undefined) {
                    return ;
                  }
                  if (match$2 !== "workflow-step") {
                    return ;
                  }
                  var match$3 = match[2];
                  if (match$3 === undefined) {
                    return ;
                  }
                  if (match$3 !== "DETAILS") {
                    return ;
                  }
                  console.log("uploading!");
                  dispatch({
                        TAG: "SetDialog",
                        _0: target
                      });
                });
          };
          var titleElWatcher = function (mutationList, observer) {
            var title = Core__Option.mapWithDefault(Core__Option.map(mutationList[0], (function (prim) {
                        return prim.target;
                      })), "", (function (prim) {
                    return prim.textContent;
                  }));
            var route = Js_string.split(" - ", title);
            if (route.length !== 2) {
              return dispatch({
                          TAG: "SetPage",
                          _0: "Other"
                        });
            }
            var match = route[0];
            if (match === "Video details") {
              return dispatch({
                          TAG: "SetPage",
                          _0: "Details"
                        });
            } else {
              return dispatch({
                          TAG: "SetPage",
                          _0: "Other"
                        });
            }
          };
          React.useEffect((function () {
                  var bodyObserver = new MutationObserver(bodyWatcher);
                  var titleObserver = new MutationObserver(titleElWatcher);
                  bodyObserver.observe(bodyEl, {
                        attributes: true,
                        childList: true,
                        subtree: true
                      });
                  titleObserver.observe(titleEl, {
                        attributes: false,
                        childList: true,
                        subtree: false
                      });
                  return (function () {
                            bodyObserver.disconnect();
                            titleObserver.disconnect();
                          });
                }), []);
          var detailsPage = function () {
            return [
                    JsxRuntime.jsx(TitleChecker.make, {
                          maybeUploadDialog: undefined
                        }, "details-page"),
                    JsxRuntime.jsx(Thumbnail.make, {}),
                    JsxRuntime.jsx(Description.make, {})
                  ];
          };
          var match$2 = state.currentPage;
          var match$3 = state.maybeUploadDialog;
          if (match$2 === "Details" && match$3 === undefined) {
            return detailsPage();
          }
          if (match$3 !== undefined) {
            var dialog = Caml_option.valFromOption(match$3);
            return [
                    JsxRuntime.jsx(TitleChecker.make, {
                          maybeUploadDialog: Webapi__Dom__Element.ofNode(dialog)
                        }, "upload-dialog"),
                    JsxRuntime.jsx(Thumbnail.make, {}),
                    JsxRuntime.jsx(Description.make, {})
                  ];
          } else {
            return [];
          }
        };
        var root = Client.createRoot(dummy);
        root.render(JsxRuntime.jsx(Styles.ThemeProvider, {
                  children: JsxRuntime.jsx(App, {}),
                  theme: theme
                }));
      }));

export {
  theme ,
  observerConfig ,
  $$document ,
  dummy ,
  update ,
  app ,
}
/* document Not a pure module */
