// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.19;

interface Lib{
    function doSomething(uint) external;
}

contract HackMe{
    Lib public lib;
    address public owner;
    uint public someNumber;

    constructor(address _lib){
        lib = Lib(_lib);
        owner = msg.sender;
    }

    function doSomething(uint _num) public {
        (bool success, ) = address(lib).delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
        require(success, "delegatecall failed!!");
    }
}

