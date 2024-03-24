/* Ganache provides a way to move forward in time through two helper functions:

evm_increaseTime: increases the time for the next block.
evm_mine: mines a new block.
You don't even need a Tardis or a DeLorean for this kind of time travel.

Let me explain how these functions work:

Every time a new block gets mined, the miner adds a timestamp to it. Let's say the transactions that created our zombies got mined in block 5.

Next, we call evm_increaseTime but, since the blockchain is immutable, there is no way of modifying an existing block. So, when the contract checks the time, it will not be increased.

If we run evm_mine, block number 6 gets mined (and timestamped) which means that, when we put the zombies to fight, the smart contract will "see" that a day has passed.
*/

async function increase(duration) {

    //first, let's increase time
    await web3.currentProvider.sendAsync({
        jsonrpc: "2.0",
        method: "evm_increaseTime",
        params: [duration], // there are 86400 seconds in a day
        id: new Date().getTime()
    }, () => {});

    //next, let's mine a new block
    web3.currentProvider.send({
        jsonrpc: '2.0',
        method: 'evm_mine',
        params: [],
        id: new Date().getTime()
    })

}

const duration = {

    seconds: function (val) {
        return val;
    },
    minutes: function (val) {
        return val * this.seconds(60);
    },
    hours: function (val) {
        return val * this.minutes(60);
    },
    days: function (val) {
        return val * this.hours(24);
    },
}

module.exports = {
    increase,
    duration,
};
