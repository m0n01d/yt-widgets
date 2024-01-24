open Webapi
open Webapi.Dom

@module("@mui/material/colors")
external pink: 'a = "pink"

let theme = outerTheme =>
  Mui.Theme.create({
    ...outerTheme,
    palette: {
      primary: {
        main: pink["500"],
      },
      secondary: {
        main: "#9c27b0",
      },
    },
    typography: {fontSize: 16.0},
  })

switch document->Document.querySelector("body") {
| None => ()
| Some(body) =>
  ReactDOM.Client.Root.render(
    ReactDOM.Client.createRoot(body),
    <Mui.ThemeProvider theme=Func(theme)>
      <SnippetEditor />
    </Mui.ThemeProvider>,
  )
}
