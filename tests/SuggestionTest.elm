module SuggestionTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode exposing (decodeString, decodeValue)
import Json.Encode exposing (encode)
import Test exposing (..)
import WheelOfSuggestions.Suggestion as Suggestion exposing (Suggestion)


suite : Test
suite =
    describe "Suggestion"
        [ describe "json"
            [ fuzz suggestion "encode >> decode is identity" <|
                \original ->
                    let
                        actual =
                            original
                                |> Suggestion.encode
                                |> decodeValue Suggestion.decoder
                    in
                    Expect.equal (Ok original) actual
            , fuzz suggestion "decode >> encode is identity" <|
                \input ->
                    let
                        original =
                            input
                                |> Suggestion.encode
                                |> encode 0

                        actual =
                            original
                                |> decodeString Suggestion.decoder
                                |> Result.map Suggestion.encode
                                |> Result.map (encode 0)
                    in
                    Expect.equal (Ok original) actual
            ]
        ]


suggestion : Fuzzer Suggestion
suggestion =
    Fuzz.string
        |> Fuzz.map Suggestion.topic
