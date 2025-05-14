module Ui.Navigation exposing (view)

import Html
import Html.Attributes


view =
    Html.header
        [ Html.Attributes.class "md:translate-y-4"
        , Html.Attributes.class "rounded-lg border md:shadow-lg overflow-hidden p-2 bg-white border-slate-200 shadow-slate-950/5 mx-auto w-full max-w-screen-xl"
        ]
        [ Html.h1 []
            [ Html.text "YTStudioTools"
            ]
        ]
