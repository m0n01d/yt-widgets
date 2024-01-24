open Webapi
open Webapi.Dom
let videoDescriptionSelector = "ytcp-video-description"
let videoDescriptionTextboxSelector = [videoDescriptionSelector, "#textbox"]->Array.joinWith(" ")
let query = _ => {
  [videoDescriptionSelector, videoDescriptionTextboxSelector]
  ->Js.Array2.map(selector => Ui.queryDom(None, selector, 3)->Js.Promise2.then(el => el))
  ->Js.Promise2.all
}

module Snippets = {
  let name = "Description.Snippets"

  type model = {
    // @TODO clean up these maybes..
    // how can we model this better?
    expandedSnippet: option<Schema.DescriptionSnippet.t>,
    maybeDialog: option<unit>,
    maybeTextbox: option<Dom.Element.t>,
    selectedSnippet: option<Schema.DescriptionSnippet.t>,
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
        expandedSnippet: if state.expandedSnippet == None {
          Some(snippet)
        } else if state.expandedSnippet == Some(snippet) {
          None
        } else {
          Some(snippet)
        },
      }

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
    }
    let (state, dispatch) = React.useReducer(update, initialState)

    let snippets = Hooks.DescriptionSnippet.useWhatever(name)

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
      <Mui.Box
        sx={Mui.Sx.obj({
          borderBottom: Mui.System.Value.Number(1.0),
          borderColor: Mui.System.Value.PrimaryMain,
        })}>
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
            <Mui.Typography variant={Body1} style={ReactDOM.Style.make(~whiteSpace="pre-wrap", ())}>
              {snippet.body->React.string}
            </Mui.Typography>
          </Mui.Box>
        </Mui.Collapse>
      </Mui.Box>
    }
    let viewSnippets = snippets => {
      <Mui.List
        subheader={<Mui.ListSubheader>
          <Mui.Typography variant={H5} padding={"1.2rem 0"->Mui.System.Value.String}>
            {"Select Snippets"->React.string}
          </Mui.Typography>
        </Mui.ListSubheader>}>
        {snippets->Array.map(viewRow)->React.array}
      </Mui.List>
    }

    let viewDialog = () => {
      <Mui.Dialog
        fullWidth={true}
        onClose={(_, _) => dispatch(ClosedDialog)}
        maxWidth={Xs}
        open_={true}
        sx={Mui.Sx.obj({zIndex: {Mui.System.Value.Number(2206.0)}})}>
        {snippets->viewSnippets}
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
