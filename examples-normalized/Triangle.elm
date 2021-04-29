module Triangle exposing (Triangle (..), triangleKindGivenSideLengths)
import Set  
type Triangle 
    =Identifier_1 
    |Identifier_2 
    |Identifier_3 

triangleKindGivenSideLengths : Float -> (Float -> (Float -> Result String Triangle))
triangleKindGivenSideLengths identifier_4 identifier_5 identifier_6 =
    if identifier_4 <= 0 || identifier_5 <= 0 || identifier_6 <= 0 then
      Err "Invalid lengths"
    else
      if identifier_4 + identifier_5 < identifier_6 || identifier_4 + identifier_6 < identifier_5 || identifier_5 + identifier_6 < identifier_4 then
        Err "Violates inequality"
      else
        
        case [identifier_4, identifier_5, identifier_6] |> identifier_7 of
          1 ->
            Ok Identifier_1
          2 ->
            Ok Identifier_2
          _ ->
            Ok Identifier_3
        

identifier_7 : List comparable -> Int
identifier_7  =
    Set.fromList >> Set.size
