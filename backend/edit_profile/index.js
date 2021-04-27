/**
 *  Return reviews
 */

const secrets = require('./index.json');
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

exports.usersAdvQuery = async (req, res) => {
  pool = await createPool();
  const output = await pool.query('SELECT * FROM Users WHERE email = "' + req.body.oldEmail + '"');
  if (output.length <= 0) {
    return res.status(400).send("User not found");
  }

  const out3 = await pool.query('SELECT * FROM Users WHERE username = "' + req.body.username +
                                                          '" OR email = "' + req.body.email+'"');
  if (out3.length > 0) {
    return res.status(401).send("Username or Email already exists");
  }

  const out2 = await pool.query("UPDATE Users SET username = '" + req.body.username +
                  "', email = '" + req.body.email + "' WHERE username = '" + output[0]["username"]+"'");

  res.status(200).send(JSON.parse(JSON.stringify(out2)));
}
