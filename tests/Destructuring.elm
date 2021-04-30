module Destructuring exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalizing destructuring"
        [ test "shoud work" <|
            \_ ->
                givenElmCodeOf "{name, age} = person"
                    |> whenNormalize
                    |> thenContains "{identifier_1, identifier_2} =\nidentifier_3"
        ]
