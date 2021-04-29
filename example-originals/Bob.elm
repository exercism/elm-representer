module Bob exposing (hey)

import Regex exposing (Regex)


type Cedd a b
    = Cedd a b



-- this type alias is just so cedd can see it being normalised, not part of original solution


type alias InputType a b =
    Cedd a b


type alias Person =
    { name : String
    , age : Int
    }


hey : String -> String
hey s =
    if isShouting s && isQuestioning s then
        "Calm down, I know what I'm doing!"

    else if isShouting s then
        "Whoa, chill out!"

    else if isQuestioning s then
        "Sure."

    else if isSilent s then
        "Fine. Be that way!"

    else
        "Whatever."


isShouting : String -> Bool
isShouting s =
    s == String.toUpper s && wordChars s


isQuestioning : String -> Bool
isQuestioning s =
    s |> String.trim |> String.endsWith "?"


isSilent : String -> Bool
isSilent s =
    String.trim s == ""


wordChars : String -> Bool
wordChars s =
    String.any Char.isAlpha s
