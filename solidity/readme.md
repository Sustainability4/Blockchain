## Obtained from the Course : [Link](https://cryptozombies.io/en/course)

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

### Testing Code with Ganache 




