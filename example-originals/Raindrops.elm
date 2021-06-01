module Raindrops exposing (raindrops)


raindrops : Int -> String
raindrops number =
    let
        factorsAndSounds = [ ( 3, "Pling" ), ( 5, "Plang" ), ( 7, "Plong" ) ]
    in
        case soundsForFactorsOf number factorsAndSounds of
            [] ->
                String.fromInt number

            sounds ->
                sounds |> String.join ""    


soundsForFactorsOf: Int -> List (Int, String) -> List String
soundsForFactorsOf number factorsAndSounds =
    factorsAndSounds
        |> List.filter (Tuple.first >> isFactorOf number)
        |> List.map Tuple.second


isFactorOf: Int -> Int -> Bool
isFactorOf m n =
    modBy n m == 0