module Ui.Navigation exposing (view)

import Html
import Html.Attributes


view =
    Html.header
        [ Html.Attributes.class "container px-4 py-4 mx-auto md:py-6"
        ]
        [ Html.h1 []
            [ Html.text "YTStudioTools"
            ]
        ]
