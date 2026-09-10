// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract LoopGasUsageVul {
//     /*
//         STORE LOOP RESULTS
//     */
//     uint256[] public storedNumbers;

//     /*
//         TRACK TOTAL ITERATIONS
//     */
//     uint256 public totalIterations;

//     /*
//         TRACK FINAL SUM
//     */
//     uint256 public finalSum;

//     /*
//     =====================================================
//     LOOP 10 TIMES
//     =====================================================
//     */

//     function runLoop()external{
//         /*
//             Local variable stored in memory/stack.
//             NOT permanent storage.
//         */
//         uint256 sum = 0;
//         /*
//         =================================================
//         FOR LOOP
//         =================================================

//         Executes 10 times:

//         i = 0
//         i = 1
//         ...
//         i = 9
//         */

//         for (  uint256 i = 0;i < 10;i++) {
//             /*
//             =============================================
//             EACH ITERATION DOES:
//             =============================================

//             1. Comparison:
//                i < 10

//             2. Arithmetic:
//                sum += i

//             3. Storage write:
//                push into array

//             4. Increment:
//                i++
//             */
//             sum += i;

//             /*
//                 STORAGE WRITE

//                 Expensive operation.
//             */
//             storedNumbers.push(i);

//             /*
//                 Update storage counter.
//             */
//             totalIterations++;
//         }

//         /*
//             Save final result to storage.
//         */
//         finalSum = sum;
//     }

//     /*
//     =====================================================
//     READ ARRAY LENGTH
//     =====================================================
//     */

//     function getArrayLength()
//         external
//         view
//         returns (uint256)
//     {

//         return storedNumbers.length;
//     }
// }

contract Looptarget {

    uint256 public callCounter;

    event TargetCalled( uint256 number );

    function recordCall(uint256 number) external { 
        
        callCounter++; 
        
        emit TargetCalled(number); 
    }
  }  

  contract LoopgasUsage {
    uint256[] public storedNumbers;

    uint256 public totalIteration;

    uint256 public finalSum;

    Looptarget public target;

    event LoopFinished( uint256 iterations, uint256 sum ); 
    
    event ExternalCallMade( uint256 iteration );

    constructor(address _target) { 
        target = Looptarget(_target); 

    }

    function runLoop100WithStorage() external { 
        uint256 sum = 0;

        for(uint256 i = 0; i < 100; i++) {
            sum += 1;

            storedNumbers.push(i);

            totalIteration++;
        }

        finalSum = sum;

        emit LoopFinished(100, sum);
  }

  function runLoop100WithoutStorage() external returns (uint256) { 
    
    uint256 sum = 0; 
    
    for (uint256 i = 0; i < 100; i++) { 
        
        sum += i; 
        } 
        
        return sum;
    }

    function runLoopWithExternalCall() external { 
        
        for (uint256 i = 0; i < 100; i++) { 
            
             target.recordCall(i); 
             
             emit ExternalCallMade(i); 
        } 
    }

    function simpleLoop100() external returns (uint256) { 
        
        uint256 counter = 0; 
        
        for (uint256 i = 0; i < 100; i++) { counter++; } 
        
        return counter; 
        
    }

    function getArrayLength() external view returns (uint256) { 
        return storedNumbers.length; 
    }

    function clearArray() external { 
        delete storedNumbers; 
    }
}