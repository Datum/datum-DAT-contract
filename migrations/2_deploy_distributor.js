var DatumTokenDistributor = artifacts.require("./DatumTokenDistributor_combined.sol");

module.exports = function(deployer) {
  deployer.deploy(DatumTokenDistributor);
};