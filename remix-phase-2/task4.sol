// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StoreBooleanVul {

    bool public isActive;

    function setStatus(bool _status) public {
        isActive = _status;
    }

    function getStatus() public view returns (bool) {
        return isActive;
    }
}
*/

contract StoreBoolean {
    bool public isActive;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setStatue(bool _status) public {
        require(msg.sender == owner,"Only the owner can change status");

        isActive = _status;
    }

    function toggleStatus() public {
        require(msg.sender == owner,"Only the owner can toggle status");

        isActive =!isActive;
    }

    function getStatus() public view returns (bool) {
        return isActive;
    }
}