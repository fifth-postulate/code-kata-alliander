module WheelOfSuggestions exposing (..)

import Browser
import Html exposing (Html)
import Html.Events as Event
import Http
import Random exposing (generate)
import Result exposing (Result)
import Task
import WheelOfSuggestions.Suggestion as Suggestion exposing (Suggestion)
import WheelOfSuggestions.Topic as Topic exposing (Topics)


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


topics : Model -> Topics
topics model =
    case model of
        Ready ts ->
            ts

        Presenting _ ts ->
            ts

        _ ->
            Topic.empty


init : flag -> ( Model, Cmd Msg )
init _ =
    let
        model =
            Initializing

        ts =
            [ Suggestion.topic "TDD like you meant it"
            , Suggestion.topic "One return statement"
            , Suggestion.topic "At most one argument per method"
            ]
                |> Topic.fromList

        cmd =
            ts
                |> Ok
                |> Task.succeed
                |> Task.perform FetchedTopics
    in
    ( model, cmd )


type Msg
    = FetchedTopics (Result Http.Error Topics)
    | PickATopic
    | Topic Suggestion


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchedTopics result ->
            case result of
                Ok ts ->
                    ( Ready ts, Cmd.none )

                Err error ->
                    ( Error error, Cmd.none )

        PickATopic ->
            ( model, generate Topic (Topic.suggestionFrom <| topics model) )

        Topic suggestion ->
            ( Presenting suggestion <| topics model, Cmd.none )


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
            template "Your suggestion is:" <| Suggestion.view suggestion


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
    Html.button [ Event.onClick PickATopic ] [ Html.text "go" ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
