module SumOfMultiples exposing (sumOfMultiples)

-- This is a demonstration solution that I use when mentoring, any 
-- improvements / comments / suggestions welcome.

-- Naming is hard in this exercise, as the domain concepts are all
-- very abstract, and there isn't enough domain to provide much
-- context

sumOfMultiples : List Int -> Int -> Int
sumOfMultiples rootNumbersToSumMultipesOf sumMultiplesUpTo =

    List.range 1 (sumMultiplesUpTo - 1)
        |> List.filter (isMultipleOfAny rootNumbersToSumMultipesOf)
        |> List.sum

isMultipleOfAny : List Int -> Int -> Bool
isMultipleOfAny rootNumbers numberThatMightBeAMultipleOfAnyRootNumber  =
    List.any 
        (\rootNumber -> numberThatMightBeAMultipleOfAnyRootNumber % rootNumber == 0) 
        rootNumbers