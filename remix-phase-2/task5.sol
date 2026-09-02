// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract UserStorageVul {

    mapping(address => uint256) public balances;

    function storeValue(uint256 _amount) public {
        balances[msg.sender] = _amount;
    }

    function getMyValue() public view returns (uint256) {
        return balances[msg.sender];
    }
}
*/

contract userBalance {
    mapping(address => uint256) public balance;

    function increaseBalance(uint256 amount) external {
        require(amount > balance[msg.sender],"value must increase");

        balance[msg.sender] = amount;
    }

    function getBalance(address user) external view returns (uint256) {
        return balance[user];
    }
}