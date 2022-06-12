// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import './ModifiersContract.sol';


contract Bounty is Modifiers {

    AggregatorV3Interface internal priceFeed;

    mapping(address => uint256) public contributors;
    mapping(address => bool) public vipContributors;
    mapping(address => string) public vipID;
    mapping(address => uint) balances;

    uint public contributorsCount;
    uint minimumContribution = 100;
    uint vipContribution = 1000;
    uint vipCounter = 0;
    address[101] vipAddresses;
    string[] vipNames;
    uint depFee;
    uint deploymentTime;
    uint256 standardTicketPrice;
    uint setStateCounter;
    



    constructor(address manager) payable {
        manager = msg.sender;
        state = 1;
        deploymentTime = block.timestamp;
        standardTicketPrice = 50 * (10 ** 18);
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        setStateCounter = 0;
        
    }


    function getTicketFee() public view returns (uint256) {
        (, int256 price, , ,) = priceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * 10 ** 10;

        uint256 costOfTicket = (standardTicketPrice * 10 ** 18) / adjustedPrice;
        return costOfTicket;
            }


    /*function retrieveAdmin(address _test) external {
        _test.delegateCall(
            abi.encodeWithSelector(BountyFactory.retrieveAdmin.selector)
        );

    }*/


    function setState(uint _state) public onlyOwner {
        require(setStateCounter == 0, "State can only be changed once");

        state = _state;
        // 0 = Red, 1 = Yellow, 2 = Green  

        if(_state == 2){
            deploymentTime = block.timestamp;
        }    

        setStateCounter++;
    }

    function checkState() public view onlyOwner returns(uint) {
        return state;
    }


    function contribute() public payable notRed {
        require(msg.value >= minimumContribution);
        uint expirationTime = deploymentTime + 90 days;
        uint currentTime = block.timestamp;

        if(currentTime > expirationTime && state == 1) {
            state = 0;
        }
        
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
        vipNames.push(name);
        vipAddresses[vipCounter] = msg.sender;
        vipCounter++;
    }

        function vipAddressChecker(uint num) private view returns(address) {
            return vipAddresses[num];
        }

        function vipNameChecker(address vip) private view returns(string memory) {
            return vipID[vip];
        }

        function vipListNames(uint num) public view onlyOwner returns(string memory) {
            return vipNameChecker(vipAddressChecker(num));
        }

        function getVipNames() public view onlyOwner returns(string[] memory) {
            return vipNames;
        }

}


//array[index] = value
// would it be possible to make a simple function that retrieves the msg.sender address from contract A 