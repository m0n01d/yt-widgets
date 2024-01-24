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

module App = {
  @react.component
  let make = () => {
    <> {"Hi"->React.string} </>
  }
}

switch document->Document.querySelector("body") {
| None => ()
| Some(body) =>
  ReactDOM.Client.Root.render(
    ReactDOM.Client.createRoot(body),
    <Mui.ThemeProvider theme=Func(theme)>
      <App />
    </Mui.ThemeProvider>,
  )
}
