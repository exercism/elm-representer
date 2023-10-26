-- This is a demonstration solution that I use when mentoring, any 
-- improvements / comments / suggestions welcome.

-- I have changed the name of the exported function from `detect` to `filterAnagramsOf`,
-- as I think it describes the intent better. Most times when you are using this module, 
-- this name / function definition will tell you all you need to know, and you won't need
-- to read anything else.

-- If you want to know how the algorithm works (the stipulation that idenitcal words be
-- removed is a debatable point for example) then you only have to read the body of 
-- `filterAnaagramsOf`.

-- So to understand what this does and how it does it there are only 4 lines to read, 
-- which I think is powerful.

-- There is a solution available that uses more point free style
module Anagram exposing (..)

import List as List exposing (filter, sort)
import String exposing (toList, toLower)

filterAnagramsOf : String -> List String -> List String
filterAnagramsOf word =
    List.filter (sortedLowercaseCharactersMatch word)
    >> List.filter (notExactlyTheSameWord word)


sortedLowercaseCharactersMatch : String -> String -> Bool
sortedLowercaseCharactersMatch word candidate =
    sortedLowercaseCharacters word == sortedLowercaseCharacters candidate

notExactlyTheSameWord : String -> String -> Bool 
notExactlyTheSameWord word1 word2 =
    String.toLower word1 /= String.toLower word2

sortedLowercaseCharacters : String -> List Char
sortedLowercaseCharacters =
    String.toLower
        >> String.toList
        >> List.sort