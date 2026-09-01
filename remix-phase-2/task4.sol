// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract storebool {
    bool public isActive;

    constructor() {
        isActive = false;
    }

    function status(bool newState) external {
        isActive = newState;
    }

    function toggleState() external {
        isActive = !isActive;
    }
}