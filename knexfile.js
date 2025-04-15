require('dotenv').config();

const common = {
  client: 'pg',
  migrations: { directory: './migrations' }
};

module.exports = {
  development: {
    ...common,
    connection: {
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      port: parseInt(process.env.DB_PORT || '5432', 10)
    }
  },
  production: {
    ...common,
    connection: process.env.DATABASE_URL,
    pool: { min: 2, max: 10 }
    // Uncomment below if needed for SSL in production:
    // ssl: { rejectUnauthorized: false }
  }
};
