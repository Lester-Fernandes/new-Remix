// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Target {
    function whoCalled() public view returns(address) {
        return msg.sender;
    }
}

contract Intermediary {
    function callTarget(address target) public view returns(address) {
        return Target(target).whoCalled();
    }
}