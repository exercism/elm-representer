module CustomTypeDeclaration exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalize"
        [ test "shoud normalize Name and ValueConstructors of Custom Types" <|
            \_ ->
                givenElmCodeOf "type FirstName = FirstName String"
                    |> whenNormalize
                    |> thenContains "type Identifier_1\n=Identifier_1 String"
        , test "shoud normalize generic type parameters of Custom Types" <|
            \_ ->
                givenElmCodeOf "type InputType a = InputType a String"
                    |> whenNormalize
                    |> thenContains "type Identifier_1 identifier_2\n=Identifier_1 identifier_2 String"
        , test "shoud ignore typeclass type parameters Custom Types" <|
            \_ ->
                givenElmCodeOf "type InputType a = InputType a number"
                    |> whenNormalize
                    |> thenContains "type Identifier_1 identifier_2\n=Identifier_1 identifier_2 number"
        ]
