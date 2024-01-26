// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Hooks from "../Util/Hooks.bs.mjs";
import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Option from "@rescript/core/src/Core__Option.bs.mjs";
import Box from "@mui/material/Box";
import * as JsxRuntime from "react/jsx-runtime";
import Card from "@mui/material/Card";
import List from "@mui/material/List";
import Paper from "@mui/material/Paper";
import Button from "@mui/material/Button";
import Divider from "@mui/material/Divider";
import Collapse from "@mui/material/Collapse";
import ListItem from "@mui/material/ListItem";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import ListItemText from "@mui/material/ListItemText";
import ListSubheader from "@mui/material/ListSubheader";

var name = "SnippetEditor";

function SnippetEditor(props) {
  var newSnippet_date = new Date();
  var newSnippet = {
    body: "Snippet text",
    category_id: 0,
    date: newSnippet_date,
    id: undefined,
    name: "New Snippet",
    order: -1
  };
  var match = Hooks.DescriptionSnippet.useWhatever(name);
  var maybePort = match[1];
  var snippets_ = match[0];
  var initialState = {
    form: {
      newSnippet: newSnippet,
      snippets: []
    }
  };
  var update = function (state, action) {
    if (typeof action !== "object") {
      var oldForm = state.form;
      var form_newSnippet = oldForm.newSnippet;
      var form_snippets = snippets_.map(function (s) {
            return [
                    s,
                    false
                  ];
          });
      var form = {
        newSnippet: form_newSnippet,
        snippets: form_snippets
      };
      return {
              form: form
            };
    }
    switch (action.TAG) {
      case "GotSnippets" :
          return {
                  form: {
                    newSnippet: newSnippet,
                    snippets: snippets_.map(function (s) {
                          return [
                                  s,
                                  false
                                ];
                        })
                  }
                };
      case "SetSnippet" :
          var snippet = action._0;
          var oldForm$1 = state.form;
          if (snippet.id === undefined) {
            return {
                    form: {
                      newSnippet: snippet,
                      snippets: oldForm$1.snippets
                    }
                  };
          }
          var snippets = oldForm$1.snippets.map(function (param) {
                var s = param[0];
                if (Caml_obj.equal(s.id, snippet.id)) {
                  return [
                          snippet,
                          true
                        ];
                } else {
                  return [
                          s,
                          param[1]
                        ];
                }
              });
          var form_newSnippet$1 = oldForm$1.newSnippet;
          var form$1 = {
            newSnippet: form_newSnippet$1,
            snippets: snippets
          };
          return {
                  form: form$1
                };
      case "Submitted" :
          var snippet$1 = action._0;
          Core__Option.mapWithDefault(maybePort, undefined, (function (port) {
                  var message = snippet$1.id === undefined ? ({
                        TAG: "SaveNewSnippet",
                        _0: snippet$1
                      }) : ({
                        TAG: "EditSnippet",
                        _0: snippet$1
                      });
                  port.postMessage(message);
                }));
          return state;
      
    }
  };
  var match$1 = React.useReducer(update, initialState);
  var dispatch = match$1[1];
  var state = match$1[0];
  React.useEffect((function () {
          dispatch({
                TAG: "GotSnippets",
                _0: snippets_
              });
        }), [snippets_]);
  var viewSnippetForm = function (param) {
    var isChanged = param[1];
    var snippet = param[0];
    var match = snippet.id === undefined ? [
        "New Snippet Text",
        "New Snippet Name"
      ] : [
        "Body",
        "Name"
      ];
    return JsxRuntime.jsxs("form", {
                children: [
                  JsxRuntime.jsx(TextField, {
                        defaultValue: snippet.name,
                        fullWidth: true,
                        label: Caml_option.some(match[1]),
                        onChange: (function ($$event) {
                            var value = $$event.currentTarget.value;
                            dispatch({
                                  TAG: "SetSnippet",
                                  _0: {
                                    body: snippet.body,
                                    category_id: snippet.category_id,
                                    date: snippet.date,
                                    id: snippet.id,
                                    name: value,
                                    order: snippet.order
                                  }
                                });
                          }),
                        value: snippet.name
                      }),
                  JsxRuntime.jsx(TextField, {
                        defaultValue: snippet.body,
                        fullWidth: true,
                        label: Caml_option.some(match[0]),
                        multiline: true,
                        onChange: (function ($$event) {
                            var value = $$event.currentTarget.value;
                            dispatch({
                                  TAG: "SetSnippet",
                                  _0: {
                                    body: value,
                                    category_id: snippet.category_id,
                                    date: snippet.date,
                                    id: snippet.id,
                                    name: snippet.name,
                                    order: snippet.order
                                  }
                                });
                          }),
                        sx: {
                          margin: "1rem 0"
                        },
                        value: snippet.body
                      }),
                  JsxRuntime.jsxs(Box, {
                        children: [
                          undefined !== snippet.id ? JsxRuntime.jsx(Button, {
                                  children: "Undo Changes",
                                  type: "button",
                                  onClick: (function (param) {
                                      dispatch("UndoChanges");
                                    }),
                                  disabled: !isChanged,
                                  variant: "text"
                                }) : null,
                          JsxRuntime.jsx(Button, {
                                children: "Save",
                                type: "submit",
                                disabled: !isChanged,
                                variant: "contained"
                              })
                        ]
                      })
                ],
                onSubmit: (function (e) {
                    e.preventDefault();
                    dispatch({
                          TAG: "Submitted",
                          _0: snippet
                        });
                  })
              });
  };
  var viewSnippet = function (param) {
    var snippet = param[0];
    var prefix = undefined === snippet.id ? "Add" : "Edit";
    return JsxRuntime.jsxs(Card, {
                sx: {
                  margin: 2.0
                },
                children: [
                  JsxRuntime.jsx(ListItem, {
                        children: Caml_option.some(JsxRuntime.jsx(ListItemText, {
                                  primary: Caml_option.some(JsxRuntime.jsx(Typography, {
                                            variant: "subtitle1",
                                            children: Caml_option.some([
                                                    prefix,
                                                    snippet.name
                                                  ].join(" - "))
                                          }))
                                }))
                      }),
                  JsxRuntime.jsx(Collapse, {
                        children: Caml_option.some(JsxRuntime.jsx(Box, {
                                  children: Caml_option.some(viewSnippetForm([
                                            snippet,
                                            param[1]
                                          ])),
                                  sx: {
                                    padding: "1rem 1.6rem"
                                  }
                                })),
                        in: true
                      })
                ]
              });
  };
  var view = function () {
    return JsxRuntime.jsx(Paper, {
                style: {
                  minWidth: "720px"
                },
                elevation: 0,
                children: Caml_option.some(JsxRuntime.jsx(List, {
                          children: Caml_option.some([
                                  [viewSnippet([
                                          state.form.newSnippet,
                                          true
                                        ])],
                                  [JsxRuntime.jsx(Divider, {})],
                                  state.form.snippets.map(viewSnippet)
                                ].flat()),
                          subheader: Caml_option.some(JsxRuntime.jsx(ListSubheader, {
                                    children: Caml_option.some(JsxRuntime.jsx(Box, {
                                              children: Caml_option.some(JsxRuntime.jsx(Typography, {
                                                        padding: "1.2rem 0",
                                                        variant: "h5",
                                                        children: "Edit Snippets"
                                                      }))
                                            }))
                                  }))
                        }))
              });
  };
  return view();
}

var make = SnippetEditor;

export {
  name ,
  make ,
}
/* Hooks Not a pure module */
