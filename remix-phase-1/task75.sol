// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract beforeModifier {
    uint public number;

    modifier setBefore() {
        number = 10; // this run before the function
        _; // Function body runs here
    }

    function test() public setBefore {
        number = 20; // This happerns after number = 10
    }
}