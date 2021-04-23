// Source: https://medium.com/@rancrump/creating-a-test-server-with-express-js-8698f7547074

// navigate to this folder on Terminal.
// Run "npm install express path" every time you need to update. Run "node index.js."
const { json } = require('express');
const express = require('express');
const app = express();
const path = require('path');
const port = 8080;

//Tell us when the server is up and running + where at
console.log("I am running at: " + port);

//Start the listener
app.listen(port);

var productsFile = require("./products.json"); // path of your json file

// GET /ingredients returns a JSON file of ingredients. [hardcoded]
app.get("/products", function(req, res, next) {
  res.json(productsFile);
});


//On Error
app.use(function (req, res, next) {
 res.status(404).sendFile(path.join(__dirname + 'filename.html'))
});




// EXAMPLES

  app.post('/messages', (req, res) => {
    const id = uuidv4();
    const message = {
      id,
      text: req.body.text,
    };

    messages[id] = message;

    return res.send(message);
  });
  // post string
//     return res.send('Received a GET HTTP method!!');


  app.get('/products/:product_name', (req, res) => {
    return res.send('GET HTTP method on user resource');
  });
  });