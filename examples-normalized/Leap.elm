module Leap exposing (isLeapYear)


isLeapYear : Int -> Bool
isLeapYear identifier_1 =
    let
      
      
      identifier_2 identifier_3 =
          Basics.remainderBy identifier_3 identifier_1 == 0
    in
      if identifier_2 400 then
        True
      else
        if identifier_2 100 then
          False
        else
          if identifier_2 4 then
            True
          else
            False
