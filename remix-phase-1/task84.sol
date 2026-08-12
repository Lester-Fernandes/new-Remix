// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract FallbackReceive {
    fallback() external payable { // payable fallback can receive ETH

    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}