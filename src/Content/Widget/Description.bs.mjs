// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Id from "rescript/lib/es6/belt_Id.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";

var cmp = Caml_obj.compare;

var IntCmp = Belt_Id.MakeComparable({
      cmp: cmp
    });

function Description$Templates(props) {
  return null;
}

var Templates = {
  IntCmp: IntCmp,
  make: Description$Templates
};

function Description(props) {
  return React.createElement(Description$Templates, {
              model: props.model
            });
}

var make = Description;

export {
  Templates ,
  make ,
}
/* IntCmp Not a pure module */
