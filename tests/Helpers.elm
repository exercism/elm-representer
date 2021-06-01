module Helpers exposing (givenElmCodeOf, givenElmFileOf, thenContains, whenNormalize)

import Dict exposing (Dict)
import Expect exposing (Expectation)
import Expect.Extra
import NormalizeElmCode
import String.Extra
import Test exposing (..)


givenElmCodeOf : String -> String
givenElmCodeOf elmCode =
    boilerplate ++ "\n\n" ++ elmCode


givenElmFileOf : String -> String
givenElmFileOf elmFile =
    elmFile


whenNormalize : String -> Result String ( Dict String String, String )
whenNormalize =
    NormalizeElmCode.normalize



-- The output from Elm-Syntax isn't the same as Elm-Format, and also isn't always
-- consistent, so this function tries to make it as consistent as possile, although
-- it does turn the code in to illegal Elm by removing required whitespace.
-- Hopefully the tradeoff is worth it


thenContains : String -> Result String ( Dict String String, String ) -> Expectation
thenContains expected normalizationResult =
    let
        cleaner =
            \( _, normalized ) ->
                normalized
                    -- remove added boilerplate
                    |> String.replace boilerplate ""
                    -- keep line breaks, but compress all other multiple whitespace to a single whitespace
                    |> String.lines
                    |> List.map String.Extra.clean
                    -- remove blank lines
                    |> List.filter (String.isEmpty >> not)
                    |> String.join "\n"
                    |> String.trim

        normalizedAndCleanedResult =
            Result.map cleaner normalizationResult
    in
    case normalizedAndCleanedResult of
        Ok normalizedAndCleanedCode ->
            Expect.Extra.match (Expect.Extra.stringPattern expected) normalizedAndCleanedCode

        Err message ->
            Expect.fail message


boilerplate : String
boilerplate =
    "module Boilerplate exposing (..)"
