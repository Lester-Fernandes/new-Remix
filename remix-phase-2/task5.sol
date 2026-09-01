// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract userBalance {
    mapping(address => uint256) public balance;

    function increaseBalance(uint256 amount) external {
        require(amount > balance[msg.sender],"value must increase");

        balance[msg.sender] = amount;
    }

    function getBalance(address user) external view returns (uint256) {
        return balance[user];
    }
}