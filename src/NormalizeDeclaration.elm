module NormalizeDeclaration exposing (..)

import Elm.Syntax.Declaration as Declaration exposing (Declaration)
import Elm.Syntax.Node exposing (Node)
import Normalization
import NormalizeElmCodeHelpers exposing (..)
import NormalizeExpression exposing (..)
import NormalizePattern exposing (..)
import NormalizeType exposing (..)
import NormalizeTypeAlias exposing (..)
import NormalizeTypeAnnotation exposing (..)


normalizeNodeDeclaration : Normalization.State -> Node Declaration -> ( Normalization.State, Node Declaration )
normalizeNodeDeclaration state original =
    normalizeNode normalizeDeclaration state original


normalizeDeclaration : Normalization.State -> Declaration -> ( Normalization.State, Declaration )
normalizeDeclaration state declaration =
    case declaration of
        Declaration.AliasDeclaration original ->
            let
                ( state2, normalized ) =
                    normalizeTypeAlias state original
            in
            ( state2, Declaration.AliasDeclaration normalized )

        Declaration.CustomTypeDeclaration original ->
            let
                ( state2, normalized ) =
                    normalizeType state original
            in
            ( state2, Declaration.CustomTypeDeclaration normalized )

        Declaration.FunctionDeclaration original ->
            let
                ( state2, normalized ) =
                    normalizeFunction state original
            in
            ( state2, Declaration.FunctionDeclaration normalized )

        Declaration.Destructuring originalPattern originalExpression ->
            let
                ( state2, normalizedPattern ) =
                    normalizeNodePattern state originalPattern

                ( state3, normalizedExpression ) =
                    normalizeNodeExpression state2 originalExpression

                normalized =
                    Declaration.Destructuring
                        normalizedPattern
                        normalizedExpression
            in
            ( state3, normalized )

        -- I don't think we need to worry about port declarations and infixes (which are for core packages only)
        -- but we can revisit later if needs be
        _ ->
            ( state, declaration )
