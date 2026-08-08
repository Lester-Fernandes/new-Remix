// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract deletemapping {
    mapping(address => uint) public user;

    function setBalance(uint _amount) public {
        user[msg.sender] = _amount;
    }

    function resetbalance() public { // delete the user's value
        delete user[msg.sender];
    }
        
}