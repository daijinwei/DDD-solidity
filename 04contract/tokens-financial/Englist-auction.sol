// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnglishAuction {
    address payable public seller;
    uint public startPrice;
    uint public reservePrice;
    uint public auctionEndTime;

    bool public auctionEnded;
    address public highestBidder;
    uint public highestBid;

    event AuctionEnded(address winner, uint amount);

    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can perform this action");
        _;
    }

    modifier onlyBeforeEnd() {
        require(block.timestamp < auctionEndTime, "Auction already ended");
        _;
    }

    constructor(uint _startPrice, uint _reservePrice, uint _duration) {
        require(_startPrice > 0, "Start price must be greater than zero");
        require(_reservePrice >= _startPrice, "Reserve price must be greater than or equal to start price");

        seller = payable(msg.sender);
        startPrice = _startPrice;
        reservePrice = _reservePrice;
        auctionEndTime = block.timestamp + _duration;
    }

    function bid() public payable onlyBeforeEnd {
        require(msg.value > highestBid, "There is already a higher or equal bid");

        // Return funds to the previous highest bidder
        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(highestBid);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function endAuction() public onlySeller {
        require(block.timestamp >= auctionEndTime, "Auction has not ended yet");
        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;

        if (highestBid >= reservePrice) {
            // Transfer the highest bid amount to the seller
            seller.transfer(highestBid);
            emit AuctionEnded(highestBidder, highestBid);
        } else {
            // Auction did not meet reserve price, return funds to highest bidder
            if (highestBidder != address(0)) {
                payable(highestBidder).transfer(highestBid);
            }
            emit AuctionEnded(address(0), 0);
        }
    }

    function withdraw() public {
        require(auctionEnded || block.timestamp >= auctionEndTime, "Auction is not ended yet");

        if (msg.sender != highestBidder) {
            require(msg.sender == seller, "Only the seller or highest bidder can withdraw");
        }

        uint amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }

    // Fallback function to receive ether
    receive() external payable {
        bid();
    }
}

