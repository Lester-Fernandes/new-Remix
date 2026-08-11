// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract afterModifier {
    uint public number;

    modifier checkAfter() {
        _; // Function runs first

        number = 100; // This runs after the function
    }

    function test() public checkAfter { // function changes number first
        number = 50;
    }
}