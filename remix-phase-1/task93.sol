// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract counter {
    uint public count;

    function increment() public { // Increase by 1 each time
        count++;
    }
}