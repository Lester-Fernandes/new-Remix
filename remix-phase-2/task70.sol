// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract CalldataGasVul {
//     /*
//         STORE PROCESSED SUM
//     */
//     uint256 public totalSum;
//     /*
//         TRACK ELEMENT COUNT
//     */
//     uint256 public totalElements;
//     /*
//     =====================================================
//     PROCESS HUGE CALDATA ARRAY
//     =====================================================
//     */
//     function processCalldataArray( uint256[] calldata data )  external {
//         /*
//             Local variable in stack.
//         */
//         uint256 sum = 0;

//         /*
//         =================================================
//         LOOP OVER CALDATA ARRAY
//         =================================================
//         */

//         for (uint256 i = 0;i < data.length;i++) {
//             /*
//                 READ FROM CALDATA

//                 Cheap read-only access.
//             */
//             sum += data[i];

//             /*
//                 Storage update per iteration.
//                 (expensive part)
//             */
//             totalElements++;
//         }

//         /*
//             One final storage write.
//         */
//         totalSum = sum;
//     }

//     /*
//     =====================================================
//     COMPARE MEMORY VERSION
//     =====================================================
//     */

//     function processMemoryArray(uint256[] memory data) public pure returns (uint256){
//         uint256 sum = 0;
//         for (  uint256 i = 0;  i < data.length;  i++ ) {
//             /*
//                 Memory access.
//             */
//             sum += data[i];
//         }
//         return sum;
//     }

//     /*
//     =====================================================
//     GET TOTAL ELEMENTS
//     =====================================================
//     */

//     function getTotalElements() external view returns (uint256){
//         return totalElements;
//     }
// }

contract CalldataGas {
    uint256 public totalSum; 
    
    uint256 public totalElements;

    uint256 public constant MAX_ARRAY_SIZE = 500;

    event ArrayProcessed( uint256 elementCount, uint256 sum );

    function processCalldataArray( uint256[] calldata data ) external {

        require( data.length <= MAX_ARRAY_SIZE, "Array too large" ); 
        
        uint256 sum = 0;

        for (uint256 i = 0; i < data.length; i++) {

            sum += data[i]; 
        }

        totalElements += data.length; 
        
        totalSum = sum; 
        
        emit ArrayProcessed(data.length, sum); 
    }

    function process500( uint256[] calldata data ) external { require( data.length <= 500, "Maximum 500 elements" ); 
    
    uint256 sum = 0; 
    
    for (uint256 i = 0; i < data.length; i++) { 
        
        sum += data[i]; 
    }

    totalElements += data.length; 
    
    totalSum = sum; 
    
    emit ArrayProcessed(data.length, sum); 
    }

    function process1000ForComparison( uint256[] calldata data ) external { 
        
        require( data.length <= 1000, "Maximum 1000 elements" ); 
        
        uint256 sum = 0;

        for (uint256 i = 0; i < data.length; i++) { 
            
            sum += data[i]; 
        }
        totalElements += data.length; 
        
        totalSum = sum; 
        
        emit ArrayProcessed(data.length, sum); 
    }

    function calculateCalldataSum( uint256[] calldata data ) external pure returns (uint256) { 
        
        require( data.length <= MAX_ARRAY_SIZE, "Array too large" );
        
         uint256 sum = 0; 
         
         for (uint256 i = 0; i < data.length; i++) { 
            
            sum += data[i]; } 
            
            return sum; 
        }
    function processMemoryArray( uint256[] memory data ) public pure returns (uint256) { 
        
        require( data.length <= MAX_ARRAY_SIZE, "Array too large" ); 
        
        uint256 sum = 0; 
        
        for (uint256 i = 0; i < data.length; i++) { 
            
            sum += data[i]; } 
            
            return sum; 
        }
    function processBatch( uint256[] calldata batch ) external {
        require( batch.length <= MAX_ARRAY_SIZE, "Batch too large" ); 
        
        uint256 batchSum = 0;

        for (uint256 i = 0; i < batch.length; i++) { 
            
            batchSum += batch[i]; 
        }

        totalElements += batch.length; 
        
        totalSum += batchSum; 
        
        emit ArrayProcessed( batch.length, batchSum ); 
    }

    function getResults() external view returns ( uint256 sum, uint256 elements ) { 
        return ( totalSum, totalElements ); 
    }

    function reset() external { 
        totalSum = 0; totalElements = 0; 
    }
}