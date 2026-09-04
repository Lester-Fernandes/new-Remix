// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract StorageToMemoryCopyVul {

//     uint256[] public numbers;

//     function addValues() public {

//         /*
//             STORE VALUES IN STORAGE ARRAY
//         */
//         numbers.push(10);

//         numbers.push(20);

//         numbers.push(30);
//     }

//     function copyArrayToMemory()
//         public
//         view
//         returns (uint256[] memory)
//     {

//         /*
//             STORAGE -> MEMORY COPY

//             Entire storage array copied
//             into temporary memory array.
//         */
//         uint256[] memory tempArray = numbers;

//         /*
//             Returning temporary copy
//         */
//         return tempArray;
//     }

//     function modifyMemoryCopy()
//         public
//         view
//         returns (uint256[] memory)
//     {

//         /*
//             Create memory copy
//         */
//         uint256[] memory tempArray = numbers;

//         /*
//             Modify MEMORY copy only
//         */
//         tempArray[0] = 999;

//         /*
//             Original storage remains unchanged
//         */
//         return tempArray;
//     }

//     function getStorageArray()
//         public
//         view
//         returns (uint256[] memory)
//     {
//         return numbers;
//     }
// }


contract StorageReferenceFixed {
    uint256[] public numbers;

    function addValues() public {
        numbers.push(10);
        numbers.push(20);
        numbers.push(30);
    }

    function modifyStorage() public {
        uint256[] storage tempArray = numbers;

        tempArray[0] = 999;
    }

    function doubleStorageValues() public {
        uint256[] storage tempArray = numbers;

        for (uint256 i = 0; i < tempArray.length; i++) {
            tempArray[i] = tempArray[i] * 2;
        }
    }

    function getStorageAray() public view returns (uint256[] memory) {
        return numbers;
    }
}