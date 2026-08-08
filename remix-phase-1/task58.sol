// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract nestedmap {
    // user address -> another address -> amount
    mapping(address => mapping(address => uint)) public user;

    function setAllowance(address _user, uint _amount) public {
    user[msg.sender][_user] = _amount;
    }
}