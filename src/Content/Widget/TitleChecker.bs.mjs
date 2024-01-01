// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ui from "../Ui.bs.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as ReactDom from "react-dom";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ReactQuery from "@rescriptbr/react-query/src/ReactQuery.bs.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import * as Material from "@mui/material";
import * as Colors from "@mui/material/colors";
import * as ReactQuery$1 from "@tanstack/react-query";

var observerConfig = {
  attributes: false,
  childList: true,
  subtree: true
};

function query(maybeUploadDialog, param) {
  var videoTitleElQuery = Js_promise2.then(Ui.queryDom(maybeUploadDialog, "ytcp-video-title", 5), (function (el) {
          return el;
        }));
  var videoTitleInputElQuery = Js_promise2.then(Ui.queryDom(maybeUploadDialog, "ytcp-social-suggestion-input", 5), (function (el) {
          return el;
        }));
  return Promise.all([
              videoTitleElQuery,
              videoTitleInputElQuery
            ]);
}

var viewOverLimit = React.createElement("div", {
      id: "TitleChecker.view",
      style: {
        color: "#dc3545",
        fontSize: "12px",
        padding: "0.2rem 1rem",
        textAlign: "right"
      }
    }, "Your title is a little long there, pal...");

function TitleChecker$TitleChecker(props) {
  var maybeUploadDialog = props.maybeUploadDialog;
  var match = React.useState(function () {
        return {
                TAG: /* UnderLimit */1,
                _0: 0.0
              };
      });
  var setState = match[1];
  var state = match[0];
  var viewProgress = function (len) {
    var w_ = len / 60.0 * 100.0;
    var w = Math.min(w_, 100.0);
    String(w) + "%";
    var backgroundColor = len > 60.0 ? Colors.red[500] : (
        len > 42.0 ? Colors.yellow[300] : Colors.green[300]
      );
    return React.createElement("div", {
                style: {
                  color: backgroundColor
                }
              }, React.createElement(Material.LinearProgress, {
                    variant: "determinate",
                    color: "inherit",
                    value: w
                  }));
  };
  var children;
  children = state.TAG === /* OverLimit */0 ? [
      viewProgress(state._0),
      viewOverLimit
    ] : [viewProgress(state._0)];
  var watcher = function (mutationList, observer) {
    var textboxLen = Belt_Option.mapWithDefault(Belt_Option.map(Belt_Option.map(Belt_Array.get(mutationList, 0), (function (mutation) {
                    return mutation.target;
                  })), (function (el) {
                return el.innerText;
              })), 0, (function (text) {
            return text.length;
          }));
    if (textboxLen > 60.0) {
      return Curry._1(setState, (function (param) {
                    return {
                            TAG: /* OverLimit */0,
                            _0: textboxLen
                          };
                  }));
    } else {
      return Curry._1(setState, (function (param) {
                    return {
                            TAG: /* UnderLimit */1,
                            _0: textboxLen
                          };
                  }));
    }
  };
  var observer = new MutationObserver(watcher);
  var queryResult = ReactQuery$1.useQuery({
        queryKey: ["titlechecker"],
        queryFn: (function (param) {
            return query(maybeUploadDialog, param);
          }),
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
  if (queryResult.isLoading) {
    return "Loading...";
  }
  if (!queryResult.isError) {
    var match$1 = queryResult.data;
    if (match$1 !== undefined && match$1.length === 2) {
      var videoTitleEl = match$1[0];
      var videoTitleInput = match$1[1];
      var len = videoTitleInput.innerText.length;
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
      observer.observe(videoTitleInput, observerConfig);
      return ReactDom.createPortal(children, videoTitleEl);
    }
    
  }
  throw {
        RE_EXN_ID: "Match_failure",
        _1: [
          "TitleChecker.res",
          88,
          4
        ],
        Error: new Error()
      };
}

var TitleChecker = {
  make: TitleChecker$TitleChecker
};

var client = new ReactQuery$1.QueryClient();

function TitleChecker$1(props) {
  return React.createElement(ReactQuery$1.QueryClientProvider, {
              client: client,
              children: React.createElement(TitleChecker$TitleChecker, {
                    maybeUploadDialog: props.maybeUploadDialog
                  })
            });
}

var ytSelector = "ytcp-video-title";

var make = TitleChecker$1;

export {
  observerConfig ,
  query ,
  ytSelector ,
  viewOverLimit ,
  TitleChecker ,
  client ,
  make ,
}
/* viewOverLimit Not a pure module */
