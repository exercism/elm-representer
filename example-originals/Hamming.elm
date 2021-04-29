module Hamming exposing (hammingDistance)

import List exposing (filter, map2)
import String exposing (length, toList)


hammingDistance : String -> String -> Result String Int
hammingDistance leftDnaStrand rightDnaStrand =
    if length leftDnaStrand == length rightDnaStrand then
        map2 (/=) (toList leftDnaStrand) (toList rightDnaStrand)
            |> filter identity
            |> List.length
            |> Ok

    else
        Err "left and right strands must be of equal length"