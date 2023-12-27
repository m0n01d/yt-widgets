module LinearProgress = {
  @module("@mui/material") @react.component
  external make: (~variant: string, ~color: string, ~value: float) => React.element =
    "LinearProgress"
}
