// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as ReactDom from "react-dom";
import * as ReactQuery from "@rescriptbr/react-query/src/ReactQuery.bs.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import * as ReactQuery$1 from "@tanstack/react-query";

var observerConfig = {
  attributes: false,
  childList: true,
  subtree: true
};

var parentVideoTitleSelector = "ytcp-video-title";

function pause(param) {
  return new Promise((function (resolve, reject) {
                setTimeout((function (param) {
                        resolve(undefined);
                      }), 333);
              }));
}

var TestError = /* @__PURE__ */Caml_exceptions.create("TitleChecker.TestError");

async function queryDomHelp(selector, n) {
  await pause(undefined);
  if (n < 0) {
    return Promise.reject({
                RE_EXN_ID: TestError,
                _1: "huh"
              });
  }
  var maybeEl = document.querySelector(selector);
  if (maybeEl == null) {
    return await queryDomHelp(selector, n - 1 | 0);
  } else {
    return Promise.resolve(maybeEl);
  }
}

function query(param) {
  var videoTitleElQuery = Js_promise2.then(queryDomHelp(parentVideoTitleSelector, 5), (function (el) {
          return el;
        }));
  var videoTitleInputQuery = Js_promise2.then(queryDomHelp("ytcp-social-suggestion-input", 5), (function (el) {
          return el;
        }));
  return Promise.all([
              videoTitleElQuery,
              videoTitleInputQuery
            ]);
}

var viewOverLimit = React.createElement("div", {
      id: "TitleChecker.viewOverLimit",
      style: {
        color: "#dc3545",
        fontSize: "12px",
        padding: "0.2rem 1rem",
        textAlign: "right"
      }
    }, "Your title is a little long there, pal...");

function TitleChecker$TitleChecker(props) {
  var match = React.useState(function () {
        return {
                TAG: /* UnderLimit */1,
                _0: 0.0
              };
      });
  var setState = match[1];
  var state = match[0];
  var queryResult = ReactQuery$1.useQuery({
        queryKey: ["todos"],
        queryFn: query,
        staleTime: Caml_option.some(ReactQuery.time({
                  NAME: "number",
                  VAL: 1
                })),
        refetchOnMount: Caml_option.some(ReactQuery.refetchOnMount({
                  NAME: "bool",
                  VAL: true
                })),
        refetchOnWindowFocus: Caml_option.some(ReactQuery.refetchOnWindowFocus({
                  NAME: "bool",
                  VAL: false
                }))
      });
  var viewProgress = function (len) {
    var w_ = len / 60.0 * 100.0;
    var w = Math.min(w_, 100.0);
    var width = String(w) + "%";
    var backgroundColor = len > 60.0 ? "red" : (
        len > 42.0 ? "yellow" : "green"
      );
    return React.createElement("div", undefined, React.createElement("div", {
                    style: {
                      backgroundColor: backgroundColor,
                      height: "2px",
                      width: width
                    }
                  }));
  };
  var children;
  children = state.TAG === /* OverLimit */0 ? [
      viewProgress(state._0),
      viewOverLimit
    ] : [viewProgress(state._0)];
  if (queryResult.isLoading) {
    return "Loading...";
  }
  if (queryResult.isError) {
    return React.createElement(React.Fragment, undefined);
  }
  var match$1 = queryResult.data;
  if (match$1 === undefined) {
    return React.createElement(React.Fragment, undefined);
  }
  if (match$1.length !== 2) {
    return React.createElement(React.Fragment, undefined);
  }
  var videoTitleEl = match$1[0];
  var videoTitleInput = match$1[1];
  var watcher = function (mutationList, observer) {
    var text = videoTitleInput.innerText;
    var textboxLen = text.length;
    if (textboxLen > 60.0) {
      Curry._1(setState, (function (param) {
              return {
                      TAG: /* OverLimit */0,
                      _0: textboxLen
                    };
            }));
    } else {
      Curry._1(setState, (function (param) {
              return {
                      TAG: /* UnderLimit */1,
                      _0: textboxLen
                    };
            }));
    }
    observer.disconnect();
  };
  var observer = new MutationObserver(watcher);
  observer.observe(videoTitleInput, observerConfig);
  var text = videoTitleInput.innerText;
  var len = text.length;
  var initialState = len > 60.0 ? ({
        TAG: /* OverLimit */0,
        _0: len
      }) : ({
        TAG: /* UnderLimit */1,
        _0: len
      });
  if (Caml_obj.notequal(initialState, state)) {
    Curry._1(setState, (function (param) {
            return initialState;
          }));
  }
  return ReactDom.createPortal(children, videoTitleEl);
}

var TitleChecker = {
  viewOverLimit: viewOverLimit,
  make: TitleChecker$TitleChecker
};

var client = new ReactQuery$1.QueryClient();

function TitleChecker$1(props) {
  return React.createElement(ReactQuery$1.QueryClientProvider, {
              client: client,
              children: React.createElement(TitleChecker$TitleChecker, {})
            });
}

var make = TitleChecker$1;

export {
  observerConfig ,
  parentVideoTitleSelector ,
  pause ,
  TestError ,
  queryDomHelp ,
  query ,
  TitleChecker ,
  client ,
  make ,
}
/* viewOverLimit Not a pure module */
