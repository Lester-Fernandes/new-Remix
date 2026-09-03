// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract DeleteMappingEntryVul {

    mapping(address => uint256) public balances;

    function setBalance(uint256 _amount) public {
        balances[msg.sender] = _amount;
    }

    function deleteMyBalance() public {
        delete balances[msg.sender];
    }

    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
*/

contract DeleteMappingEntry {
    mapping(address => bool) public whitelisted;

    function addToWitelist() public {
        whitelisted[msg.sender] = true;
    }

    function removeFromWhitelist() public {
        delete whitelisted[msg.sender];
    }

    function isWhitelisted() public view returns (bool) {
        return whitelisted[msg.sender];
    }

    function checkWhitelist(address _user) public view returns (bool) {
        return whitelisted[_user];
    }
}