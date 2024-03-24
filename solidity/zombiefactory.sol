// version pragma is used to esnure a similar environment for all the solidity codes. 
pragma solidity ^0.4.25;

import "./ownable.sol"; // importing other scripts 
import "./safemath.sol";

// contract is the basic building block of solidity. even the solidity libraries are written as contracts.
// Look at the inheretance created for ZombieFactory function as it inherits from Ownable
contract ZombieFactory is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  // event are way to communicate what is happenning in our contract to the front end. 
  event NewZombie(uint zombieId, string name, uint dna);

  // uint is an unsigned integer and is stored in the contract memory if declated like below. 
  // uint cannot have negative values it needs to have only non-negative values. 
  // like uint there is an int variable that can have negative values. 
  // by default uint is 256 bits but it can be 32 bits or it can be 16 bits or 8 bits 
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  /* struct help us define a critical datatype with many properties. We have defined a zombie struct below with various properties */
  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  // Arrays can be fixed or dynamic in character. The array below is a dynamic array. a fixed array will have a fix size 
  // Zombie[8] this is a fixed array. The declaration that the array is public means that this array can be read from but cannot be wrote to.
  // As soon as we declare an array public a getter method will be declared for that array. 
  Zombie[] public zombies;

  // Mappings and address are datatypes which helps map a variable to another variable 
  // Address is a datatype which helps define address. 
  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;

  // function declaration in solidity happens as below 
  // public : anyone can call this function
  // private : only functions within the contract can call this function 
  // internal : can be accessed from inside but not outside 
  // external 
  // view : function only views the data but not modify it 
  // pure : functions does not even view the data or access it within the contract. 
  // payable
  // modifiers 
  function _createZombie(string _name, uint _dna) internal {
    // push function help us push new values to array
    uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    zombieToOwner[id] = msg.sender; // msg.sender is a global variable which will give us the address of the sender who called the function.
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
    // emit is used to communicate the information to an event. 
    emit NewZombie(id, _name, _dna);
  }

  // One can also pass the function parameter like in this case _str as a memory parameter. 
  // If we pass the variable as memory, function creates the copy of the variable and then use it. 
  // it helps trump any changes made to the variable inside the function. 
  function _generateRandomDna(string _str) private view returns (uint) {
    // keccak is a hash algorithm that we are using to genrate the random numbers 
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    // typecasting is casting a particular variable on a variable type. 
    return rand % dnaModulus;
  }

  function createRandomZombie(string _name) public {
    require(ownerZombieCount[msg.sender] == 0); // this is a necessary condition for this function to execute
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createZombie(_name, randDna);
  }

}
