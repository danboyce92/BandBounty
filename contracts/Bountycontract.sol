// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import './ModifiersContract.sol';

contract Bounty is Modifiers {

    mapping(address => uint256) public contributors;
    mapping(address => bool) public vipContributors;
    uint public contributorsCount;
    uint minimumContribution = 100;
    uint vipContribution = 1000;

    constructor() {
        manager = msg.sender;
        state = 1;
    }


    function setState(uint _state) public onlyOwner {
        state = _state;        
        
    }

    function checkState() public view onlyOwner returns(uint) {
        return state;
    }

    function contribute() public payable notRed {
        require(msg.value > minimumContribution);
        
        if(contributors[msg.sender] == 0) {
        contributorsCount++;
        }
        contributors[msg.sender] = 1;

        if(msg.value >= vipContribution) {
            vipContributors[msg.sender] = true;
        }

    }

    function getFunds() public view returns (uint){
        return address(this).balance;
    }


    function refund() public view redOnly returns(address) {
        return msg.sender;
    }



}
