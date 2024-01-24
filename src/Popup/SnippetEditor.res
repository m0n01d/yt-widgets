let name = "SnippetEditor"
type model = {snippets: array<Schema.DescriptionSnippet.t>}

type msg = GotSnippets(array<Schema.DescriptionSnippet.t>)
let update = (state: model, action: msg) => {
  switch action {
  | GotSnippets(snippets) => state
  }
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
        <Mui.TextField label={"Name"->React.string} defaultValue={snippet.name} />
        <Mui.TextField label={"Body"->React.string} multiline={true} defaultValue={snippet.body} />
      </Mui.Box>
    </Mui.Collapse>
  </Mui.Box>
}

let view = (snippets: array<Schema.DescriptionSnippet.t>) => {
  <Mui.List
    subheader={<Mui.ListSubheader>
      <Mui.Typography variant={H5} padding={"1.2rem 0"->Mui.System.Value.String}>
        {"Edit Snippets"->React.string}
      </Mui.Typography>
    </Mui.ListSubheader>}>
    {snippets->Array.map(viewSnippet)->React.array}
  </Mui.List>
}
@react.component
let make = () => {
  let initialState = {
    snippets: [],
  }
  let (state, dispatch) = React.useReducer(update, initialState)

  let snippets = Hooks.DescriptionSnippet.useWhatever(name)

  {snippets->view}
}
