module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import Effect exposing (Effect)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html
import Html.Attributes
import Html.Events exposing (onClick)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Ui.Button
import Ui.Card
import UrlPath
import View exposing (View)


type alias Model =
    { pricingPeriod : PricingPeriod
    }


type PricingPeriod
    = Monthly
    | Yearly


type Msg
    = TogglePricingPeriod


type alias RouteParams =
    {}


type alias Data =
    { message : String
    }


type alias ActionData =
    {}


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildWithLocalState
            { view = view
            , init = init
            , update = update
            , subscriptions = \_ _ _ _ -> Sub.none
            }


init :
    App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect Msg )
init app shared =
    ( { pricingPeriod = Monthly }
    , Effect.none
    )


update :
    App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect Msg )
update app shared msg model =
    case msg of
        TogglePricingPeriod ->
            ( { model
                | pricingPeriod =
                    case model.pricingPeriod of
                        Monthly ->
                            Yearly

                        Yearly ->
                            Monthly
              }
            , Effect.none
            )


data : BackendTask FatalError Data
data =
    BackendTask.succeed Data
        |> BackendTask.andMap
            (BackendTask.succeed "Hello!")


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = [ "images", "icon-png.png" ] |> UrlPath.join |> Pages.Url.fromPath
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Welcome to elm-pages!"
        , locale = Nothing
        , title = "elm-pages is running"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View (PagesMsg Msg)
view app shared model =
    { title = "elm-pages is running"
    , body =
        [ Html.section
            [ Html.Attributes.class "flex flex-col items-center justify-center flex-1 flex-shrink-0 min-h-dvh gap-4 md:gap-8 bg-gradient-to-b from-white to-gray-50 px-4"
            ]
            [ Html.span
                [ Html.Attributes.class "bg-red-50 text-red-700 px-4 py-1.5 rounded-full text-sm font-semibold tracking-wide mb-4" ]
                [ Html.text "YouTube Studio Tools" ]
            , Html.p
                [ Html.Attributes.class "text-3xl md:text-7xl text-center max-w-4xl"
                ]
                [ Html.strong [ Html.Attributes.class "font-extrabold" ]
                    [ Html.text "Make uploading videos "
                    , Html.span
                        [ Html.Attributes.class "text-red-700 relative"
                        ]
                        [ Html.text "a breeze"
                        , Html.span
                            [ Html.Attributes.class "absolute -bottom-2 left-0 w-full h-1 bg-red-700 rounded-full opacity-50" ]
                            []
                        ]
                    ]
                ]
            , Html.p
                [ Html.Attributes.class "text-lg text-gray-600 mb-6 mt-4 text-center max-w-xl" ]
                [ Html.text "Save time in the studio so you can focus on creating great content" ]
            , Html.div
                [ Html.Attributes.class "flex flex-col sm:flex-row gap-4 mt-4" ]
                [ Ui.Button.view { style = Ui.Button.Primary, onClick = (), label = "Install Now FREE" }
                , Html.a
                    [ Html.Attributes.class "inline-flex items-center justify-center font-medium text-center transition-all ease-in py-2 px-4 text-sm rounded-md text-gray-700 hover:text-gray-900 hover:bg-gray-100"
                    , Html.Attributes.href "#features"
                    ]
                    [ Html.text "See Features"
                    , Html.div
                        [ Html.Attributes.class "ml-2" ]
                        [ Html.text "↓" ]
                    ]
                ]
            ]
        , Html.div
            [ Html.Attributes.id "features"
            , Html.Attributes.class "scroll-mt-16"
            ]
            []
        , viewBenefits_TitleChecker
        , viewBenefits_Snippets
        , viewBenefits_PreviewThumbnail
        , viewBenefits_Checklist
        , viewPricingSection model.pricingPeriod
        ]
    }


viewInstallNow =
    Html.section []
        [ Html.text "Install now: "
        , Ui.Button.view { style = Ui.Button.Primary, onClick = (), label = "Install Now FREE" }
        ]


viewTheThing =
    Html.p
        [ Html.Attributes.class "pb-2 mb-2 text-gray-700 border-b-2 border-red-700 md:text-2xl"
        ]
        [ Html.text "Streamlined tools. Made by Youtubers, for "
        , Html.span [ Html.Attributes.class "font-semibold text-red-500" ] [ Html.text "You" ]
        , Html.span
            [ Html.Attributes.class "text-gray-300"
            ]
            [ Html.text "tubers." ]
        ]


sectionClasses =
    Html.Attributes.class "px-8 py-20 flex flex-col justify-center my-8 min-h-48 md:min-h-[75vh] md:[&:nth-child(even)_div]:!flex-row-reverse bg-white border-b border-gray-100"


fakeCard =
    Ui.Card.view


fakeImg =
    Html.div
        [ Html.Attributes.class "w-48 h-48 my-8 border border-red-500"
        ]
        []


