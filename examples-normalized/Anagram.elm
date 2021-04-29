module Anagram exposing (..)
import List as List exposing (filter, sort)
import String  exposing (toList, toLower)

identifier_1 : String -> (List String -> List String)
identifier_1 identifier_2 =
    List.filter (identifier_3 identifier_2) >> List.filter (identifier_4 identifier_2)

identifier_3 : String -> (String -> Bool)
identifier_3 identifier_2 identifier_5 =
    identifier_6 identifier_2 == identifier_6 identifier_5

identifier_4 : String -> (String -> Bool)
identifier_4 identifier_7 identifier_8 =
    String.toLower identifier_7 /= String.toLower identifier_8

identifier_6 : String -> List Char
identifier_6  =
    String.toLower >> String.toList >> List.sort
