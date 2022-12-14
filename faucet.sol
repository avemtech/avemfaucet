// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

contract Faucet {
    address public owner;
    uint public drip = 5 ether;

    mapping(address => uint) public lockTime;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _; 
    }

    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function setDrip(uint newDripValue) public onlyOwner {
        drip = newDripValue;
    }

    function donateToFaucet() public payable {
        // Nothing to do here - just receive the funds
    }

    function requestTokens(address payable _requestor) public payable {
        require(_requestor != owner, "The owner cannot request tokens from the faucet.");

        require(block.timestamp > lockTime[_requestor], "Sorry, you must wait before requesting tokens again. Please try again later.");

        require(address(this).balance >= drip, "The faucet does not have enough funds to fulfill your request. Please consider donating to the faucet to help keep it running.");

        lockTime[_requestor] = block.timestamp + 1 days;

        _requestor.transfer(drip);        
    }

    function getFaucetInfo() public view returns (address, uint) {
        return (owner, drip);
    }

    function getFaucetBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getLockTime(address _requestor) public view returns (uint) {
        return lockTime[_requestor];
    }
}
