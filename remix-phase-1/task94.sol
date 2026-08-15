// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Restricted {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not The Owner");
        _;
    }

    function secrete() public view onlyOwner returns(string memory) {
        return "Owner only";
    }
}