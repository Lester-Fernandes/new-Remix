// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract autogetter {
    mapping(address => uint) public user; // public automatically  creates a getter 

    function setBalance(uint _amount) public {
        user[msg.sender] = _amount;
    }
}