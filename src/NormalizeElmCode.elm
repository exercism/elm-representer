module NormalizeElmCode exposing (normalize)

import Dict as Dict exposing (Dict)
import Elm.Parser
import Elm.Processing exposing (init, process)
import Elm.Writer exposing (write, writeFile)
import Normalization
import NormalizeElmFile exposing (normalizeElmFile)
import Parser



-- todo
-- Run the example files as tests, just to ensure that they succeed (don't worry about the created text). This will ensure that the created code is valid and can be re parsed, and if we ever find problems we can add them to the examples.
-- Later: dockerise
--  run elm-format afterwards. the code created by elm-syntax can be a bit weird, and is more likely to change that the format that elm-format insists on. Although apparently elm-syntax-dsl might do a similar thing and be easier to integrate, so investigate that
-- Later: Think about using elm-syntax-dsl instead of elm-syntax. It uses the same types, but without the `Node a` type stuff, which should make things simpler and result in less code. I have looked at the code though, and now I'm not sure it will help, as it just re exposes the elm-syntax types, instead of redefining similar types but wihtout the Node's
-- Later: create pull request with exercism elm-representer
-- Later: add code coverage
--  This isn't working at the moment, I think elm coverrage doesn't work with latest version of elm-test
-- Later: add pull request / issue to elm-syntax repo about the `process init` thing which is hard to work out
-- Later: add pull request / issue to elm-syntax about typeclasses being classified as generic types in the syntax
-- Later, probably never: normalize within scope (so 'a' can normalize to different values if it is defined in different scopes). This would improve the normalization, but the mapping format defined by exercism doesn't support it, so there probably isn't much point, and it would be harder to do


normalize : String -> Result String ( Dict String String, String )
normalize original =
    let
        ( firstState, firstNormalization ) =
            normalizeWithoutCheck original

        ( _, secondNormalization ) =
            normalizeWithoutCheck firstNormalization
    in
    if firstNormalization == secondNormalization then
        Ok ( firstState, firstNormalization )

    else
        Err <|
            "Inconsistency detected, which means there is a bug, please create an Issue with this output"
                ++ "\n\nFirst normalisation\n"
                ++ firstNormalization
                ++ "\n\nSecond normalisation\n"
                ++ secondNormalization


normalizeWithoutCheck : String -> ( Dict String String, String )
normalizeWithoutCheck original =
    case Elm.Parser.parse original of
        Err error ->
            ( Dict.empty, "Failed: " ++ Parser.deadEndsToString error )

        Ok rawFile ->
            process init rawFile
                |> normalizeElmFile
                |> Tuple.mapFirst Normalization.getIdentifierMapping
                |> Tuple.mapSecond (writeFile >> write)
