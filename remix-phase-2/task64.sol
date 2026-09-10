// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract NonPayableReceiverVul {

//     /*
//         TRACK EXECUTION
//     */
//     uint256 public counter;

//     /*
//     =====================================================
//     NORMAL FUNCTION
//     =====================================================

//     NOT payable.
//     */

//     function increment()
//         external
//     {

//         counter++;
//     }

//     /*
//     =====================================================
//     IMPORTANT
//     =====================================================

//     NO receive()
//     NO payable fallback()

//     Therefore:
//     direct ETH transfers fail.
//     */
// }

// /*
// =========================================================
// PAYABLE CONTRACT
// =========================================================
// */

// contract PayableReceiverVul {

//     /*
//         TRACK RECEIVED ETH
//     */
//     uint256 public receivedAmount;

//     /*
//     =====================================================
//     RECEIVE ETH
//     =====================================================
//     */

//     receive()
//         external
//         payable
//     {

//         /*
//             Store received ETH amount.
//         */
//         receivedAmount += msg.value;
//     }
// }

// /*
// =========================================================
// SENDER CONTRACT
// =========================================================
// */

// contract ETHSenderVul {

//     /*
//         TRACK LAST RESULT
//     */
//     bool public lastSuccess;

//     /*
//         TRACK TOTAL SENT
//     */
//     uint256 public totalSent;

//     /*
//     =====================================================
//     SEND ETH SAFELY
//     =====================================================
//     */

//     function sendETH(
//         address payable _receiver
//     )
//         external
//         payable
//     {

//         /*
//             Attempt ETH transfer using call().
//         */
//         (bool success, ) =
//             _receiver.call{
//                 value: msg.value
//             }("");

//         /*
//             Save result.
//         */
//         lastSuccess = success;

//         /*
//             SAFE HANDLING.

//             Revert if transfer failed.
//         */
//         require(
//             success,
//             "ETH transfer failed"
//         );

//         /*
//             Update accounting ONLY after success.
//         */
//         totalSent += msg.value;
//     }

//     /*
//     =====================================================
//     DANGEROUS SEND
//     =====================================================

//     Ignores success boolean.
//     */

//     function dangerousSend(
//         address payable _receiver
//     )
//         external
//         payable
//     {

//         /*
//             Attempt ETH transfer.
//         */
//         _receiver.call{
//             value: msg.value
//         }("");

//         /*
//             DANGEROUS:
//             Execution continues even if transfer failed.
//         */

//         totalSent += msg.value;
//     }

//     /*
//     =====================================================
//     CHECK CONTRACT BALANCE
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

contract NonPayableReceiver {
    uint256 public counter;

function increment() external { 
    counter++; 
    }
}

contract PayableReceiver {
    uint256 public receivedAmount; 
    
    event ETHReceived( address indexed sender, uint256 amount );

receive() external payable { 
    
    receivedAmount += msg.value; 

    emit ETHReceived( msg.sender, msg.value ); 
    }     
}

contract payableFallbackReceiver {
    uint256 public receivedAmount; 
    
    uint256 public fallbackCalls; 
    
    event FallbackTriggered( address indexed sender, uint256 amount, bytes data );

    fallback() external payable { fallbackCalls++; 
    
    receivedAmount += msg.value; 
    
    emit FallbackTriggered( msg.sender, msg.value, msg.data ); 
    }

    function contractBalance() external view returns (uint256) { 
        
        return address(this).balance; 
    }
}

contract ETHSender {
    bool public lastSuccess; 
    
    bytes public lastData; 
    
    uint256 public totalSent; 
    
    uint256 public successfulTransfers; 
    
    uint256 public successfulSends; 
    
    uint256 public successfulCalls;

    event ETHTransferSuccess( address indexed receiver, uint256 amount ); 
    
    event ETHTransferFailed( address indexed receiver, uint256 amount, string reason ); 
    
    event SendResult( address indexed receiver, uint256 amount, bool success ); 
    
    event CallResult( address indexed receiver, uint256 amount, bool success );

    function sendETH( address payable _receiver ) external payable { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        ( bool success, bytes memory data ) = _receiver.call{ value: msg.value }(""); 
        
        lastSuccess = success; lastData = data;
        
        if (!success) { string memory reason = decodeRevertMessage(data); 
        
        emit ETHTransferFailed( _receiver, msg.value, reason ); 
        
        revert(reason); } 
        
         totalSent += msg.value; 
         
         successfulCalls++; 
         
         emit ETHTransferSuccess( _receiver, msg.value ); 
    }

    function tryCatchTransfer( address _receiver ) external payable { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        try ETHTransferHelper(_receiver).receiveETH{ value: msg.value }() {
            
            lastSuccess = true; 
            
            lastData = ""; 
            
            totalSent += msg.value; 
            
            emit ETHTransferSuccess( _receiver, msg.value ); } catch Error( string memory reason ) { 
                
             lastSuccess = false; 
             
             emit ETHTransferFailed( _receiver, msg.value, reason ); 
             
             revert(reason); } catch { /* Unknown failure. */ lastSuccess = false; 
             
             emit ETHTransferFailed( _receiver, msg.value, "Unknown transfer failure" ); 
             
             revert( "Unknown transfer failure" ); 
        } 
    }

    function sendETHUsingSend(address payable _receiver) external payable returns (bool) {
        require( msg.value > 0, "No ETH sent" ); 
        
        bool success = _receiver.send(msg.value); 
        
        lastSuccess = success; emit SendResult( _receiver, msg.value, success ); 
        
        if (success) { totalSent += msg.value; successfulSends++; } 
        
        return success; 
    }

    function sendETHUsingTransfer( address payable _receiver ) external payable {
        
         require( msg.value > 0, "No ETH sent" ); 
         
        _receiver.transfer( msg.value ); 
        
         totalSent += msg.value; 
         
         successfulTransfers++; 
         
         emit ETHTransferSuccess( _receiver, msg.value ); 
    }

    function tryCallWithoutRevert( address payable _receiver ) external payable returns (bool) { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        ( bool success, bytes memory data ) = _receiver.call{ value: msg.value }(""); 
        
        lastSuccess = success; lastData = data;  
        
        if (success) { totalSent += msg.value; 
        
        successfulCalls++; 
        
        emit ETHTransferSuccess( _receiver, msg.value ); } else { 
            
            emit ETHTransferFailed( _receiver, msg.value, decodeRevertMessage(data) ); } 
            
            return success; 
    }

    function decodeRevertMessage( bytes memory _data ) public pure returns (string memory) { 
        
        if (_data.length < 4) { return "Unknown revert reason"; } bytes4 selector; 
        
        assembly { selector := mload( add(_data, 32) ) }  
        
        if ( selector == bytes4(0x08c379a0) ) { bytes memory reasonData = new bytes( _data.length - 4 ); 
        
        for ( uint256 i = 4; i < _data.length; i++ ) { reasonData[i - 4] = _data[i]; } 
        
        return abi.decode( reasonData, (string) ); } 
        
        return "Unknown revert reason"; 
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance; 
    }

    receive() external payable {}
}

contract ETHTransferHelper {
    function receiveETH() external payable {
        
    }
}

