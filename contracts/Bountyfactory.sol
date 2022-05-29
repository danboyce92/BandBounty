// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import './BandBounty.sol';

contract BountyFactory {
    Bounty[] public deployedBounties;
    
    function createBounty(address creator) external payable {
        Bounty bounty = new Bounty{value: 111}(creator);
        deployedBounties.push(bounty);
        

    /*function getDeployedBounties() public view returns(Bounty[] memory) {
        return deployedBounties;
    }*/

    }
}