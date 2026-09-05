// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract LargeMemoryArrayVul {

//     /*
//         STORAGE ARRAY

//         Persists permanently.
//     */
//     uint256[] public storedValues;

//     function addValues(uint256 _count) public {

//         /*
//             Add values into storage array.

//             WARNING:
//             Large loops increase gas usage.
//         */
//         for (uint256 i = 0; i < _count; i++) {

//             storedValues.push(i);
//         }
//     }

//     function returnLargeArray(uint256 _size)
//         public
//         pure
//         returns (uint256[] memory)
//     {

//         /*
//             CREATE LARGE MEMORY ARRAY

//             Memory allocated dynamically.
//         */
//         uint256[] memory tempArray =new uint256[](_size);

//         /*
//             Fill memory array
//         */
//         for (uint256 i = 0; i < _size; i++) {

//             tempArray[i] = i + 1;
//         }

//         /*
//             Entire array returned.

//             Larger arrays:
//             higher gas cost.
//         */
//         return tempArray;
//     }

//     function copyStorageToMemory()
//         public
//         view
//         returns (uint256[] memory)
//     {

//         /*
//             FULL STORAGE -> MEMORY COPY

//             Dangerous if storage array becomes huge.
//         */
//         return storedValues;
//     }
// }

contract LargeMemoryArray {
    uint256[] public storedValues;

    function addValue(uint256 _count) public {
        for(uint256 i = 0; i < _count; i++) {
            storedValues.push(i);
        }
    }

    function returnLargeArray(uint256 _size) public pure returns (uint256[] memory) {
        uint256[] memory tempArray = new uint256[](_size);

        for(uint256 i = 0; i < _size; i++) {
            tempArray[i] = i + 1;
        }

        return tempArray;
    }

    function getPaginatedValues(uint256 _start, uint256 _count) public view returns (uint256[] memory) {
        require(_start <= storedValues.length,"Start index out of bounds");

        require(_count <= storedValues.length - _start,"Range exceeds array");

        uint256[] memory result = new uint256[](_count);

        for(uint256 i = 0; i < _count; i++) {
            result[i] = storedValues[_start + i];
        }

        return result;
    }

    function getLength() public view returns (uint256) {
        return storedValues.length;
    }

    function clearStorage() public {
        delete storedValues;
    }
}