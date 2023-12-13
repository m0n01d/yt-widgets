// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as ReactDom from "react-dom";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var ytSelector = "ytcp-video-title";

var moConfig = {
  attributes: true,
  childList: true,
  subtree: true
};

var viewOverLimit = React.createElement("div", {
      id: "TitleChecker.view",
      style: {
        color: "#dc3545",
        fontSize: "12px",
        padding: "0.2rem 1rem",
        textAlign: "right"
      }
    }, "Your title is a little long there, pal...");

function make(props) {
  var maybeVideoTitleEl = document.querySelector(ytSelector);
  var maybeVideoTitleInput = Belt_Option.flatMap((maybeVideoTitleEl == null) ? undefined : Caml_option.some(maybeVideoTitleEl), (function (el) {
          return Caml_option.nullable_to_opt(el.querySelector("ytcp-social-suggestion-input"));
        }));
  var initialModel = Belt_Option.mapWithDefault(maybeVideoTitleInput, /* UnderLimit */0, (function (videoTitleEl) {
          if (videoTitleEl.innerText.length > 60) {
            return /* OverLimit */1;
          } else {
            return /* UnderLimit */0;
          }
        }));
  var match = React.useState(function () {
        return initialModel;
      });
  var setState = match[1];
  var view = match[0] ? viewOverLimit : React.createElement(React.Fragment, undefined);
  var watcher = function (mutationList, observer) {
    var textboxValue = Belt_Option.map(Belt_Option.map(Belt_Array.get(mutationList, 0), (function (mutation) {
                return mutation.target;
              })), (function (el) {
            return el.innerText;
          }));
    if (textboxValue !== undefined) {
      if (textboxValue.length > 60) {
        Curry._1(setState, (function (param) {
                return /* OverLimit */1;
              }));
      } else {
        Curry._1(setState, (function (param) {
                return /* UnderLimit */0;
              }));
      }
    } else {
      console.log("no");
    }
    console.log("from res", mutationList);
  };
  var observer = new MutationObserver(watcher);
  if (!(maybeVideoTitleEl == null) && maybeVideoTitleInput !== undefined) {
    observer.observe(Caml_option.valFromOption(maybeVideoTitleInput), moConfig);
    return ReactDom.createPortal(view, maybeVideoTitleEl);
  } else {
    return React.createElement(React.Fragment, undefined);
  }
}

export {
  ytSelector ,
  moConfig ,
  viewOverLimit ,
  make ,
}
/* viewOverLimit Not a pure module */
