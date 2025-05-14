module Ui.Navigation exposing (view)

import Html
import Html.Attributes
import Html.Events


view : { showMenu : Bool, onMenuClick : msg } -> Html.Html msg
view { showMenu, onMenuClick } =
    Html.header
        [ Html.Attributes.class "sticky top-0 z-40"
        , Html.Attributes.class "rounded-lg border md:shadow-lg overflow-visible px-6 py-3 bg-white border-slate-200 shadow-slate-950/5 mx-auto w-full max-w-screen-xl flex items-center justify-between"
        ]
        [ Html.div
            [ Html.Attributes.class "flex items-center" ]
            [ Html.div
                [ Html.Attributes.class "w-8 h-8 mr-3 bg-red-600 rounded-md flex items-center justify-center text-white font-bold text-lg" ]
                [ Html.text "YT" ]
            , Html.h1
                [ Html.Attributes.class "text-xl font-bold text-gray-800" ]
                [ Html.text "Studio Tools" ]
            ]
        , Html.div
            [ Html.Attributes.class "hidden md:flex items-center space-x-6" ]
            [ Html.a
                [ Html.Attributes.class "text-gray-600 hover:text-red-600 transition-colors"
                , Html.Attributes.href "#features"
                ]
                [ Html.text "Features" ]
            , Html.a
                [ Html.Attributes.class "text-gray-600 hover:text-red-600 transition-colors"
                , Html.Attributes.href "#pricing"
                ]
                [ Html.text "Pricing" ]
            , Html.button
                [ Html.Attributes.class "px-4 py-2 rounded-md bg-gray-800 text-white font-medium hover:bg-gray-900 transition-colors shadow-sm" ]
                [ Html.text "Get Started" ]
            ]
        , Html.button
            [ Html.Attributes.class "md:hidden flex flex-col space-y-1.5 p-1.5 rounded-md hover:bg-gray-100 transition-colors"
            , Html.Events.onClick onMenuClick
            ]
            [ Html.div [ Html.Attributes.class "w-6 h-0.5 bg-gray-700" ] []
            , Html.div [ Html.Attributes.class "w-6 h-0.5 bg-gray-700" ] []
            , Html.div [ Html.Attributes.class "w-6 h-0.5 bg-gray-700" ] []
            ]
        , if showMenu then
            Html.div
                [ Html.Attributes.class "fixed md:absolute top-16 right-4 mt-2 w-64 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 z-50 md:hidden"
                , Html.Attributes.style "max-height" "calc(100vh - 100px)"
                , Html.Attributes.style "overflow-y" "auto"
                ]
                [ Html.a
                    [ Html.Attributes.class "block px-4 py-3 text-gray-700 hover:bg-gray-100 hover:text-red-600 transition-colors"
                    , Html.Attributes.href "#features"
                    ]
                    [ Html.text "Features" ]
                , Html.a
                    [ Html.Attributes.class "block px-4 py-3 text-gray-700 hover:bg-gray-100 hover:text-red-600 transition-colors"
                    , Html.Attributes.href "#pricing"
                    ]
                    [ Html.text "Pricing" ]
                , Html.div
                    [ Html.Attributes.class "px-4 py-3 border-t" ]
                    [ Html.button
                        [ Html.Attributes.class "w-full px-4 py-2 rounded-md bg-gray-800 text-white font-medium hover:bg-gray-900 transition-colors shadow-sm" ]
                        [ Html.text "Get Started" ]
                    ]
                ]

          else
            Html.text ""
        ]
