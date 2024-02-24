module WheelOfSuggestions.Topic exposing (Topics, empty, fromList, suggestionFrom)

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
