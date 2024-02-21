module WheelOfSuggestions exposing (..)

import Browser
import Html exposing (Html)
import Http
import Result exposing (Result)
import Task


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
    | Error Http.Error
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
            Initializing
    in
    ( model, Task.perform FetchedTopics <| Task.succeed (Ok { suggestions = [ { topic = "TDD like you meant it" } ] }) )


type Msg
    = FetchedTopics (Result Http.Error Topics)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchedTopics result ->
            case result of
                Ok topics ->
                    ( Ready topics, Cmd.none )

                Err error ->
                    ( Error error, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Initializing ->
            viewInitializing

        Error error ->
            viewError error

        Ready _ ->
            viewReady

        Presenting suggestion _ ->
            viewSuggestion suggestion


viewInitializing : Html msg
viewInitializing =
    Html.text "Fetching topics"


viewError : Http.Error -> Html msg
viewError _ =
    Html.div []
        [ Html.p []
            [ Html.text "A problem occurred:" ]
        , Html.pre []
            [ Html.text "Unspecified error"
            ]
        ]


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
