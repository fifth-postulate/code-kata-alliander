module WheelOfSuggestions.Topic exposing (Topics, decoder, empty, encode, fromList, suggestionFrom)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Random exposing (Generator)
import WheelOfSuggestions.Suggestion as Suggestion exposing (Suggestion)


type Topics
    = Topics { suggestions : List Suggestion }


empty : Topics
empty =
    fromList []


fromList : List Suggestion -> Topics
fromList suggestions =
    Topics { suggestions = suggestions }


suggestionFrom : Topics -> Generator Suggestion
suggestionFrom (Topics { suggestions }) =
    case suggestions of
        [] ->
            Random.constant (Suggestion.topic "Your choice")

        t :: ts ->
            Random.uniform t ts


encode : Topics -> Value
encode (Topics topics) =
    Encode.object
        [ ( "suggestions", Encode.list Suggestion.encode topics.suggestions )
        ]


decoder : Decoder Topics
decoder =
    Decode.field "suggestions" (Decode.list Suggestion.decoder)
        |> Decode.map fromList
