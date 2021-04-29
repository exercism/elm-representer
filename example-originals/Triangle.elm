-- This is a demonstration solution that I use when mentoring, any 
-- improvements / comments / suggestions welcome. I confess that 
-- I stole it from the user `qxp`.

-- I have changed the name of the exported function to `triangleKindGivenSideLengths`,
-- as I think it describes the intent better, and means you don't have to specify
-- lengths in the parameter names (they could just as easily be angles). Another
-- option would be to define a Length type.

-- Most times when you are using this module, the name / function definition will 
-- tell you all you need to know, and you won't need to read anything else.

-- The `Violates Equality` condition could arguably be encapsulated, but I think
-- that the Error string describes it adequately, and introducing another function
-- would just add more noise. It does probably make changing one without changing 
-- the other a little bit more likely, but I think its a minor point.

module Triangle exposing (Triangle(..), triangleKindGivenSideLengths)

import Set


type Triangle
    = Equilateral
    | Isosceles
    | Scalene


triangleKindGivenSideLengths : Float -> Float -> Float -> Result String Triangle
triangleKindGivenSideLengths x y z =
    if x <= 0 || y <= 0 || z <= 0 then
        Err "Invalid lengths"

    else if x + y < z || x + z < y || y + z < x then
        Err "Violates inequality"

    else
        case [ x, y, z ] |> numberOfDistinctValues of
            1 ->
                Ok Equilateral

            2 ->
                Ok Isosceles

            _ ->
                Ok Scalene


numberOfDistinctValues : List comparable -> Int
numberOfDistinctValues =
    Set.fromList >> Set.size