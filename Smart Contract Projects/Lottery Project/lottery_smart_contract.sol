//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    // We need to declare a dynamic array as we do not know how many people will be entering the lottery
    address payable[] public players;
    // We have provided the address of the manager as someone who deploys the contract and also manages it
    address public manager;

    constructor(){
        // We are providing the address of the manager as the person who deploys the contract 
        // The contructor will be called only once as it deploys the contract
        manager = msg.sender;
    }

    receive() external payable {
        // We need to convert the address to payable before pushing it to the array as we have the array 
        // of payable addresses. 
        // checking only 0.1 ether was sent to the contract 
        require(msg.value == 0.1 ether, "Please send only 0.1 ether for the lottery");
        players.push(payable(msg.sender));
    }

    function get_balance() public view returns(uint){
        // returns the balance of the smart contract
        // only manager can see the balance of the contract
        require(msg.sender == manager, "Only manager of the contract has the permission to see the balance of the contract");
        return address(this).balance;
    }

    function random() public view returns(uint){
        // This function is used for generating a random integer in order to pick up a winner
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public{
        // Only manager can call the pick winner
        require(msg.sender == payable(manager), "Only manager is allowed to call this function");
        require(players.length >= 3, "There should be more than three or three players to pick a winner");

        uint random_number = random();
        address payable winner;

        uint index = random_number % (players.length);

        winner = players[index];
        // Transferring the lottery fund to the winner
        winner.transfer(get_balance());
        // resetting the lottery 
        players = new address payable[](0);
    }

}
