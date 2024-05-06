Smart contract for decentralised auction like an alternative for ebay. 
1. Auction has an owner ( aperson who sells goods and services), a start and an end date.
2. The owner can cancel the auction if there is an emergency or can finalize the auction after its end time.
3. People can send ether by calling the function called placeBid(). The senders address and the value sent to the auction will be stored in mapping variables called bids.
4. Users are incentivised to bid the maximum they are willing to pay but they are not bound to that full amount but rather to the previous highest bid plus an increment. The contract will automatically bid up to a given amount.
5. Highest binding bid is the selling price and the highest bidder won the auction
6. After the auction ends the owner gets the highestBindingBid and everybosy else withdraw their own amount
