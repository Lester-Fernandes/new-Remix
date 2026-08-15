// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract zeroValues {
    uint public number;
    address public user;

    function setdata(uint _number, address _user) public { // This function stores the values
        number = _number;
        user = _user;
    }
}