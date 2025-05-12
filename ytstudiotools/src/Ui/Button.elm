module Ui.Button exposing (Style(..), view)

import Html
import Html.Attributes


type Style
    = Primary


type alias Config msg =
    { onClick : msg
    , style : Style
    }


styleToClass style =
    case style of
        Primary ->
            "bg-blue-500 text-onPrimary hover:bg-blue-700 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"


baseStyles =
    "px-4 py-2 rounded-md font-medium shadow-md"


view config =
    Html.button
        [ config.style |> styleToClass |> Html.Attributes.class
        , Html.Attributes.class baseStyles
        ]
        [ Html.text "Click me" ]
