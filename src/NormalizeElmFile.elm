module NormalizeElmFile exposing (normalizeElmFile)

import Elm.Syntax.Declaration exposing (Declaration)
import Elm.Syntax.Exposing exposing (Exposing(..), TopLevelExpose(..))
import Elm.Syntax.File exposing (File)
import Elm.Syntax.Import exposing (Import)
import Elm.Syntax.Module as Module
import Elm.Syntax.Node as Node exposing (Node)
import Normalization
import NormalizeDeclaration exposing (..)
import NormalizeElmCodeHelpers exposing (..)


normalizeElmFile : File -> ( Normalization.State, File )
normalizeElmFile original =
    let
        exportedNames =
            Module.exposingList (Node.value original.moduleDefinition)
                |> exposingNames

        importedNames =
            original.imports
                |> List.map Node.value
                |> List.concatMap importNames

        state =
            Normalization.initialize (exportedNames ++ importedNames)

        ( state2, normalizedDeclarations ) =
            normalizeNodes normalizeNodeDeclaration state original.declarations

        normalized =
            File
                original.moduleDefinition
                original.imports
                normalizedDeclarations
                []
    in
    ( state2, normalized )


importNames : Import -> List String
importNames theImport =
    let
        explicits =
            Maybe.map Node.value theImport.exposingList
                |> Maybe.map exposingNames
                |> Maybe.withDefault []

        aliasName =
            Maybe.map Node.value theImport.moduleAlias
                |> Maybe.map (String.join ".")
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
    in
    explicits ++ aliasName


exposingNames : Exposing -> List String
exposingNames theExposing =
    case theExposing of
        All _ ->
            []

        Explicit nodeExposings ->
            List.map Node.value nodeExposings
                |> List.map topLevelExposeName


topLevelExposeName : TopLevelExpose -> String
topLevelExposeName topLevelExpose =
    case topLevelExpose of
        InfixExpose name ->
            name

        FunctionExpose name ->
            name

        TypeOrAliasExpose name ->
            name

        TypeExpose { name } ->
            name


normalizeNodeDeclaration : Normalization.State -> Node Declaration -> ( Normalization.State, Node Declaration )
normalizeNodeDeclaration state original =
    normalizeNode normalizeDeclaration state original
