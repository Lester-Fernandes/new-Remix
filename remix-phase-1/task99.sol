// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract streeTest {
    uint public total;

    function add(uint num) public {
        total += num;
    }

    function subtract(uint num) public {
        total -= num;
    }

    function reset() public {
        total = 0;
    }
}