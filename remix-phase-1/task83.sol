// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract BothFunction {
    receive() external payable { // Runs when ETH is send + calldata is empty

    }

    fallback() external payable { // Runs when: calldata does not match a function

    }
}