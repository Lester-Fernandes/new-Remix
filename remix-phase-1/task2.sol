// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StatePersistence {
    uint public number;

    function setNumber(uint _num) public {
        number = _num;
    }
}