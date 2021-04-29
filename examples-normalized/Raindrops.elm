module Raindrops exposing (raindrops)


raindrops : Int -> String
raindrops identifier_1 =
    let
      
      
      identifier_2  =
          [(3, "Pling"), (5, "Plang"), (7, "Plong")]
    in
      
      case identifier_3 identifier_1 identifier_2 of
        [] ->
          String.fromInt identifier_1
        identifier_4 ->
          identifier_4 |> String.join ""
      

identifier_3 : Int -> (List ((Int, String)) -> List String)
identifier_3 identifier_1 identifier_2 =
    identifier_2 |> List.filter (Tuple.first >> identifier_5 identifier_1) |> List.map Tuple.second

identifier_5 : Int -> (Int -> Bool)
identifier_5 identifier_6 identifier_7 =
    modBy identifier_7 identifier_6 == 0
