module NormalizeTypeAnnotation exposing (normalizeNodeTypeAnnotation, normalizeNodeTypeAnnotations, normalizeTypeAnnotation)

import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node exposing (Node)
import Elm.Syntax.TypeAnnotation as TypeAnnotation exposing (TypeAnnotation)
import Normalization
import NormalizeElmCodeHelpers exposing (..)


normalizeNodeTypeAnnotation : Normalization.State -> Node TypeAnnotation -> ( Normalization.State, Node TypeAnnotation )
normalizeNodeTypeAnnotation state original =
    normalizeNode normalizeTypeAnnotation state original


normalizeNodeTypeAnnotations : Normalization.State -> List (Node TypeAnnotation) -> ( Normalization.State, List (Node TypeAnnotation) )
normalizeNodeTypeAnnotations state original =
    normalizeNodes normalizeNodeTypeAnnotation state original


normalizeTypeAnnotation : Normalization.State -> TypeAnnotation -> ( Normalization.State, TypeAnnotation )
normalizeTypeAnnotation state typeAnnotation =
    case typeAnnotation of
        TypeAnnotation.Record original ->
            let
                ( state2, normalized ) =
                    normalizeNodeRecordFields state original
            in
            ( state2, TypeAnnotation.Record normalized )

        TypeAnnotation.Tupled original ->
            let
                ( state2, normalized ) =
                    normalizeNodeTypeAnnotations state original
            in
            ( state2, TypeAnnotation.Tupled normalized )

        TypeAnnotation.Typed originalName originalTypes ->
            let
                ( state2, normalizedName ) =
                    normalizeNodeTypeName state originalName

                ( state3, normalizedTypes ) =
                    normalizeNodeTypeAnnotations state2 originalTypes
            in
            ( state3, TypeAnnotation.Typed normalizedName normalizedTypes )

        TypeAnnotation.GenericRecord originalName originalRecordDefinition ->
            let
                ( state2, normalizedName ) =
                    normalizeNodeString state originalName

                ( state3, normalizedRecordDefinition ) =
                    normalizeNodeRecordDefinition state2 originalRecordDefinition
            in
            ( state3, TypeAnnotation.GenericRecord normalizedName normalizedRecordDefinition )

        TypeAnnotation.FunctionTypeAnnotation originalParameters originalReturn ->
            let
                ( state2, normalizedParameters ) =
                    normalizeNodeTypeAnnotation state originalParameters

                ( state3, normalizedReturn ) =
                    normalizeNodeTypeAnnotation state2 originalReturn
            in
            ( state3, TypeAnnotation.FunctionTypeAnnotation normalizedParameters normalizedReturn )

        TypeAnnotation.GenericType original ->
            let
                -- interestingly type classes come through as GenericTypes in elm-syntax, presumably because they start with a lower case letter
                ( state2, normalized ) =
                    normalizeTypeString state original
            in
            ( state2, TypeAnnotation.GenericType normalized )

        _ ->
            ( state, typeAnnotation )


normalizeNodeRecordDefinition : Normalization.State -> Node TypeAnnotation.RecordDefinition -> ( Normalization.State, Node TypeAnnotation.RecordDefinition )
normalizeNodeRecordDefinition state original =
    normalizeNode normalizeRecordDefinition state original


normalizeRecordDefinition : Normalization.State -> TypeAnnotation.RecordDefinition -> ( Normalization.State, TypeAnnotation.RecordDefinition )
normalizeRecordDefinition state original =
    normalizeNodeRecordFields state original


normalizeNodeRecordField : Normalization.State -> Node TypeAnnotation.RecordField -> ( Normalization.State, Node TypeAnnotation.RecordField )
normalizeNodeRecordField state original =
    normalizeNode normalizeRecordField state original


normalizeNodeRecordFields : Normalization.State -> List (Node TypeAnnotation.RecordField) -> ( Normalization.State, List (Node TypeAnnotation.RecordField) )
normalizeNodeRecordFields state original =
    normalizeNodes normalizeNodeRecordField state original


normalizeRecordField : Normalization.State -> TypeAnnotation.RecordField -> ( Normalization.State, TypeAnnotation.RecordField )
normalizeRecordField state original =
    let
        ( state2, normalizedName ) =
            normalizeNodeString
                state
                (Tuple.first original)

        ( state3, normalizedTypeAnnotation ) =
            normalizeNodeTypeAnnotation
                state2
                (Tuple.second original)

        recordField =
            ( normalizedName, normalizedTypeAnnotation )
    in
    ( state3, recordField )


normalizeNodeTypeName : Normalization.State -> Node ( ModuleName, String ) -> ( Normalization.State, Node ( ModuleName, String ) )
normalizeNodeTypeName state original =
    normalizeNode normalizeTypeName state original


normalizeTypeName : Normalization.State -> ( ModuleName, String ) -> ( Normalization.State, ( ModuleName, String ) )
normalizeTypeName state ( originalModuleName, originalTypeName ) =
    let
        ( state2, normalizedTypeName ) =
            normalizeTypeString
                state
                originalTypeName
    in
    if List.isEmpty originalModuleName then
        ( state2, ( originalModuleName, normalizedTypeName ) )

    else
        ( state, ( originalModuleName, originalTypeName ) )
