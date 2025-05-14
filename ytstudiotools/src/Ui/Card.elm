module Ui.Card exposing (view)

import Html
import Html.Attributes


view { benefit, feature } =
    Html.div
        [ Html.Attributes.class "w-full max-w-2xl overflow-hidden rounded-lg p-2 border border-slate-200 bg-white shadow-lg shadow-slate-950/5"
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
            [ Html.source
                [ Html.Attributes.src "/titlelengthchecker.mp4"
                , Html.Attributes.type_ "video/mp4"
                ]
                []
            ]
        , Html.div
            [ Html.Attributes.class "h-max w-full rounded px-3 py-2"
            ]
            [ Html.h6
                [ Html.Attributes.class "font-sans text-base font-bold text-current antialiased md:text-lg lg:text-xl"
                ]
                [ Html.text feature ]
            , Html.p
                [ Html.Attributes.class "my-1 font-sans text-base text-slate-600 antialiased"
                ]
                [ Html.text benefit ]
            ]
        , Html.div
            [ Html.Attributes.class "w-full rounded px-3 pb-3 pt-1.5"
            ]
            [ Html.button
                [ Html.Attributes.class "inline-flex rounded-md border border-slate-800 bg-slate-800 px-4 py-2 text-center font-sans text-sm font-medium text-slate-50 transition-all duration-300 ease-in hover:border-slate-700 hover:bg-slate-700 disabled:cursor-not-allowed disabled:opacity-50 disabled:shadow-none"
                ]
                [ Html.text "Install Now" ]
            ]
        ]
