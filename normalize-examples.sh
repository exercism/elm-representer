sh make.sh

cat example-originals/Anagram.elm        | node src/cli.js examples-normalized/AnagramIdentifierMapping.json > examples-normalized/Anagram.elm
cat example-originals/Bob.elm            | node src/cli.js examples-normalized/BobIdentifierMapping.json > examples-normalized/Bob.elm
cat example-originals/GradeSchool.elm    | node src/cli.js examples-normalized/GradeSchoolIdentifierMapping.json > examples-normalized/GradeSchool.elm
cat example-originals/Hamming.elm        | node src/cli.js examples-normalized/HammingIdentifierMapping.json > examples-normalized/Hamming.elm
cat example-originals/Leap.elm           | node src/cli.js examples-normalized/LeapIdentifierMapping.json > examples-normalized/Leap.elm
cat example-originals/Pangram.elm        | node src/cli.js examples-normalized/PangramIdentifierMapping.json > examples-normalized/Pangram.elm
cat example-originals/Raindrops.elm      | node src/cli.js examples-normalized/RaindropsIdentifierMapping.json > examples-normalized/Raindrops.elm
cat example-originals/SumOfMultiples.elm | node src/cli.js examples-normalized/SumOfMultiplesIdentifierMapping.json > examples-normalized/SumOfMultiples.elm
cat example-originals/Triangle.elm       | node src/cli.js examples-normalized/TriangleIdentifierMapping.json > examples-normalized/Triangle.elm
cat example-originals/TwelveDays.elm     | node src/cli.js examples-normalized/TwelveDaysIdentifierMapping.json > examples-normalized/TwelveDays.elm
