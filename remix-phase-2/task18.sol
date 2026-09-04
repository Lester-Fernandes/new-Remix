// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract MemoryArrayVul {

//     uint256[] public storedNumbers;

//     function createMemoryArray()
//         public
//         pure
//         returns (uint256[] memory)
//     {

//         /*
//             CREATE MEMORY ARRAY

//             new uint256[](3)

//             Creates temporary array in memory
//             with fixed size = 3
//         */
//         uint256[] memory tempArray = new uint256[](3);

//         /*
//             Store values inside memory array
//         */
//         tempArray[0] = 10;

//         tempArray[1] = 20;

//         tempArray[2] = 30;

//         /*
//             Return temporary memory array
//         */
//         return tempArray;
//     }

//     function calculateSquares(uint256 _number)
//         public
//         pure
//         returns (uint256[] memory)
//     {

//         /*
//             Temporary memory array
//         */
//         uint256[] memory squares = new uint256[](3);

//         /*
//             Store calculated values
//         */
//         squares[0] = _number;

//         squares[1] = _number * _number;

//         squares[2] = _number * _number * _number;

//         return squares;
//     }

//     function storeValue(uint256 _value) public {

//         /*
//             STORAGE ARRAY

//             This persists permanently.
//         */
//         storedNumbers.push(_value);
//     }
// }

contract MemoryArrayFixed {
    uint256[] public storedNumbers;

    function createMultipliedArray(uint256 _multiplier) public pure returns (uint256[] memory) {
        uint256[] memory values = new uint256[](5);


        for (uint256 i = 0; i < 5; i++) {
            values[i] = (i + 1) * _multiplier;
        }

        return values;
    }

    function storeValue(uint256 _value) public {
        storedNumbers.push(_value);
    }

    function getStoredNumber() public view returns (uint256) {
        return storedNumbers.length;
    }
}