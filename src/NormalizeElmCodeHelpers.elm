module NormalizeElmCodeHelpers exposing (..)

import Elm.Syntax.Node as Node exposing (Node)
import Normalization


normalizeTypeString :
    Normalization.State
    -> String
    -> ( Normalization.State, String )
normalizeTypeString =
    Normalization.normalizeType


normalizeNodeString :
    Normalization.State
    -> Node String
    -> ( Normalization.State, Node String )
normalizeNodeString state original =
    normalizeNode normalizeString state original


normalizeString :
    Normalization.State
    -> String
    -> ( Normalization.State, String )
normalizeString =
    Normalization.normalize


normalizeNodeStrings :
    Normalization.State
    -> List (Node String)
    -> ( Normalization.State, List (Node String) )
normalizeNodeStrings state original =
    normalizeNodes normalizeNodeString state original


normalizeMaybe :
    (Normalization.State -> a -> ( Normalization.State, a ))
    -> Normalization.State
    -> Maybe a
    -> ( Normalization.State, Maybe a )
normalizeMaybe normalizer state maybeOriginal =
    Maybe.map
        (normalizer state)
        maybeOriginal
        |> Maybe.map (\( state2, signature ) -> ( state2, Just signature ))
        |> Maybe.withDefault ( state, Nothing )


normalizeNode :
    (Normalization.State -> a -> ( Normalization.State, a ))
    -> Normalization.State
    -> Node a
    -> ( Normalization.State, Node a )
normalizeNode normalizer state original =
    let
        normalized =
            Node.map
                (normalizer state)
                original
    in
    ( Node.value normalized |> Tuple.first
    , Node.map Tuple.second normalized
    )


normalizeNodes :
    (Normalization.State -> Node a -> ( Normalization.State, Node a ))
    -> Normalization.State
    -> List (Node a)
    -> ( Normalization.State, List (Node a) )
normalizeNodes normalizer state original =
    List.foldl
        (normalizeAccumulateNode normalizer)
        ( state, [] )
        original


normalizeAccumulateNode :
    (Normalization.State -> Node a -> ( Normalization.State, Node a ))
    -> Node a
    -> ( Normalization.State, List (Node a) )
    -> ( Normalization.State, List (Node a) )
normalizeAccumulateNode normalizer original ( state, normalizedNodes ) =
    let
        ( nextState, normalized ) =
            normalizer state original
    in
    ( nextState, normalizedNodes ++ [ normalized ] )


normalizeList :
    (Normalization.State -> a -> ( Normalization.State, a ))
    -> Normalization.State
    -> List a
    -> ( Normalization.State, List a )
normalizeList normalizer state original =
    List.foldl
        (normalizeAccumulateListItem normalizer)
        ( state, [] )
        original


normalizeAccumulateListItem :
    (Normalization.State -> a -> ( Normalization.State, a ))
    -> a
    -> ( Normalization.State, List a )
    -> ( Normalization.State, List a )
normalizeAccumulateListItem normalizer original ( state, normalizedList ) =
    let
        ( nextState, normalized ) =
            normalizer state original
    in
    ( nextState, normalizedList ++ [ normalized ] )
