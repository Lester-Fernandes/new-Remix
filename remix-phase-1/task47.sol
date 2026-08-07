// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract assertExample {
    function test(uint num) public pure {
        assert (num == 10); // Assert should always be true
    }
}