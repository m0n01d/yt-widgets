let name = "SnippetEditor"
type model = {snippets: array<Schema.DescriptionSnippet.t>}

type msg = GotSnippets(array<Schema.DescriptionSnippet.t>)
let update = (state: model, action: msg) => {
  switch action {
  | GotSnippets(snippets) => state
  }
}
@react.component
let make = () => {
  let initialState = {
    snippets: [],
  }
  let (state, dispatch) = React.useReducer(update, initialState)

  let snippets = Hooks.DescriptionSnippet.useWhatever(name)

  <> {snippets->Js.Json.stringifyAny->Option.getWithDefault("no")->React.string} </>
}
