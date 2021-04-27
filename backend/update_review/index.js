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

exports.updateReview = async (req, res) => {
  pool = await createPool();
  const output = await pool.query("UPDATE Reviews SET review_id = " + req.body.review_id + ", product_id = " + req.body.product_id + ", brand = '" + req.body.brand + "', author = '" + req.body.author + "', date_updated = " + req.body.date_updated + ", stars = " + req.body.stars + ", title = '" + req.body.title + "', helpful_yes = " + req.body.helpful_yes + ", helpful_no = " + req.body.helpful_no + ", review_text = '" + req.body.review_text + "'")
  res.send(JSON.parse(JSON.stringify(output)));
}
