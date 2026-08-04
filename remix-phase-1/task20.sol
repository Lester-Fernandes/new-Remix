// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract functionchaining { // First function
    function add(uint a, uint b) public pure returns(uint){
        return a + b;
    }

    function total() public pure returns(uint){ // Secound function this function call the first function
        return add(100, 100);
    }
}