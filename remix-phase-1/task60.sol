// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract valmapping {
    mapping(address => uint) public user;

    function setbalance(address _user, uint _amount) public { // anyone can call this function
        user[msg.sender] = _amount; 
    }
}