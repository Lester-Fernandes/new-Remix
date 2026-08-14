// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract randomcalldata {
    event randomcall(bytes data);

    fallback() external {
        emit randomcall(msg.data); // Save the calldata in the event
    }

}