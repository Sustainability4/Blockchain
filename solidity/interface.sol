// contract acts like a class. Another contract can inherit from the contract considered as base
// Although solidity supports multiple inheritance but it introduces a problem called the diamond problem. 
// When the contract inherit only a single contract is created on solidity. 
// Base contract contructor is automatically called.

//SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.5.0 <0.9.0;

/*
contract BaseContract{
    // contract has two state variables
    int public x;
    address public owner; 

    constructor(){
        x = 5;
        owner = msg.sender;
    }

    function setx(int _x) public {
        x = _x;
    }

}
*/

// An abstract contract is the one with atleast one function that is not implemented
// Abstract contract cannot be deployed 
abstract contract BaseContract{
    // contract has two state variables
    int public x;
    address public owner; 

    constructor(){
        x = 5;
        owner = msg.sender;
    }

    function setx(int _x) public virtual; // Function without the implementation must be marked virtual
    // Also the function inheriting the contract must implement the virtual function. 
    // Or if not implementing the function contract that inherits from the basecontract must also be marked abstract

}

contract A is BaseContract{ // basic inheritance of contract A from BaseContract
    //Contract A can add its own functionality 
    uint y = 7;
    // While deploying this contract the base contract does not get deployed on solidity
    // one can override the function from the base contract but not the state variable 
    function setx(int _x) public override{
        x = _x;
    }
}

// Interfaces are similar to abstract contract but cannot have functions implemented 
// They cannot inherit from other contracts but can inherit from other interfaces
// All declared functions must be external
// They cannot declare a constructor or state variables
// interface is created using interface keyword instead of contract
// Functions of the interface are external in character.
