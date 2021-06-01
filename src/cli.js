
// Link to compiled Elm code main.js
var Elm = require('./main').Elm;
var main = Elm.Main.init();

//
var args = process.argv.slice(2);
var mappingJsonFilename = args[0]

// Get data from stdin
var fs = require("fs");
var input = fs.readFileSync(process.stdin.fd, "utf-8");
//console.log("\n   Input: ", input)

// Send data to the elm app
main.ports.get.send(input);

// Get data from the elm app
main.ports.put.subscribe(function (data) {
  // send normalized code to stdout
  console.log(data[0])
  // save json mapping object to the file specified in the parameter
  fs.writeFile(mappingJsonFilename, data[1], function (err, data) {
    if (err) {
      throw err
    }
  })
});

