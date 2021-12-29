// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PollFactory {
  event NewPoll(uint id, string title);
  event VoteAdded(address voter, uint id, string title, uint firstChoiceCount, uint secondChoiceCount);
  // Keeps record of poll creators
  mapping (uint => address) pollToOwner;
  // Keeps record on how many times a user voted on a specific poll
  mapping (address => mapping(uint => uint)) voterVotesOnPoll;
  //maps pollId to the poll and its attributes

  //information that each poll consists of
  struct Poll {
    string title;
    string option1;
    string option2;
    uint option1Count;
    uint option2Count;
    uint32 pollDuration;
  }

  //polls database
  Poll[] public polls;

  //create poll function
  function createPoll(
    string memory _title,
    string memory _firstOption,
    string memory _secondOption) public returns (uint) {
    // time restriction variable for the created poll to be voted on
    uint durationTime = 1 weeks;
    // adds poll to our poll database
    polls.push(Poll(_title, _firstOption, _secondOption, 0, 0, uint32(block.timestamp + durationTime)));
    //identifier for each poll (plus an index for our polls database)
    uint id = polls.length - 1;
    // assigns the poll's id to the function caller's address
    pollToOwner[id] = msg.sender;
    emit NewPoll(id, _title);
    return id;
  }

  function getPoll(uint _pollId) public view returns (
    string memory,
    string memory,
    string memory,
    uint,
    uint,
    uint32
  ) {
    return (
      polls[_pollId].title,
      polls[_pollId].option1,
      polls[_pollId].option2,
      polls[_pollId].option1Count,
      polls[_pollId].option2Count,
      polls[_pollId].pollDuration
    );
  }

  //Assures the poll's expiartion date and time is not passed before a user can vote
  modifier pollExpiration (uint _pollId) {
    require(polls[_pollId].pollDuration > block.timestamp, "Time expired");
    _;
  }

  //user cannot vote if the time duration expires
  function vote(
    uint _pollId,
    bool optionOne,
    bool optionTwo
  ) public pollExpiration(_pollId) returns (string memory) {
    // checks if voter previously voted in selected _pollId parameter
    require(voterVotesOnPoll[msg.sender][_pollId] == 0, "You already Voted On This Poll");
    // if one of the options is clicked, it adds to the _pollId's count
    string memory option = "";
    if (optionOne == true) {
      polls[_pollId].option1Count++;
      option = polls[_pollId].option1;
    } else if (optionTwo == true) {
      polls[_pollId].option2Count++;
      option = polls[_pollId].option2;
    }
    //Tells the contract in the voterVotedCheck mapping that the address of the
    //function caller voted by adding 1 to its count
    voterVotesOnPoll[msg.sender][_pollId]++;
    //Fires up the PollVotedOnEvent
    emit VoteAdded(
      msg.sender,
      _pollId,
      polls[_pollId].title ,
      polls[_pollId].option1Count,
      polls[_pollId].option2Count
    );
    return option;
  }
}
