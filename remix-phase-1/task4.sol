// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MemortVSStorage {

 function getNumber() public pure returns(uint) { // Returns a local variable
    uint number = 100; // Local variable exists only during function execution

    return number;
 }

}