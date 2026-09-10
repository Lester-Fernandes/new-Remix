// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract DataStorageVul {
//     /*
//         STORED VALUE
//     */
//     uint256 public storedNumber;

//     /*
//         TRACK LAST CALLER
//     */
//     address public lastCaller;

//     /*
//     =====================================================
//     STORE NUMBER
//     =====================================================
//     */

//     function setNumber(uint256 _number )  external {

//         /*
//             Save input.
//         */
//         storedNumber = _number;

//         /*
//             Store msg.sender.

//             IMPORTANT:
//             This will become
//             calling contract address
//             during nested execution.
//         */
//         lastCaller = msg.sender;
//     }

//     /*
//     =====================================================
//     READ VALUE
//     =====================================================
//     */

//     function getNumber() external view returns (uint256){

//         return storedNumber;
//     }
// }

// /*
// =========================================================
// CALLER CONTRACT
// =========================================================
// */

// contract NestedCallerVul {
//     /*
//         TARGET CONTRACT
//     */
//     DataStorageVul public target;

//     /*
//         TRACK LOCAL EXECUTION
//     */
//     uint256 public localCounter;

//     /*
//         STORE LAST READ VALUE
//     */
//     uint256 public lastReadValue;

//     /*
//         CONSTRUCTOR
//     */
//     constructor(address _target) {
//         /*
//             Save target contract reference.
//         */
//         target = DataStorageVul(_target);
//     }

//     /*
//     =====================================================
//     CALL TARGET CONTRACT
//     =====================================================
//     */

//     function callSetNumber( uint256 _number ) external {
//         /*
//             Local state update.
//         */
//         localCounter++;

//         /*
//             EXTERNAL CONTRACT CALL

//             Execution jumps into:
//             DataStorage.setNumber()
//         */
//         target.setNumber(_number);
//     }

//     /*
//     =====================================================
//     READ FROM TARGET CONTRACT
//     =====================================================
//     */

//     function readTargetNumber()  external {
//         /*
//             Nested external read.
//         */
//         uint256 value = target.getNumber();

//         /*
//             Save locally.
//         */
//         lastReadValue = value;
//     }
// }

contract DataStorage {
    uint256 public storedNumber; 
    
    address public lastCaller; 
    
    uint256 public callbackCounter;

    event NumberStored( address indexed caller, uint256 number ); 
    
    event ETHReceived( address indexed sender, uint256 amount );

    function setNumber( uint256 _number ) external { 
        
        storedNumber = _number; 
        
        lastCaller = msg.sender; 
        
        emit NumberStored( msg.sender, _number ); 
        
    }

    function failFunction() external pure { 
        
        revert("DataStorage failure"); 
    }

    function callback() external { 
        callbackCounter++; 
    }

    receive() external payable { 
        
        emit ETHReceived( msg.sender, msg.value ); 
        
    }

    function contractBalance() external view returns (uint256) {
        
         return address(this).balance; 
        }
}

contract NestCall {
    DataStorage public target; 
    
    uint256 public localCounter; 
    
    uint256 public lastReadValue; 
    
    bool private locked;

    event TargetCalled( address indexed target, uint256 number ); 
    
    event CallFailed( string reason ); 
    
    event ETHSent( address indexed target, uint256 amount );

    constructor( address  payable _target ) {
        
         require( _target != address(0), "Invalid target" ); 
         
         target = DataStorage(_target); 
        }

        modifier nonReentrant() { 
            
            require( !locked, "Reentrancy blocked" ); 
            
            locked = true; 
            _; 
            
            locked = false; 
    }

    function callSetNumber( uint256 _number ) external nonReentrant { 
        
        localCounter++; 
        
         target.setNumber( _number ); 
         
         emit TargetCalled( address(target), _number ); 
    }

    function readTargetNumber() external { 
        
        uint256 value = target.storedNumber(); 
        
        lastReadValue = value; 
    }

    function lowLevelSetNumber( uint256 _number ) external nonReentrant { 
        
        localCounter++; 
        
        ( bool success, bytes memory data ) = address(target).call( abi.encodeWithSignature( "setNumber(uint256)", _number ) ); 
        
        if (!success) { string memory reason = decodeRevertMessage(data); 
        
        emit CallFailed( reason ); revert(reason); } 
        
        emit TargetCalled( address(target), _number ); 
        
    }

    function failingNestedCall() external nonReentrant { 
        
        localCounter++; 
        
         target.failFunction(); 
         
    }

    function tryCatchFailingCall() external nonReentrant { 
        
        localCounter++; 
        
        try target.failFunction() { 
            
            emit TargetCalled( address(target), 0 ); } catch Error( string memory reason ) { 
                
            emit CallFailed( reason ); 
            
            revert(reason); } catch { emit CallFailed( "Unknown failure" ); 
            
            revert( "Unknown failure" ); 
        } 
    }

      function sendETHToTarget() external payable nonReentrant { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        ( bool success, ) = payable(address(target)).call{ value: msg.value }("");
        
         require( success, "ETH transfer failed" ); 
         
         emit ETHSent( address(target), msg.value ); 
    }  

    function lowLevelETHTransfer( address payable _receiver ) external payable nonReentrant { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        ( bool success, bytes memory data ) = _receiver.call{ value: msg.value }(""); 
        
        if (!success) { string memory reason = decodeRevertMessage(data); 
        
        emit CallFailed( reason ); revert(reason); } 
        
        emit ETHSent( _receiver, msg.value ); 
        
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

contract MaliciousCallback {
    
     NestCall public target; 
     
     uint256 public attackCount; 
     
     uint256 public maxAttacks = 3; 
     
     bool public attacking;

    event CallbackAttempt( uint256 count );

    constructor( address payable _target ) { 
        
        require( _target != address(0), "Invalid target" ); 
        
        target = NestCall(_target); 
    }

    function startAttack() external { 
        
        attackCount = 0; 
        
        attacking = true; 
        
        target.callSetNumber(100); 
        
        attacking = false; 
    }

    fallback() external { 
        
        if ( attacking && attackCount < maxAttacks ) { attackCount++; 
        
        emit CallbackAttempt( attackCount ); 
        
       target.callSetNumber(200); 
       
       } 
    }

    receive() external payable { 
        
        if ( attacking && attackCount < maxAttacks ) { attackCount++; 
        
        emit CallbackAttempt( attackCount ); 
        
        target.callSetNumber(200); 
        
        } 
    }
    function contractBalance() external view returns (uint256) { 
        return address(this).balance; 
    }
}