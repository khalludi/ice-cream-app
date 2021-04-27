const express = require('express')
const app = express()
const port = 3000

const mysqlx = require('@mysql/xdevapi');

const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get('/', async (req, res) => {
    mysqlx.getSession('root:testuser@34.70.246.39:3306')
        .then(session => {
            return session.sql(`SELECT * FROM Users LIMIT 10`)
                .execute()
        }).then(result => {
            res.send(JSON.stringify(result));
        });

    // const talentiQuery = pool.query('SELECT username FROM Users');
    // const output = await talentiQuery;
    // if (output.length <= 0) {
    //   return res.status(400).send("User not found");
    // }
  
    res.status(200).send("All Good!");
})

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
  })