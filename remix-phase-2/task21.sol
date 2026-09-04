// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ModifyCopiedMemoryArrayVul {

//     uint256[] public numbers;

//     function addValues() public {

//         /*
//             STORE VALUES PERMANENTLY
//             inside storage array
//         */
//         numbers.push(100);

//         numbers.push(200);

//         numbers.push(300);
//     }

//     function modifyMemoryCopy()
//         public
//         view
//         returns (
//             uint256[] memory,
//             uint256[] memory
//         )
//     {

//         /*
//             STORAGE -> MEMORY COPY

//             tempArray becomes independent copy.
//         */
//         uint256[] memory tempArray = numbers;

//         /*
//             MODIFY MEMORY COPY ONLY
//         */
//         tempArray[0] = 999;

//         /*
//             RETURN:
//             1. Modified memory copy
//             2. Original storage array
//         */
//         return (tempArray, numbers);
//     }

//     function getStorageArray()
//         public
//         view
//         returns (uint256[] memory)
//     {
//         return numbers;
//     }
// }

contract ModifyCopiedMemoryArray {
    uint256[] public numbers;

    function addValues() public {
        numbers.push(100);
        numbers.push(200);
        numbers.push(300);
    }

    function modifyStorage() public {
        uint256[] storage tempArray = numbers;

        tempArray[0] = 999;
    }

    function increaseAllValues(uint256 _amount) public {
        uint256[] storage tempArray = numbers;

        for(uint256 i = 0; i < tempArray.length; i++) {
            tempArray[i] = tempArray[i] + _amount;
        }
    }

    function getStorageArray() public view returns (uint256[] memory) {
        return numbers;
    }
}