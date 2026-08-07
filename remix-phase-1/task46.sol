// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract revertExample {
    function withdraw(uint amount) public pure {
        if(amount > 100){ // stop the transaction manually
            revert("Amount is too high");
        }
    }
}