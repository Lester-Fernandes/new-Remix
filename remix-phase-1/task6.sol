// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract StateReset {

    uint public number = 10; // Initial value

    function reset() public { // reset number back to zero
        number = 0;
    }
}