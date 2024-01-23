// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ui from "../Ui.bs.mjs";
import * as React from "react";
import * as Schema from "../../Data/Schema.bs.mjs";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as ReactDom from "react-dom";
import * as ReactQuery from "@rescriptbr/react-query/src/ReactQuery.bs.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import Box from "@mui/material/Box";
import * as JsxRuntime from "react/jsx-runtime";
import List from "@mui/material/List";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import * as ReactQuery$1 from "@tanstack/react-query";
import Collapse from "@mui/material/Collapse";
import ListItem from "@mui/material/ListItem";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Input from "@mui/icons-material/Input";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";
import NoteAdd from "@mui/icons-material/NoteAdd";
import ListSubheader from "@mui/material/ListSubheader";
import ListItemButton from "@mui/material/ListItemButton";
import ExpandLess from "@mui/icons-material/ExpandLess";
import ExpandMore from "@mui/icons-material/ExpandMore";

var videoDescriptionSelector = "ytcp-video-description";

var videoDescriptionTextboxSelector = [
    videoDescriptionSelector,
    "#textbox"
  ].join(" ");

function query(param) {
  return Promise.all([
                videoDescriptionSelector,
                videoDescriptionTextboxSelector
              ].map(function (selector) {
                  return Js_promise2.then(Ui.queryDom(undefined, selector, 3), (function (el) {
                                return el;
                              }));
                }));
}

var name = Schema.DescriptionSnippet.tableName;

function update(state, action) {
  if (typeof action !== "object") {
    switch (action) {
      case "ClosedDialog" :
          return {
                  expandedSnippet: state.expandedSnippet,
                  maybeDialog: undefined,
                  maybeTextbox: state.maybeTextbox,
                  selectedSnippet: state.selectedSnippet,
                  snippets: state.snippets
                };
      case "OpenDialog" :
          return {
                  expandedSnippet: state.expandedSnippet,
                  maybeDialog: Caml_option.some(undefined),
                  maybeTextbox: state.maybeTextbox,
                  selectedSnippet: state.selectedSnippet,
                  snippets: state.snippets
                };
      case "SnippetFlushed" :
          return {
                  expandedSnippet: state.expandedSnippet,
                  maybeDialog: state.maybeDialog,
                  maybeTextbox: state.maybeTextbox,
                  selectedSnippet: undefined,
                  snippets: state.snippets
                };
      
    }
  } else {
    switch (action.TAG) {
      case "ExpandedSnippet" :
          return {
                  expandedSnippet: undefined === state.expandedSnippet ? action._0 : undefined,
                  maybeDialog: state.maybeDialog,
                  maybeTextbox: state.maybeTextbox,
                  selectedSnippet: state.selectedSnippet,
                  snippets: state.snippets
                };
      case "GotSnippets" :
          return {
                  expandedSnippet: state.expandedSnippet,
                  maybeDialog: state.maybeDialog,
                  maybeTextbox: state.maybeTextbox,
                  selectedSnippet: state.selectedSnippet,
                  snippets: action._0.map(function (s) {
                        return s;
                      })
                };
      case "GotTextbox" :
          return {
                  expandedSnippet: state.expandedSnippet,
                  maybeDialog: state.maybeDialog,
                  maybeTextbox: Caml_option.some(action._0),
                  selectedSnippet: state.selectedSnippet,
                  snippets: state.snippets
                };
      case "SelectedSnippet" :
          return {
                  expandedSnippet: state.expandedSnippet,
                  maybeDialog: state.maybeDialog,
                  maybeTextbox: state.maybeTextbox,
                  selectedSnippet: action._0,
                  snippets: state.snippets
                };
      
    }
  }
}

