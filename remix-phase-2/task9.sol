// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract deleteTask {
    uint256 public number;

    function setNumber(uint256 newNumber) external {
        number = newNumber;
    }

    function resetNumber() external {
        delete number;
    }
}