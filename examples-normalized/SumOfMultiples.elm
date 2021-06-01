module SumOfMultiples exposing (sumOfMultiples)


sumOfMultiples : List Int -> (Int -> Int)
sumOfMultiples identifier_1 identifier_2 =
    List.range 1 (identifier_2 - 1) |> List.filter (identifier_3 identifier_1) |> List.sum

identifier_3 : List Int -> (Int -> Bool)
identifier_3 identifier_4 identifier_5 =
    List.any (\identifier_6 -> identifier_5 % identifier_6 == 0)
     identifier_4
