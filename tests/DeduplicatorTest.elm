module DeduplicatorTest exposing (..)

import Deduplicator
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

suite : Test
suite =
    describe "The Deduplicator module"
        [ describe "Deduplicator.deduplicate" -- Nest as many descriptions as you like.
            [ test "returns an identical list for an list of length 1" <|
                \_ ->
                    let
                        words =
                            ["fish"]
                    in
                        Expect.equal words (Deduplicator.deduplicate words)
            , test "returns an identical list for an list of length 0" <|
                \_ ->
                    let
                        words =
                            []
                    in
                        Expect.equal words (Deduplicator.deduplicate words)
            ]
        ]
