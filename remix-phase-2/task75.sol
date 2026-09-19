// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract MaxUintBoundaryTestVul {

//     uint256 public lastValue;
//     uint256 public sum;
//     uint256 public calls;

//     event ValueReceived(uint256 value);

//     /*
//     =====================================================
//     NORMAL FUNCTION
//     =====================================================
//     */

//     function set(uint256 value) public  {
//         lastValue = value;
//         sum += value;
//         calls++;

//         emit ValueReceived(value);
//     }

//     /*
//     =====================================================
//     BOUNDARY TEST: MAX UINT
//     =====================================================
//     */

//     function testMaxUint() external {
//         uint256 max = type(uint256).max;

//         set(max);
//     }

//     /*
//     =====================================================
//     STRESS BOUNDARY TEST
//     =====================================================
//     */

//     function stressMax(uint256 n) external {
//         uint256 max = type(uint256).max;

//         for (uint256 i = 0; i < n; i++) {
//             set(max);
//         }
//     }

//     /*
//     =====================================================
//     SAFE CHECK VERSION
//     =====================================================
//     */

//     function safeSet(uint256 value) external {
//         require(value < type(uint256).max, "Max not allowed");

//         lastValue = value;
//         sum += value;
//         calls++;
//     }
// }

contract MaxUintBoundaryTest {
    uint256 public lastValue;
    uint256 public sum;
    uint256 public calls;
    uint256 public constant MAX_UINT = type(uint256).max;
    uint256 public constant MAX_BATCH_SIZE = 50;

    event ValueReceived(uint256 value);
    event BatchProcessed(uint256 count, uint256 total);
    event GasMeasured(string testName, uint256 value, uint256 gasUsed);

    function set(uint256 value) public {
        require(value != MAX_UINT, "Max uint is not allowed");

        lastValue = value;

        sum += value;

        calls++;

        emit ValueReceived(value);
    }

    function testMaxUint() external {
        uint256 max = MAX_UINT;

        set(max);
    }

    function setNormalValue(uint256 value) external {
        require(value != MAX_UINT, "Max uint is not allowed");

        uint256 gasStart = gasleft();

        lastValue = value;
        sum += value;
        calls++;

        uint256 gasUsed = gasStart - gasleft();

        emit GasMeasured("Normal value", value, gasUsed);

        emit ValueReceived(value);
    }

    function testMaxValueGas() external {
        uint256 max = MAX_UINT;

        uint256 gasStart = gasleft();

        lastValue = max;

        require(sum == 0, "Reset sum before max test");

        sum += max;
        calls++;

        uint256 gasUsed = gasStart - gasleft();

        emit GasMeasured("MAX_UINT value", max, gasUsed);
    }

    function processMaxBatch(uint256 n) external {
        require(n > 0 && n <= MAX_BATCH_SIZE,"Invalid batch size");

        uint256 gasStart = gasleft();

        uint256 max = MAX_UINT;

        for(uint256 i = 0; i < n; i++) {
            lastValue = max;

            calls++;
        }
    uint256 gasUsed = gasStart - gasleft();

    emit BatchProcessed(n, n);

    emit GasMeasured("MAX_UINT batch",max, gasUsed);

    }

    function processNormalBatch(uint256 n, uint256 value) external {
        require(n > 0 && n <= MAX_BATCH_SIZE,"Invalid batch size");

        require(value != MAX_UINT,"MAX uint is not allowed");

        uint256 gasStart = gasleft();

        for (uint256 i = 0; i <  n; i++) {
            lastValue = value;

            calls++;

            require(sum <= MAX_UINT - value, "Sum overflow");

            sum += value;
        }

        uint256 gasUsed = gasStart - gasleft();

        emit BatchProcessed(n, n * value);

        emit GasMeasured("Normal value batch", value, gasUsed);
    }

    function fuzzTest(uint256 seed, uint256 iterations) external {
        require(iterations > 0 && iterations <= MAX_BATCH_SIZE, "Invalid iterations");

        uint256 currentSeed = seed;

        for(uint256 i = 0; i < iterations; i++) {
            uint256 value = uint256(keccak256(abi.encodePacked(currentSeed, i)));

            if(value == MAX_UINT) {
                continue;
            }

            lastValue = value;

            if(sum <= MAX_UINT - value) {
                sum += value;
                calls++;
            }
        }

        emit BatchProcessed(iterations, sum);
    }

    function testBoundaryValues() external {
        uint256 maxMinusOne = MAX_UINT - 1;

        lastValue = maxMinusOne;

        require(MAX_UINT != MAX_UINT,"MAX_UINT rejected");
    }

    function isAllowed(uint256 value) external pure returns (bool) {
        return value != MAX_UINT;
    }

    function calAdd(uint256 value) external view returns (bool) {
        return sum <= MAX_UINT - value;
    }

    function getState() external view returns (uint256, uint256, uint256) {
        return(lastValue, sum, calls);
    }

    function reset() external {
        lastValue = 0;
        sum = 0;
        calls = 0;
    }
}