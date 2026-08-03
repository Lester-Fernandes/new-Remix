// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract StateReset {

    uint public number = 10;

    function reset() public {
        number = 0;
    }
}