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


type Model
    = Initializing
    | Ready Topics
    | Presenting Suggestion Topics


type alias Topics =
    { suggestions : List Suggestion }


type alias Suggestion =
    { topic : String }


init : flag -> ( Model, Cmd Msg )
init _ =
    let
        model =
            Ready { suggestions = [ { topic = "TDD like you meant it" } ] }
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
view model =
    case model of
        Initializing ->
            viewInitializing

        Ready _ ->
            viewReady

        Presenting suggestion _ ->
            viewSuggestion suggestion


viewInitializing : Html msg
viewInitializing =
    Html.text "Fetching topics"


viewReady : Html Msg
viewReady =
    Html.div []
        [ Html.p []
            [ Html.text "Are you feeling lucky?"
            ]
        ]


viewSuggestion : Suggestion -> Html Msg
viewSuggestion { topic } =
    Html.div []
        [ Html.p []
            [ Html.text topic
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
