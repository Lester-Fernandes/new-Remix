// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract publicVisibility {
    uint public number;

    function setNumber(uint _number) public { // public function can be called from anywhere
        number = _number;
    }
}