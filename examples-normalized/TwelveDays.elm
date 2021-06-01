module TwelveDays exposing (recite)


recite : Int -> (Int -> List String)
recite identifier_1 identifier_2 =
    List.map identifier_3 (List.range identifier_1 identifier_2)

identifier_3 : Int -> String
identifier_3 identifier_4 =
    "On the " ++ identifier_5 identifier_4 ++ " day of Christmas my true love gave to me, " ++ identifier_6 identifier_4

identifier_5 : Int -> String
identifier_5 identifier_7 =
    
    case identifier_7 of
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
    

identifier_6 : Int -> String
identifier_6 identifier_4 =
    String.join " "
     (List.range 1 identifier_4 |> List.reverse |> List.map identifier_8)

identifier_8 : Int -> String
identifier_8 identifier_4 =
    
    case identifier_4 of
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
    
