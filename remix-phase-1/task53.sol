// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract multipleUser {
    mapping(address => uint) public user;

    function amount(uint _amount) public { // Each account get it own value
        user[msg.sender] = _amount;
    }
}