viewBenefits benefits cardConfig =
    Html.section [ sectionClasses ]
        [ [ case benefits of
                x :: xs ->
                    [ Html.div []
                        [ Html.p
                            [ Html.Attributes.class "font-bold mb-6 text-3xl text-red-600"
                            ]
                            [ Html.text x ]
                        , xs
                            |> List.map
                                (\benefit ->
                                    Html.li
                                        [ Html.Attributes.class "font-sans text-slate-600 mb-3 flex items-center"
                                        ]
                                        [ Html.span
                                            [ Html.Attributes.class "mr-2 text-red-500 flex-shrink-0" ]
                                            [ Html.text "✓" ]
                                        , Html.text benefit
                                        ]
                                )
                            |> Html.ul
                                [ Html.Attributes.class "list-none space-y-1"
                                ]
                        ]
                    ]

                _ ->
                    [ Html.text "" ]
          , [ Ui.Card.view cardConfig
            ]
          ]
            |> List.concat
            |> Html.div
                [ Html.Attributes.class "flex flex-row gap-8 flex-col items-center justify-around px-4 py-8 border-box md:flex-row max-w-6xl mx-auto"
                ]
        ]


viewBenefits_TitleChecker =
    viewBenefits
        [ "Craft titles that rank higher in search results"
        , "Stop second-guessing your title length with real-time feedback"
        , "Catch viewers' attention in those crucial first 2 seconds"
        ]
        { benefit = "Get the green light and watch your views climb"
        , feature = "Title Checker"
        }


viewBenefits_Snippets =
    viewBenefits
        [ "Save time on repetitive description tasks"
        , "Add social links, CTAs and affiliate links in seconds"
        , "Keep your branding consistent across all your videos"
        ]
        { benefit = "Create once, reuse everywhere, earn more"
        , feature = "Snippet Editor"
        }


viewBenefits_PreviewThumbnail =
    viewBenefits
        [ "See exactly what viewers see before you publish"
        , "Preview your thumbnail in Home, Channel, and Search feeds"
        , "Spot design issues that kill click-through rates"
        ]
        { benefit = "Thumbnails that make people click"
        , feature = "Thumbnail Preview"
        }


viewBenefits_Checklist =
    viewBenefits
        [ "Never forget tags, cards, or end screens again"
        , "Follow your custom upload routine every single time"
        , "Build the perfect checklist for your unique workflow"
        ]
        { benefit = "Flawless uploads, every time", feature = "Upload Checklist" }


viewPricingSection : PricingPeriod -> Html.Html (PagesMsg Msg)
viewPricingSection pricingPeriod =
    let
        ( proPrice, proPeriod ) =
            case pricingPeriod of
                Monthly ->
                    ( "6", "monthly" )

                Yearly ->
                    ( "48", "yearly" )
    in
    Html.section
        [ Html.Attributes.class "px-8 py-16 flex flex-col items-center bg-gradient-to-br from-gray-50 to-gray-100" ]
        [ Html.div
            [ Html.Attributes.class "max-w-6xl w-full mb-12 text-center" ]
            [ Html.span
                [ Html.Attributes.class "bg-red-50 text-red-700 px-4 py-1.5 rounded-full text-xs font-semibold uppercase tracking-wide" ]
                [ Html.text "Pricing" ]
            , Html.h2
                [ Html.Attributes.class "text-4xl font-bold text-center mt-4 mb-2" ]
                [ Html.text "Choose Your Plan" ]
            , Html.p
                [ Html.Attributes.class "text-gray-600 max-w-lg mx-auto" ]
                [ Html.text "Save time with tools designed specifically for YouTubers. Select the plan that works best for your channel." ]
            ]
        , Html.div
            [ Html.Attributes.class "flex flex-col md:flex-row gap-8 max-w-6xl w-full justify-center mt-8" ]
            [ viewPricingCard pricingPeriod
                { title = "Free"
                , price = "0"
                , period = "forever"
                , features =
                    [ "Title Checker"
                    , "Basic Snippets (2 max)"
                    , "Standard Checklist"
                    ]
                , buttonLabel = "Install Free"
                , buttonStyle = Ui.Button.Primary
                , popular = False
                }
            , viewPricingCard pricingPeriod
                { title = "Pro"
                , price = proPrice
                , period = proPeriod
                , features =
                    [ "Everything in Free"
                    , "Unlimited Snippets"
                    , "Thumbnail Preview"
                    , "Custom Checklists"
                    , "Advanced Analytics"
                    , "Priority Support"
                    , if pricingPeriod == Yearly then
                        "Save $24 with yearly billing"

                      else
                        "Save with yearly billing"
                    ]
                , buttonLabel = "Upgrade to Pro"
                , buttonStyle = Ui.Button.Primary
                , popular = True
                }
            ]
        ]


