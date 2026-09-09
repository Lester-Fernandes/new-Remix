// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract RejectETHVul {
//     /*
//         Track calls
//     */
//     uint256 public counter;
//     /*
//     =====================================================
//     ALWAYS REVERT ON ETH
//     =====================================================
//     */
//     receive() external payable{
//         revert("ETH rejected");
//     }

//     /*
//     =====================================================
//     ALWAYS FAIL FUNCTION
//     =====================================================
//     */

//     function failFunction()  external pure {
//         revert("Function failed");
//     }

//     /*
//     =====================================================
//     SUCCESS FUNCTION
//     =====================================================
//     */

//     function successFunction()  external{
//         /*
//             Increment counter.
//         */
//         counter++;
//     }
// }

// /*
// =========================================================
// VULNERABLE CONTRACT
// =========================================================
// */

// contract DangerousUncheckedCallVul {
//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//         TRACK WITHDRAWALS
//     */
//     mapping(address => bool) public withdrawn;

//     /*
//     =====================================================
//     DEPOSIT ETH
//     =====================================================
//     */

//     function deposit()   external payable {
//         balances[msg.sender] += msg.value;
//     }

//     /*
//     =====================================================
//     DANGEROUS WITHDRAW
//     =====================================================

//     PROBLEM:
//     ignores success boolean.
//     */

//     function dangerousWithdraw( address payable _receiver, uint256 _amount)external{
//         /*
//             Validate balance.
//         */
//         require(balances[msg.sender] >= _amount,"Insufficient balance");
//         /*
//             EFFECTS:
//             Update storage FIRST.
//         */
//         balances[msg.sender] -= _amount;

//         withdrawn[msg.sender] = true;

//         /*
//         =================================================
//         DANGEROUS EXTERNAL CALL
//         =================================================

//         ETH transfer may FAIL.

//         BUT:
//         success boolean ignored.
//         */

//         _receiver.call{ value: _amount }("");

//         /*
//             Execution continues regardless.

//             HUGE PROBLEM.
//         */
//     }

//     /*
//     =====================================================
//     SAFE VERSION
//     =====================================================
//     */

//     function safeWithdraw( address payable _receiver,  uint256 _amount)    external {
//         /*
//             Validate balance.
//         */
//         require(
//             balances[msg.sender] >= _amount,
//             "Insufficient balance"
//         );

//         /*
//             Update storage.
//         */
//         balances[msg.sender] -= _amount;

//         /*
//             Properly check success.
//         */
//         (bool success, ) =_receiver.call{value: _amount  }("");
//         /*
//             Revert if transfer failed.
//         */
//         require( success,"ETH transfer failed");
//     }

//     /*
//     =====================================================
//     CHECK CONTRACT BALANCE
//     =====================================================
//     */

//     function contractBalance()  external view   returns (uint256) {
//         return address(this).balance;
//     }
// }

contract RejectETH {
    uint256 public counter;

    receive() external payable {
        revert("ETH rejected");
    }

    function failFunction() external pure {
        revert("Function failed");
    }

    function successFunction() external {
        counter++;
    }
}

interface IRejectETH { 
    function failFunction() external; 

    function successFunction() external; 
    }

contract DangerousUncheckedCall {
    mapping(address => uint256) public balances;

    mapping(address => bool) public withdrawn;

    bool public lastSuccess;

    bytes public lastData;

    string public lastError;

    event Deposited(address indexed user, uint256 amount); 

    event WithdrawalSuccessful(address indexed user, address indexed receiver, uint256 amount); 
    
    event WithdrawalFailed(address indexed user, address indexed receiver, uint256 amount, string reason);

    function deposit() external payable { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        balances[msg.sender] += msg.value; 
        
        emit Deposited( msg.sender, msg.value ); 
        
    }

    function dangerousWithdraw( address payable _receiver, uint256 _amount ) external { 
        
        require( balances[msg.sender] >= _amount, "Insufficient balance" ); 
        
        balances[msg.sender] -= _amount; 
        
        withdrawn[msg.sender] = true; 
        
        _receiver.call{ value: _amount }(""); 
        
        emit WithdrawalSuccessful( msg.sender, _receiver, _amount ); 
        
    }

    function safeWithdraw( address payable _receiver, uint256 _amount ) external { 
        
        require( balances[msg.sender] >= _amount,"Insufficient balance" ); 
        
        balances[msg.sender] -= _amount; 
        
        (bool success, bytes memory data) = _receiver.call{ value: _amount }(""); 
        
        lastSuccess = success; lastData = data; 
        
        if (!success) { string memory reason = decodeRevertMessage(data); 
        
        lastError = reason; 
        
        emit WithdrawalFailed( msg.sender, _receiver, _amount, reason ); 
        
        revert(reason); 
        }
         
        withdrawn[msg.sender] = true; lastError = ""; 
        
        emit WithdrawalSuccessful(msg.sender, _receiver, _amount); 
        
    }

    function tryCatchFailure( address _target ) external { 
        
        try IRejectETH(_target).failFunction() { lastSuccess = true; 
        
        lastError = ""; } catch Error( string memory reason ) 
        
        { lastSuccess = false; lastError = reason; } catch Panic( uint256 ) 
        
        {lastSuccess = false; 
        
        lastError = "Panic occurred"; } catch 
        
        { lastSuccess = false; 
        
        lastError = "Unknown failure"; 
        } 
    }

    function tryCatchSuccess( address _target ) external { 
        
        try IRejectETH(_target).successFunction() { lastSuccess = true; 
        
        lastError = ""; } catch { lastSuccess = false; 
        
        lastError = "Call failed"; 
        } 
    }

    function decodeRevertMessage( bytes memory _data ) public pure returns (string memory) { 
        
        if (_data.length < 4) { return "Unknown revert reason"; } bytes4 selector; 
        
        assembly { selector := mload( add(_data, 32) ) } 
        
        if ( selector == bytes4(0x08c379a0) ) { bytes memory reasonData = new bytes( _data.length - 4 ); 
        
        for ( uint256 i = 4; i < _data.length; i++ ) 
        
        { reasonData[i - 4] = _data[i]; } return abi.decode( reasonData, (string) ); 
        
        } return "Unknown revert reason"; 
        
    }

    function contractBalance() external view returns (uint256) { 
        
        return address(this).balance; 
        
    }    
}