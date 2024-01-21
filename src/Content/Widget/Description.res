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
    maybeDialog: option<unit>,
    selectedSnippets: Set.t<Schema.DescriptionSnippet.id>,
    snippets: array<(Schema.DescriptionSnippet.t, bool)>,
  }

  type msg =
    | GotSnippets(array<Schema.DescriptionSnippet.t>)
    | OpenDialog
    | SelectedSnippet(Schema.DescriptionSnippet.t)

  let update = (state: model, action: msg) => {
    switch action {
    | GotSnippets(newSnippets) => {...state, snippets: newSnippets->Array.map(s => (s, false))}
    | OpenDialog => {...state, maybeDialog: Some()}
    | SelectedSnippet(snippet) => {
        switch document->Document.querySelector(videoDescriptionTextboxSelector) {
        | None => ()
        | Some(el) => {
            let html = el->Element.innerText
            let newHtml = [html, "\n", snippet.body]->Array.joinWith("")
            el->Element.setInnerText(newHtml)
          }
        }
        {
          ...state,
          snippets: state.snippets->Array.map(foo => {
            let (s, isSelected) = foo
            if snippet.id == s.id {
              (s, true)
            } else {
              (s, isSelected)
            }
          }),
        }
      }
    }
  }

  @react.component
  let make = () => {
    let initialState = {maybeDialog: None, selectedSnippets: Set.make(), snippets: []}
    let (state, dispatch) = React.useReducer(update, initialState)

    Js.log2("state", state)
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

    React.useEffect(() => {
      None
    }, [state.selectedSnippets])

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

    let viewRow = ((snippet: Schema.DescriptionSnippet.t, isSelected)) => {
      let open_ = true
      let disabled = isSelected
      Js.log2("disabled", disabled)
      <React.Fragment>
        <Mui.TableRow>
          <Mui.TableCell>
            <Mui.IconButton disabled onClick={_ => dispatch(SelectedSnippet(snippet))}>
              <Ui.Icon.Input />
            </Mui.IconButton>
            <Mui.IconButton>
              <Ui.Icon.EditNote />
            </Mui.IconButton>
          </Mui.TableCell>
          <Mui.TableCell> {snippet.name->React.string} </Mui.TableCell>
          <Mui.TableCell>
            {snippet.body->String.slice(~start=0, ~end=12)->React.string}
          </Mui.TableCell>
          <Mui.TableCell> {snippet.date->Js.Date.toLocaleDateString->React.string} </Mui.TableCell>
        </Mui.TableRow>
        <Mui.TableRow>
          <td colSpan={4}>
            <Mui.Collapse in_={open_} unmountOnExit={true}>
              <Mui.Box>
                <Mui.TextField
                  defaultValue={snippet.body->React.string} fullWidth={true} multiline={true}
                />
              </Mui.Box>
            </Mui.Collapse>
          </td>
        </Mui.TableRow>
      </React.Fragment>
    }

    let viewCollapsibleTable = snippets => {
      <Mui.TableContainer>
        <Mui.Table>
          <Mui.TableHead>
            <Mui.TableRow>
              <Mui.TableCell />
              <Mui.TableCell> {"Name"->React.string} </Mui.TableCell>
              <Mui.TableCell> {"Body"->React.string} </Mui.TableCell>
              <Mui.TableCell> {"Date"->React.string} </Mui.TableCell>
            </Mui.TableRow>
          </Mui.TableHead>
          <Mui.TableBody> {snippets->Js.Array2.map(viewRow)->React.array} </Mui.TableBody>
        </Mui.Table>
      </Mui.TableContainer>
    }
    let viewDialog = () => {
      <Mui.Dialog fullWidth={true} maxWidth={Md} open_={true}>
        {state.snippets->viewCollapsibleTable}
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
        Js.log(videoDescriptionTextboxEl)
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
