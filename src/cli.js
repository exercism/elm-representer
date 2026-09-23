
import fs from 'node:fs';
import elmPackage from './main.js';

// Link to compiled Elm code main.js
const { Elm } = elmPackage;
const main = Elm.Main.init();

//
const args = process.argv.slice(2);
const mappingJsonFilename = args[0];

// Get data from stdin
const input = fs.readFileSync(process.stdin.fd, 'utf-8');
//console.log("\n   Input: ", input)

// Send data to the elm app
main.ports.get.send(input);

// Get data from the elm app
main.ports.put.subscribe(function (data) {
  // send normalized code to stdout
  console.log(data[0]);
  // save json mapping object to the file specified in the parameter
  fs.writeFile(mappingJsonFilename, data[1], function (err) {
    if (err) {
      throw err;
    }
  });
});

