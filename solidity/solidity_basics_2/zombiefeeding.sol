pragma solidity >=0.5.0 <0.6.0;

// In order for inheritance to work we need to import the main file here. We need to import zombiefactory.sol. 
import "./zombiefactory.sol";

// There are two interesting types of function definition : internal and external. Internal are functions that are like private but can be called by teh contracts that inherit from the 
// base contract. External are functions very similar to public but can only called by functions outside the contract not inside the contract.

// In order to interact with functions openly defined on the blockchain we need to first define an interface for that function and under that interface we just need to mention the function that
// we wish to call. Although the way we define this function is not at all similar to the function defined inside a contract. 
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

// Look at inheritance being defined here. 
contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // This is how we call the cryptokittoies function using teh interface we created. We need to pass on the address to use this function. 
  KittyInterface kittyContract = KittyInterface(ckAddress);

  // Modify function definition here:
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId]; // there are two types of storage in solidity, memory and storage. Storage permanently stores the variable on teh blockchain memeory and memory makes a temporary storage
    // Solidity automatically deals with the issue. All the variables defined outside a function are considered as storage automatically and within teh functions as memory. 
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;

    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId); // This is how we handle the return of multiple values. The idea here is that the values that we do not wish to take into account 
    // we can represent them by a comma and only we can take teh variable we need by the name. In this case we want genes. 
    // And modify function call here:
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
