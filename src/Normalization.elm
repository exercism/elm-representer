module Normalization exposing (State, getFinalIdentifierMapping, initialize, normalize, normalizeType)

import Dict as Dict exposing (Dict)


type State
    = State
        { initialIdentifierMapping : Dict String String
        , identifierMapping : Dict String String
        , uniqueInt : Int
        }


initialize : List String -> State
initialize customReservedWords =
    let
        reservedWords =
            [ ( "Int", "Int" )
            , ( "Float", "Float" )
            , ( "toFloat", "toFloat" )
            , ( "round", "round" )
            , ( "floor", "floor" )
            , ( "ceiling", "ceiling" )
            , ( "truncate", "truncate" )
            , ( "max", "max" )
            , ( "min", "min" )
            , ( "compare", "compare" )
            , ( "Order", "Order" )
            , ( "GT", "GT" )
            , ( "EQ", "EQ" )
            , ( "LT", "LT" )
            , ( "Bool", "Bool" )
            , ( "True", "True" )
            , ( "False", "False" )
            , ( "not", "not" )
            , ( "xor", "xor" )
            , ( "modBy", "modBy" )
            , ( "remainderBy", "remainderBy" )
            , ( "negate", "negate" )
            , ( "abs", "abs" )
            , ( "clamp", "clamp" )
            , ( "sqrt", "sqrt" )
            , ( "logBase", "logBase" )
            , ( "e", "e" )
            , ( "pi", "pi" )
            , ( "cos", "cos" )
            , ( "sin", "sin" )
            , ( "tan", "tan" )
            , ( "acos", "acos" )
            , ( "asin", "asin" )
            , ( "atan", "atan" )
            , ( "atan2", "atan2" )
            , ( "degrees", "degrees" )
            , ( "radians", "radians" )
            , ( "turns", "turns" )
            , ( "toPolar", "toPolar" )
            , ( "fromPolar", "fromPolar" )
            , ( "isNan", "isNan" )
            , ( "isInfinite", "isInfinite" )
            , ( "identity", "identity" )
            , ( "always", "always" )
            , ( "Never", "Never" )
            , ( "never", "never" )
            , ( "List", "List" )
            , ( "Maybe", "Maybe" )
            , ( "Just", "Just" )
            , ( "Result", "Result" )
            , ( "Ok", "Ok" )
            , ( "Err", "Err" )
            , ( "String", "String" )
            , ( "Char", "Char" )
            , ( "Tuple", "Tuple" )
            , ( "Debug", "Debug" )
            , ( "Program", "Program" )
            , ( "Cmd", "Cmd" )
            , ( "Sub", "Sub" )
            ]
                ++ List.map (\s -> ( s, s )) customReservedWords

        initialIdentifierMapping =
            Dict.fromList reservedWords
    in
    State
        { initialIdentifierMapping = initialIdentifierMapping
        , identifierMapping = initialIdentifierMapping
        , uniqueInt = 1
        }


{-| Normalize a string that is being used to identify an Elm Type
Handles the additional case of typeclasses, which can be
(re)used as function and value names, so can't be part of the
more general case solution
-}
normalizeType : State -> String -> ( State, String )
normalizeType state original =
    if List.member original [ "number", "comparable", "appendable", "compappend" ] then
        ( state, original )

    else
        normalize state original


normalize : State -> String -> ( State, String )
normalize (State state) original =
    case Dict.get original state.identifierMapping of
        Just normalizedIdentifier ->
            ( State state, normalizedIdentifier )

        Nothing ->
            let
                newNormalizedIdentifier =
                    normalizeMaintainCase state.uniqueInt original
            in
            ( State
                { initialIdentifierMapping = state.initialIdentifierMapping
                , identifierMapping = Dict.insert original newNormalizedIdentifier state.identifierMapping
                , uniqueInt = state.uniqueInt + 1
                }
            , newNormalizedIdentifier
            )


{-| Elm is strict about the case of the first letters of identifiers,
so we should maintain it.
-}
normalizeMaintainCase : Int -> String -> String
normalizeMaintainCase uniqueInt original =
    if firstLetterIsLowerCase original then
        "identifier_" ++ String.fromInt uniqueInt

    else
        "Identifier_" ++ String.fromInt uniqueInt


{-| The "." is for record access function expressions, which always
start with a '.' and are always lower case after that. Due to a nuance
in Elm-Syntax, we don't need to maintain the '.' (Elm-Syntax adds it
when writing back out to a string)
-}
firstLetterIsLowerCase : String -> Bool
firstLetterIsLowerCase original =
    let
        firstCharacter =
            String.left 1 original
    in
    (String.toLower firstCharacter == firstCharacter)
        || firstCharacter
        == "."


getFinalIdentifierMapping : State -> Dict String String
getFinalIdentifierMapping (State { initialIdentifierMapping, identifierMapping }) =
    -- Remove initial identifiers
    Dict.diff identifierMapping initialIdentifierMapping
        |> Dict.toList
        -- Reverse the key and values to have in the correct way for the specs
        |> List.map (\( key, val ) -> ( val, key ))
        |> Dict.fromList
