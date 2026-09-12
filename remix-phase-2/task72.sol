// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract RepeatedStorageWritesVul {

//     /*
//         STORAGE VARIABLES
//     */
//     uint256 public counter;
//     uint256 public lastValue;

//     /*
//         STORAGE ARRAY
//     */
//     uint256[] public history;

//     /*
//     =====================================================
//     HEAVY STORAGE WRITE LOOP
//     =====================================================
//     */

//     function heavyWrites(uint256 n) external {
//         /*
//             Loop controlled by user input.
//         */
//         for ( uint256 i = 0; i < n; i++ ) {
//             /*
//             =============================================
//             EXPENSIVE OPERATION 1
//             =============================================

//             Increment storage variable.
//             */
//             counter++;

//             /*
//             =============================================
//             EXPENSIVE OPERATION 2
//             =============================================
//             */
//             lastValue = i;

//             /*
//             =============================================
//             EXPENSIVE OPERATION 3
//             =============================================
//             */
//             history.push(i);
//         }
//     }

//     /*
//     =====================================================
//     OPTIMIZED VERSION
//     =====================================================
//     */

//     function optimizedWrites(uint256 n) external{
//         /*
//             Local variable (cheap).
//         */
//         uint256 tempCounter = counter;

//         uint256 tempValue = 0;

//         uint256[] memory tempArray = new uint256[](n);

//         for (  uint256 i = 0; i < n; i++ ) {
//             /*
//                 ONLY memory operations inside loop.
//             */
//             tempCounter++;

//             tempValue = i;

//             tempArray[i] = i;
//         }

//         /*
//             SINGLE storage write operations.
//         */
//         counter = tempCounter;
//         lastValue = tempValue;

//         /*
//             Write array once (optional pattern).
//         */
//         for (uint256 i = 0;i < n; i++) {
//             history.push(tempArray[i]);
//         }
//     }

//     /*
//     =====================================================
//     GET HISTORY LENGTH
//     =====================================================
//     */

//     function getHistoryLength() external view returns (uint256) {
//         return history.length;
//     }
// }

contract RepeatedStorageWrites {
    uint256 public counter;
    uint256 public lastValue;

    uint256 public constant MAX_N = 50;

    event OperationCompleted(uint256 iterations, uint256 finalCounter, uint256 finalValue);

    event IterationLogged(uint256 index, uint256 value);

    function heavyWrites(uint256 n) external {
        require(n <= MAX_N,"n too large");

        for(uint256 i = 0; i < n;
        i++) {
            counter++;

            lastValue = i;

            emit OperationCompleted(n, counter, lastValue);
        }
        
    }

    function optimizedWrites(uint256 n) external {
        require(n <= MAX_N,"n too large");

        uint256 tempCounter = counter;

        uint256 tempValue = lastValue;

        for(uint256 i = 0; i < n; i++) {
            tempCounter++;

            tempValue = i;
        }

        counter = tempCounter;

        lastValue = tempValue;

        emit OperationCompleted(n, tempCounter, tempValue);
    }

    function processWithEvents(uint256 n) external {
        require(n <= MAX_N,"n too large");

        uint256 tempCounter = counter;

        uint256 tempValue = lastValue;

        for(uint256 i = 0; i < n; i++) {
            tempCounter++;
            tempValue = i;

            emit IterationLogged(i, tempValue);
        }

        counter = tempCounter;
        lastValue = tempValue;

        emit OperationCompleted(n, tempCounter, tempValue);
    }

    function calculateOnly(uint256 n) external pure returns (uint256 fainallCounter, uint256 finalValue) {
        require(n <= MAX_N,"n too large");

        uint256 tempCounter = 0;

        uint256 tempValue = 0;

        for(uint256 i = 0; i < n; i++){
            tempCounter++;
            tempValue = i;
        }

        return(tempCounter, tempValue);
    }

    function getState() external view returns (uint256 currentCounter, uint256 currentLastValue) {
        return(counter, lastValue);
    }

    function reset() external {
        counter = 0;
        lastValue = 0;
    }
}