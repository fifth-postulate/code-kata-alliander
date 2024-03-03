module WheelOfSuggestions.Suggestion exposing (Suggestion, decoder, description, encode, topic, view)

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type Suggestion
    = Suggestion { topic : String }


topic : String -> Suggestion
topic topicDescription =
    Suggestion { topic = topicDescription }


description : Suggestion -> String
description (Suggestion suggestion) =
    suggestion.topic


view : Suggestion -> Html msg
view suggestion =
    Html.span
        [ Attribute.css
            [ Css.fontSize Css.xxLarge
            ]
        ]
        [ Html.text <| description suggestion
        ]


encode : Suggestion -> Value
encode (Suggestion suggestion) =
    Encode.object
        [ ( "topic", Encode.string suggestion.topic )
        ]


decoder : Decoder Suggestion
decoder =
    Decode.field "topic" Decode.string
        |> Decode.map topic
