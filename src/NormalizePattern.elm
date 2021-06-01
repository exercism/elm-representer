module NormalizePattern exposing (..)

import Elm.Syntax.Exposing exposing (Exposing(..), TopLevelExpose(..))
import Elm.Syntax.Expression exposing (..)
import Elm.Syntax.Node exposing (Node)
import Elm.Syntax.Pattern exposing (Pattern(..))
import Normalization
import NormalizeElmCodeHelpers exposing (..)


normalizeNodePattern : Normalization.State -> Node Pattern -> ( Normalization.State, Node Pattern )
normalizeNodePattern state original =
    normalizeNode normalizePattern state original


normalizeNodePatterns : Normalization.State -> List (Node Pattern) -> ( Normalization.State, List (Node Pattern) )
normalizeNodePatterns state original =
    normalizeNodes normalizeNodePattern state original


normalizePattern : Normalization.State -> Pattern -> ( Normalization.State, Pattern )
normalizePattern state originalPattern =
    case originalPattern of
        AllPattern ->
            ( state, AllPattern )

        UnitPattern ->
            ( state, UnitPattern )

        CharPattern original ->
            ( state, CharPattern original )

        StringPattern original ->
            ( state, StringPattern original )

        HexPattern original ->
            ( state, HexPattern original )

        IntPattern original ->
            ( state, IntPattern original )

        FloatPattern original ->
            ( state, FloatPattern original )

        TuplePattern original ->
            let
                ( state2, normalized ) =
                    normalizeNodePatterns state original
            in
            ( state2, TuplePattern normalized )

        RecordPattern original ->
            let
                ( state2, normalized ) =
                    normalizeNodeStrings state original
            in
            ( state2, RecordPattern normalized )

        UnConsPattern original1 original2 ->
            let
                ( state2, normalized1 ) =
                    normalizeNodePattern state original1

                ( state3, normalized2 ) =
                    normalizeNodePattern state2 original2
            in
            ( state3, UnConsPattern normalized1 normalized2 )

        ListPattern original ->
            let
                ( state2, normalized ) =
                    normalizeNodePatterns state original
            in
            ( state2, ListPattern normalized )

        VarPattern original ->
            let
                ( state2, normalized ) =
                    normalizeString state original
            in
            ( state2, VarPattern normalized )

        NamedPattern qualifiedNameRef patterns ->
            let
                ( state2, normalizedPatterns ) =
                    normalizeNodePatterns state patterns
            in
            ( state2, NamedPattern qualifiedNameRef normalizedPatterns )

        AsPattern pattern name ->
            let
                ( state2, normalizedPattern ) =
                    normalizeNodePattern state pattern

                ( state3, normalizedName ) =
                    normalizeNodeString state2 name
            in
            ( state3, AsPattern normalizedPattern normalizedName )

        ParenthesizedPattern original ->
            let
                ( state2, normalized ) =
                    normalizeNodePattern state original
            in
            ( state2, ParenthesizedPattern normalized )
