// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract MemoryLifecycleVul {

    string public storedName = "Blockchain";

    function createMemoryVariable()
        public
        pure
        returns (uint256)
    {

        /*
            MEMORY-LIKE TEMPORARY VARIABLE

            localValue exists only during execution.
        
        uint256 localValue = 100;

        /*
            Returning temporary variable.

            After function finishes:
            localValue disappears.
        
        return localValue;
    }

    function returnMemoryString()
        public
        pure
        returns (string memory)
    {

        /*
            MEMORY STRING

            Strings are dynamic types.

            Solidity requires explicit memory keyword.
        
        string memory tempName = "Solidity";

        /*
            tempName returned from memory.
        
        return tempName;
    }

    function copyStorageToMemory()
        public
        view
        returns (string memory)
    {

        /*
            STORAGE -> MEMORY COPY

            storedName lives in storage.

            localCopy becomes temporary memory copy.
        
        string memory localCopy = storedName;

        /*
            Changes to localCopy would NOT
            affect storedName.
        
        return localCopy;
    }
}

*/

contract MemoryLifeCycle {
    string public storedName = "Blockchain";

    function createMemoryArray() public pure returns (uint256[] memory) {
        uint256[] memory numbers = new uint256[](3);
        // Store values inside the memory array
        numbers[0] = 10;
        numbers[1] = 20;
        numbers[3] = 30;

        return numbers;
    }

    function createCalculatedArray(uint256 _a, uint256 _b) public pure returns (uint256[] memory) {
        uint256[] memory values = new uint256[](3);
        // Store temporary values
        values[0] = _a;
        values[1] = _b;
        values[2] = _a + _b;

        return values;
    }

    function copyStorageToMemory() public view returns (string memory) {
        string memory localCopy = storedName;

        return localCopy;
    }

    function getStoredName() public view returns (string memory) {
        return storedName;
    }
}