## Obtained from the Course : [Link](https://cryptozombies.io/en/course)

### Idea on the usage of GAS

gas is like the money we spend in solidity. Gas depends upon the space optimisation and the computation optimisation of the solidity code. Hence space and time complexity become very important for a solidity code. Space needs to be optimised by using fifferent versions of the variables like uint. uint is a 256 bit but we may not need such a heavy storage and hence we can turn back onto uint 8 or uint 16. Also while defining these units in a struct its very important to keep them packed closed. For e.g. uint 16 should be packed near uint 16 and similarly for other uint variables.

View and Pure functions does not cost gas technically. Also, the memory storage is better than permanent storage as permanent storage cost significant gas. 

### Deployment with Truffle
1. Make sure that the npm and node has been installed on your computer
2. Create a directory, cd into the directory
3. run npm install truffle -g  (-g makes it globally available)
4. run truffle init (it will create the directory structure as below)
```
├── contracts (storing all the contract code, it automatically creates a contract file called migrations.sol)
│   ├── Migrations.sol
├── migrations (migrations contain java script files that tells truffle how to deploy the contract)
│   ├── 1_initial_migration.js
├── dist (or build
├── test (test cases as once the solidity code is deployed on the ethereum it can't be changed)
├── truffle-config.js
└── truffle.js
```
5. We will be using infura so that we do not have to create our own ethereum blocks and it is hard to manage the keys using infura so we will need a hd wallet which we will install using  npm install truffle-hdwallet-provider
6. execute truffle compile in order to compile the project as truffle can't understand solidity and has to use a byte code to convey things
7. Migration.sol captures all teh history of changes one made to their smart contracts, so that we do not deploy the same contract again and again.
8. We can modify the migration file 1_initial_migrations.js in order to make our contract migrate
9. We need to update the truffle.js file in order to make sure we add enough information for it to deploy on ethereum or rinkyby or other networks. We need to create our own private key as well. Usually as a safe practice one should read the private key from a file put under gitignore.
```
//1. Initialize `truffle-hdwallet-provider`
const HDWalletProvider = require("truffle-hdwallet-provider");
// Set your own mnemonic here
const mnemonic = "YOUR_MNEMONIC";

// Module exports to make this configuration available to Truffle itself
module.exports = {
  // Object with configuration for each network
  networks: {
    // Configuration for mainnet
    mainnet: {
      provider: function () {
        // Setting the provider with the Infura Mainnet address and Token
        return new HDWalletProvider(mnemonic, "https://mainnet.infura.io/v3/YOUR_TOKEN")
      },
      network_id: "1"
    },
    // Configuration for rinkeby network
    rinkeby: {
      // Special function to setup the provider
      provider: function () {
        // Setting the provider with the Infura Rinkeby address and Token
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/YOUR_TOKEN")
      },
      network_id:4 //Fill in the `network_id` for the Rinkeby network.
    }
  }
};
```
10. truffle migrate --network rinkeby. We first deploy on rinkeby as it does not consume ether and help us test our code before we deploy it to the mainnet. truffle migrate --network mainnet. One can add other methods to the above file truffle.js and can have deployment made to those networks.

### Testing Code 

We have build our project for deployment and we have also learned how to deploy. After building our directory will look something like this: 
```
├── build
  ├── contracts
      ├── Migrations.json
      ├── CryptoZombies.json
      ├── erc721.json
      ├── ownable.json
      ├── safemath.json
      ├── zombieattack.json
      ├── zombiefactory.json
      ├── zombiefeeding.json
      ├── zombiehelper.json
      ├── zombieownership.json
├── contracts
  ├── Migrations.sol
  ├── CryptoZombies.sol
  ├── erc721.sol
  ├── ownable.sol
  ├── safemath.sol
  ├── zombieattack.sol
  ├── zombiefactory.sol
  ├── zombiefeeding.sol
  ├── zombiehelper.sol
  ├── zombieownership.sol
├── migrations
└── test
. package-lock.json
. truffle-config.js
. truffle.js
```
Test folder will help us provide for tests within the java script and solidity both. We will keep things in java for now. 
1. Lets create a java script file : touch test/CryptoZombies.js
2. Everytime we build a contract using truffle, it produces a json file for our solidity code containing the bytecode references and saves it in build/contracts. We need to load the build artifacts of the contract in our test file in order for truffle to understand on how to format our function cells. We will use contract abstraction for this as this will hide the complexity of the solidity contract and will provide an easy way to interact with it. 
3. Before deploying the contract on ethereum its always better to test the code locally. **Ganche** helps us to test our code locally, it sets up an ethereum environment locally for us. Everytime ganache startes it creates 10 different accounts with 100 ethers to make testing easier. These accounts are adjacent to each other and hence we can access them using an array but its difficult for comprehension.
4. Callback parameter is the one that talks to the blockchain which means that the function is asynchronous. We may use await keyword to make sure that the function waits for the return to be there.
5. Usually, every test has the following phases:
      1. set up: in which we define the initial state and initialize the inputs.
      2. act: where we actually test the code. Always make sure you test only one thing.
      3. assert: where we check the results.
6. There is a concept of hooks in truffle and ganache. What hooks do is that they help us create some calls that needs to be run before each test. Each test is a independent snippet in itself. The test needs to create a new instance always before it excutes itself. Hence rather than writing this script with every test snippet we can centralise it. Similarly we can have an after.each function which can self destruct the instance after the test is executed as we do not want our blockchain to bloat.
7. One can group tests using a context function. Which allows you to group similar tests together and make the code more scalable. 