viewPricingToggle : PricingPeriod -> Html.Html (PagesMsg Msg)
viewPricingToggle pricingPeriod =
    let
        isMonthly =
            pricingPeriod == Monthly

        monthlyClass =
            if isMonthly then
                "font-bold text-red-700"

            else
                "text-gray-500"

        yearlyClass =
            if not isMonthly then
                "font-bold text-red-700"

            else
                "text-gray-500"

        toggleClass =
            if isMonthly then
                "bg-gray-200"

            else
                "bg-red-600"

        circleClass =
            if isMonthly then
                "transform translate-x-0"

            else
                "transform translate-x-5"
    in
    Html.div
        [ Html.Attributes.class "flex items-center justify-center gap-3 mb-3 mt-1 text-xs bg-gray-50 py-2 px-3 rounded-full shadow-sm" ]
        [ Html.span
            [ Html.Attributes.class ("transition-colors " ++ monthlyClass) ]
            [ Html.text "Monthly" ]
        , Html.div
            [ Html.Attributes.class "relative cursor-pointer w-10 h-5 rounded-full transition-colors duration-300 ease-in-out"
            , Html.Attributes.class toggleClass
            , Html.Events.onClick (PagesMsg.fromMsg TogglePricingPeriod)
            ]
            [ Html.div
                [ Html.Attributes.class ("absolute top-1 left-1 bg-white w-3 h-3 rounded-full shadow transition-transform duration-300 ease-in-out " ++ circleClass) ]
                []
            ]
        , Html.span
            [ Html.Attributes.class ("transition-colors " ++ yearlyClass) ]
            [ Html.text "Yearly" ]
        ]


viewPricingCard pricingPeriod config =
    Html.div
        [ Html.Attributes.class <|
            "relative flex flex-col p-8 rounded-xl shadow-lg bg-white max-w-sm w-full transform transition-all duration-300 hover:shadow-xl hover:-translate-y-1 "
                ++ (if config.popular then
                        "border-2 border-red-500 z-10"

                    else
                        "border border-gray-200"
                   )
        ]
        [ if config.popular then
            Html.div
                [ Html.Attributes.class "absolute -top-4 left-1/2 transform -translate-x-1/2 bg-red-500 text-white px-6 py-1.5 rounded-full text-sm font-bold shadow-md" ]
                [ Html.text "Most Popular" ]

          else
            Html.text ""
        , Html.div
            [ Html.Attributes.class "flex flex-col items-center" ]
            [ Html.h3
                [ Html.Attributes.class "text-2xl font-bold text-center mb-1" ]
                [ Html.text config.title ]
            , if config.popular then
                viewPricingToggle pricingPeriod

              else
                Html.text ""
            ]
        , Html.div
            [ Html.Attributes.class "text-center mb-8 mt-2" ]
            [ Html.span
                [ Html.Attributes.class "text-5xl font-extrabold" ]
                [ Html.text <| "$" ++ config.price ]
            , Html.span
                [ Html.Attributes.class "text-gray-600 ml-1" ]
                [ Html.text <| "/" ++ config.period ]
            ]
        , Html.div
            [ Html.Attributes.class "w-full h-px bg-gray-200 mb-6" ]
            []
        , Html.ul
            [ Html.Attributes.class "mb-8 space-y-4" ]
            (List.map
                (\feature ->
                    Html.li
                        [ Html.Attributes.class "flex items-center" ]
                        [ Html.div
                            [ Html.Attributes.class "mr-3 flex-shrink-0 text-lg" ]
                            [ if String.startsWith "Save" feature then
                                Html.div
                                    []
                                    [ Html.text "⭐" ]

                              else if String.contains "Analytics" feature then
                                Html.div
                                    []
                                    [ Html.text "📊" ]

                              else if String.contains "Snippet" feature then
                                Html.div
                                    []
                                    [ Html.text "📝" ]

                              else if String.contains "Checklist" feature then
                                Html.div
                                    []
                                    [ Html.text "☑️" ]

                              else if String.contains "Title" feature then
                                Html.div
                                    []
                                    [ Html.text "🔤" ]

                              else if String.contains "Thumbnail" feature then
                                Html.div
                                    []
                                    [ Html.text "🖼️" ]

                              else if String.contains "Priority Support" feature then
                                Html.div
                                    []
                                    [ Html.text "🔔" ]

                              else if String.contains "Everything in Free" feature then
                                Html.div
                                    []
                                    [ Html.text "✅" ]

                              else
                                Html.div
                                    []
                                    [ Html.text "✓" ]
                            ]
                        , if String.startsWith "Save" feature && config.popular then
                            Html.div []
                                [ Html.text feature
                                , if pricingPeriod == Yearly then
                                    Html.span
                                        [ Html.Attributes.class "ml-2 bg-green-100 text-green-800 text-xs font-medium px-2 py-0.5 rounded-full" ]
                                        [ Html.text "33% off" ]

                                  else
                                    Html.text ""
                                ]

                          else
                            Html.span [ Html.Attributes.class "text-gray-700" ] [ Html.text feature ]
                        ]
                )
                config.features
            )
        , Html.div
            [ Html.Attributes.class "mt-auto w-full" ]
            [ Ui.Button.view
                { style = config.buttonStyle
                , onClick = ()
                , label = config.buttonLabel
                }
            ]
        ]
