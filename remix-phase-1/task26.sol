// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract originexample {
    address public sender;
    address public origin;

    function check() public {
        sender = msg.sender; // save the address of the person that call the function

        origin = tx.origin; // save the address how started the transaction
    }
}