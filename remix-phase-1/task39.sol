// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract callTransfer {
    function deposit() public payable {} // allows users to send ETH

    function withdraw() public {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}(""); // transfer ETH using call method

        require(success, "Transfer failed");
    }
}