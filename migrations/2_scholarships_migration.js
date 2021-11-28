const Scholarships = artifacts.require("Scholarships");

module.exports = function (deployer) {
  deployer.deploy(Scholarships);
};
