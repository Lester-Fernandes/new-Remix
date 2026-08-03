// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract IndependentStorage {
    uint public age;

    bool public passed;

    address public owner;

    function setage(uint _age) public { // Update age
        age = _age;
    }

    function setpassed(bool _passed) public { // Update passed status
        passed = _passed;
    }

    function setowner(address _owner) public { // Update owner address
        owner = _owner;
    }
}