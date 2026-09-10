// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract GasComparisonVul {

//     /*
//         STORAGE VARIABLE
//     */
//     uint256 public storedNumber;

//     /*
//         STORAGE ARRAY
//     */
//     uint256[] public values;

//     /*
//     =====================================================
//     VIEW FUNCTION
//     =====================================================

//     READS storage only.

//     NO state changes.
//     */

//     function readStoredNumber()
//         external
//         view
//         returns (uint256)
//     {

//         /*
//             Read storage value.
//         */
//         return storedNumber;
//     }

//     /*
//     =====================================================
//     PURE FUNCTION
//     =====================================================

//     Uses no storage at all.
//     */

//     function calculateSum(
//         uint256 a,
//         uint256 b
//     )
//         external
//         pure
//         returns (uint256)
//     {

//         /*
//             Pure computation only.
//         */
//         return a + b;
//     }

//     /*
//     =====================================================
//     STATE-CHANGING FUNCTION
//     =====================================================

//     WRITES to storage.
//     */

//     function updateStoredNumber(
//         uint256 _num
//     )
//         external
//     {

//         /*
//             EXPENSIVE STORAGE WRITE.
//         */
//         storedNumber = _num;
//     }

//     /*
//     =====================================================
//     STORAGE-HEAVY FUNCTION
//     =====================================================

//     Multiple storage writes.
//     */

//     function storeManyValues()
//         external
//     {

//         /*
//             Loop with storage writes.
//         */
//         for (
//             uint256 i = 0;
//             i < 10;
//             i++
//         ) {

//             /*
//                 VERY expensive.
//             */
//             values.push(i);
//         }
//     }

//     /*
//     =====================================================
//     VIEW ARRAY LENGTH
//     =====================================================

//     Cheap storage read.
//     */

//     function getArrayLength()
//         external
//         view
//         returns (uint256)
//     {

//         return values.length;
//     }
// }

contract GasComparision {
    uint256 public storedNumber; 
    
    uint256[] public values;

    mapping(address => uint256) public userValues;

    uint256 public mappingWriteCount;

    event NumberUpdated( uint256 newNumber ); 
    
    event StorageLoopFinished( uint256 numberOfWrites ); 
    
    event MappingUpdated( address indexed user, uint256 value );

    function readStoredNumber() external view returns (uint256) {
        return storedNumber; 
    }

    function calculateSum( uint256 a, uint256 b ) external pure returns (uint256) {
        return a + b; 
    }

    function updateStoredNumber( uint256 _num ) external {

        storedNumber = _num; 
        
        emit NumberUpdated(_num); 
    }

    function store1000Values() external { for (uint256 i = 0; i < 1000; i++) {
        values.push(i); 
        }
        
        emit StorageLoopFinished(1000); 
    }
    function store1000Optimized() external {
        uint256 start = values.length; 
        
        for (uint256 i = 0; i < 1000; i++) {
            values.push(start + i); } 
            
            emit StorageLoopFinished(1000); 
    }
    function useMemory1000() external pure returns (uint256) {
        uint256[] memory temp = new uint256[](1000); 
        
        uint256 sum = 0;

        for (uint256 i = 0; i < 1000; i++) { 
            
            temp[i] = i; sum += temp[i]; 
        }
        return sum;
    }
    function calculate1000InMemory() external pure returns (uint256) { 
        
        uint256 sum = 0; 
        
        for (uint256 i = 0; i < 1000; i++) { 
            
            sum += i; } 
            
            return sum; 
    }

    function writeMapping( uint256 _value ) external {
        userValues[msg.sender] = _value;

        mappingWriteCount++; 
        
        emit MappingUpdated( msg.sender, _value ); 
    }

    function write1000MappingValues() external { 
        for (uint256 i = 0; i < 1000; i++) {

            userValues[ address(uint160(i + 1)) ] = i; }
            
             mappingWriteCount += 1000; 
        }

    function getArrayLength() external view returns (uint256) { 
        return values.length; 
    }
    function getMyMappingValue() external view returns (uint256) {
         return userValues[msg.sender]; 
        } 
}

