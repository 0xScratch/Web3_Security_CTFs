/*
    This contract locks away ether. The initial ether is locked away until 50 years has passed, and subsequent contributions are locked until even later.

    All you have to do to complete this challenge is wait 50 years and withdraw the ether. If you're not that patient, you'll need to combine several techniques to hack this contract.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract FiftyYearsChallenge {
    struct Contribution {
        uint256 amount;
        uint256 unlockTimestamp;
    }
    Contribution[] queue;
    uint256 head;

    address owner;
    constructor(address player) payable {
        require(msg.value == 1 ether);

        owner = player;
        queue.push(Contribution(msg.value, block.timestamp + 1577846300));
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function upsert(uint256 index, uint256 timestamp) public payable {
        require(msg.sender == owner);

        if (index >= head && index < queue.length) {
            // Update existing contribution amount without updating timestamp.
            Contribution storage contribution = queue[index];
            contribution.amount += msg.value;
        } else {
            // Append a new contribution. Require that each contribution unlock
            // at least 1 day after the previous one.
            require(timestamp >= queue[queue.length - 1].unlockTimestamp + 1 days);

            contribution.amount = msg.value;
            contribution.unlockTimestamp = timestamp;
            queue.push(contribution);
        }
    }

    function withdraw(uint256 index) public {
        require(msg.sender == owner);
        require(block.timestamp >= queue[index].unlockTimestamp);

        // Withdraw this and any earlier contributions.
        uint256 total = 0;
        for (uint256 i = head; i <= index; i++) {
            total += queue[i].amount;

            // Reclaim storage.
            delete queue[i];
        }

        // Move the head of the queue forward so we don't have to loop over
        // already-withdrawn contributions.
        head = index + 1;

        payable(msg.sender).transfer(total);
    }
}