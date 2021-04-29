module Expression exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalize"
        [ test "shoud normalize operator application expressions" <|
            \_ ->
                givenElmCodeOf "shadowAdd x y =\n    x + y"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 identifier_3 =\nidentifier_2 + identifier_3"
        , test "shoud normalize if expressions" <|
            \_ ->
                givenElmCodeOf "shadowMax x y =\n    if x > y then x else y"
                    |> whenNormalize
                    |> thenContains """identifier_1 identifier_2 identifier_3 =
if identifier_2 > identifier_3 then
identifier_2
else
identifier_3"""
        , test "shoud normalize tuple expressions" <|
            \_ ->
                givenElmCodeOf "tuple x y =\n    (x, y)"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 identifier_3 =\n(identifier_2, identifier_3)"
        , test "shoud normalize list expressions" <|
            \_ ->
                givenElmCodeOf "list x y =\n    [x, y]"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 identifier_3 =\n[identifier_2, identifier_3]"
        , test "shoud normalize paranthesized expressions" <|
            \_ ->
                givenElmCodeOf "paranthesized x =\n    (x)"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 =\n(identifier_2)"
        , test "shoud normalize let expressions" <|
            \_ ->
                givenElmCodeOf """shadowIdentity x =
    let 
        y = x
    in
        y"""
                    |> whenNormalize
                    |> thenContains """identifier_1 identifier_2 =
let
identifier_3 =
identifier_2
in
identifier_3"""
        , test "shoud normalize case expressions" <|
            \_ ->
                givenElmCodeOf """shadowIdentity x =
    case x of 
        1 -> 1
        _ -> x"""
                    |> whenNormalize
                    |> thenContains """identifier_1 identifier_2 =
case identifier_2 of
1 ->
1
_ ->
identifier_2"""
        , test "shoud normalize lambda expressions" <|
            \_ ->
                givenElmCodeOf "shadowIdentity =\n    \\x -> x"
                    |> whenNormalize
                    |> thenContains "identifier_1 =\n\\identifier_2 -> identifier_2"
        , test "shoud normalize record access expressions" <|
            \_ ->
                givenElmCodeOf "getBlah x =\n    x.y"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 =\nidentifier_2.identifier_3"
        , test "shoud normalize record access function expressions" <|
            \_ ->
                givenElmCodeOf "getBlah x =\n    .y x"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 =\n.identifier_3 identifier_2"
        , test "shoud normalize record expressions" <|
            \_ ->
                givenElmCodeOf "fromFirstName =\n    { name = firstName }"
                    |> whenNormalize
                    |> thenContains "identifier_1 =\n{identifier_2 = identifier_3}"
        , test "shoud normalize record updateexpressions" <|
            \_ ->
                givenElmCodeOf "updateName person newName =\n    { person | name = newName }"
                    |> whenNormalize
                    |> thenContains "identifier_1 identifier_2 identifier_3 =\n{ identifier_2 | identifier_4 = identifier_3 }"
        ]
