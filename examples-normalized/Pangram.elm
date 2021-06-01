module Pangram exposing (isPangram)
import Set  exposing (..)

isPangram : String -> Bool
isPangram identifier_1 =
    let
      
      
      identifier_2  =
          26
    in
      String.toLower identifier_1 |> String.toList |> List.filter Char.isAlpha |> Set.fromList |> Set.size |> (==) identifier_2
