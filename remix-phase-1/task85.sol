// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract NoFallback {
    function hello() public pure returns (string memory) { // Only a normaal function exists
        return "Hello World";
    }
}