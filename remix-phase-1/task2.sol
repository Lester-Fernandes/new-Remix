// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StatePersistence {
    uint public number; // State variable stored on the blockchain

    function setNumber(uint _num) public { // Updates the value of number
        number = _num;
    }
}