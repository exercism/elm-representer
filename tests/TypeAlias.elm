module TypeAlias exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalize"
        [ test "shoud normalize Name and Type of Custom Type - Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias FirstName = Name"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\nIdentifier_2"
        , test "shoud normalize Name and generic type parameters of Custom Type - Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias InputType a = AnotherCustomType a"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 identifier_2 =\nIdentifier_3 identifier_2"
        , test "shoud normalize name of Tuple Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias InputType = (String, Int)"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\n(String, Int)"
        , test "shoud normalize parameter types of Tuple Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias InputType = (Name, Name)"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\n(Identifier_2, Identifier_2)"
        , test "shoud normalize types of Function Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias InputType = Name -> Name"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\nIdentifier_2 -> Identifier_2"
        , test "shoud normalize Name and Parameters of Record Types" <|
            \_ ->
                givenElmCodeOf """
type alias Person = 
    { name : Name
    , age : Int
    }
"""
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\n{identifier_2 : Identifier_3, identifier_4 : Int}"
        , test "shoud normalize Name and Parameters of Extensible Record Types" <|
            \_ ->
                givenElmCodeOf """
type alias Person a = 
    { a |
    name : String
    }
"""
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 identifier_2 =\n{ identifier_2 | identifier_3 : String }"
        , test "shoud ignore typeclass Type of Custom Type - Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias FirstName = appendable"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\nappendable"
        , test "shoud ignore typeclass types of Tuple Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias InputType = (number, compappend)"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\n(number, compappend)"
        , test "shoud ignore typeclass types of Function Type Alias'" <|
            \_ ->
                givenElmCodeOf "type alias InputType = number -> number"
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\nnumber -> number"
        , test "shoud ignore typeclass types of Record Types" <|
            \_ ->
                givenElmCodeOf """
type alias Person = 
    { name : comparable
    }
"""
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 =\n{identifier_2 : comparable}"
        , test "shoud ignore typeclass types of Extensible Record Types" <|
            \_ ->
                givenElmCodeOf """
type alias Person a = 
    { a |
    name : appendable
    }
"""
                    |> whenNormalize
                    |> thenContains "type alias Identifier_1 identifier_2 =\n{ identifier_2 | identifier_3 : appendable }"
        ]
