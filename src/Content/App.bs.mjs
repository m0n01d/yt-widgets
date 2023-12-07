// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml from "rescript/lib/es6/caml.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Inject from "./Inject.bs.mjs";
import * as Belt_Id from "rescript/lib/es6/belt_Id.js";
import * as Counter from "../Widgets/Counter.bs.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_array from "rescript/lib/es6/js_array.js";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Client from "react-dom/client";

var config = {
  attributes: false,
  childList: true,
  subtree: true
};

function pageFromString(str) {
  var s = Js_string.replace(" - YouTube Studio", "", str);
  if (s === "Channel content") {
    return /* Content */1;
  }
  throw {
        RE_EXN_ID: "Match_failure",
        _1: [
          "App.res",
          19,
          2
        ],
        Error: new Error()
      };
}

function pageToString(page) {
  switch (page) {
    case /* Dashboard */0 :
        return "Dashboard";
    case /* Content */1 :
        return "Content";
    case /* Details */2 :
        return "Details";
    
  }
}

function pageToInt(page) {
  return page + 1 | 0;
}

function cmp(a, b) {
  return Caml.int_compare(a + 1 | 0, b + 1 | 0);
}

var StrCmp = Belt_Id.MakeComparable({
      cmp: cmp
    });

var Widget = {};

function widgetToComponent(widget) {
  return React.createElement(Counter.make, {});
}

function reducer(state, action) {
  if (action.TAG === /* ChangedPage */0) {
    return {
            currentPage: pageFromString(action._0),
            pageStatus: state.pageStatus,
            dialog: state.dialog,
            widgets: state.widgets
          };
  } else {
    return {
            currentPage: state.currentPage,
            pageStatus: /* AppReady */{
              _0: action._0
            },
            dialog: state.dialog,
            widgets: state.widgets
          };
  }
}

function App$ViewWaiting(props) {
  var dispatch = props.dispatch;
  var observer = new MutationObserver((function (mutations, observer) {
          Js_array.reduce((function (acc, m) {
                  if (m.target.nodeName === "YTCP-APP") {
                    return m.target.nodeName;
                  }
                  
                }), undefined, mutations);
          var foo = document.querySelector("title");
          if (!(foo == null)) {
            observer.disconnect();
            return Curry._1(dispatch, {
                        TAG: /* YTStudioAppWasLoaded */1,
                        _0: foo
                      });
          }
          
        }));
  observer.observe(props.el, config);
  return React.createElement(React.Fragment, undefined);
}

var ViewWaiting = {
  make: App$ViewWaiting
};

function App$ViewWidgets(props) {
  var state = props.state;
  var dispatch = props.dispatch;
  var observer = new MutationObserver((function (mutations, observer) {
          console.log("view title mutations", mutations);
          var len = mutations.length;
          if (len !== 1) {
            if (len === 0) {
              return ;
            }
            throw {
                  RE_EXN_ID: "Match_failure",
                  _1: [
                    "App.res",
                    108,
                    6
                  ],
                  Error: new Error()
                };
          }
          var mutation = mutations[0];
          Curry._1(dispatch, {
                TAG: /* ChangedPage */0,
                _0: mutation.target.text
              });
        }));
  observer.observe(props.titleEl, {
        attributes: true,
        childList: true,
        subtree: false
      });
  var widgets = Js_dict.get(state.widgets, pageToString(state.currentPage));
  if (widgets === undefined) {
    return React.createElement("div", undefined, "LoadingWidgets");
  }
  var components = Belt_Array.map(widgets, widgetToComponent);
  console.log(components);
  return components;
}

var ViewWidgets = {
  make: App$ViewWidgets
};

function App$App(props) {
  var widgets = {};
  widgets["Dashboard"] = [/* Counter */0];
  var match = React.useReducer(reducer, {
        currentPage: /* Dashboard */0,
        pageStatus: /* Waiting */0,
        dialog: undefined,
        widgets: widgets
      });
  var dispatch = match[1];
  var state = match[0];
  var titleEl = state.pageStatus;
  return React.createElement("div", undefined, titleEl ? React.createElement(App$ViewWidgets, {
                    titleEl: titleEl._0,
                    dispatch: dispatch,
                    state: state
                  }) : React.createElement(App$ViewWaiting, {
                    dispatch: dispatch,
                    el: props.el
                  }));
}

var App = {
  make: App$App
};

var rootElement = document.querySelector("body");

if (!(rootElement == null)) {
  var dummyEl = Inject.Inject.createInjectElement(undefined);
  var root = Client.createRoot(dummyEl);
  root.render(React.createElement(App$App, {
            el: rootElement
          }));
}

export {
  config ,
  pageFromString ,
  pageToString ,
  pageToInt ,
  StrCmp ,
  Widget ,
  widgetToComponent ,
  reducer ,
  ViewWaiting ,
  ViewWidgets ,
  App ,
}
/* StrCmp Not a pure module */