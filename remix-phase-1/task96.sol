// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract logicflaw {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint amount = balances[msg.sender];

        payable(msg.sender).transfer(amount); // BAD: send ETH first

        balances[msg.sender] = 0; // state update later
    }
}