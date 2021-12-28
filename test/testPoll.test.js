const PollFactory = artifacts.require("PollFactory");
const utils = require("./helpers/utils");

contract("PollFactory", accounts => {
    let pollInstance;
    let pollName = "Red or Blue";
    let firstOption = "Red";
    let secondOption = "Blue";
    let optionOneVote = true;
    let optionTwoVote = false;
    let pollCreator;
    let expectedVoter;
    before(async() => {
        pollInstance = await PollFactory.Deployed();
    });
    it("allows you to create a poll", async() => {
        const result = await pollInstance.createPoll(pollName, firstOption, secondOption, { from: accounts[0] });
        pollCreator = accounts[0];
        assert.equal(result.receipt.status, true)
        assert.equal(result.logs[0].args.title, pollName);
        assert.equal(result.logs[0].args.optionOne, firstOption);
        assert.equal(result.logs[0].args.optionTwo, secondOption);
        assert.equal(result.logs[0].args.option1Count, 0);
        assert.equal(result.logs[0].args.option2Count, 0);
        assert.equal(pollCreator, accounts[0]);
    });
    it("allows users to vote on the created poll", async() => {
        const result = await pollInstance.createPoll(pollName, firstOption, secondOption, { from: accounts[0] });
        const voteResult = await pollInstance.vote(0, optionOneVote, optionTwoVote, { from: accounts[1] });
        expectedVoter = accounts[1];
        assert.equal(voteResult.receipt.status, true);
        assert.equal(result.logs[0].args.option1Count, 1);
        assert.equal(result.logs[0].args.option2Count, 0);
        assert.equal(expectedVoter, accounts[1], "The voter address should match the second account");
    });
    it("should prevent users from voting more than once on the same poll", async() => {
        const result = await pollInstance.createPoll(pollName, firstOption, secondOption, { from: accounts[0] });
        await pollInstance.vote(0, optionOneVote, optionTwoVote, { from: accounts[1] });
        await utils.shouldThrow(pollInstance.vote(0, optionOneVote, optionTwoVote, { from: accounts[1] }));
        await utils.shouldThrow(pollInstance.vote(0, false, true, { from: accounts[1] }));
    })
});