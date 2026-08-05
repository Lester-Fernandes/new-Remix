// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract checkvalue {
    uint public value;

    function pay() payable public {
        value = msg.value; // store the ether amount send
    }
}