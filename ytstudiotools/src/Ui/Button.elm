module Ui.Button exposing (Style(..), view)

import Html
import Html.Attributes


type Style
    = Primary
    | Secondary


type alias Config msg =
    { label : String
    , onClick : msg
    , style : Style
    }


styleToClass style =
    case style of
        Primary ->
            "bg-red-600 border-red-600 text-white hover:bg-red-700 hover:border-red-700"
        
        Secondary ->
            "bg-transparent border-gray-300 text-gray-700 hover:bg-gray-50 hover:text-gray-900"


baseStyles =
    "inline-flex items-center justify-center border align-middle select-none font-sans font-medium text-center transition-all duration-300 ease-in disabled:opacity-50 disabled:shadow-none disabled:cursor-not-allowed data-[shape=pill]:rounded-full data-[width=full]:w-full focus:shadow-none text-sm rounded-md py-2.5 px-5 shadow-md hover:shadow-lg"


view config =
    Html.button
        [ Html.Attributes.class (styleToClass config.style)
        , Html.Attributes.class baseStyles
        ]
        [ Html.text config.label ]
