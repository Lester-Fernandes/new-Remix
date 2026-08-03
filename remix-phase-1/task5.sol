// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract stateOverwrite {
    uint public number;

    function updatenumber(uint _number) public {

        number = _number;
    }
}