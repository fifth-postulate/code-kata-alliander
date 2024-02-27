module TopicsTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode exposing (decodeString, decodeValue)
import Json.Encode exposing (encode)
import SuggestionTest
import Test exposing (..)
import WheelOfSuggestions.Topic as Topic exposing (Topics)


suite : Test
suite =
    describe "Topic"
        [ describe "json"
            [ fuzz topics "encode >> decode is identity" <|
                \original ->
                    let
                        actual =
                            original
                                |> Topic.encode
                                |> decodeValue Topic.decoder
                    in
                    Expect.equal (Ok original) actual
            , fuzz topics "decode >> encode is identity" <|
                \input ->
                    let
                        original =
                            input
                                |> Topic.encode
                                |> encode 0

                        actual =
                            original
                                |> decodeString Topic.decoder
                                |> Result.map Topic.encode
                                |> Result.map (encode 0)
                    in
                    Expect.equal (Ok original) actual
            ]
        ]


topics : Fuzzer Topics
topics =
    Fuzz.list SuggestionTest.suggestion
        |> Fuzz.map Topic.fromList
