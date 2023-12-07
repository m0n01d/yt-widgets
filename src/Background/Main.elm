module Background.Main exposing (main)

import Platform


main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = always Sub.none
        }


init : () -> ( (), Cmd msg )
init flags =
    ( (), Cmd.none )


update msg model =
    ( (), Cmd.none )
