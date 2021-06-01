module TwelveDays exposing (recite)

-- This is a demonstration solution that I use when mentoring, any 
-- improvements / comments / suggestions welcome.

-- It has a primitive obsession on Int, but this is kind of specified
-- by the question so I haven't worried about it.
-- Also having two large case statements is a shame, as is having the
-- strings for the day ("first") and gifts ("a Partridge in a Pear Tree")
-- far part in the code and not logically linked. It is possible to fix
-- this, but it makes the code more complicated and I'm not convinced 
-- it is worth the trade off 

-- Ideally this function would return something to indicate that it can 
-- error (other than an empty list). So `Maybe (List String)`
-- or `Either (List String)`. Its part of the exercise though
-- so it can't be changed, I imagine that this is to keep the
-- exercise suitably simple.
-- It might also take a domain object instead of an Int
recite : Int -> Int -> List String
recite start stop =
    List.map reciteDay (List.range start stop)


reciteDay : Int -> String
reciteDay day =
    "On the "
        ++ nth day
        ++ " day of Christmas my true love gave to me, "
        ++ allGiftsFor day

nth : Int -> String
nth input =
    case input of
        1 ->
            "first"

        2 ->
            "second"

        3 ->
            "third"

        4 ->
            "fourth"

        5 ->
            "fifth"

        6 ->
            "sixth"

        7 ->
            "seventh"

        8 ->
            "eighth"

        9 ->
            "ninth"

        10 ->
            "tenth"

        11 ->
            "eleventh"

        12 ->
            "twelfth"

        _ ->
            ""

allGiftsFor : Int -> String
allGiftsFor day =
    String.join 
        " " 
        (List.range 1 day 
        |> List.reverse
        |> List.map firstGiftFor)

firstGiftFor : Int -> String
firstGiftFor day =
    case day of
        1 ->
            "a Partridge in a Pear Tree."

        2 ->
            "two Turtle Doves, and"

        3 ->
            "three French Hens,"

        4 ->
            "four Calling Birds,"

        5 ->
            "five Gold Rings,"

        6 ->
            "six Geese-a-Laying,"

        7 ->
            "seven Swans-a-Swimming,"

        8 ->
            "eight Maids-a-Milking,"

        9 ->
            "nine Ladies Dancing,"

        10 ->
            "ten Lords-a-Leaping,"

        11 ->
            "eleven Pipers Piping,"

        12 ->
            "twelve Drummers Drumming,"

        _ ->
            ""