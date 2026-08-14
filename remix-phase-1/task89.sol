// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract payablefallback {
    fallback() external payable { // Payable fallback can receive ETH

    }

    function getbalance() public view returns (uint) {
        return address(this).balance;
    }
}