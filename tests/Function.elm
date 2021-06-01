module Function exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalizing functions"
        [ test "shoud normalize name and parameters" <|
            \_ ->
                givenElmCodeOf "identityFunction x =\n    x"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 =\nidentifier_2"
        , test "shoud normalize signature" <|
            \_ ->
                givenElmCodeOf """identityFunction : a -> a
identityFunction x =
    x"""
                    |> whenNormalize
                    |> thenContains """identifier_1 : identifier_2 -> identifier_2
identifier_1 identifier_3 =
identifier_3"""
        , test "shoud ignore typeclasses in signature" <|
            \_ ->
                givenElmCodeOf """identityFunction : comparable -> comparable
identityFunction x =
    x"""
                    |> whenNormalize
                    |> thenContains """identifier_1 : comparable -> comparable
identifier_1 identifier_2 =
identifier_2"""
        ]
