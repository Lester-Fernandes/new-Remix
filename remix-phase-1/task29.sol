// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract value {
    function pay() public payable { // user must send some ETH
        require(msg.value > 0, "Send some ETH");
    }
}