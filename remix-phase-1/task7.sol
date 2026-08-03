// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract IndependentStorage {
    uint public age;

    bool public passed;

    address public owner;

    function setage(uint _age) public {
        age = _age;
    }

    function setpassed(bool _passed) public {
        passed = _passed;
    }

    function setowner(address _owner) public {
        owner = _owner;
    }
}