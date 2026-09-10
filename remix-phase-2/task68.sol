// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract StorageGasCostVul {
//     /*
//         LARGE STORAGE ARRAY
//     */
//     uint256[] public storedValues;

//     /*
//         TRACK TOTAL WRITES
//     */
//     uint256 public totalWrites;

//     /*
//         TRACK FINAL VALUE
//     */
//     uint256 public lastStoredValue;

//     /*
//     =====================================================
//     STORE MANY VALUES
//     =====================================================
//     */

//     function storeManyValues() external {
//         /*
//         =================================================
//         LOOP 100 TIMES
//         =================================================

//         Every iteration performs:
//         STORAGE WRITE.
//         */

//         for (uint256 i = 0; i < 100; i++) {

//             /*
//             =============================================
//             VERY EXPENSIVE OPERATION
//             =============================================

//             Push value into storage array.
//             */

//             storedValues.push(i);

//             /*
//                 Another storage write.
//             */
//             totalWrites++;

//             /*
//                 Another storage write.
//             */
//             lastStoredValue = i;
//         }
//     }

//     /*
//     =====================================================
//     CHEAPER MEMORY VERSION
//     =====================================================
//     */

//     function useMemoryArray()  external pure returns (uint256[] memory) {
//         /*
//             Memory array exists temporarily.

//             MUCH cheaper than storage.
//         */
//         uint256[] memory temp = new uint256[](100);

//         /*
//             Fill memory array.
//         */
//         for ( uint256 i = 0; i < 100; i++ ) {
//             temp[i] = i;
//         }

//         /*
//             Return temporary memory array.
//         */
//         return temp;
//     }

//     /*
//     =====================================================
//     GET ARRAY LENGTH
//     =====================================================
//     */

//     function getLength()
//         external
//         view
//         returns (uint256)
//     {

//         return storedValues.length;
//     }
// }

contract StorageGasCost {
    uint256[] public storedValues;

    uint256 public totalWrites;

    uint256 public lastStoredValue;

    struct Data{
        uint256 value;
        
        uint256 timestamp;
    }

    Data[] public dataRecords;

    event ValuesStored( uint256 numberOfValues ); 
    
    event StructsStored( uint256 numberOfValues );

    function store1000Values() external {
        for(uint256 i = 0; i < 1000; i++) {
            storedValues.push(i);

            totalWrites++;
        }

        lastStoredValue = 999;

        emit ValuesStored(1000);
    }

    function store1000Optimized() external {
        for(uint256 i = 0; i < 1000; i++) {
            storedValues.push(i);
        }

        totalWrites += 1000;

        lastStoredValue = 999;

        emit ValuesStored(1000);
    }

    function useMemory1000() external pure returns (uint256[] memory) {
        uint256[] memory temp = new uint256[](1000);

        for(uint256 i = 0; i < 1000; i++) {
            temp[i] = i;
        }

        return temp;
    }

    function storeStructs() external {
        for(uint256 i = 0; i < 100; i++) {
            dataRecords.push(Data({value: i, timestamp: block.timestamp}));
        }

        emit StructsStored(100);
    }

    function getLength() external view returns (uint256) {
        return storedValues.length;
    }

    function getStructLength() external view returns (uint256) {
        return dataRecords.length;
    }

    function clearValues() external {
        delete storedValues;
    }

    function clearStructs() external {
        delete dataRecords;
    }
}