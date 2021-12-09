const Marketplace = artifacts.require("Marketplace");


//This is migrating the blockchain from one state to another by putting a new smart contract on it
module.exports = function(deployer) {
  deployer.deploy(Marketplace);
};
