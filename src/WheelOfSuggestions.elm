module WheelOfSuggestions exposing (..)

import Browser
import Html exposing (Html)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { message : String
    }


init : flag -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { message = "Hello, World!" }
    in
    ( model, Cmd.none )


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )


view : Model -> Html Msg
view { message } =
    Html.text message


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
