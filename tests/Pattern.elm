module Pattern exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalize"
        [ test "shoud normalize tuple pattern" <|
            \_ ->
                givenElmCodeOf "add (x, y) =\n    x + y"
                    |> whenNormalize
                    |> thenContains "identifier_1 (identifier_2, identifier_3) =\nidentifier_2 + identifier_3"
        , test "shoud normalize record pattern" <|
            \_ ->
                givenElmCodeOf "add {x, y} =\n    x + y"
                    |> whenNormalize
                    |> thenContains "identifier_1 {identifier_2, identifier_3} =\nidentifier_2 + identifier_3"
        , test "shoud normalize uncons pattern" <|
            \_ ->
                givenElmCodeOf "shadowIdentity x :: xs =\n    x :: xs"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 :: identifier_3 =\nidentifier_2 :: identifier_3"
        , test "shoud normalize list pattern" <|
            \_ ->
                givenElmCodeOf "add [x1, x2] =\n    x1 + x2"
                    |> whenNormalize
                    |> thenContains "identifier_1 [identifier_2, identifier_3] =\nidentifier_2 + identifier_3"
        , test "shoud normalize named pattern" <|
            \_ ->
                givenElmCodeOf "value (Node a) =\n    a"
                    |> whenNormalize
                    |> thenContains "identifier_1 ( Node identifier_2 ) =\nidentifier_2"
        , test "shoud normalize as pattern" <|
            \_ ->
                givenElmCodeOf "shadowIdentity ((_, _) as tuple) =\n    tuple"
                    |> whenNormalize
                    |> thenContains "identifier_1 ( (_, _) as identifier_2 ) =\nidentifier_2"
        ]
