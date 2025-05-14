module Ui.Card exposing (view)

import Html
import Html.Attributes

view =
  Html.div
    [ Html.Attributes.class "w-full max-w-xs overflow-hidden rounded-lg p-2 border border-slate-200 bg-white shadow-lg shadow-slate-950/5"
    ]
    [ Html.img
        [ Html.Attributes.class "hidden"
        , Html.Attributes.src "https://images.unsplash.com/photo-1581337204873-ef36aa186caa?q=80&w=800&auto=format&fit=crop"
        , Html.Attributes.alt "image"
        ]
        []
      , Html.video
        [ Html.Attributes.autoplay True
          , Html.Attributes.loop True
         , Html.Attributes.attribute "muted" ""
          , Html.Attributes.attribute "playsinline" ""
          ]
          [Html.source [Html.Attributes.src "https://private-user-images.githubusercontent.com/5841729/443437473-40dd9163-34ac-46a3-ad36-3b4580e5943c.mp4?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxODI5MTQsIm5iZiI6MTc0NzE4MjYxNCwicGF0aCI6Ii81ODQxNzI5LzQ0MzQzNzQ3My00MGRkOTE2My0zNGFjLTQ2YTMtYWQzNi0zYjQ1ODBlNTk0M2MubXA0P1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI1MDUxNCUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNTA1MTRUMDAzMDE0WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YWY3Y2NhMTJjZWYxZjdkMTc3N2U0NjNmZGNkZTM5YzY2NTZlMzkyNjUwMDNiOWI1Y2U4MWE5NTU2OTg3MTVkNyZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QifQ.RX0gSbtKSSqd0hfGrGOOVy62nT4lB0xFwxIYD_MQ00I"

          , Html.Attributes.type_ "video/mp4"
          ] []
          ]
    , Html.div
        [ Html.Attributes.class "h-max w-full rounded px-3 py-2"
        ]
        [ Html.h6
            [ Html.Attributes.class "font-sans text-base font-bold text-current antialiased md:text-lg lg:text-xl"
            ]
            [ Html.text " UI/UX Review Check " ]
        , Html.p
            [ Html.Attributes.class "my-1 font-sans text-base text-slate-600 antialiased"
            ]
            [ Html.text " The place is close to Barceloneta Beach and bus stop just 2 min by walk and near to \"Naviglio\" where you can enjoy the main night life in Barcelona. " ]
        ]
    , Html.div
        [ Html.Attributes.class "w-full rounded px-3 pb-3 pt-1.5"
        ]
        [ Html.button
            [ Html.Attributes.class "inline-flex rounded-md border border-slate-800 bg-slate-800 px-4 py-2 text-center font-sans text-sm font-medium text-slate-50 transition-all duration-300 ease-in hover:border-slate-700 hover:bg-slate-700 disabled:cursor-not-allowed disabled:opacity-50 disabled:shadow-none"
            ]
            [ Html.text " Read More " ]
        ]
    ]
