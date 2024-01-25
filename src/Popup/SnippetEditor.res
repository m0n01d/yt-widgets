open Webapi.Dom
let name = "SnippetEditor"

type form = {newSnippet: Schema.DescriptionSnippet.t, snippets: array<Schema.DescriptionSnippet.t>}
type model = {form: form}

type tag = TableAdd(Schema.DescriptionSnippet.t) | TablePut(Schema.DescriptionSnippet.t)

type msg =
  | GotSnippets(array<Schema.DescriptionSnippet.t>)
  | SetSnippet(Schema.DescriptionSnippet.t)
  | Submitted(Schema.DescriptionSnippet.t)

@react.component
let make = () => {
  let newSnippet: Schema.DescriptionSnippet.t = {
    body: "Snippet text",
    category_id: 0,
    date: Js.Date.make(),
    id: None,
    name: "New Snippet",
    order: -1,
  }
  let (snippets_, maybePort) = Hooks.DescriptionSnippet.useWhatever(name)
  let update = (state: model, action: msg) => {
    switch action {
    | GotSnippets(snippets) => {...state, form: {newSnippet, snippets}}
    | SetSnippet(snippet) => {
        let oldForm = state.form
        if snippet.id == None {
          {...state, form: {...oldForm, newSnippet: snippet}}
        } else {
          let snippets = oldForm.snippets->Array.map(s => {
            if s.id == snippet.id {
              snippet
            } else {
              s
            }
          })
          let form = {...oldForm, snippets}
          {...state, form}
        }
      }
    | Submitted(snippet) => {
        maybePort->Option.mapWithDefault((), port => {
          let message = if snippet.id == None {
            TableAdd(snippet)
          } else {
            TablePut(snippet)
          }
          port->Chrome.Runtime.Port.postMessage(message)
        })
        state
      }
    }
  }
  let initialState = {
    {
      form: {newSnippet, snippets: []},
    }
  }
  let (state, dispatch) = React.useReducer(update, initialState)

  React.useEffect1(() => {
    dispatch(GotSnippets(snippets_))

    None
  }, [snippets_])

  let viewSnippetForm = (snippet: Schema.DescriptionSnippet.t) => {
    let (bodyLabel, nameLabel) = if snippet.id == None {
      ("New Snippet Text", "New Snippet Name")
    } else {
      ("Body", "Name")
    }
    <form
      onSubmit={e => {
        ReactEvent.Form.preventDefault(e)
        dispatch(Submitted(snippet))
      }}>
      <Mui.TextField
        label={nameLabel->React.string}
        defaultValue={snippet.name}
        value={snippet.name}
        fullWidth={true}
        onChange={event => {
          let value = ReactEvent.Form.currentTarget(event)["value"]
          dispatch(SetSnippet({...snippet, name: value}))
        }}
      />
      <Mui.TextField
        sx={Mui.Sx.obj({margin: Mui.System.Value.String("1rem 0")})}
        label={bodyLabel->React.string}
        multiline={true}
        defaultValue={snippet.body}
        value={snippet.body}
        fullWidth={true}
        onChange={event => {
          let value = ReactEvent.Form.currentTarget(event)["value"]
          dispatch(SetSnippet({...snippet, body: value}))
        }}
      />
      <Mui.Box>
        {if None != snippet.id {
          <Mui.Button type_=Button variant=Text> {"Undo Changes"->React.string} </Mui.Button>
        } else {
          React.null
        }}
        <Mui.Button type_=Submit variant=Contained> {"Save"->React.string} </Mui.Button>
      </Mui.Box>
    </form>
  }

  let viewSnippet = (snippet: Schema.DescriptionSnippet.t) => {
    let isExpanded = true
    <Mui.Box>
      <Mui.ListItem
        secondaryAction={<Mui.IconButton
        //onClick={_ => dispatch(ExpandedSnippet(snippet))}
        >
          {if isExpanded {
            <Ui.Icon.Expand.Less />
          } else {
            <Ui.Icon.Expand.More />
          }}
        </Mui.IconButton>}>
        <Mui.ListItemText
          primary={<Mui.Typography variant={Subtitle1}>
            {snippet.name->React.string}
          </Mui.Typography>}
        />
      </Mui.ListItem>
      <Mui.Collapse in_={isExpanded}>
        <Mui.Box sx={Mui.Sx.obj({padding: Mui.System.Value.String("1rem 1.6rem")})}>
          {viewSnippetForm(snippet)}
        </Mui.Box>
      </Mui.Collapse>
    </Mui.Box>
  }

  let view = () => {
    <Mui.Paper elevation={1} style={ReactDOM.Style.make(~minWidth="720px", ())}>
      <Mui.List
        subheader={<Mui.ListSubheader>
          <Mui.Typography variant={H5} padding={"1.2rem 0"->Mui.System.Value.String}>
            {"Edit Snippets"->React.string}
          </Mui.Typography>
        </Mui.ListSubheader>}>
        {[[viewSnippet(state.form.newSnippet)], state.form.snippets->Array.map(viewSnippet)]
        ->Array.flat
        ->React.array}
      </Mui.List>
    </Mui.Paper>
  }

  {view()}
}
