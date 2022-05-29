# BandBounty


*Things to note*

**setState function**
setState should only be accessible by the admin. Because each contract is deployed by the factory and not the admin, msg.sender does not work anymore with onlyOwner modifier. For this reason, until a solution is discovered, I have to manually put in the admin address into the setState function whenever this is deployed to a testnet for display.