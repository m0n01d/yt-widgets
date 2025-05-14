module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html
import Html.Attributes
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Ui.Button
import Ui.Card
import UrlPath
import View exposing (View)
import Html.Events exposing (onClick)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    { message : String
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


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
    -> View (PagesMsg Msg)
view app shared =
    { title = "elm-pages is running"
    , body =
        [ Html.section
            [ Html.Attributes.class "flex flex-col items-center justify-center flex-1 flex-shrink-0 min-h-dvh gap-2 md:gap-6"
            ]
            [ Html.p
                [ Html.Attributes.class "text-2xl md:text-6xl"
                ]
                [ Html.strong [ Html.Attributes.class "font-extrabold" ]
                    [ Html.text "Tools that grow your "
                    , Html.span
                        [ Html.Attributes.class "text-red-700"
                        ]
                        [ Html.text "Channel" ]
                    ]
                ]
            , Html.p [] [ Html.text "Save time with tools that don't get in your way" ]

            -- , viewTheThing
            , Html.div
                []
                [ Ui.Button.view { style = Ui.Button.Primary, onClick = (), label = "Install Now FREE" }
                ]
            ]
        , viewBenefits_TitleChecker
        , viewBenefits_Snippets
        , viewBenefits_PreviewThumbnail
        , viewBenefits_Checklist
        , viewPricingSection
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
    Html.Attributes.class "px-8 py-10 flex flex-col justify-center my-8 min-h-48 md:min-h-[75vh] md:[&:nth-child(even)_div]:!flex-row-reverse"


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
                            [ Html.Attributes.class "font-bold mb-6 text-2xl text-red-500"
                            ]
                            [ Html.text x ]
                        , xs
                            |> List.map
                                (\benefit ->
                                    Html.li
                                        [ Html.Attributes.class "font-sans text-slate-600"
                                        ]
                                        [ Html.text benefit ]
                                )
                            |> Html.ul
                                [ Html.Attributes.class "list-none md:list-disc"
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
                [ Html.Attributes.class "flex flex-row gap-y-8 flex-col items-center justify-around px-2 py-8 border-box md:flex-row"
                ]
        ]


viewBenefits_TitleChecker =
    viewBenefits
        [ "Reach more viewers with SEO"
        , "Shorter titles are proven to work better"
        , "An average viewer processes your title in <2s"
        ]
        { benefit = "Green means good to go!"
        , feature = "Title Checker"
        }


viewBenefits_Snippets =
    viewBenefits
        [ "Save time"
        , "Create snippets to add to your descriptions quickly & easily"
        , "Add affiliate links and Subscribe CTAs with a click"
        ]
        { benefit = "Write once, never copy paste again"
        , feature = "Snippet Editor"
        }


viewBenefits_PreviewThumbnail =
    viewBenefits
        [ "How does your thumbnail look in the Feed?"
        , "See a preview on the Home page or your Channel"
        , "Check your thumbnail's alignment, balance and colors"
        ]
        { benefit = "Get more views"
        , feature = "Thumbnail Preview"
        }


viewBenefits_Checklist =
    viewBenefits
        [ "Don't miss important steps"
        , "Add an Upload Checklist to help guide you"
        , "Customize steps"
        ]
        { benefit = "Theres a lot to remember on each upload", feature = "Upload Checklist" }


viewPricingSection =
    Html.section
        [ Html.Attributes.class "px-8 py-16 flex flex-col items-center bg-gray-50" ]
        [ Html.h2
            [ Html.Attributes.class "text-3xl font-bold text-center mb-12" ]
            [ Html.text "Choose Your Plan" ]
        , Html.div
            [ Html.Attributes.class "flex flex-col md:flex-row gap-8 max-w-6xl w-full justify-center" ]
            [ viewPricingCard
                { title = "Free"
                , price = "0"
                , period = "forever"
                , features =
                    [ "Title Checker"
                    , "Basic Snippets (2 max)"
                    , "Thumbnail Preview"
                    , "Standard Checklist"
                    ]
                , buttonLabel = "Install Free"
                , buttonStyle = Ui.Button.Primary
                , popular = False
                }
            , viewPricingCard
                { title = "Pro"
                , price = "6"
                , period = "monthly"
                , features =
                    [ "Everything in Free"
                    , "Unlimited Snippets"
                    , "Custom Checklists"
                    , "Advanced Analytics"
                    , "Priority Support"
                    ]
                , buttonLabel = "Upgrade to Pro"
                , buttonStyle = Ui.Button.Primary
                , popular = True
                }
            ]
        , Html.div
            [ Html.Attributes.class "mt-8 text-center" ]
            [ Html.p
                [ Html.Attributes.class "text-gray-600 mb-2" ]
                [ Html.text "Pro plan also available yearly" ]
            , Html.p
                [ Html.Attributes.class "text-xl font-bold text-red-700" ]
                [ Html.text "$48/year "
                , Html.span
                    [ Html.Attributes.class "text-sm font-normal text-gray-600" ]
                    [ Html.text "(save $24)" ]
                ]
            ]
        ]


viewPricingCard config =
    Html.div
        [ Html.Attributes.class <|
            "relative flex flex-col p-8 rounded-lg shadow-md bg-white max-w-sm w-full transform transition-transform hover:scale-105 "
                ++ (if config.popular then
                        "border-2 border-red-500"

                    else
                        "border border-gray-200"
                   )
        ]
        [ if config.popular then
            Html.div
                [ Html.Attributes.class "absolute -top-4 left-1/2 transform -translate-x-1/2 bg-red-500 text-white px-4 py-1 rounded-full text-sm font-bold" ]
                [ Html.text "Most Popular" ]

          else
            Html.text ""
        , Html.h3
            [ Html.Attributes.class "text-2xl font-bold text-center mb-4" ]
            [ Html.text config.title ]
        , Html.div
            [ Html.Attributes.class "text-center mb-6" ]
            [ Html.span
                [ Html.Attributes.class "text-4xl font-bold" ]
                [ Html.text <| "$" ++ config.price ]
            , Html.span
                [ Html.Attributes.class "text-gray-600" ]
                [ Html.text <| "/" ++ config.period ]
            ]
        , Html.ul
            [ Html.Attributes.class "mb-8 space-y-3" ]
            (List.map
                (\feature ->
                    Html.li
                        [ Html.Attributes.class "flex items-center" ]
                        [ Html.div
                            [ Html.Attributes.class "text-green-500 mr-2" ]
                            [ Html.text "✓" ]
                        , Html.text feature
                        ]
                )
                config.features
            )
        , Html.div
            [ Html.Attributes.class "mt-auto" ]
            [ Ui.Button.view
                { style = config.buttonStyle
                , onClick = ()
                , label = config.buttonLabel
                }
            ]
        ]
