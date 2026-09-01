// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract addresstask {

    address public storeAddress;

    address public owner;

    constructor() { // constructor only deploy only onces
        owner = msg.sender;

        storeAddress = msg.sender;
    }

    function changaddress(address newAddress) external {
        require(msg.sender == owner,"Not the Owner"); // prevents other users from changing the address
        require(msg.sender != address(0),"Zero address is rejected"); // prevents storing the zero address

        storeAddress = newAddress;
    }

    function getAddress() external view returns (address) {
        return storeAddress;
    }

}