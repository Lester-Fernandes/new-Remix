// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract StorageVsMemoryVul {

//     /*
//         STRUCT STORED ON BLOCKCHAIN
//     */
//     struct User {
//         uint256 score;
//         bool active;
//     }

//     /*
//         STORAGE MAPPING

//         Persistent blockchain storage
//     */
//     mapping(address => User) public users;

//     function createUser() public {

//         users[msg.sender] = User({
//             score: 100,
//             active: true
//         });
//     }

//     function updateUsingStorage() public {
//         /*
//             STORAGE REFERENCE

//             user directly points to:
//             users[msg.sender]
//         */
//         User storage user = users[msg.sender];
//         /*
//             MODIFY STORAGE DIRECTLY

//             Changes persist permanently.
//         */
//         user.score = 999;
//     }

//     function updateUsingMemory() public view returns (uint256,bool) {

//         /*
//             MEMORY COPY

//             Creates independent temporary copy.
//         */
//         User memory user = users[msg.sender];

//         /*
//             MODIFY MEMORY COPY ONLY

//             Original storage remains unchanged.
//         */
//         user.score = 555;
//         user.active = false;

//         /*
//             Returning modified MEMORY values
//         */
//         return (
//             user.score,
//             user.active
//         );
//     }

//     function getUser()public view returns (uint256,bool){
//         User storage user = users[msg.sender];
//         return (
//             user.score,
//             user.active
//         );
//     }
// }

contract StorageVsMemory {
    struct User{
        uint256 score;
        bool active;
    }

    mapping(address => User) public users;
    uint256[] public storageArray;

    function createUser() public {
        users[msg.sender] = User({
            score: 100, active: true
        });
    }

    function updateUsingStorage() public {
        User storage user = users[msg.sender];

        user.score = 999;
    }

    function updateUsingMemory() public view returns (uint256, bool) {
        User memory user = users[msg.sender];

        user.score = 555;
        user.active = false;

        return(user.score, user.active);
    }

    function getUser() public view returns (uint256, bool) {
        User storage user = users[msg.sender];

        return(user.score, user.active);
    }

    function modifyMemoryArray() public pure returns (uint256[] memory) {
        uint256[] memory numbers = new uint256[](3);

        numbers[0] = 10;
        numbers[1] = 20;
        numbers[2] = 30;

        numbers[0] = 999;
        numbers[1] = 888;
        numbers[2] = 777;

        return numbers;
    }

    function createStorageArray() public {
        storageArray.push(10);
        storageArray.push(20);
        storageArray.push(30);
    }

    function modifyStorageArray() public {
        uint256[] storage tempArray = storageArray;

        tempArray[0] = 999;
        tempArray[1] = 888;
        tempArray[2] = 777;
    }

    function getMemoryArrayExample() public pure returns (uint256[] memory) {
        uint256[] memory numbers = new uint256[](3);

        numbers[0] = 100;
        numbers[1] = 200;
        numbers[2] = 300;

        numbers[0] = 1000;

        return numbers;
    }

    function getStorageArray() public view returns (uint256[] memory) {
        return storageArray;
    }

    function clearStorageArray() public {
        delete storageArray;
    }
}