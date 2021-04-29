module Exports exposing (suite)

import Helpers exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Normalize"
        [ test "shoud not normalize Module Name" <|
            \_ ->
                givenElmFileOf "module Bob exposing (..)"
                    |> whenNormalize
                    |> thenContains "module Bob exposing (..)"
        , test "shoud not normalize exported things" <|
            \_ ->
                givenElmFileOf "module Bob exposing (hey, Hey, Hey2 (..))"
                    |> whenNormalize
                    |> thenContains "module Bob exposing (hey, Hey, Hey2 (..))"
        ]
