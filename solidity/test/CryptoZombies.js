const CryptoZombies = artifacts.require("CryptoZombies"); // abstraction of the contract 
const utils = require("./helpers/utils");// importing other util and helper functions 
const time = require("./helpers/time");
// definining abstract variable to replace assert 
var expect = require('chai').expect; // chai is a very interesting library it helps replace assert function as this function might not be readable by truffle
const zombieNames = ["Zombie 1", "Zombie 2"];
contract("CryptoZombies", (accounts) => {
    let [alice, bob] = accounts; // initilisation of alice and bob for simplicity, ganache creates 10 blockc in array but its not easy to reference every time
    let contractInstance; 
    // Before each and after each functions. before each helps to execute this function before every test case run and after each can be defined in a sam e way 
    /* If you really, really want to achieve mastery, go ahead and read on. Otherwise... just click next and off you go to the next chapter.

You still around?😁

Awesome! After all, why would you want to deny yourself a whole lot of awesomeness?

Now, let's circle back to how contract.new works. Basically, every time we call this function, Truffle makes it so that a new contract gets deployed.

On one side, this is helpful because it lets us start each test with a clean sheet.

On the other side, if everybody would create countless contracts the blockchain will become bloated. We want you to hang around, but not your old test contracts!

We would want to prevent this from happening, right?

Happily, the solution is pretty straightforward... our contract should selfdestruct once it's no longer needed.

The way this works is as follows:

first, we would want to add a new function to the CryptoZombies smart contract like so:

function kill() public onlyOwner {
   selfdestruct(owner());
}
Note: If you want to learn more about selfdestruct(), you can read the Solidity docs here. The most important thing to bear in mind is that selfdestruct is the only way for code at a certain address to be removed from the blockchain. This makes it a pretty important feature!

next, somewhat similar to the beforeEach() function explained above, we'll make a function called afterEach():

afterEach(async () => {
   await contractInstance.kill();
});
Lastly, Truffle will make sure this function is called after a test gets executed.

And voila, the smart contract removed itself!*/
    beforeEach(async () => {
        contractInstance = await CryptoZombies.new();
    });
    it("should be able to create a new zombie", async () => {
        const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
        expect(result.receipt.status).to.equal(true);
        expect(result.logs[0].args.name).to.equal(zombieNames[0]);
    })
    it("should not allow two zombies", async () => {
        await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
        await utils.shouldThrow(contractInstance.createRandomZombie(zombieNames[1], {from: alice}));
    })
    context("with the single-step transfer scenario", async () => {
        it("should transfer a zombie", async () => {
            const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
            const zombieId = result.logs[0].args.zombieId.toNumber();
            await contractInstance.transferFrom(alice, bob, zombieId, {from: alice});
            const newOwner = await contractInstance.ownerOf(zombieId);
            expect(newOwner).to.equal(bob);
        })
    })
    // context function helps group multiple tests into one. If we put x before any context function or it. That test will get skipped. 
    context("with the two-step transfer scenario", async () => {
        it("should approve and then transfer a zombie when the approved address calls transferFrom", async () => {
            const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
            const zombieId = result.logs[0].args.zombieId.toNumber();
            await contractInstance.approve(bob, zombieId, {from: alice});
            await contractInstance.transferFrom(alice, bob, zombieId, {from: bob});
            const newOwner = await contractInstance.ownerOf(zombieId);
            expect(newOwner).to.equal(bob);
        })
        it("should approve and then transfer a zombie when the owner calls transferFrom", async () => {
            const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
            const zombieId = result.logs[0].args.zombieId.toNumber();
            await contractInstance.approve(bob, zombieId, {from: alice});
            await contractInstance.transferFrom(alice, bob, zombieId, {from: alice});
            const newOwner = await contractInstance.ownerOf(zombieId);
            expect(newOwner).to.equal(bob); // implementation of chai 
         })
    })
    it("zombies should be able to attack another zombie", async () => {
        let result;
        result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
        const firstZombieId = result.logs[0].args.zombieId.toNumber();
        result = await contractInstance.createRandomZombie(zombieNames[1], {from: bob});
        const secondZombieId = result.logs[0].args.zombieId.toNumber();
        await time.increase(time.duration.days(1));
        await contractInstance.attack(firstZombieId, secondZombieId, {from: alice});
        expect(result.receipt.status).to.equal(true);
    })
})
