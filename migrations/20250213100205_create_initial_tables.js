/**
 * @param {import('knex')} knex
 */
exports.up = function(knex) {
  return knex.schema.createTable('users', function(table) {
    table.increments('id').primary();
    table.string('name').notNullable();
    table.string('email').unique().notNullable();
    table.timestamps(true, true);
  });
};

/**
 * @param {import('knex')} knex
 */
exports.down = function(knex) {
  return knex.schema.dropTable('users');
};

