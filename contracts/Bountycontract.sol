// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import './ModifiersContract.sol';

contract Bounty is Modifiers {

    mapping(address => uint256) public contributors;
    mapping(address => bool) public vipContributors;
    mapping(address => string) public vipID;
    mapping(address => uint) balances;

    uint public contributorsCount;
    uint minimumContribution = 100;
    uint vipContribution = 1000;
    uint vipCounter = 0;
    address[101] vipAddresses;

    constructor() {
        manager = msg.sender;
        state = 1;
    }


    function setState(uint _state) public onlyOwner {
        state = _state;
        // 0 = Red, 1 = Yellow, 2 = Green        
        
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

        //Add contribution to user balances
        balances[msg.sender] += msg.value;

    }

    function getFunds() public view returns (uint){
        return address(this).balance;
    }


    function refund() public redOnly payable {
        require(balances[msg.sender] > 0, "Must have contributed to get a refund");

        payable (msg.sender).transfer(balances[msg.sender]);
    }

    function enterVipList(string memory name) public greenOnly {
        require(balances[msg.sender] >= vipContribution, "Must contribute enough for VIP pass"); 
        require(vipCounter < 101, "Vip List full");

        vipID[msg.sender] = name;
        
        vipAddresses[vipCounter] = msg.sender;
        vipCounter++;
    }

        function vipAddressChecker(uint num) private view returns(address) {
            return vipAddresses[num];
        }

        function vipNameChecker(address vip) private view returns(string memory) {
            return vipID[vip];
        }

        function vipListNames(uint num) public view returns(string memory) {
            return vipNameChecker(vipAddressChecker(num));
        }

}


//array[index] = value