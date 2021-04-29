module Destructuring exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalize"
        [ test "shoud normalize destructuring" <|
            \_ ->
                givenElmCodeOf "{name, age} = person"
                    |> whenNormalize
                    |> thenContains "{identifier_1, identifier_2} =\nidentifier_3"
        ]
