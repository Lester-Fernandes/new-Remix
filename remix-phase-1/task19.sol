// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract storeinput {
    string public name;
    function setname(string memory _name) public { // Store the input value
        name = _name;
    }
}