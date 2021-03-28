const express = require('express')
const app = express()
const port = 3000

// mysql.server stop
const secrets = require('./secrets.json');
const mysql = require('promise-mysql');

const createTcpPool = async config => {
  // Extract host and port from socket address
  // const dbSocketAddr = process.env.DB_HOST.split(':');

  // Establish a connection to the database
  return await mysql.createPool({
    user: secrets.user, // e.g. 'my-db-user'
    password: secrets.passwd, // e.g. 'my-db-password'
    database: secrets.database, // e.g. 'my-database'
    host: secrets.host, // e.g. '127.0.0.1'
    port: '3306', // e.g. '3306'
    // ... Specify additional properties here.
    ...config,
  });
};

const createPool = async () => {
  const config = {
    // [START cloud_sql_mysql_mysql_limit]
    // 'connectionLimit' is the maximum number of connections the pool is allowed
    // to keep at once.
    connectionLimit: 5,
    // [END cloud_sql_mysql_mysql_limit]

    // [START cloud_sql_mysql_mysql_timeout]
    // 'connectTimeout' is the maximum number of milliseconds before a timeout
    // occurs during the initial connection to the database.
    connectTimeout: 10000, // 10 seconds
    // 'acquireTimeout' is the maximum number of milliseconds to wait when
    // checking out a connection from the pool before a timeout error occurs.
    acquireTimeout: 10000, // 10 seconds
    // 'waitForConnections' determines the pool's action when no connections are
    // free. If true, the request will queued and a connection will be presented
    // when ready. If false, the pool will call back with an error.
    waitForConnections: true, // Default: true
    // 'queueLimit' is the maximum number of requests for connections the pool
    // will queue at once before returning an error. If 0, there is no limit.
    queueLimit: 0, // Default: 0
    // [END cloud_sql_mysql_mysql_timeout]
  };
  return await createTcpPool(config);
};

let pool;

app.get('/', async (req, res) => {
  pool = await createPool();
  const talentiQuery = pool.query('SELECT * FROM Users LIMIT 10');
<<<<<<< HEAD
//  const talentiQuery = pool.query('SELECT u.email, drv.max_len FROM Users u JOIN (SELECT r.author as author, MAX(LENGTH(r.review_text)) as max_len FROM Reviews r GROUP BY r.author) as drv ON drv.author = u.username ORDER BY drv.max_len DESC LIMIT 15')
  const output = await talentiQuery;
  res.send(JSON.parse(JSON.stringify(output)));
})

app.get('/advanced-query', async (req, res) => {
  pool = await createPool();
//  const talentiQuery = pool.query('SELECT * FROM Users LIMIT 10');
  const talentiQuery = pool.query('SELECT u.email, drv.max_len FROM Users u JOIN (SELECT r.author as author, MAX(LENGTH(r.review_text)) as max_len FROM Reviews r GROUP BY r.author) as drv ON drv.author = u.username ORDER BY drv.max_len DESC LIMIT 15')
  const output = await talentiQuery;
  res.send(JSON.parse(JSON.stringify(output)));
})

app.get('/user-search', async (req, res) => {
  pool = await createPool();
  const talentiQuery = pool.query("SELECT * FROM Users WHERE username LIKE '%" + req.query.search_term + "%' OR email LIKE '%" + req.query.search_term + "%' ");
=======
>>>>>>> 501eb35d0d1a908ee2fa688110a32f7ad75fd14f
  const output = await talentiQuery;
  res.send(JSON.parse(JSON.stringify(output)));
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})