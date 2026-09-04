// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ModifyMemoryArrayVul {

//     uint256[] public storedNumbers;

//     function createAndModifyArray()
//         public
//         pure
//         returns (uint256[] memory)
//     {
//         /*
//             CREATE MEMORY ARRAY
//             Temporary array with size 3
//         */
//         uint256[] memory tempArray = new uint256[](3);

//         /*
//             Initial values
//         */
//         tempArray[0] = 1;
//         tempArray[1] = 2;
//         tempArray[2] = 3;
//         /*
//             MODIFY MEMORY ARRAY
//             Memory arrays are mutable.
//         */
//         tempArray[1] = 999;

//         /*
//             Final array:

//             [1,999,3]
//         */
//         return tempArray;
//     }
//     function modifyInputArray(uint256[] memory _numbers)
//         public
//         pure
//         returns (uint256[] memory)
//     {

//         /*
//             Modify first element
//         */
//         _numbers[0] = 777;

//         /*
//             Changes apply only to memory copy
//         */
//         return _numbers;
//     }

//     function storeValue(uint256 _value) public {

//         /*
//             STORAGE ARRAY

//             Persists permanently.
//         */
//         storedNumbers.push(_value);
//     }
// }

contract modifyMemoryArray {
    uint256[] public storedNumbers;

    function doubleArray() public pure returns (uint256[] memory) {
        uint256[] memory numbers = new uint256[](5);

        for(uint256 i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] * 2;
        }

        return numbers;
    }

    function doubleInputArray(uint256[] memory _numbers) public pure returns (uint256[] memory) {
        for(uint256 i = 0; i < _numbers.length; i++) {
            _numbers[i] = _numbers[i] * 2;
        }

        return _numbers;
    }

    function storeValue(uint256 _value) public {
        storedNumbers.push(_value);
    }
}