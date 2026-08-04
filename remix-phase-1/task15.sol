// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract viewfunction {
    uint public age = 100;

    function getage() public view returns(uint) { // view function can only reads data 
        return age;
    }
}