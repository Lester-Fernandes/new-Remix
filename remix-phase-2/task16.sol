// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract LocalUintVariableVul {

    uint256 public storedValue;

    function calculateSum(uint256 _a, uint256 _b)
        public
        pure
        returns (uint256)
    {

        /*
            LOCAL VARIABLE

            sum exists ONLY during execution.

            It is NOT stored permanently
            on blockchain storage.
        
        uint256 sum = _a + _b;

        return sum;
    }

    function storeCalculatedValue(
        uint256 _x,
        uint256 _y
    ) public {

        /*
            TEMPORARY LOCAL VARIABLE

            Used for intermediate computation.
        
        uint256 result = _x + _y;

        /*
            STORAGE WRITE

            Only this line modifies blockchain state.
        
        storedValue = result;
    }

    function demonstrateLocalVariable()
        public
        pure
        returns (uint256)
    {

        /*
            Local variable created
        
        uint256 temp = 100;

        /*
            temp exists only during this function call
        
        temp = temp + 50;

        return temp;
    }
}

*/

contract LocalUintVariable {
    uint256 public storedValue;

    function calculateMultiplication(uint256 _a, uint _b) public pure returns (uint256)
    {
        uint256 result = _a * _b; // Local Variable

        return result;
    }

    function getStoredValue() public view returns (uint256) {
        return storedValue;
    }
}