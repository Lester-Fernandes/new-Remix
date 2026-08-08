// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract data {
    mapping(address => uint) public balance; // stores the number for each user

    function setBalance(uint _amount) public {
        balance[msg.sender] = _amount;
    }
}