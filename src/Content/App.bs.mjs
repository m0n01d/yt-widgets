// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Thumbnail from "./Widget/Thumbnail.bs.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Description from "./Widget/Description.bs.mjs";
import * as TitleChecker from "./Widget/TitleChecker.bs.mjs";
import * as Client from "react-dom/client";
import * as JsxPPXReactSupport from "rescript/lib/es6/jsxPPXReactSupport.js";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.bs.mjs";
import * as Webapi__Dom__Document from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Document.bs.mjs";

var observerConfig = {
  attributes: true,
  childList: true,
  subtree: true
};

var $$document = window.document;

var dummy = $$document.createElement("div");

function update(state, action) {
  if (typeof action === "number") {
    return {
            currentPage: state.currentPage,
            maybeUploadDialog: undefined,
            remote: state.remote
          };
  } else if (action.TAG === /* SetDialog */0) {
    return {
            currentPage: state.currentPage,
            maybeUploadDialog: Caml_option.some(action._0),
            remote: state.remote
          };
  } else {
    return {
            currentPage: action._0,
            maybeUploadDialog: state.maybeUploadDialog,
            remote: state.remote
          };
  }
}

var app = Belt_Option.map(Caml_option.nullable_to_opt($$document.querySelector("title")), (function (titleEl) {
        var bodyEl = Belt_Option.getWithDefault(Belt_Option.flatMap(Webapi__Dom__Document.asHtmlDocument($$document), (function (prim) {
                    return Caml_option.nullable_to_opt(prim.body);
                  })), dummy);
        var App = function (props) {
          var pageTitle = titleEl.textContent;
          var route = Js_string.split(" - ", pageTitle);
          var initialPage;
          if (route.length !== 2) {
            initialPage = /* Other */1;
          } else {
            var match = route[0];
            initialPage = match === "Video details" ? /* Details */0 : /* Other */1;
          }
          var initialState_remote = {
            descriptionTemplates: undefined
          };
          var initialState = {
            currentPage: initialPage,
            maybeUploadDialog: undefined,
            remote: initialState_remote
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
                        body: "ready"
                      });
                }), []);
          var bodyWatcher = function (mutationList, observer) {
            Belt_Array.forEach(mutationList, (function (mutation) {
                    var hasRemovedDialog = Array.prototype.slice.call(mutation.removedNodes).some(function (el) {
                          var name = el.nodeName.toLowerCase();
                          return name === "ytcp-uploads-dialog";
                        });
                    if (hasRemovedDialog) {
                      return Curry._1(dispatch, /* RemovedDialog */0);
                    }
                    var target = mutation.target;
                    var name = target.nodeName.toLocaleLowerCase();
                    var attributeName = mutation.attributeName;
                    var attribute = Belt_Option.flatMap(Webapi__Dom__Element.ofNode(target), (function (node) {
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
                    Curry._1(dispatch, {
                          TAG: /* SetDialog */0,
                          _0: target
                        });
                  }));
          };
          var titleElWatcher = function (mutationList, observer) {
            var title = Belt_Option.mapWithDefault(Belt_Option.map(Belt_Array.get(mutationList, 0), (function (prim) {
                        return prim.target;
                      })), "", (function (prim) {
                    return prim.textContent;
                  }));
            var route = Js_string.split(" - ", title);
            if (route.length !== 2) {
              return Curry._1(dispatch, {
                          TAG: /* SetPage */1,
                          _0: /* Other */1
                        });
            }
            var match = route[0];
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
                  return (function (param) {
                            bodyObserver.disconnect();
                            titleObserver.disconnect();
                          });
                }), []);
          var dialogWidgets = function (dialog) {
            return [JsxPPXReactSupport.createElementWithKey("upload-dialog", TitleChecker.make, {
                          maybeUploadDialog: Webapi__Dom__Element.ofNode(dialog)
                        })];
          };
          var match$2 = state.currentPage;
          var match$3 = state.maybeUploadDialog;
          if (match$2) {
            if (match$3 !== undefined) {
              return dialogWidgets(Caml_option.valFromOption(match$3));
            } else {
              return [];
            }
          } else if (match$3 !== undefined) {
            if (match$3 !== undefined) {
              return dialogWidgets(Caml_option.valFromOption(match$3));
            } else {
              return [];
            }
          } else {
            return [
                    JsxPPXReactSupport.createElementWithKey("details-page", TitleChecker.make, {
                          maybeUploadDialog: undefined
                        }),
                    React.createElement(Thumbnail.make, {}),
                    React.createElement(Description.Templates.make, {
                          model: state.remote.descriptionTemplates
                        })
                  ];
          }
        };
        var root = Client.createRoot(dummy);
        root.render(React.createElement(App, {}));
      }));

export {
  observerConfig ,
  $$document ,
  dummy ,
  update ,
  app ,
}
/* document Not a pure module */
