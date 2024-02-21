module WheelOfSuggestions.Suggestion exposing (Suggestion, description, topic, view)

import Html exposing (Html)


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
    Html.span []
        [ Html.text <| description suggestion
        ]
