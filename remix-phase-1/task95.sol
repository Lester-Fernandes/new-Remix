// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract securewithdraw {
    uint public balance = 100;

    function withdraw(uint amount) public {
        require(amount <= balance, "Too much");

        balance -= amount;
    }
}