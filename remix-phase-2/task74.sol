// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ZeroValueEdgeCaseVul {

//     /*
//         STORAGE VARIABLES
//     */
//     uint256 public total;
//     uint256 public lastInput;
//     uint256 public counter;

//     /*
//         STORAGE ARRAY
//     */
//     uint256[] public values;

//     /*
//     =====================================================
//     FUNCTION: ADD VALUE (INCLUDING ZERO)
//     =====================================================
//     */

//     function addValue(uint256 value) public {

//         /*
//         =================================================
//         EDGE CASE: ZERO INPUT
//         =================================================
//         */

//         lastInput = value;

//         /*
//             Even if value = 0,
//             state is still updated.
//         */

//         total += value;

//         /*
//             Storage write ALWAYS happens.
//         */
//         values.push(value);

//         /*
//             Counter always increases,
//             even for zero.
//         */
//         counter++;
//     }

//     /*
//     =====================================================
//     SAFE VERSION (ZERO CHECK)
//     =====================================================
//     */

//     function addValueSafe(uint256 value)
//         external
//     {

//         /*
//             Ignore zero values.
//         */
//         require(value > 0, "Zero not allowed");

//         lastInput = value;
//         total += value;
//         values.push(value);
//         counter++;
//     }

//     /*
//     =====================================================
//     ZERO TEST FUNCTION
//     =====================================================
//     */

//     function testZero()
//         external
//     {

//         /*
//             Explicit zero input calls.
//         */
//         addValue(0);
//         addValue(0);
//         addValue(0);
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

//         return values.length;
//     }
// }

contract ZeroValueEdgeCase {
    uint256 public total; 
    uint256 public lastInput; 
    uint256 public counter;
    uint256 public constant MAX_UINT = type(uint256).max;

    event ValueAdded( uint256 value, uint256 newTotal);
    event ZeroRejected();

    function addValueSafe(uint256 value) external {
        require( value > 0, "Zero not allowed");

        require( total <= MAX_UINT - value, "Total overflow");

        lastInput = value;

        total += value;

        counter++;

        emit ValueAdded(value, total);
    }

    function addValueWithoutZeroCheck( uint256 value ) external {
        total += value; 
        
        lastInput = value; 
        
        counter++; 
        
        emit ValueAdded( value, total );
    }

    function logValue(uint256 value) external {
        require(value > 0, "Zero not allowed");

        uint256 newTotal;

        require(total <= MAX_UINT - value,"Total overflow");

        newTotal = total + value;

        total = newTotal;
        lastInput = value;
        counter++;

        emit ValueAdded(value, newTotal);
    }

    function addMaxUint() external {
        require( total == 0, "Total must be zero" ); 
        
        total = MAX_UINT; 
        
        lastInput = MAX_UINT; 
        
        counter++; 
        
        emit ValueAdded( MAX_UINT, MAX_UINT );
    }
    
    function getMaxUint() external pure returns (uint256) {
        return type(uint256).max;
    }

    function canAdd(uint256 value) external view returns (bool) {
        return total <= MAX_UINT - value;
    }

    function compareZeroValidation(uint256 value) external pure returns(bool withoutCheck, bool withCheck) {
        withoutCheck = true;

        withCheck = value > 0;
    }

    function getState() external view returns(uint256 currentTotal, uint256 currentLastInput, uint256 currentCounter) {
        return (total, lastInput, counter);
    }

    function reset() external {
        total = 0;
        lastInput = 0;
        counter = 0;
    }
}