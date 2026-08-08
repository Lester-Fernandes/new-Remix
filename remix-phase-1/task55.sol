// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract overwrite {
    mapping(address => uint) public user;

    function balance(uint _amount) public { // save or replace the value
        user[msg.sender] = _amount;
    }
}