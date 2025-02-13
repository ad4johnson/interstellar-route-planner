require('dotenv').config();

module.exports = {
  development: {
    client: 'pg',
    connection: {
      host: process.env.DB_HOST || '127.0.0.1',  // Use the DB_HOST from .env
      user: process.env.DB_USER || 'admin',
      password: process.env.DB_PASSWORD || 'securepassword',
      database: process.env.DB_NAME || 'interstellar_db',
      port: process.env.DB_PORT || 5432
    },
    migrations: {
      directory: './migrations'
    }
  }
};