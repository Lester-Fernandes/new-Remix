// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract DeleteStorageVariableVul {

    uint256 public number = 100;

    bool public isActive = true;

    address public owner =
        0x1111111111111111111111111111111111111111;

    string public message = "Blockchain";

    uint256[] public numbers;

    constructor() {
        numbers.push(10);
        numbers.push(20);
        numbers.push(30);
    }

    
    =====================================================
    DELETE UINT
    =====================================================
    

    function deleteNumber() public {

        delete number;
    }

    
    =====================================================
    DELETE BOOL
    =====================================================
    

    function deleteBool() public {

        delete isActive;
    }

    
    =====================================================
    DELETE ADDRESS
    =====================================================
    

    function deleteOwner() public {

        delete owner;
    }

    
    =====================================================
    DELETE STRING
    =====================================================
    

    function deleteMessage() public {

        delete message;
    }

    
    =====================================================
    DELETE ENTIRE ARRAY
    =====================================================
    

    function deleteArray() public {

        delete numbers;
    }

    
    =====================================================
    DELETE ARRAY INDEX
    =====================================================
    

    function deleteArrayIndex(uint256 _index) public {

        delete numbers[_index];
    }

    
    =====================================================
    VIEW ARRAY
    =====================================================
    

    function getArray()
        public
        view
        returns(uint256[] memory)
    {
        return numbers;
    }
}
*/

contract deleteStorageVariable {
    uint256 public number = 100;

    bool public isActive = true;

    address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    string public message = "Lester";

    uint256[] public numbers;

    constructor() {
        numbers.push(10);
        numbers.push(20);
        numbers.push(30);
    }

    function deleteNumber() public {
        delete number;
    }

    function deleteBool() public {
        delete isActive;
    }

    function deleteOwner() public {
        delete owner;
    }

    function deleteMessage() public {
        delete message;
    }

    function deleteArray() public {
        delete number;
    }

    function removeArrayElement(uint256 _index) public {
        require(_index < numbers.length,"Index out of bounds"); // check if the index exists

        numbers[_index] = numbers[numbers.length -1]; // move the last element to the removed position

        numbers.pop(); // Remove the last element
    }

    function getArray() public view returns (uint256[] memory) {
        return numbers;
    }

    function getLength() public view returns (uint256) {
        return numbers.length;
    }
}