// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract largeUint {
    uint public value; // uint can store maximum 256

    function setvalue(uint _value) public {
        value = _value;
    }
}