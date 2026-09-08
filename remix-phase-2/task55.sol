// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ETHReceiverVul {

//     /*
//         TRACK TOTAL ETH RECEIVED
//     */
//     uint256 public totalReceived;

//     /*
//         TRACK LAST SENDER
//     */
//     address public lastSender;

//     /*
//         TRACK NUMBER OF RECEIVES
//     */
//     uint256 public receiveCounter;

//     /*
//     =====================================================
//     RECEIVE FUNCTION
//     =====================================================

//     Automatically executes when:
//     - ETH sent
//     - calldata EMPTY
//     */

//     receive()
//         external
//         payable
//     {

//         /*
//             msg.sender:
//             address sending ETH
//         */
//         lastSender = msg.sender;

//         /*
//             msg.value:
//             ETH amount received
//         */
//         totalReceived += msg.value;

//         /*
//             Track receive executions
//         */
//         receiveCounter++;
//     }

//     /*
//     =====================================================
//     CHECK CONTRACT ETH BALANCE
//     =====================================================
//     */

//     function contractBalance()
//         external
//         view
//         returns (uint256)
//     {

//         return address(this).balance;
//     }
// }

// /*
// =========================================================
// SENDER CONTRACT
// =========================================================
// */

// contract ETHSenderVul {

//     /*
//         STORE RECEIVER ADDRESS
//     */
//     address payable public receiver;

//     /*
//         TRACK LAST STATUS
//     */
//     bool public lastSuccess;


//     /*
//         CONSTRUCTOR
//     */
//     constructor(address payable _receiver)
//     {
//         receiver = _receiver;
//     }

//     /*
//     =====================================================
//     SEND ETH
//     =====================================================
//     */

//     function sendETH()
//         external
//         payable
//     {

//         /*
//             ETH sent with EMPTY calldata.

//             This triggers:
//             receive()
//         */
//         (bool success, ) =
//             receiver.call{
//                 value: msg.value
//             }("");

//         /*
//             Save result
//         */
//         lastSuccess = success;

//         /*
//             Ensure success
//         */
//         require(
//             success,
//             "ETH transfer failed"
//         );
//     }
// }

contract ETHReceiver {
    uint256 public totalReceived;

    address public lastSender;

    uint256 public receiveCounter;

    uint256 public fallbackCounter;

    bool private locked;


event ETHReceived(address indexed sender, uint256 amount);

event FallbackTriggered(address indexed sender, bytes data, uint256 amount);

event ETHWithdrawn(address indexed receipient, uint256 amount);

modifier nonReetrant() {
    require(!locked, "Reentrancy detected");

    locked = true;

    _;

    locked = false;
}

receive() external payable {
    lastSender = msg.sender;

    totalReceived += msg.value;

    receiveCounter++;

    emit ETHReceived(msg.sender, msg.value);
}

fallback() external payable {
lastSender = msg.sender;

totalReceived += msg.value;

fallbackCounter++;

emit FallbackTriggered(msg.sender, msg.data, msg.value);
}

function normalFunction() external pure returns (string memory) {
    return "Normal execution";
}

function withdraw() external nonReetrant {
    uint256 amount = address(this).balance;

    require(amount > 0,"No ETH available");

    (bool success, ) = payable(msg.sender).call{value: amount}("");

    require(success,"ETH transfer failed");

    emit ETHWithdrawn(msg.sender, amount);
}

function contractBalance() external view returns (uint256) {
    return address(this).balance;
}
}

contract ETHSender {
    address payable public receiver;

    bool public lastSuccess;

    constructor(address payable _receiver) {
        require(_receiver != address(0),"Invalid receiver");

        receiver = _receiver;
    }

    function sendETH() external payable {
        require(msg.value > 0, "Send ETH");
        
        (bool success, ) = receiver.call{value: msg.value}("");

        lastSuccess = success;

        require(success, "ETH transfer failed");
    }

    function triggerFallback() external payable
    {
        require(msg.value > 0, "Send ETH");

        (bool success, ) = receiver.call{ value: msg.value }
        ( abi.encodeWithSignature( "doesNotExist()" ) );

        lastSuccess = success;

        require(success,"Fallback call failed");
    }
}