module NormalizeExpression exposing (..)

import Elm.Syntax.Exposing exposing (Exposing(..), TopLevelExpose(..))
import Elm.Syntax.Expression exposing (..)
import Elm.Syntax.Node exposing (Node)
import Elm.Syntax.Pattern exposing (Pattern(..))
import Elm.Syntax.Signature exposing (Signature)
import Normalization
import NormalizeElmCodeHelpers exposing (..)
import NormalizePattern exposing (..)
import NormalizeTypeAnnotation exposing (..)


normalizeFunction : Normalization.State -> Function -> ( Normalization.State, Function )
normalizeFunction state original =
    let
        ( state2, normalizedSignature ) =
            normalizeMaybe
                normalizeNodeSignature
                state
                original.signature

        ( state3, normalizedFunctionImplementation ) =
            normalizeNodeFunctionImplementation
                state2
                original.declaration

        normalizedFunction =
            Function
                Maybe.Nothing
                normalizedSignature
                normalizedFunctionImplementation
    in
    ( state3, normalizedFunction )


normalizeNodeSignature : Normalization.State -> Node Signature -> ( Normalization.State, Node Signature )
normalizeNodeSignature state original =
    normalizeNode normalizeSignature state original


normalizeSignature : Normalization.State -> Signature -> ( Normalization.State, Signature )
normalizeSignature state original =
    let
        ( state2, normalizedName ) =
            normalizeNodeString
                state
                original.name

        ( state3, normalizedTypeAnnotation ) =
            normalizeNodeTypeAnnotation
                state2
                original.typeAnnotation

        normalizedSignature =
            Signature
                normalizedName
                normalizedTypeAnnotation
    in
    ( state3, normalizedSignature )


normalizeNodeFunctionImplementation : Normalization.State -> Node FunctionImplementation -> ( Normalization.State, Node FunctionImplementation )
normalizeNodeFunctionImplementation state original =
    normalizeNode normalizeFunctionImplementation state original


normalizeFunctionImplementation : Normalization.State -> FunctionImplementation -> ( Normalization.State, FunctionImplementation )
normalizeFunctionImplementation state original =
    let
        ( state2, normalizedName ) =
            normalizeNodeString
                state
                original.name

        ( state3, normalizedArguments ) =
            normalizeNodePatterns
                state2
                original.arguments

        ( state4, normalizedExpression ) =
            normalizeNodeExpression
                state3
                original.expression

        normalizedFunctionImplementation =
            FunctionImplementation
                normalizedName
                normalizedArguments
                normalizedExpression
    in
    ( state4, normalizedFunctionImplementation )


normalizeNodeExpression : Normalization.State -> Node Expression -> ( Normalization.State, Node Expression )
normalizeNodeExpression state original =
    normalizeNode normalizeExpression state original


normalizeNodeExpressions : Normalization.State -> List (Node Expression) -> ( Normalization.State, List (Node Expression) )
normalizeNodeExpressions state original =
    normalizeNodes normalizeNodeExpression state original


normalizeExpression : Normalization.State -> Expression -> ( Normalization.State, Expression )
normalizeExpression state originalExpression =
    case originalExpression of
        UnitExpr ->
            ( state, UnitExpr )

        Application original ->
            let
                ( state2, normalized ) =
                    normalizeNodeExpressions state original
            in
            ( state2, Application normalized )

        OperatorApplication op dir left right ->
            let
                ( state2, normalizedLeft ) =
                    normalizeNodeExpression state left

                ( state3, normalizedRight ) =
                    normalizeNodeExpression state2 right

                normalized =
                    OperatorApplication
                        op
                        dir
                        normalizedLeft
                        normalizedRight
            in
            ( state3, normalized )

        FunctionOrValue originalModuleName originalName ->
            let
                ( state2, normalized ) =
                    normalizeString state originalName
            in
            if List.isEmpty originalModuleName then
                ( state2, FunctionOrValue originalModuleName normalized )

            else
                ( state, FunctionOrValue originalModuleName originalName )

        IfBlock c t e ->
            let
                ( state2, normalizedCondition ) =
                    normalizeNodeExpression state c

                ( state3, normalizedThen ) =
                    normalizeNodeExpression state2 t

                ( state4, normalizedElse ) =
                    normalizeNodeExpression state3 e

                normalized =
                    IfBlock
                        normalizedCondition
                        normalizedThen
                        normalizedElse
            in
            ( state4, normalized )

        PrefixOperator original ->
            ( state, PrefixOperator original )

        Operator original ->
            ( state, Operator original )

        Hex original ->
            ( state, Hex original )

        Integer original ->
            ( state, Integer original )

        Floatable original ->
            ( state, Floatable original )

        Negation original ->
            ( state, Negation original )

        Literal original ->
            ( state, Literal original )

        CharLiteral original ->
            ( state, CharLiteral original )

        TupledExpression original ->
            let
                ( state2, normalized ) =
                    normalizeNodeExpressions state original
            in
            ( state2, TupledExpression normalized )

        ListExpr original ->
            let
                ( state2, normalized ) =
                    normalizeNodeExpressions state original
            in
            ( state2, ListExpr normalized )

        ParenthesizedExpression original ->
            let
                ( state2, normalized ) =
                    normalizeNodeExpression state original
            in
            ( state2, ParenthesizedExpression normalized )

        LetExpression original ->
            let
                ( state2, normalizedDeclarations ) =
                    normalizeNodeLetDeclarations state original.declarations

                ( state3, normalizedExpression ) =
                    normalizeNodeExpression state2 original.expression

                normalized =
                    LetExpression <|
                        LetBlock
                            normalizedDeclarations
                            normalizedExpression
            in
            ( state3, normalized )

        CaseExpression original ->
            let
                ( state2, normalized ) =
                    normalizeCaseBlock state original
            in
            ( state2, CaseExpression normalized )

        LambdaExpression original ->
            let
                ( state2, normalizedArguments ) =
                    normalizeNodePatterns state original.args

                ( state3, normalizedExpression ) =
                    normalizeNodeExpression state2 original.expression

                normalized =
                    LambdaExpression <|
                        Lambda
                            normalizedArguments
                            normalizedExpression
            in
            ( state3, normalized )

        RecordAccess exp name ->
            let
                ( state2, normalizedExpression ) =
                    normalizeNodeExpression state exp

                ( state3, normalizedName ) =
                    normalizeNodeString state2 name

                normalized =
                    RecordAccess
                        normalizedExpression
                        normalizedName
            in
            ( state3, normalized )

        RecordAccessFunction original ->
            let
                ( state2, normalized ) =
                    normalizeString state original
            in
            ( state2, RecordAccessFunction normalized )

        RecordExpr original ->
            let
                ( state2, normalized ) =
                    normalizeNodeRecordSetters state original
            in
            ( state2, RecordExpr normalized )

        RecordUpdateExpression name updates ->
            let
                ( state2, normalizedName ) =
                    normalizeNodeString state name

                ( state3, normalizedUpdates ) =
                    normalizeNodeRecordSetters state2 updates

                normalized =
                    RecordUpdateExpression
                        normalizedName
                        normalizedUpdates
            in
            ( state3, normalized )

        GLSLExpression original ->
            ( state, GLSLExpression original )


