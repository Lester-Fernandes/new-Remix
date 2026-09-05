// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract MemoryStringExampleVul {

//     /*
//         STORAGE STRING

//         Stored permanently on blockchain.
//     */
//     string public storedName;

//     function saveName(string memory _name) public {

//         /*
//             _name exists temporarily in memory.

//             During execution:
//             _name can be modified.

//             After execution:
//             memory cleared.
//         */

//         /*
//             STORAGE WRITE

//             Copies memory string into storage.
//         */
//         storedName = _name;
//     }

//     function getWelcomeMessage(
//         string memory _name
//     )
//         public
//         pure
//         returns (string memory)
//     {

//         /*
//             MEMORY STRING VARIABLE

//             Temporary dynamic string.
//         */
//         string memory message = _name;

//         /*
//             Returning temporary memory string.
//         */
//         return message;
//     }

//     function compareStrings(
//         string memory _first,
//         string memory _second
//     )
//         public
//         pure
//         returns (
//             string memory,
//             string memory
//         )
//     {

//         /*
//             Both strings exist only temporarily
//             during execution.
//         */

//         return (_first, _second);
//     }
// }

contract MemoryString {
    string public storedName;

    function saveName(string memory _name) public {
        storedName = _name;
    }

    function getWelcomeMessage(string memory _name) public pure returns (string memory) {
        string memory message = _name;

        return message;
    }

    function compareString(string memory _first, string memory _secound) public pure returns (string memory, string memory) {
        return (_first, _secound);
    }

    function concatenateString(string memory _first, string memory _secound) public pure returns (string memory) {
        bytes memory combined = bytes.concat(bytes(_first), bytes(_secound));

        return string(combined);
    }
    
    function concatenateWithSpace(string memory _first, string memory _secound) public pure returns (string memory) {
        
        bytes memory combined = bytes.concat(
        bytes(_first), bytes(" "), bytes(_secound));

        return string(combined);
    }
}