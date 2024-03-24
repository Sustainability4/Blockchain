pragma solidity ^0.4.25;

import "./zombiefactory.sol";

// whenever we needd to interact with an external function on the blockchain we need to define an interface to suggest through which function we
// want our interaction with from the contract. 
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

contract ZombieFeeding is ZombieFactory {

  KittyInterface kittyContract; // we are calling the interface function. Although we need an address of the contract to interact with interface 

  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  // we are not hard coding the address just to make sure that the immutability feature of our contract doesn't give us problems in future. 
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address); // we are initialising our kitty contract using the address to the external contract we need to read from
  }

  // There are two important types of fucntions : internal and external ; internal function can only be assessed from within the function and also from
  // the functions that inherit from the contract. external can only be called outside the contract, they cannot be used from iside a contract
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  // in this function the idea of onlyOwnerOf is a function modifier which will restrict this function to only the owner of the contract. 
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId]; // storage and memory variable differ in terms that storage variables get permanently stored on
    // on a blockchain whereas memory variables get stored in a copy and are removed from the storage once the function call is over. 
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId); // A very classic example of handling multiple return values in solidity 
    // we just need to put the last variable with commas in the beginning to make sure that we are only getting the last return variable not the whole
    // thing. 
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
