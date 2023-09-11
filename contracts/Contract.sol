// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Contract is ERC721 {
    mapping(address => bool) private whitelist;
    address private owner;
    uint256 _nftId;
    bool private isPaused = false;

    uint256 private _nftPrice = 0.01 ether;

    constructor() ERC721("Best NFT in the World", "BNW") {
        owner = msg.sender;   
        whitelist[msg.sender] = true;
        _nftId = 0;
    }

    modifier isInWhitelist() {
        require(whitelist[msg.sender], "You need to be in whitelist");
        _;
    }

    modifier isNotPaused() {
        require(!isPaused, "Contract temporary paused");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    // NFT minting and transfering
    function mintNft() public payable isNotPaused {
        require(msg.value >= _nftPrice, "Insufficient NFT price");
        _mint(msg.sender, _nftId);
        _nftId++;
    }

    // Also for owner, because he in whitelist too
    function mintNftWhitelist() public isInWhitelist isNotPaused {
        _mint(msg.sender, _nftId);
        _nftId++;
    }

    function mintBatchNftWhitelist(uint256 amount) public isInWhitelist onlyOwner isNotPaused {
        for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, _nftId + i);
        }
        _nftId += amount;
    }

    function transferNft(address to, uint256 nftId) public onlyOwner {
        _transfer(msg.sender, to, nftId);
    }

    function withdraw() public onlyOwner isNotPaused {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Pausable
    function togglePause(bool newValue) public onlyOwner {
        isPaused = newValue;
    }


    // Access control
    function addToWhitelist(address user) public onlyOwner isNotPaused {
        whitelist[user] = true;
    }

    function changeOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Zero owner");
        owner = newOwner;
    }

    // Getters
    function checkIsInWhitelist(address user) public view returns(bool) {
        require(user != address(0), "Zero owner");
        return whitelist[user];
    }

    function getNftId() public view returns(uint256) {
        return _nftId;
    }

    function getNftPrice() public view returns(uint256) {
        return _nftPrice;
    }

    function getPaused() public view returns(bool) {
        return isPaused;
    }

    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}