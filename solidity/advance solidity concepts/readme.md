1. The solidity contract is immutable in character. Once the contract is on ethereum blockchain we cannot change the contract. We need to be very careful about writing the contract.
2. An ownable contract is created to ensure that our external functions are only called by the owners and not everyone and anyone.
3. There is a gas fee to run functions on solidity and hence code optimisation becomes very important.
4. The global variables defined in a solidity contract will have a uint 256 no matter which uint type we use but in case of a struct uint can be defined for 8 bits, 16 bits or 32 bits.
5. Also inside the struct the similar units placed closer helps solidity minimise the space occupation as well.
6. Computation and space complexity are very essential to reduce teh gas fees.
7. Time units in solidity are very well defined, we will have a now variable to access the time now which is the time from the creation of the block to now in seconds. Solidity uses other units of time like days,seconds, minutes, hours and weeks.
8. Passing the struct to a private function one can pass the pointer to the struct
9. view functions called externally do not charge any gas fees. If a view function is called internally it will cost gas fees as it will create transaction across every node in order to verify teh function.
10. In case of ethereum for loops are sometimes better in terms of gas fees as storage can be very costly on ethereum blockchain.
11. We should use memory key to make sure we minimize storage as storage key will permanently store the variable on blockchain. Although solidity take care of variable types itself but its better to not use storage functionality.
