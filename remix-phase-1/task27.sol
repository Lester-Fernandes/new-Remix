// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ContractA { // first contract
    function getSender() public view returns (address) { // returns the address of whoever called this function
        return msg.sender;
    }
}

contract ContractB { // second contract
    function callcontract(address _contractAddress) public view returns (address) { // This function calls contractA
        ContractA contracta = ContractA(_contractAddress); // this connect to the deployed contracta

        return contracta.getSender(); // call the function in contractA
    }
}