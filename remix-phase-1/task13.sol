// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract internalfunction { // internal function can be called only within the same contract
    function add(uint a, uint b) internal pure returns(uint) {
        return a + b;
    }

    function calculate() public pure returns(uint){ // public function can call the internal function
        return add(100, 100);
    }
}