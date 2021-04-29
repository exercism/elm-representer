-- This is a demonstration solution that I use when mentoring, any 
-- improvements / comments / suggestions welcome.

-- I prefer to put each conditional on its own line, and indent,
-- to make the logic easier to read

-- There is another style of solution available, where you 
-- calculate all the `divisibleBy`'s, and then use pattern
-- matching, effectively creating a truth table.

module Leap exposing (isLeapYear)


isLeapYear : Int -> Bool
isLeapYear year =
    let
        divisibleBy number = 
            Basics.remainderBy number year == 0         
    in
        if divisibleBy 400 then
            True

        else if divisibleBy 100 then
            False

        else if divisibleBy 4 then
            True

        else
            False