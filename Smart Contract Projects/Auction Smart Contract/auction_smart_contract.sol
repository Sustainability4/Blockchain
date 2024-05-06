//SPDX-License-Indentifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Auction {
    /* 
    Step 1 : Declare the state variables. 
    */
    // This variable will store the address of teh owner and this address is payable i.e can receive ether
    address payable public owner;
    // good practice is to use the time according to the block number as block.timestamp can be easily spoofed by the miners 
    uint public startBlock;
    uint public endBlock;
    // Saving information about the product being auctioned on blockchain is very costly so we may use IFS or Inter-Planetary File System
    // We will save only the IPFS hash in the smart contract 
    string public ipfsHash;
    // We will also save the state of the auction which can be running, started or ended 
    // Note we do not use the semicolons here
    enum State {Started, Running, Ended, Cancelled}
    // Decalre a variable to describe state 
    State public auctionState;

    // Highest binding bid, highest bidder 
    uint public highestBindingBid;
    address payable public highestBidder;

    // declaring a mapping variable to map the bids of each of the bidder 
    mapping(address => uint) public bids;

    // Now we need to add the bid increaments to which the contract variable will automatically bid the increaments 
    uint bidIncreament;

    /*
    Step 2 : Declaring the Constructor
    */

    constructor (){
        owner = payable(msg.sender); // notice we converted msg.sender to the payable address as owner has been declared payable.
        auctionState = State.Running;
        startBlock = block.number; // starting the auction, we can start the auction in future by using that one block gets generated on ethereum every 50 seconds 
        // Lets say you want to end auction a week later : number of blocks = 7*24*60*60/50 = 40320
        endBlock = startBlock+40320;
        ipfsHash = ""; // initialising it to empty string
        bidIncreament = 100; // putting an increament of 100 wei
    }

    /*
    Step 3 : Write Functions and modifiers
    */

    // function modifiers : modifies the functions and save writing unnecessary codes. It is usually used in place of require function. 
    // We can have one function for one condition. This way code becomes more manageable

    modifier notOwner(){
        require(owner != msg.sender, "Owner cannot call this function");
        _; // Note this special statement. Its tehre on every modifier. Function body is inserted in underliend part whenever the modifier applies to the function. 
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "Only owner can call this function");
        _; // Note this special statement. Its tehre on every modifier. Function body is inserted in underliend part whenever the modifier applies to the function. 
    }
    // Placing modifiers for start and end block so that bid can only be placed during that period
    modifier afterStart() {
        require(block.number>=startBlock, "Auction should start before the bid is placed");
        _;
    }

    modifier beforeEnd() {
        require(block.number<endBlock, "Auction already ended");
        _;
    }

    // Also we need to make sure that the state of the auction is Running
    modifier isRunningState(){
        require(auctionState == State.Running, " The status of the auction is not Running");
        _;
    }
    // Creating the min function : helper function as there is no min functionality in solidity
    function min(uint a, uint b) pure internal returns(uint){
        if (a<=b) {
            return a;
        }else {
            return b;
        }
    }

    function placeBid() public payable notOwner() afterStart() beforeEnd() isRunningState(){
        require(msg.value>=100, "The bid should be greater than 100 wei");

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid>highestBindingBid,"Your bid is lesser than or equal to highest binding bid");
        bids[msg.sender] = currentBid;

        if (currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid+bidIncreament,bids[highestBidder]);
        }else{
            highestBindingBid = min(currentBid,bids[highestBidder]+bidIncreament);
            highestBidder = payable(msg.sender);
        }
    }

    function cancelAuction() public onlyOwner(){
        auctionState = State.Cancelled;
    }

    // In order to avoid attacks withdrawal patters are used where the owner of the moeny can withdraw money but teh smart contract will not send the bidders money on
    // its own. This helps reduce teh re-entrance attacks. 

    function finalizeAuction() public {
        require(auctionState == State.Cancelled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender]>0);

        
        address payable recepient;
        uint value;

        if (auctionState == State.Cancelled){ // auction cancelled 
            recepient = payable(msg.sender);
            value = bids[msg.sender];
        }else{ // if the auction ended not cancelled
            if (msg.sender == owner){
                recepient = owner;
                value = highestBindingBid;
            }else{// this is the bidder
                if (msg.sender == highestBidder){
                    recepient = highestBidder;
                    value = bids[highestBidder]- highestBindingBid;
                }else{ // neither highest bidder nor teh owner
                    recepient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }
        recepient.transfer(value);
    }

}
