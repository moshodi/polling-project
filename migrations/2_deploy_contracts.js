var PollFactory = artifacts.require("PollFactory");

module.exports = function(deployer) {
    deployer.deploy(PollFactory);
};