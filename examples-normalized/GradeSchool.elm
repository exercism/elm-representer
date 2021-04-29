module GradeSchool exposing (addStudent, allStudents, empty, studentsInGrade)
import Dict  exposing (Dict)
type alias Identifier_1  =
    Int
type alias Identifier_2  =
    String
type alias Identifier_3  =
    Dict Identifier_1 (List Identifier_2)

empty : Identifier_3
empty  =
    Dict.empty

addStudent : Identifier_1 -> (Identifier_2 -> (Identifier_3 -> Identifier_3))
addStudent identifier_4 identifier_5 identifier_6 =
    let
      
      
      identifier_7  =
          identifier_5 :: studentsInGrade identifier_4 identifier_6 |> List.sort
    in
      Dict.insert identifier_4 identifier_7 identifier_6

studentsInGrade : Identifier_1 -> (Identifier_3 -> List Identifier_2)
studentsInGrade identifier_4 identifier_6 =
    Dict.get identifier_4 identifier_6 |> Maybe.withDefault []

allStudents : Identifier_3 -> List ((Identifier_1, List Identifier_2))
allStudents identifier_6 =
    Dict.toList identifier_6
