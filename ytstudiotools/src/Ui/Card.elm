module Ui.Card exposing (view)

import Html
import Html.Attributes


view { benefit, feature, tooltipText } =
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
                [ Html.Attributes.class "absolute top-3 right-3 bg-red-600 text-white px-3 py-1 rounded-full text-xs font-medium shadow-md" ]
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
                [ Html.Attributes.class "inline-flex rounded-md border border-gray-800 bg-gray-800 px-4 py-2 text-center font-sans text-sm font-medium text-white transition-all duration-300 ease-in hover:border-gray-900 hover:bg-gray-900 disabled:cursor-not-allowed disabled:opacity-50 shadow-sm hover:shadow-md"
                , Html.Attributes.attribute "data-toggle" "popover"
                , Html.Attributes.attribute "data-placement" "top-start"
                , Html.Attributes.attribute "data-popover-class" "bg-white w-4/12 md:w-48 border border-slate-200 text-slate-800 text-xl rounded-md py-1 px-2 shadow-sm z-50"
                ]
                [ Html.text "Learn More" ]
            , Html.div
                [ Html.Attributes.class "hidden"
                , Html.Attributes.attribute "data-popover-content" ""
                ]
                [ Html.text tooltipText
                ]
            ]
        ]
