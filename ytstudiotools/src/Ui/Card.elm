module Ui.Card exposing (view)

import Html
import Html.Attributes


view { benefit, feature } =
    Html.div
        [ Html.Attributes.class "w-full max-w-2xl overflow-hidden rounded-xl p-0 border border-slate-200 bg-white shadow-xl shadow-slate-950/5 transition-all duration-300 hover:shadow-2xl hover:-translate-y-1"
        ]
        [ Html.div
            [ Html.Attributes.class "relative w-full overflow-hidden bg-slate-100" ]
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
                , Html.Attributes.class "w-full object-cover"
                ]
                [ Html.source
                    [ Html.Attributes.src "/titlelengthchecker.mp4"
                    , Html.Attributes.type_ "video/mp4"
                    ]
                    []
                ]
            , Html.div
                [ Html.Attributes.class "absolute top-3 left-3 bg-red-600 text-white px-3 py-1 rounded-full text-xs font-medium shadow-md" ]
                [ Html.text "Feature" ]
            ]
        , Html.div
            [ Html.Attributes.class "h-max w-full rounded px-6 py-5"
            ]
            [ Html.h6
                [ Html.Attributes.class "font-sans text-xl font-bold text-slate-800 antialiased md:text-xl lg:text-2xl"
                ]
                [ Html.text feature ]
            , Html.p
                [ Html.Attributes.class "mt-3 mb-4 font-sans text-base text-slate-600 antialiased"
                ]
                [ Html.text benefit ]
            ]
        , Html.div
            [ Html.Attributes.class "w-full rounded px-6 pb-5"
            ]
            [ Html.button
                [ Html.Attributes.class "inline-flex items-center justify-center rounded-md border border-red-600 bg-red-600 px-5 py-2.5 text-center font-sans text-sm font-medium text-white transition-all duration-300 ease-in hover:bg-red-700 hover:border-red-700 shadow-md hover:shadow-lg disabled:cursor-not-allowed disabled:opacity-50 disabled:shadow-none"
                ]
                [ Html.text "Install Now" ]
            ]
        ]
