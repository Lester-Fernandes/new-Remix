// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract externalfunction { // the external function can call from outside the contract
    function words() external pure returns(string memory) {
        return "Hello World";
    }

    function callwords() public view returns(string memory) { // external function must be called using return this.words();
        return this.words();
    }
}