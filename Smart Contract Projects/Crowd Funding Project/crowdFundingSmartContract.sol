//SPDX-License-Identifier: GPL-3.0
// events are logger facility in solidity. Java scvript callback function will listen to the event and update
// the frontend. Events can only be accessed by the external actors like JS.
// we use event keywrod to declare function and use emit to update the event

pragma solidity >= 0.6.0 <0.9.0;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public admin;
    uint public numberOfContributors;
    uint public minimumContribution;
    uint public deadline; // timestamp
    uint public goal;
    uint public raisedAmount;
    struct Request{ // As this struct has a mapping inside it and hence we cannot have array of storage on this
    // struct variable.
        string description;
        address payable recepient;
        uint value;
        bool completed;
        uint numberOfVoters;
        mapping(address=>bool) voters; // default value of bool type is false
    }
    mapping(uint=>Request) public requests;
    uint public numRequests;

    constructor(uint _goal, uint _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address _recepient, uint _value);
    event MakePaymentEvent(address _recepient, uint _value);

    function contribute() public payable{
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimum contribution not met");

        if (contributors[msg.sender]==0){
            numberOfContributors++;
        }

        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);
    }

    receive() payable external{
        contribute();
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getRefund() public {
        require(block.timestamp > deadline && raisedAmount < goal, "Conditions not met for Refund");
        require(contributors[msg.sender]>0);

        address payable recepient = payable(msg.sender);
        uint value = contributors[msg.sender];
        recepient.transfer(value);

        contributors[msg.sender] = 0;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Only Admin can call this function");
        _;
    }

    function createRequest(string memory _description, address payable _recepient, uint _value) public onlyAdmin(){
        Request storage newRequest = requests[numRequests];// storage is needed as we have a mapping in a struct
        numRequests++;
        newRequest.description = _description;
        newRequest.recepient = _recepient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.numberOfVoters = 0;

        emit CreateRequestEvent(_description, _recepient, _value);
    }

    function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender]>0, "Must be a contributor to vote");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender]==false,"You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.numberOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin(){
        require(raisedAmount>= goal);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "The request has been completed");
        require(thisRequest.numberOfVoters > numberOfContributors/2);

        thisRequest.recepient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit MakePaymentEvent(thisRequest.recepient, thisRequest.value);
    }

}