function Description$Snippets(props) {
  var initialState_snippets = [];
  var initialState = {
    expandedSnippet: undefined,
    maybeDialog: undefined,
    maybeTextbox: undefined,
    selectedSnippet: undefined,
    snippets: initialState_snippets
  };
  var match = React.useReducer(update, initialState);
  var dispatch = match[1];
  var state = match[0];
  React.useEffect((function () {
          var onMessageListener = function (param) {
            var tag = param.tag;
            if (tag === "init") {
              var snippets = param.payload.map(function (snippet) {
                    var d = snippet.date.toString();
                    var date = new Date(d);
                    return {
                            body: snippet.body,
                            category_id: snippet.category_id,
                            date: date,
                            id: snippet.id,
                            name: snippet.name,
                            order: snippet.order
                          };
                  });
              dispatch({
                    TAG: "GotSnippets",
                    _0: snippets
                  });
            } else {
              throw {
                    RE_EXN_ID: "Match_failure",
                    _1: [
                      "Description.res",
                      64,
                      8
                    ],
                    Error: new Error()
                  };
            }
            console.log("app chrome port inbound", tag);
          };
          var port = chrome.runtime.connect({
                name: name
              });
          port.onMessage.addListener(onMessageListener);
        }), []);
  React.useEffect(function () {
        var match = state.maybeTextbox;
        var match$1 = state.selectedSnippet;
        if (match !== undefined && match$1 !== undefined) {
          var textbox = Caml_option.valFromOption(match);
          var oldText = textbox.innerText;
          var newText = [
              oldText,
              match$1.body
            ].join("\n-\n");
          textbox.innerText = newText;
          var ev = new Event("input");
          textbox.dispatchEvent(ev);
          dispatch("SnippetFlushed");
        }
        
      });
  var viewActivateBtn = JsxRuntime.jsx(Button, {
        children: "Add Snippet",
        onClick: (function (param) {
            dispatch("OpenDialog");
          }),
        endIcon: Caml_option.some(JsxRuntime.jsx(NoteAdd, {})),
        sx: {
          width: "130px",
          margin: "1rem 0"
        },
        variant: "contained"
      });
  var viewRow = function (snippet) {
    var isExpanded = Caml_obj.equal(snippet, state.expandedSnippet);
    return JsxRuntime.jsxs(React.Fragment, {
                children: [
                  JsxRuntime.jsx(ListItem, {
                        children: Caml_option.some(JsxRuntime.jsxs(ListItemButton, {
                                  children: [
                                    JsxRuntime.jsx(ListItemIcon, {
                                          children: Caml_option.some(JsxRuntime.jsx(Input, {}))
                                        }),
                                    JsxRuntime.jsx(ListItemText, {
                                          primary: Caml_option.some(JsxRuntime.jsx(Typography, {
                                                    fontSize: "1.6rem",
                                                    variant: "subtitle1",
                                                    children: Caml_option.some(snippet.name)
                                                  }))
                                        })
                                  ],
                                  onClick: (function (param) {
                                      dispatch({
                                            TAG: "SelectedSnippet",
                                            _0: snippet
                                          });
                                    })
                                })),
                        secondaryAction: Caml_option.some(JsxRuntime.jsx(IconButton, {
                                  children: Caml_option.some(isExpanded ? JsxRuntime.jsx(ExpandLess, {}) : JsxRuntime.jsx(ExpandMore, {})),
                                  onClick: (function (param) {
                                      dispatch({
                                            TAG: "ExpandedSnippet",
                                            _0: snippet
                                          });
                                    })
                                }))
                      }),
                  JsxRuntime.jsx(Collapse, {
                        children: Caml_option.some(JsxRuntime.jsx(Box, {
                                  children: Caml_option.some(JsxRuntime.jsx(Typography, {
                                            fontSize: "1.2rem",
                                            variant: "body1",
                                            children: Caml_option.some(snippet.body)
                                          })),
                                  sx: {
                                    padding: "1rem 1.2rem"
                                  }
                                })),
                        in: isExpanded
                      })
                ]
              });
  };
  var viewSnippets = function (snippets) {
    return JsxRuntime.jsx(List, {
                children: Caml_option.some(snippets.map(viewRow)),
                subheader: Caml_option.some(JsxRuntime.jsx(ListSubheader, {
                          children: Caml_option.some(JsxRuntime.jsx(Typography, {
                                    padding: "1.2rem 0",
                                    variant: "h5",
                                    children: "Select snippets"
                                  }))
                        }))
              });
  };
  var viewDialog = function () {
    return JsxRuntime.jsx(Dialog, {
                open: true,
                children: Caml_option.some(viewSnippets(state.snippets)),
                fullWidth: true,
                maxWidth: "xs",
                onClose: (function (param, param$1) {
                    dispatch("ClosedDialog");
                  })
              });
  };
  var view = function (state) {
    var match = state.maybeDialog;
    var maybeDialog = match !== undefined ? viewDialog() : null;
    return [
            maybeDialog,
            viewActivateBtn
          ];
  };
  var queryResult = ReactQuery$1.useQuery({
        queryKey: [name],
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
  var match$1 = queryResult.data;
  if (match$1 === undefined) {
    return null;
  }
  if (match$1.length !== 2) {
    return null;
  }
  var el = match$1[0];
  var videoDescriptionTextboxEl = match$1[1];
  if (undefined === state.maybeTextbox) {
    dispatch({
          TAG: "GotTextbox",
          _0: videoDescriptionTextboxEl
        });
  }
  return ReactDom.createPortal(view(state), el);
}

var Snippets = {
  name: name,
  update: update,
  make: Description$Snippets
};

var client = new ReactQuery$1.QueryClient();

function Description(props) {
  return JsxRuntime.jsx(ReactQuery$1.QueryClientProvider, {
              client: client,
              children: JsxRuntime.jsx(Description$Snippets, {})
            });
}

var make = Description;

export {
  videoDescriptionSelector ,
  videoDescriptionTextboxSelector ,
  query ,
  Snippets ,
  client ,
  make ,
}
/* videoDescriptionTextboxSelector Not a pure module */
