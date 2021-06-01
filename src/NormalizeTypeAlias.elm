module NormalizeTypeAlias exposing (normalizeTypeAlias)

import Elm.Syntax.TypeAlias exposing (TypeAlias)
import Normalization
import NormalizeElmCodeHelpers exposing (..)
import NormalizeTypeAnnotation exposing (..)


normalizeTypeAlias : Normalization.State -> TypeAlias -> ( Normalization.State, TypeAlias )
normalizeTypeAlias state original =
    let
        ( state2, normalizedName ) =
            normalizeNodeString
                state
                original.name

        ( state3, normalizedGenerics ) =
            normalizeNodeStrings
                state2
                original.generics

        ( state4, normalizedTypeAnnotation ) =
            normalizeNodeTypeAnnotation
                state3
                original.typeAnnotation

        typeAlias =
            TypeAlias
                Maybe.Nothing
                normalizedName
                normalizedGenerics
                normalizedTypeAnnotation
    in
    ( state4, typeAlias )
