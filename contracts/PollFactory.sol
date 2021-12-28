// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PollFactory {
  event PollCreated(uint pollId, string title);
  event PollVotedOn(
    address voter, 
    uint pollId, 
    string title, 
    string option, 
    uint optionOneCount, 
    uint optionTwoCount);
  // ?? event PollExpired(uint pollId, string title);
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
  function _createPoll(
    string memory _title,
    string memory _firstOption,
    string memory _secondOption) private {
    // time restriction variable for the created poll to be voted on
    uint durationTime = 1 weeks;
    // adds poll to our poll database
    polls.push(Poll(_title, _firstOption, _secondOption, 0, 0, uint32(block.timestamp + durationTime)));
    //identifier for each poll (plus an index for our polls database)
    uint id = polls.length - 1;
    // assigns the poll's id to the function caller's address
    pollToOwner[id] = msg.sender;
    emit PollCreated(id, _title);
  }

  //Assures the poll's expiartion date and time is not passed before a user can vote
  modifier pollExpiration (uint _pollId) {
    require(polls[_pollId].pollDuration > block.timestamp);
    _;
  }
  
  //user cannot vote if the time duration expires
  function _vote(uint _pollId, bool optionOne, bool optionTwo) private pollExpiration(_pollId) {
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
    emit PollVotedOn(
      msg.sender,
      _pollId,
      polls[_pollId].title,
      option,
      polls[_pollId].option1Count,
      polls[_pollId].option2Count
    );
  }
}
