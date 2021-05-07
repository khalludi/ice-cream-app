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

exports.filterProduct = async (req, res) => {
  pool = await createPool();

  brand_cols = "";
  if (req.query.filter_brand) {
    first = true;
    arr = req.query.filter_brand.split(",");
    for (let val of arr) {
      if (first) {
        brand_cols = brand_cols.concat("'").concat(val).concat("'");
        first = false;
      } else {
        brand_cols = brand_cols.concat(",'").concat(val).concat("'");
      }
    }
  }

  let out;
  if (req.query.filter_rating && req.query.filter_brand) {
    out = await pool.query("SELECT * FROM Products WHERE avg_rating >= " + 
      req.query.filter_rating + " AND brand_name IN (" + brand_cols + 
      ") ORDER BY brand_name, avg_rating");
  } else if (req.query.filter_rating) {
    out = await pool.query("SELECT * FROM Products WHERE avg_rating >= " + 
      req.query.filter_rating + " ORDER BY avg_rating");
  } else if (req.query.filter_brand) {
    out = await pool.query("SELECT * FROM Products WHERE brand_name IN (" + 
      brand_cols + ") ORDER BY brand_name");
  } else {
    out = await pool.query("SELECT * FROM Products ORDER BY brand_name, avg_rating");
  }
  res.status(200).send(JSON.parse(JSON.stringify(out)));
}
