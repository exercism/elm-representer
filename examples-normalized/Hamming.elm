module Hamming exposing (hammingDistance)
import List  exposing (filter, map2)
import String  exposing (length, toList)

hammingDistance : String -> (String -> Result String Int)
hammingDistance identifier_1 identifier_2 =
    if length identifier_1 == length identifier_2 then
      map2 (/=) (toList identifier_1) (toList identifier_2) |> filter identity |> List.length |> Ok
    else
      Err "left and right strands must be of equal length"
