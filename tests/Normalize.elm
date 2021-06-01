module Normalize exposing (suite)

import Expect
import Normalization
import Test exposing (..)



-- These things are imported automatically / by default, so need to take
-- account of this during the normalization
-- https://package.elm-lang.org/packages/elm/core/latest/
-- import Basics exposing (..)
-- module Basics exposing
--   ( Int, Float
--   , (+), (-), (*), (/), (//), (^)
--   , toFloat, round, floor, ceiling, truncate
--   , (==), (/=)
--   , (<), (>), (<=), (>=), max, min, compare, Order(..)
--   , Bool(..), not, (&&), (||), xor
--   , (++)
--   , modBy, remainderBy, negate, abs, clamp, sqrt, logBase, e
--   , pi, cos, sin, tan, acos, asin, atan, atan2
--   , degrees, radians, turns
--   , toPolar, fromPolar
--   , isNaN, isInfinite
--   , identity, always, (<|), (|>), (<<), (>>), Never, never
--   )
-- import List exposing (List, (::))
-- import Maybe exposing (Maybe(..)) -- Just, Nothing
-- import Result exposing (Result(..)) -- Ok, Err
-- import String exposing (String)
-- import Char exposing (Char)
-- import Tuple
-- import Debug
-- import Platform exposing ( Program )
-- import Platform.Cmd as Cmd exposing ( Cmd )
-- import Platform.Sub as Sub exposing ( Sub )


suite : Test
suite =
    describe "Normalization"
        [ shouldIgnore "Int"
        , shouldIgnore "Float"
        , shouldIgnore "toFloat"
        , shouldIgnore "round"
        , shouldIgnore "floor"
        , shouldIgnore "ceiling"
        , shouldIgnore "truncate"
        , shouldIgnore "max"
        , shouldIgnore "min"
        , shouldIgnore "compare"
        , shouldIgnore "Order"
        , shouldIgnore "GT"
        , shouldIgnore "EQ"
        , shouldIgnore "LT"
        , shouldIgnore "Bool"
        , shouldIgnore "True"
        , shouldIgnore "False"
        , shouldIgnore "not"
        , shouldIgnore "xor"
        , shouldIgnore "modBy"
        , shouldIgnore "remainderBy"
        , shouldIgnore "negate"
        , shouldIgnore "abs"
        , shouldIgnore "clamp"
        , shouldIgnore "sqrt"
        , shouldIgnore "logBase"
        , shouldIgnore "e"
        , shouldIgnore "pi"
        , shouldIgnore "cos"
        , shouldIgnore "sin"
        , shouldIgnore "tan"
        , shouldIgnore "acos"
        , shouldIgnore "asin"
        , shouldIgnore "atan"
        , shouldIgnore "atan2"
        , shouldIgnore "degrees"
        , shouldIgnore "radians"
        , shouldIgnore "turns"
        , shouldIgnore "toPolar"
        , shouldIgnore "fromPolar"
        , shouldIgnore "isNan"
        , shouldIgnore "isInfinite"
        , shouldIgnore "identity"
        , shouldIgnore "always"
        , shouldIgnore "Never"
        , shouldIgnore "never"
        , shouldIgnore "List"
        , shouldIgnore "Maybe"
        , shouldIgnore "Just"
        , shouldIgnore "Result"
        , shouldIgnore "Ok"
        , shouldIgnore "Err"
        , shouldIgnore "String"
        , shouldIgnore "Char"
        , shouldIgnore "Tuple"
        , shouldIgnore "Debug"
        , shouldIgnore "Program"
        , shouldIgnore "Cmd"
        , shouldIgnore "Sub"

        -- these are typeclasses, think they are part of the language rather than a default import,
        -- and can be (re)used as function / value names
        , shouldIgnoreType "number"
        , shouldIgnoreType "appendable"
        , shouldIgnoreType "comparable"
        , shouldIgnoreType "compappend"
        , test "shoud be case sensitive" <|
            \_ ->
                normalize2 "x" "X"
                    |> Expect.equal [ "identifier_1", "Identifier_2" ]
        ]


shouldIgnoreType : String -> Test
shouldIgnoreType reservedWord =
    test ("shoud ignore " ++ reservedWord) <|
        \_ ->
            normalizeType reservedWord
                |> Expect.equal reservedWord


shouldIgnore : String -> Test
shouldIgnore reservedWord =
    test ("shoud ignore " ++ reservedWord) <|
        \_ ->
            normalize reservedWord
                |> Expect.equal reservedWord


normalize string =
    Normalization.initialize []
        |> (\state ->
                Normalization.normalize state string
                    |> Tuple.second
           )


normalize2 string1 string2 =
    Normalization.initialize []
        |> (\state ->
                Normalization.normalize state string1
                    |> (\( state2, normalized1 ) -> normalized1 :: [ Tuple.second (Normalization.normalize state2 string2) ])
           )


normalizeType string =
    Normalization.initialize []
        |> (\state ->
                Normalization.normalizeType state string
                    |> Tuple.second
           )
