// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
    function raiseAlert(address user) external;
}

contract DetectionBot is IDetectionBot {
    address public vaultAddr;

    constructor(address _vaultAddr) {
        vaultAddr = _vaultAddr;
    }
   
    function handleTransaction(address user, bytes calldata msgData) external {
        (,,address origSender) = abi.decode(msgData[4:], (address, uint256, address));
        if (origSender == vaultAddr) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}