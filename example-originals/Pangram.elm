module Pangram exposing (isPangram)

import Set exposing (..)


isPangram : String -> Bool
isPangram sentence =
    let
        numberOfLettersInAlphabet = 26    
    in
        String.toLower sentence
        |> String.toList
        |> List.filter Char.isAlpha
        |> Set.fromList
        |> Set.size
        |> (==) numberOfLettersInAlphabet