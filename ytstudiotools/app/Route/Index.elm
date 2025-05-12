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
        [ Html.h1
            [ Html.Attributes.class "flex"
            ]
            [ Html.text "elm-pages is up and running!" ]
        , Html.p
            [ Html.Attributes.class "material-card"
            ]
            [ Html.text <| "The message is: " ++ app.data.message
            , Html.button [ Html.Attributes.class "material-button" ] [ Html.text "clicK" ]
            , Html.button [ Html.Attributes.class "material-button-primary" ] [ Html.text "clicK" ]
            , Html.button [ Html.Attributes.class "material-button-primary2" ] [ Html.text "clicK" ]
            , Html.button [ Html.Attributes.class "bg-blue-500 text-onPrimary hover:bg-blue-700 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2" ] [ Html.text "clicK" ]
            , Ui.Button.view { style = Ui.Button.Primary, onClick = () }
            ]
        , Route.Blog__Slug_ { slug = "hello" }
            |> Route.link [] [ Html.text "My blog post" ]
        ]
    }
