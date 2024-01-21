let videoDescriptionSelector = "ytcp-video-description"
let query = _ => {
  [videoDescriptionSelector]
  ->Js.Array2.map(selector => Ui.queryDom(None, selector, 3)->Js.Promise2.then(el => el))
  ->Js.Promise2.all
}

type snippet = {body: string}
module Snippets = {
  let name = Schema.DescriptionSnippet.tableName // tableName and Port name match for easy lookup

  type model = {maybeDialog: option<unit>, snippets: array<Schema.DescriptionSnippet.t>}

  type msg = GotSnippets(array<Schema.DescriptionSnippet.t>) | OpenDialog

  let update = (state: model, action: msg) => {
    switch action {
    | GotSnippets(newSnippets) => {...state, snippets: newSnippets}
    | OpenDialog => {...state, maybeDialog: Some()}
    }
  }

  @react.component
  let make = () => {
    let initialState = {maybeDialog: None, snippets: []}
    let (state, dispatch) = React.useReducer(update, initialState)
    React.useEffect0(() => {
      let onMessageListener: Chrome.Runtime.Port.message<'a> => unit = ({payload, tag}) => {
        switch tag {
        | "init" => dispatch(GotSnippets(payload))
        }
        Js.log2("app chrome port inbound", tag)
      }
      let port = Chrome.Runtime.connect({name: name})
      Chrome.Runtime.Port.addListener(port, onMessageListener)

      //   let message: Chrome.Runtime.Port.message<'a> = {payload: None, tag: "ready"}
      //   port->Chrome.Runtime.Port.postMessage(message)

      None
    })

    let viewActivateBtn = {
      <Mui.Button
        endIcon={<Mui.Icon />}
        onClick={_ => dispatch(OpenDialog)}
        sx={Mui.Sx.obj({
          margin: Mui.System.Value.String("1rem 0"),
          width: Mui.System.Value.String("100px"),
        })}
        variant={Contained}>
        {"Add Snippet"->React.string}
      </Mui.Button>
    }

    let viewRow = (snippet: Schema.DescriptionSnippet.t) => {
      let open_ = true
      <React.Fragment>
        <Mui.TableRow>
          <Mui.TableCell> {snippet.name->React.string} </Mui.TableCell>
        </Mui.TableRow>
        <Mui.TableRow>
          <Mui.TableCell>
            <Mui.Collapse in_={open_} unmountOnExit={true}>
              <Mui.Box>
                <Mui.TextField defaultValue={snippet.body->React.string} multiline={true} />
              </Mui.Box>
            </Mui.Collapse>
          </Mui.TableCell>
        </Mui.TableRow>
      </React.Fragment>
    }

    let viewCollapsibleTable = snippets => {
      <Mui.TableContainer>
        <Mui.Table>
          <Mui.TableHead>
            <Mui.TableRow>
              <Mui.TableCell> {"Column 1"->React.string} </Mui.TableCell>
            </Mui.TableRow>
          </Mui.TableHead>
          <Mui.TableBody> {snippets->Js.Array2.map(viewRow)->React.array} </Mui.TableBody>
        </Mui.Table>
      </Mui.TableContainer>
    }
    let viewDialog = () => {
      <Mui.Dialog open_={true}> {state.snippets->viewCollapsibleTable} </Mui.Dialog>
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
    | {data: Some([el]), _} => ReactDOM.createPortal(view(state), el)
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
