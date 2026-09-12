// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract StressTestCallsVul {
//     /*
//         STORAGE STATE
//     */
//     uint256 public counter;
//     uint256 public totalCalls;
//     uint256[] public history;

//     /*
//     =====================================================
//     SINGLE STATE UPDATE FUNCTION
//     =====================================================
//     */

//     function singleCall(uint256 value) public {

//         /*
//             Increment counters.
//         */
//         counter++;
//         totalCalls++;

//         /*
//             Store value.
//         */
//         history.push(value);
//     }

//     /*
//     =====================================================
//     STRESS TEST FUNCTION (LOOPED CALLS)
//     =====================================================
//     */

//     function stressTest(uint256 times) external {

//         /*
//         =================================================
//         WARNING:
//         =================================================

//         This simulates repeated usage.

//         Gas grows linearly with `times`.
//         */

//         for (uint256 i = 0; i < times; i++ ) {

//             /*
//                 Repeated internal execution.
//             */
//             singleCall(i);
//         }
//     }

//     /*
//     =====================================================
//     DIRECT CALL STRESS (EXTERNAL STYLE SIMULATION)
//     =====================================================
//     */

//     function externalStyleStress(uint256 times) external{

//         for ( uint256 i = 0;  i < times; i++ ) {
//             /*
//                 Simulates repeated user interactions.
//             */
//             this.singleCall(i);
//         }
//     }

//     /*
//     =====================================================
//     RESET STATE (FOR TESTING ONLY)
//     =====================================================
//     */

//     function reset() external {

//         counter = 0;
//         totalCalls = 0;

//         delete history;
//     }

//     /*
//     =====================================================
//     GET HISTORY SIZE
//     =====================================================
//     */

//     function getHistoryLength() external view returns (uint256) {
//         return history.length;
//     }
// }

contract StressTestCall {
    uint256 public counter;
    uint256 public totalCalls;
    uint256 public constant MAX_CALLS = 100;

    event StressTestCompleted(uint256 calls, uint256 finalCounter, uint256 gasUsed);

    event CallLogged(uint256 index, uint256 value);

    function singleCall(uint256 value) public {
        counter++;
        totalCalls++;

        emit CallLogged(totalCalls -1, value);
    }

    function stressTest(uint256 time) external {
        require(time <= MAX_CALLS,"Too many calls");

        uint256 gasStart = gasleft();

        for(uint256 i = 0; i < time; i++){
            singleCall(i);
        }

        uint256 gasUsed = gasStart - gasleft();

        emit StressTestCompleted(time, counter, gasUsed);
    }

    function externalStyleStress(uint256 time) external {
        require(time <= MAX_CALLS, "TOO many calls");

        uint256 gasStart = gasleft();

        for(uint256 i = 0; i < time; i++) {
            this.singleCall(i);
        }

        uint256 gasUsed = gasStart - gasleft();

        emit StressTestCompleted(time,counter,gasUsed);
    }

    function eventOnlyStress(uint256 time) external {
        require(time <= MAX_CALLS,"TOO many calls");

        uint256 gasStart = gasleft();

        uint256 localcounter = counter;

        for(uint256 i = 0; i < time; i++) {
            localcounter++;

            emit CallLogged(i,i);
        }

        counter = localcounter;

        totalCalls += time;

        uint256 gasUsed = gasStart - gasleft();

        emit StressTestCompleted(time, localcounter, gasUsed);
    }

    function measureCalculationGas(uint256 time) external view returns (uint256 result, uint256 gasUsed) {
        require(time <= MAX_CALLS, "Too many calls");

        uint256 gasStart = gasleft();

        uint256 localCounter = 0;

        for(uint256 i = 0; i < time; i++) {
            localCounter++;
        }

        gasUsed = gasStart - gasleft();

        result = localCounter;
    }

    function getState() external view returns (uint256 currentCounter, uint256 currentTotalCalls) {
        return(counter, totalCalls);
    }

    function reset() external {
        counter = 0;
        totalCalls = 0;
    }
}