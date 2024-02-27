// solidity code should start with pragma version. this is very helpful as this prevents issues with future compiler versions. It helps define consistency across the entire code.
// every solidity code is encapsulated within a contract. It is the basic construct in solidity

pragma solidity >=0.5.0 <0.6.0; // version in solidity

// basic construct in solidity everything starts with a contract 
// state variables are permanently stored in contract storage. This means that they are written to ethereum blockchain. Think of them like writing to the DB
contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16; // this will be permanently stored in the database on blockchain. unint normally meant for uint 256 if we need 8,16 or 32 bits uint then we need to put it like uint8, uint16, etc.
    uint dnaModulus = 10 ** dnaDigits; // mathematical operations in solidity are very similar to most of the mathematical operations like +,-,/,*. Modulus %, exponential **

    // structs can be considered as the classes within the contract they help extend your variable properties
    // in the below example we can define a struct zombie with two interesting properties name and dna. 
    struct Zombie {
        string name;
        uint dna;
    }

    // One can see two types of arrays in solidity, one is dynamic array and other is fixed array. 
    // fixed arrays are defined as Zombie[3] public zombies;
    // We can create public arrays and hence solidity will itself create a getter method for that. Other contracts will be able to read from but not write back to this array.It is a useful pattern 
    // of storing public data in your contract. 
    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1; // push is used to append to the array the new value
        emit NewZombie(id, _name, _dna);
    }

    // Look at the function declaration in solidity 
    // look at the parameters declaration, we need to specify the data types of the parameters 
    // memory helps pass the variable into the function by value which means it will create a copy of the variable. 
    // other way of passing the value is by reference i.e the function will take in the variable by reference and if in the course of oepration of the function the variable changes it will also change the original value of the function
    // passing the variable name with underscore is a convention in order to differntiate them for global variables 
    // in solidity functions are considered private by default that means anyone can call the function and execute. It is a good practice to make all the function private and only change them back to public if we need them. 
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
