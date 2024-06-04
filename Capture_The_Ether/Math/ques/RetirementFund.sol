/*
    This retirement fund is what economists call a commitment device. I am trying to make sure I hold on to 1 ether for retirement.

    I have committed 1 ether to the contract below, and I won't withdraw it until 10 years have passed. If I do withdraw early, 10% of my ether goes to the beneficiary (you!).

    I really don't want you to have 0.1 of my ether, so I'm resolved to leave those funds alone until 10 years from now. Good luck!
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RetirementFundChallenge {
    uint256 startBalance;
    address owner = msg.sender;
    address beneficiary;
    uint256 expiration = block.timestamp + 315569260;

    constructor(address player)  payable {
        require(msg.value == 1 ether);

        beneficiary = player;
        startBalance = msg.value;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function withdraw() public {
        unchecked {
            require(msg.sender == owner);

            if (block.timestamp < expiration) {
                // early withdrawal incurs a 10% penalty
                payable(msg.sender).transfer(address(this).balance * 9 / 10);
            } else {
                payable(msg.sender).transfer(address(this).balance);
            }
        }
    }

    function collectPenalty() public {
        unchecked {
            require(msg.sender == beneficiary);

            uint256 withdrawn = startBalance - address(this).balance;

            // an early withdrawal occurred
            require(withdrawn > 0);

            // penalty is what's left
            payable(msg.sender).transfer(address(this).balance);
        }
    }
}