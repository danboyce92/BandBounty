# BandBounty


# *Things to note*

## **setState function**
setState should only be accessible by the admin. Because each contract is deployed by the factory and not the admin, msg.sender does not work anymore with onlyOwner modifier. For this reason, until a solution is discovered, *I have to manually put in the admin address into the setState function whenever this is deployed to a testnet for display.*

## **Red, Yellow and Green States**
Using modifiers, some functions can be restricted depending on what state they need to be in in order for the function run. 
### Red ____
 indicates that the Bounty is void because it has either run out of time or the band has declined. This state deactivates the contribute function and activates the refund function.
### Yellow ____
 indicates that the bounty is currently in the contribution phase, this state will either expire and turn to the Red state after 90 days or be green lit by having the band accept and having set a target
### Green ____
 indicates that the bounty has been green lit by the band and has the potential to go ahead. If a project is green lit, the possibility of adding vip tickets becomes available. If a band has agreed to such things, meet + greets, attending soundchecks etc, can be added to increase the chance of reaching the target required for the show to go ahead. After 90 days, if the target hasn't been met the bounty should expire and the state should change to red.

## **How do I incorporate time?**
Time is another issue. I want Bounties to change state to Red if 90 days pass without a yellow contract being greenlit or a greenlit contract reaching it's target. How do trigger a function autonomously?
I have the contribute function set to expire after 90 days and change the state to red. Issue with this is that I need to change it so that if the bounty is green lit it, the expiration will adjust to 90 days from when that occurs. Right now regardless of the green state, it will expire after 90 days.

Timing in contribution function appears to be fixed, add some tests to verify that it works as expected.

## **How do I incorporate a price feed oracle?**
Getting a price feed oracle set up is important if I want to be able to set the contribution prices to a set number like for example 50$ for a standard ticket, 100$ for a vip etc.
Right now they contribute a fixed number of wei, change this.

Function reverts..

call to Bounty.getTicketFee errored: VM error: revert.

revert
	The transaction has been reverted to the initial state.
Note: The called function should be payable if you send value and the value you send should be less than your current balance.
Debug the transaction to get more information.

_________________________________

### Processing

#### Target complete
Need to set target, need to set trigger to red state if target is not met within time limit, and also need to protect from red state if target is met within time limit.

Should setState be protected with a uint or a bool? Which is cheaper?

__________________________________

### Things beyond the scope of this project.
The focus of this project is to get a nice smooth working front end with an idea incorporating the ethereum blockchain. This is not intended to be a finished project but something to help me picture what one would require. Things that I would add or change about this project if I gave it more time.
- Actually creating an ERC-721 contract for the green state vip tickets.
- Expanding the options for the owner, when it comes to vip tickets, right now there are standard tickets and vip tickets, more in options in between would be nice.
- 