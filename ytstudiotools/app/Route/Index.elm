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


viewBenefits benefits =
    Html.section [ sectionClasses ]
        [ [ case benefits of
                x :: xs ->
                    [ Html.div []
                        [ Html.p
                            [ Html.Attributes.class "mb-4 text-2xl text-red-500"
                            ]
                            [ Html.text x ]
                        , xs
                            |> List.map
                                (\benefit ->
                                    Html.li [] [ Html.text benefit ]
                                )
                            |> Html.ul
                                [ Html.Attributes.class "list-none md:list-disc"
                                ]
                        ]
                    ]

                _ ->
                    [ Html.text "" ]
          , [ fakeCard ]
          ]
            |> List.concat
            |> Html.div
                [ Html.Attributes.class "flex flex-row flex-col items-center justify-around px-2 py-8 border-box md:flex-row"
                ]
        ]


viewBenefits_TitleChecker =
    viewBenefits
        [ "Reach more viewers with SEO"
        , "Shorter titles are proven to work better"
        , "Don't let your title go unread"
        ]


viewBenefits_Snippets =
    viewBenefits
        [ "Save time"
        , "Create snippets to add to your descriptions quickly & easily"
        , "Add affiliate links and Subscribe CTAs with a click"
        ]


viewBenefits_PreviewThumbnail =
    viewBenefits
        [ "How does your thumbnail look in the Feed?"
        , "See a preview on the Home page or your Channel"
        , "Check your thumbnail's alignment, balance and colors"
        ]


viewBenefits_Checklist =
    viewBenefits
        [ "Don't miss important steps"
        , "Add an Upload Checklist so you can smash SEO"
        ]
