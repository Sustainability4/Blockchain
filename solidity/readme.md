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
6. 



