// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract DynamicArrayGrowthVul {

    uint256[] public numbers;

    function addMultipleValues(uint256 _value1,uint256 _value2,uint256 _value3) public {
        numbers.push(_value1);
        numbers.push(_value2);
        numbers.push(_value3);
    }

    function getNumber(uint256 _index)public
        view
        returns (uint256)
    {
        return numbers[_index];
    }

    function getLength() public view returns (uint256) {
        return numbers.length;
    }
}
*/
/*
Audit Report

Title: Uncontrolled Dynamic Array Growth in addMultipleValue()

Severity: Medium

Location: Contract: DynamicArrayGrowthVal
          Function: addMultipleValues()

Vulnerability Description: The vulnerable addMultipleValues() function allows any external user to append three values to the dynamic array 
                           during every function call

Impact: An attacker can repeatedly increase the size of the dynamic array

Proof of Concept:
    1. Deploy the vulnerable DynamicArrayGrowthVul contract
    2. Initailly: numbers.length = 0
    3. Call: addMultipleValues(10, 20, 30)
    4. Array length becomes: 3
    5. Call the function again: addMultipleValues(40, 50, 60)
    6. Array length becomes: 6
    7. Repeated calls continue increasing the array length
    8. No maximum array size is enforced

Root Cause: The root cause is that addMultipleValues() perform three unconditional push() operations without validating the resulting array length

Recommendation: Define a maximum permitted array length and verify that adding all three values will not exceed that limit before modifying storage

*/


contract DynamicArrayGrowth {
    uint256[] public number;

    uint256 public constant MAX_LENGTH = 10;

    function MultipleValues(uint256 _value1, uint256 _value2, uint256 _value3) public { // Adds three values to the array
        require(number.length + 3 <= MAX_LENGTH,"Array maximum length exceeded");

        number.push(_value1);

        number.push(_value2);

        number.push(_value3);
    }

    function getNumber(uint256 _index) public view returns (uint256) {
        return number[_index];
    }

    function getLength() public view returns (uint256) {
        return number.length;
    }
}