module WheelOfSuggestions exposing (..)

import Browser
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attribute
import Html.Styled.Events as Event
import Http
import Random exposing (generate)
import Result exposing (Result)
import WheelOfSuggestions.Suggestion as Suggestion exposing (Suggestion)
import WheelOfSuggestions.Topic as Topic exposing (Topics)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view >> Html.toUnstyled
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

        cmd =
            Http.get
                { url = "topics.json"
                , expect = Http.expectJson FetchedTopics Topic.decoder
                }
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
            template "Are you feeling lucky?" <| (viewReady "Hit me!" <| Html.span [] [])

        Presenting suggestion _ ->
            template "Your suggestion is:" <| (viewReady "again" <| Suggestion.view suggestion)


template : String -> Html Msg -> Html Msg
template title content =
    Html.div
        [ Attribute.css
            [ Css.fontSize Css.xLarge
            ]
        ]
        [ Html.p
            [ Attribute.css
                [ Css.textAlign Css.center
                ]
            ]
            [ Html.text title ]
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


viewReady : String -> Html Msg -> Html Msg
viewReady message content =
    Html.div
        [ center ]
        [ content
        , Html.div
            [ center ]
            [ Html.button
                [ Event.onClick PickATopic
                , Attribute.css
                    [ Css.fontSize Css.large
                    , Css.marginTop (Css.px 25)
                    ]
                ]
                [ Html.text message ]
            ]
        ]


center : Attribute msg
center =
    Attribute.css
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.justifyContent Css.center
        , Css.alignItems Css.center
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
