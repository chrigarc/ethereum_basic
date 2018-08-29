// Allows us to use ES6 in our migrations and tests.
require('babel-register');

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' ,// Match any network id,
	  gas: 4700000,
	  from: '0xc05e785647915808ce438bcdc2b0ab8c73fb4efd'
    }
  }
};
