module WheelOfSuggestions exposing (..)

import Browser
import Html exposing (Html)
import Http
import Result exposing (Result)
import Task
import WheelOfSuggestions.Suggestion as Suggestion exposing (Suggestion)


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


init : flag -> ( Model, Cmd Msg )
init _ =
    let
        model =
            Initializing
    in
    ( model, Task.perform FetchedTopics <| Task.succeed (Ok { suggestions = [ Suggestion.topic "TDD like you meant it" ] }) )


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
            template "Initializing" viewInitializing

        Error error ->
            template "A problem occurred:" <| viewError error

        Ready _ ->
            template "Are you feeling lucky?" <| viewReady

        Presenting suggestion _ ->
            template "Your suggestion is:" <| viewSuggestion suggestion


template : String -> Html Msg -> Html Msg
template title content =
    Html.div []
        [ Html.p [] [ Html.text title ]
        , content
        ]


viewInitializing : Html msg
viewInitializing =
    Html.text "Fetching topics"


viewError : Http.Error -> Html msg
viewError _ =
    Html.pre []
        [ Html.text "Unspecified error"
        ]


viewReady : Html Msg
viewReady =
    Html.button [] [ Html.text "go" ]


viewSuggestion : Suggestion -> Html Msg
viewSuggestion suggestion =
    Html.span []
        [ Html.text <| Suggestion.description suggestion
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
