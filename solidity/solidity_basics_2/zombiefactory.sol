pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // Mappings are an organised way of storing data in a key value pair. You can refernce them as dictionary for solidity.
    mapping (uint => address) public zombieToOwner; // mapping key is uint and it holds the account address of the user. On blockchain every account has a unique address. This mapping has been made public
    mapping (address => uint) ownerZombieCount; // the adress key is mapped to a number which is the owner's zombie count.

    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++; // There are some global variables in solidity that everyone can benefit from. There is something like msg.sender which stores the address of the personwho called the function
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0); // require function is a condition check for the function to execute. It should not be the case that the person is able to create unlimited zombies. It should
        // be able to create only one zombie. Later that person can eat a zombie to create more zombies. If this condition does not meet the function will not execute. 
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
// There is a concept of inheritence in solidity as well. The idea is that we cannot have one contract very long.That is not a good way to oraganise our code. We need to make sure that we define a 
// new contract saying that contract Zombiefeeding is Zombiefactory{} This will make sure that Zombiefeeding has access to all the public functions of Zombiefactory.
