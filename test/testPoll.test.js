const PollFactory = artifacts.require("PollFactory");
const utils = require("./helpers/utils");

contract("PollFactory", accounts => {
    let pollInstance;
    let pollName = "Red or Blue";
    let firstOption = "Red";
    let secondOption = "Blue";
    let optionOneVote = true;
    let optionTwoVote = false;
    let expectedVoter;

    before(async() => {
        pollInstance = await PollFactory.new();
    });
    it("allows you to create a poll", async() => {
        const result = await pollInstance.createPoll(pollName, firstOption, secondOption, { from: accounts[0] });
        assert.equal(result.receipt.status, true);
        assert.equal(result.logs[0].args.id, 0);
        assert.equal(result.logs[0].args.title, pollName);
    });
    it("allows users to vote on the created poll", async() => {
        const result = await pollInstance.createPoll(pollName, firstOption, secondOption, { from: accounts[0] });
        const voteResult = await pollInstance.vote(0, optionOneVote, optionTwoVote, { from: accounts[1] });
        expectedVoter = accounts[1];
        assert.equal(voteResult.receipt.status, true);
        assert.equal(voteResult.logs[0].args.voter, expectedVoter)
        assert.equal(voteResult.logs[0].args.id, 0);
        assert.equal(voteResult.logs[0].args.title, pollName);
        assert.equal(voteResult.logs[0].args.firstChoiceCount, 1);
        assert.equal(voteResult.logs[0].args.secondChoiceCount, 0);
        assert.equal(expectedVoter, accounts[1], "The voter address should match the second account");
    });

    it("should prevent users from voting more than once on the same poll", async() => {
        const result = await pollInstance.createPoll(pollName, firstOption, secondOption, { from: accounts[0] });
        await pollInstance.vote(0, optionOneVote, optionTwoVote, { from: accounts[1] });
        await utils.shouldThrow(pollInstance.vote(0, optionOneVote, optionTwoVote, { from: accounts[1] }));
    })
});