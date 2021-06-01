-- This is a demonstration solution that I use when mentoring, any 
-- improvements / comments / suggestions welcome.

-- Mostly based on the solution by blackbart420, who deserves the credit

module GradeSchool exposing (addStudent, allStudents, empty, studentsInGrade)

import Dict exposing (Dict)


type alias Grade =
    Int


type alias Student =
    String


type alias School =
    Dict Grade (List Student)


empty : School
empty =
    Dict.empty


addStudent : Grade -> Student -> School -> School
addStudent grade student school =
    let
        students =
            student
                :: studentsInGrade grade school
                |> List.sort
    in
    Dict.insert grade students school


studentsInGrade : Grade -> School -> List Student
studentsInGrade grade school =
    Dict.get grade school
    |> Maybe.withDefault []


allStudents : School -> List ( Grade, List Student )
allStudents school =
    -- this relies on the fact that Dict.toList returns a list sorted by the keys
    Dict.toList school