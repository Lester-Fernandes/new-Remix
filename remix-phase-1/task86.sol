// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract FallbackEventt {
    event fallbackcalled(address sernder, uint value); // event used to record fallback calls

    fallback() external payable { // fallback receives unknow calls
        emit fallbackcalled(msg.sender, msg.value); // Log who called and how much ETH was sent
    }
}