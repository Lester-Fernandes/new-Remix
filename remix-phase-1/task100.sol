// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract badBank {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawAll(address user) public { // the function lets anyone choose any user's address
        uint amount = balances[user];

        balances[user] = 0;

        payable(msg.sender).transfer(amount);
    }
}