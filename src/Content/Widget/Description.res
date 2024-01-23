open Webapi
open Webapi.Dom
let videoDescriptionSelector = "ytcp-video-description"
let videoDescriptionTextboxSelector = [videoDescriptionSelector, "#textbox"]->Array.joinWith(" ")
let query = _ => {
  [videoDescriptionSelector, videoDescriptionTextboxSelector]
  ->Js.Array2.map(selector => Ui.queryDom(None, selector, 3)->Js.Promise2.then(el => el))
  ->Js.Promise2.all
}

type snippet = {body: string}
module Snippets = {
  let name = Schema.DescriptionSnippet.tableName // tableName and Port name match for easy lookup

  type model = {
    // @TODO clean up these maybes..
    // how can we model this better?
    expandedSnippet: option<Schema.DescriptionSnippet.t>,
    maybeDialog: option<unit>,
    maybeTextbox: option<Dom.Element.t>,
    selectedSnippet: option<Schema.DescriptionSnippet.t>,
    snippets: array<Schema.DescriptionSnippet.t>,
  }

  type msg =
    | ClosedDialog
    | ExpandedSnippet(Schema.DescriptionSnippet.t)
    | GotSnippets(array<Schema.DescriptionSnippet.t>)
    | GotTextbox(Dom.Element.t)
    | OpenDialog
    | SelectedSnippet(Schema.DescriptionSnippet.t)
    | SnippetFlushed

  let update = (state: model, action: msg) => {
    switch action {
    | ClosedDialog => {...state, maybeDialog: None}
    | ExpandedSnippet(snippet) => {
        ...state,
        expandedSnippet: if None == state.expandedSnippet {
          Some(snippet)
        } else {
          None
        },
      }
    | GotSnippets(newSnippets) => {...state, snippets: newSnippets->Array.map(s => s)}
    | GotTextbox(textbox) => {...state, maybeTextbox: Some(textbox)}
    | OpenDialog => {...state, maybeDialog: Some()}
    | SelectedSnippet(snippet) => {...state, selectedSnippet: Some(snippet)}
    | SnippetFlushed => {...state, selectedSnippet: None}
    }
  }

  @react.component
  let make = () => {
    let initialState = {
      expandedSnippet: None,
      maybeDialog: None,
      maybeTextbox: None,
      selectedSnippet: None,
      snippets: [],
    }
    let (state, dispatch) = React.useReducer(update, initialState)

    React.useEffect0(() => {
      let onMessageListener: Chrome.Runtime.Port.message<'a> => unit = ({payload, tag}) => {
        switch tag {
        | "init" => {
            let snippets = payload->Js.Array2.map((snippet: Schema.DescriptionSnippet.t) => {
              let d = snippet.date->Js.Date.toString
              let date = Js.Date.fromString(d)
              // Hack to get around the fact that it type checks
              // but the `date` field gets converted to a string when coming over the Port
              // create a new date from the old stringified date so that
              // date functions work properly

              {...snippet, date}
            })
            dispatch(GotSnippets(snippets))
          }
        }
        Js.log2("app chrome port inbound", tag)
      }
      let port = Chrome.Runtime.connect({name: name})
      Chrome.Runtime.Port.addListener(port, onMessageListener)

      //   let message: Chrome.Runtime.Port.message<'a> = {payload: None, tag: "ready"}
      //   port->Chrome.Runtime.Port.postMessage(message)

      None
    })

    React.useEffectOnEveryRender(() => {
      switch (state.maybeTextbox, state.selectedSnippet) {
      | (Some(textbox), Some(snippet)) => {
          let oldText = textbox->Dom.Element.innerText
          let newText = [oldText, snippet.body]->Array.joinWith("\n-\n")
          textbox->Dom.Element.setInnerText(newText)
          let ev = Dom.Event.make("input")
          textbox->Dom.Element.dispatchEvent(ev)->ignore
          dispatch(SnippetFlushed)
        }
      | _ => ()
      }
      None
    })

    let viewActivateBtn = {
      <Mui.Button
        endIcon={<Ui.Icon.NoteAdd />}
        onClick={_ => dispatch(OpenDialog)}
        sx={Mui.Sx.obj({
          margin: Mui.System.Value.String("1rem 0"),
          width: Mui.System.Value.String("130px"),
        })}
        variant={Contained}>
        {"Add Snippet"->React.string}
      </Mui.Button>
    }
    let viewRow = (snippet: Schema.DescriptionSnippet.t) => {
      let isExpanded = Some(snippet) == state.expandedSnippet
      <React.Fragment>
        <Mui.ListItem
          secondaryAction={<Mui.IconButton onClick={_ => dispatch(ExpandedSnippet(snippet))}>
            {if isExpanded {
              <Ui.Icon.Expand.Less />
            } else {
              <Ui.Icon.Expand.More />
            }}
          </Mui.IconButton>}>
          <Mui.ListItemButton onClick={_ => dispatch(SelectedSnippet(snippet))}>
            <Mui.ListItemIcon>
              <Ui.Icon.Input />
            </Mui.ListItemIcon>
            <Mui.ListItemText
              primary={<Mui.Typography variant={Subtitle1}>
                {snippet.name->React.string}
              </Mui.Typography>}
            />
          </Mui.ListItemButton>
        </Mui.ListItem>
        <Mui.Collapse in_={isExpanded}>
          <Mui.Box sx={Mui.Sx.obj({padding: Mui.System.Value.String("1rem 1.6rem")})}>
            <Mui.Typography variant={Body1}> {snippet.body->React.string} </Mui.Typography>
          </Mui.Box>
        </Mui.Collapse>
      </React.Fragment>
    }
    let viewSnippets = snippets => {
      <Mui.List
        subheader={<Mui.ListSubheader>
          <Mui.Typography variant={H5} padding={"1.2rem 0"->Mui.System.Value.String}>
            {"Select snippets"->React.string}
          </Mui.Typography>
        </Mui.ListSubheader>}>
        {snippets->Array.map(viewRow)->React.array}
      </Mui.List>
    }

    let viewDialog = () => {
      <Mui.Dialog
        fullWidth={true} onClose={(_, _) => dispatch(ClosedDialog)} maxWidth={Xs} open_={true}>
        {state.snippets->viewSnippets}
      </Mui.Dialog>
    }

    let view = state => {
      let maybeDialog = switch state.maybeDialog {
      | None => React.null
      | Some(_) => viewDialog()
      }

      let children = [maybeDialog, viewActivateBtn]
      React.array(children)
    }

    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: [name],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
    })

    switch queryResult {
    | {data: Some([el, videoDescriptionTextboxEl]), _} => {
        if None == state.maybeTextbox {
          dispatch(GotTextbox(videoDescriptionTextboxEl))
        }
        ReactDOM.createPortal(view(state), el)
      }
    | _ => React.null
    }
  }
}

let client = ReactQuery.Provider.createClient()
@react.component
let make = () => {
  <ReactQuery.Provider client>
    <Snippets />
  </ReactQuery.Provider>
}
