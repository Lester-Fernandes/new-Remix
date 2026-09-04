// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract MemoryStructExampleVul {

//     /*
//         STRUCT DEFINITION

//         Groups related data together.
//     */
//     struct User {

//         string name;

//         uint256 age;

//         bool active;
//     }

//     /*
//         STORAGE STRUCT

//         Stored permanently on blockchain.
//     */
//     User public storedUser;

//     function createMemoryStruct()
//         public
//         pure
//         returns (
//             string memory,
//             uint256,
//             bool
//         )
//     {

//         /*
//             MEMORY STRUCT CREATION

//             Temporary struct allocated in memory.
//         */
//         User memory tempUser = User({

//             name: "Alice",

//             age: 25,

//             active: true
//         });

//         /*
//             tempUser exists only during execution.
//         */
//         return (
//             tempUser.name,
//             tempUser.age,
//             tempUser.active
//         );
//     }

//     function createAndModifyMemoryStruct()
//         public
//         pure
//         returns (
//             string memory,
//             uint256,
//             bool
//         )
//     {

//         /*
//             Temporary memory struct
//         */
//         User memory tempUser = User({

//             name: "Bob",

//             age: 30,

//             active: true
//         });

//         /*
//             MODIFY MEMORY STRUCT

//             Changes affect only temporary copy.
//         */
//         tempUser.age = 99;

//         tempUser.active = false;

//         return (
//             tempUser.name,
//             tempUser.age,
//             tempUser.active
//         );
//     }

//     function storeUser() public {

//         /*
//             STORAGE MUTATION

//             This persists permanently.
//         */
//         storedUser = User({

//             name: "Charlie",

//             age: 40,

//             active: true
//         });
//     }
// }

contract MemoryStruct {
    struct User {
        string name;
        uint256 age;
        bool active;
    }

    User public storedUser;

    function storeUser() public {
        storedUser = User({
            name: "Lester", age: 21, active: true
        });
    }

        function modifyMemoryCopy() public view returns (string memory, uint256, bool) {
            User memory tempUser = storedUser;

        tempUser.name = "Boss";
        tempUser.age = 100;
        tempUser.active = false;

    return( tempUser.name, tempUser.age, tempUser.active);

    }

    function getStoredUser() public view returns (string memory, uint256, bool) {
    return (storedUser.name, storedUser.age, storedUser.active);
}
}
