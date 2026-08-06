// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract emptywithdraw {
    function withdraw() public {
        require(address(this).balance > 0, "No ETH available"); // Check enough ETH is available

        payable(msg.sender).transfer(address(this).balance);
    }
}