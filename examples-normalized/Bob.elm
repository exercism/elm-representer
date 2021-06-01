module Bob exposing (hey)
import Regex  exposing (Regex)
type Identifier_1 identifier_2 identifier_3
    =Identifier_1 identifier_2 identifier_3
type alias Identifier_4 identifier_2 identifier_3 =
    Identifier_1 identifier_2 identifier_3
type alias Identifier_5  =
    {identifier_6 : String, identifier_7 : Int}

hey : String -> String
hey identifier_8 =
    if identifier_9 identifier_8 && identifier_10 identifier_8 then
      "Calm down, I know what I'm doing!"
    else
      if identifier_9 identifier_8 then
        "Whoa, chill out!"
      else
        if identifier_10 identifier_8 then
          "Sure."
        else
          if identifier_11 identifier_8 then
            "Fine. Be that way!"
          else
            "Whatever."

identifier_9 : String -> Bool
identifier_9 identifier_8 =
    identifier_8 == String.toUpper identifier_8 && identifier_12 identifier_8

identifier_10 : String -> Bool
identifier_10 identifier_8 =
    identifier_8 |> String.trim |> String.endsWith "?"

identifier_11 : String -> Bool
identifier_11 identifier_8 =
    String.trim identifier_8 == ""

identifier_12 : String -> Bool
identifier_12 identifier_8 =
    String.any Char.isAlpha identifier_8
