# pollingProject

## Description
This is a blockchain-Based polling system that was built with the Truffle smart contract framework. 

#### How it Works
This polling system gives users the ability to:

	1. Create a poll that holds two options.
	2. Vote on any poll of their chosing no more than once.
	
#### Stack 

	- Truffle-- Smart Contract Framework
	- Ganache-- Local Ethereum Blockchain
	
### Before You Begin

Prerequisites (attached are links on how to install them):

	1. Node.js and Node Package Manager: https://docs.npmjs.com/downloading-and-installing-node-js-and-npm
	2. Git: https://github.com/git-guides/install-git
	3. Solidity Compiler: https://docs.soliditylang.org/en/v0.8.10/installing-solidity.html
	4. Truffle: http://trufflesuite.com/docs/truffle/getting-started/installation
	5. Ganache: https://trufflesuite.com/ganache/

## How to Install

#### Step One

In your terminal change to a directory of your choice and clone the repo.

	$ cd <your directory name>
	$ git clone https://github.com/moshodi/polling-project.git
	
#### Step Two 

Once the repo is cloned, change to the repo's directory in the terminal.

	$ cd pollingSystem
	
Now your terminal is inside the project.

## Test The Smart Contracts

#### Compile The Contracts

	$ truffle compile

#### Get Your Local Ganache Blockchain Running 

Click QuickStart Ethereum

#### Migrate The Contracts To Ganache

	$ truffle migrate

#### Run the test scripts

	S truffle test

The end results should be:

	- Two passing tests for:
		1. creating a poll
		2. voting on a poll
		
	- One failing test for: 
		1. voting more than once on a poll
		
Your terminal should result in this:

	1) Contract: PollFactory
   		✓ allows you to create a poll (544ms)
    		✓ allows users to vote on the created poll (703ms)
    		1) should prevent users from voting more than once on the same poll

    		Events emitted during test:
   		---------------------------

		PollFactory.NewPoll(
	      	  id: 2 (type: uint256),
		  title: 'Red or Blue' (type: string)
		)


    		---------------------------


  	2 passing (5s)
  	1 failing

	  1) Contract: PollFactory
	       should prevent users from voting more than once on the same poll:
	     Error: Returned error: VM Exception while processing transaction: revert You already Voted On This Poll -- Reason given: You already Voted On This 		Poll.
	      at Context.<anonymous> (test/testPoll.test.js:37:28)
	      at processTicksAndRejections (node:internal/process/task_queues:96:5)
