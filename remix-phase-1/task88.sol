// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract emptycalldata {
    event received(address sender, uint amount);

    receive() external payable { // runs when ETH is received with empty calldata
        emit received(msg.sender, msg.value);
    }
}