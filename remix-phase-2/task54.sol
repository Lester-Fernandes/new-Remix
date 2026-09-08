// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract TargetContractVul {
//     /*
//         TRACK FALLBACK EXECUTION
//     */
//     uint256 public fallbackCounter;

//     uint256 public receivedETH;

//     /*
//     =====================================================
//     FALLBACK FUNCTION
//     =====================================================

//     Triggered when:
//     - unknown function called
//     - calldata unmatched
//     */

//     fallback()
//         external
//         payable
//     {

//         /*
//             Track execution.
//         */
//         fallbackCounter++;

//         /*
//             Track ETH received.
//         */
//         receivedETH += msg.value;
//     }

//     /*
//     =====================================================
//     RECEIVE FUNCTION
//     =====================================================

//     Triggered when:
//     ETH sent with EMPTY calldata.
//     */

//     receive()
//         external
//         payable
//     {

//         receivedETH += msg.value;
//     }

//     /*
//     =====================================================
//     NORMAL FUNCTION
//     =====================================================
//     */

//     function normalFunction()
//         external
//         pure
//         returns (string memory)
//     {

//         return "Normal execution";
//     }
// }

// /*
// =========================================================
// CALLER CONTRACT
// =========================================================
// */

// contract FallbackCallerVul {
//     /*
//         STORE TARGET ADDRESS
//     */
//     address public target;

//     /*
//         LAST CALL STATUS
//     */
//     bool public lastSuccess;

//     /*
//         CONSTRUCTOR
//     */
//     constructor(address _target)
//     {

//         target = _target;
//     }

//     /*
//     =====================================================
//     CALL UNKNOWN FUNCTION
//     =====================================================
//     */

//     function triggerFallback()
//         external
//     {

//         /*
//             LOW-LEVEL CALL

//             Calling NON-EXISTENT function:
//             "doesNotExist()"
//         */
//         (bool success, ) = target.call(abi.encodeWithSignature("doesNotExist()"));
//         /*
//             Save result.
//         */
//         lastSuccess = success;
//     }

//     /*
//     =====================================================
//     SEND ETH + UNKNOWN CALLDATA
//     =====================================================
//     */

//     function triggerFallbackWithETH()external payable{
//         /*
//             Sends:
//             - ETH
//             - invalid function calldata
//         */
//         (bool success, ) = target.call{value: msg.value}(abi.encodeWithSignature("fakeFunction()"));
//         lastSuccess = success;
//     }

//     /*
//     =====================================================
//     SEND PLAIN ETH
//     =====================================================
//     */

//     function triggerReceive()external payable{
//         /*
//             Empty calldata.
//             receive() executes.
//         */
//         (bool success, ) = target.call{value: msg.value}("");
//         lastSuccess = success;
//     }
// }

contract TargetContract {
    uint256 public fallbackCounter;
    uint256 public receivedETH;
    bool private locked;

    event FallbackTriggered(
        address indexed caller,
        uint256 value,
        bytes data
    );

    event ReceiveTriggered(
        address indexed caller,
        uint256 value
    );

    event ETHWithdrawn(
        address indexed user,
        uint256 amount
    );

    modifier nonReentrant() {
        require(!locked, "Reentrancy detected");

        locked = true;

        _;

        locked = false;
    }

    fallback() external payable {
        fallbackCounter++;

        receivedETH += msg.value;

        emit FallbackTriggered(
            msg.sender,
            msg.value,
            msg.data
        );
    }

    receive() external payable {
        receivedETH += msg.value;

        emit ReceiveTriggered(
            msg.sender,
            msg.value
        );
    }

    function normalFunction()
        external
        pure
        returns (string memory)
    {
        return "Normal execution";
    }

    function withdraw() external nonReentrant {
        uint256 amount = receivedETH;

        require(amount > 0, "No ETH available");

        receivedETH = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");

        require(success, "ETH transfer failed");

        emit ETHWithdrawn(msg.sender, amount);
    }

    function callWithdraw() external {
        uint256 amount = receivedETH;

        require(amount > 0, "No ETH available");

        receivedETH = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");

        require(success, "ETH transfer failed");

        emit ETHWithdrawn(msg.sender, amount);
    }

    function contractBalance() external view returns (uint256)
    {
        return address(this).balance;
    }
}


contract FallbackCaller {
    address public target;

    bool public lastSuccess;

    constructor(address _target) {
        require(_target != address(0),"Invalid target" );

        target = _target;
    }

    function triggerFallback() external {
        (bool success, ) = target.call( abi.encodeWithSignature("doesNotExist()"));

        lastSuccess = success;

        require(success,"Fallback call failed" );
    }

    function triggerFallbackWithETH() external payable
    {
        require(msg.value > 0,"Send ETH" );

        (bool success, ) = target.call{
            value: msg.value
        }(abi.encodeWithSignature("fakeFunction()") );

        lastSuccess = success;

        require( success,"Fallback call failed");
    }

    function triggerReceive() external payable
    {
        require(msg.value > 0,"Send ETH");

        (bool success, ) = target.call{
            value: msg.value}("");

        lastSuccess = success;

        require(success,"Receive call failed");
    }

    function callWithdraw() external {
        (bool success, ) = target.call(abi.encodeWithSignature("withdraw()"));

        require(success,"Withdraw failed");
    }

    receive() external payable {}
}
