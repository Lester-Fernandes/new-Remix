// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract mappingrequire {
    mapping(address => uint) public user;

    function setBalance(uint _amount) public {
        user[msg.sender] = _amount;
    }

    function withdraw(uint _amount) public { // user cannot withdraw more than their balance
        require(user[msg.sender] >= _amount, "Not enough balance");

        user[msg.sender] = _amount;
    }
}