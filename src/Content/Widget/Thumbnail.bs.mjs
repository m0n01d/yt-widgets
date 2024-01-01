// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ui from "../Ui.bs.mjs";
import * as React from "react";
import * as ReactDom from "react-dom";
import * as ReactQuery from "@rescriptbr/react-query/src/ReactQuery.bs.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import * as ReactQuery$1 from "@tanstack/react-query";

function query(param) {
  var sidePanelEl = Js_promise2.then(Ui.queryDom(undefined, "ytcp-video-metadata-editor-sidepanel", 3), (function (el) {
          return el;
        }));
  return Promise.all([sidePanelEl]);
}

function Thumbnail$Preview(props) {
  var queryResult = ReactQuery$1.useQuery({
        queryKey: ["Thumbnail.Preview"],
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
  var view = React.createElement("div", undefined, "This is a thumb");
  var match = queryResult.data;
  if (match === undefined) {
    return null;
  }
  if (match.length !== 1) {
    return null;
  }
  var sidePanelEl = match[0];
  return ReactDom.createPortal(view, sidePanelEl);
}

var Preview = {
  make: Thumbnail$Preview
};

var client = new ReactQuery$1.QueryClient();

function Thumbnail(props) {
  return React.createElement(ReactQuery$1.QueryClientProvider, {
              client: client,
              children: React.createElement(Thumbnail$Preview, {})
            });
}

var make = Thumbnail;

export {
  query ,
  Preview ,
  client ,
  make ,
}
/* client Not a pure module */