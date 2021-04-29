module Function exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalize"
        [ test "shoud normalize Name and parameters of functions" <|
            \_ ->
                givenElmCodeOf "identityFunction x =\n    x"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 =\nidentifier_2"
        , test "shoud normalize function signature" <|
            \_ ->
                givenElmCodeOf """identityFunction : a -> a
identityFunction x =
    x"""
                    |> whenNormalize
                    |> thenContains """identifier_1 : identifier_2 -> identifier_2
identifier_1 identifier_3 =
identifier_3"""
        , test "shoud ignore typeclasses in function signature" <|
            \_ ->
                givenElmCodeOf """identityFunction : comparable -> comparable
identityFunction x =
    x"""
                    |> whenNormalize
                    |> thenContains """identifier_1 : comparable -> comparable
identifier_1 identifier_2 =
identifier_2"""
        ]
