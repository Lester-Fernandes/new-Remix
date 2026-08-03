// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract stateOverwrite {
    uint public number; // State Variable

    function updatenumber(uint _number) public { // Update the state variable with a new value

        number = _number; 
    }
}