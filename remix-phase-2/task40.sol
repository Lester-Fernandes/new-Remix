// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract NestedIfConditionsVul {

//     /*
//         OWNER ADDRESS
//     */
//     address public owner;

//     /*
//         USER SCORES
//     */
//     mapping(address => uint256) public scores;

//     /*
//         USER LEVELS
//     */
//     mapping(address => string) public levels;

//     /*
//         CONSTRUCTOR
//     */
//     constructor() {

//         owner = msg.sender;
//     }

//     /*
//     =====================================================
//     NESTED IF LOGIC
//     =====================================================
//     */

//     function evaluateUser(uint256 _score,bool _premium)external{
//         /*
//             FIRST BRANCH
//             Check minimum score.
//         */
//         if (_score >= 50) {

//             /*
//                 SECOND BRANCH

//                 Check premium status.
//             */
//             if (_premium == true) {

//                 /*
//                     THIRD BRANCH

//                     Check elite score.
//                 */
//                 if (_score >= 90) {

//                     levels[msg.sender] =
//                         "Elite Premium";

//                 } else {

//                     levels[msg.sender] =
//                         "Premium";
//                 }

//             } else {

//                 /*
//                     NON-PREMIUM USER
//                 */
//                 levels[msg.sender] =
//                     "Standard";
//             }

//             /*
//                 SAVE SCORE
//             */
//             scores[msg.sender] = _score;

//         } else {

//             /*
//                 LOW SCORE BRANCH
//             */
//             levels[msg.sender] =
//                 "Rejected";
//         }
//     }

//     /*
//     =====================================================
//     OWNER BONUS FUNCTION
//     =====================================================
//     */

//     function ownerBonus(
//         address _user
//     )
//         external
//     {

//         /*
//             FIRST CONDITION:
//             owner check
//         */
//         if (msg.sender == owner) {

//             /*
//                 SECOND CONDITION:
//                 user must exist
//             */
//             if (scores[_user] > 0) {

//                 /*
//                     THIRD CONDITION:
//                     high score required
//                 */
//                 if (scores[_user] >= 80) {

//                     scores[_user] += 20;
//                 }
//             }
//         }
//     }
// }

contract NestedifConditions {
    address public owner;

    bool public paused;

    mapping(address => uint256) public scores;

    mapping(address => string) public levels;

    mapping(address => bool) public blacklisted;

    mapping(address => bool) public vip;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"Not the owner");
        _;
    }

    function evaluateUser(uint256 _score, bool _premium) external {
        if(paused) {
            levels[msg.sender] = "Paused";

            return;
        }

        if(blacklisted[msg.sender]) {
            levels[msg.sender] = "Blacklisted";

            return;
        }

        if(_score >= 50) {
            if(vip[msg.sender]) {
                if(_score >= 70) {
                    levels[msg.sender] = "VIP";
                } else {
                    levels[msg.sender] = "VIP - Low Score";
                }
            } else {
                if(_premium) {
                    if(_score >= 90) {
                        levels[msg.sender] = "Elite Premium";
                    } else {
                        levels[msg.sender] = "premium";
                    }
                } else {
                    levels[msg.sender] = "Standard";
                }
            }
        } else {
            levels[msg.sender] = "Rejected";

            scores[msg.sender] = _score;
        }
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    function blacklist(address _user) external onlyOwner {
        require(_user != address(0),"Invalidaddress");

        blacklisted[_user] = true;
    }

    function unblacklist(address _user) external onlyOwner {
        require(_user != address(0),"Invalid address");

        blacklisted[_user] = false;
    }

    function addVIP(address _user) external onlyOwner {
        require(_user != address(0),"Invalid address");

        vip[_user] = true;
    }

    function removeVIP(address _user) external onlyOwner {
        require(_user != address(0),"Invalid address");

        vip[_user] = false;
    }

    function ownerBouns(address _user) external onlyOwner {
        if(scores[_user] > 0) {
            if(scores[_user] >= 80) {
                if(!blacklisted[_user]) {
                    scores[_user] = scores[_user] + 20;
                }
            }
        } 
    }
}