normalizeCaseBlock : Normalization.State -> CaseBlock -> ( Normalization.State, CaseBlock )
normalizeCaseBlock state original =
    let
        ( state2, normalizedExpression ) =
            normalizeNodeExpression state original.expression

        ( state3, normalizedCases ) =
            normalizeCases state2 original.cases

        normalized =
            CaseBlock normalizedExpression normalizedCases
    in
    ( state3, normalized )


normalizeNodeRecordSetter : Normalization.State -> Node RecordSetter -> ( Normalization.State, Node RecordSetter )
normalizeNodeRecordSetter state original =
    normalizeNode normalizeRecordSetter state original


normalizeNodeRecordSetters : Normalization.State -> List (Node RecordSetter) -> ( Normalization.State, List (Node RecordSetter) )
normalizeNodeRecordSetters state original =
    normalizeNodes normalizeNodeRecordSetter state original


normalizeRecordSetter : Normalization.State -> RecordSetter -> ( Normalization.State, RecordSetter )
normalizeRecordSetter state ( originalName, originalExpression ) =
    let
        ( state2, normalizedName ) =
            normalizeNodeString state originalName

        ( state3, normalizedExpression ) =
            normalizeNodeExpression state2 originalExpression

        normalized =
            ( normalizedName, normalizedExpression )
    in
    ( state3, normalized )


normalizeCases : Normalization.State -> List Case -> ( Normalization.State, List Case )
normalizeCases state original =
    normalizeList normalizeCase state original


normalizeCase : Normalization.State -> Case -> ( Normalization.State, Case )
normalizeCase state ( originalPattern, originalExpression ) =
    let
        ( state2, normalizedPattern ) =
            normalizeNodePattern state originalPattern

        ( state3, normalizedExpression ) =
            normalizeNodeExpression state2 originalExpression

        normalized =
            ( normalizedPattern, normalizedExpression )
    in
    ( state3, normalized )


normalizeNodeLetDeclaration : Normalization.State -> Node LetDeclaration -> ( Normalization.State, Node LetDeclaration )
normalizeNodeLetDeclaration state original =
    normalizeNode normalizeLetDeclaration state original


normalizeNodeLetDeclarations : Normalization.State -> List (Node LetDeclaration) -> ( Normalization.State, List (Node LetDeclaration) )
normalizeNodeLetDeclarations state original =
    normalizeNodes normalizeNodeLetDeclaration state original


normalizeLetDeclaration : Normalization.State -> LetDeclaration -> ( Normalization.State, LetDeclaration )
normalizeLetDeclaration state originalLetDeclaration =
    case originalLetDeclaration of
        LetFunction original ->
            let
                ( state2, normalized ) =
                    normalizeFunction state original
            in
            ( state2, LetFunction normalized )

        LetDestructuring originalPattern originalExpression ->
            let
                ( state2, normalizedPattern ) =
                    normalizeNodePattern state originalPattern

                ( state3, normalizedExpression ) =
                    normalizeNodeExpression state2 originalExpression
            in
            ( state3, LetDestructuring normalizedPattern normalizedExpression )
