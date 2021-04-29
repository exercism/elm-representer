module NormalizeType exposing (normalizeType)

import Elm.Syntax.Node exposing (Node)
import Elm.Syntax.Type exposing (Type, ValueConstructor)
import Normalization
import NormalizeElmCodeHelpers exposing (..)
import NormalizeTypeAnnotation exposing (..)


normalizeType : Normalization.State -> Type -> ( Normalization.State, Type )
normalizeType state original =
    let
        ( state2, normalizedName ) =
            normalizeNodeString
                state
                original.name

        ( state3, normalizedGenerics ) =
            normalizeNodeStrings
                state2
                original.generics

        ( state4, normalizedValueConstructors ) =
            normalizeNodeValueConstructors
                state3
                original.constructors

        normalizedType =
            Type
                Maybe.Nothing
                normalizedName
                normalizedGenerics
                normalizedValueConstructors
    in
    ( state4, normalizedType )


normalizeNodeValueConstructor : Normalization.State -> Node ValueConstructor -> ( Normalization.State, Node ValueConstructor )
normalizeNodeValueConstructor state original =
    normalizeNode normalizeValueConstructor state original


normalizeNodeValueConstructors : Normalization.State -> List (Node ValueConstructor) -> ( Normalization.State, List (Node ValueConstructor) )
normalizeNodeValueConstructors state original =
    normalizeNodes normalizeNodeValueConstructor state original


normalizeValueConstructor : Normalization.State -> ValueConstructor -> ( Normalization.State, ValueConstructor )
normalizeValueConstructor state original =
    let
        ( state2, normalizedName ) =
            normalizeNodeString state original.name

        ( state3, normalizedArguments ) =
            normalizeNodeTypeAnnotations state2 original.arguments

        normalizedValueConstructor =
            ValueConstructor
                normalizedName
                normalizedArguments
    in
    ( state3, normalizedValueConstructor )
