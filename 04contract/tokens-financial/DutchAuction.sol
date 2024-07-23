// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
荷兰拍卖（Dutch auction）是一种特殊的拍卖方式，其价格从高到低递减，
直到有买家愿意接受当前的价格为止。让我们编写一个简单的荷兰拍卖合约，实现基本的拍卖功能。
*/

contract DutchAuction {
    // 拍卖家的地址
    address public seller;
    // 起拍价
    uint public startPrice;

    // 结束价
    uint public endPrice;
    // 拍卖结束时间戳
    uint public auctionEndTime;
    // 拍卖是否结束
    bool public auctionEnded;

    // 最高价价格的买家
    address public highestBidder;
    // 最高的价格
    uint public highestBid;

    // 拍卖结束的事件
    event AuctionEnded(address winner, uint amount);

    // 只有调者用户才能拍卖
    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can perform this action");
        _;
    }
    // 只有在拍卖期间才能拍卖
    modifier onlyBeforeEnd() {
        require(block.timestamp < auctionEndTime, "Auction already ended");
        _;
    }

    // 构造函数，初始化起拍价，结束价，拍卖的持续时间
    constructor(uint _startPrice, uint _endPrice, uint _duration) {
        require(_startPrice > 0, "Start price must be greater than zero");
        require(_startPrice >= _endPrice, "End price must be less than or equal to start price");

        seller = msg.sender;
        startPrice = _startPrice;
        endPrice = _endPrice;
        auctionEndTime = block.timestamp + _duration;
    }

    // 拍卖函数，允许买家出价。如果新出价高于当前最高出价，则更新最高出价，并将前一个最高出价的买家退款。
    function bid() public payable onlyBeforeEnd {
        require(msg.value > highestBid, "There is already a higher or equal bid");

        if (highestBidder != address(0)) {
            // Refund the previous highest bidder
            payable(highestBidder).transfer(highestBid);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    // 只有卖家可以调用。确保拍卖已经结束，并将最终的出价金额转移到卖家账户。
    function endAuction() public onlySeller {
        require(block.timestamp >= auctionEndTime, "Auction has not ended yet");

        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);

        // Transfer the auction proceeds to the seller
        payable(seller).transfer(highestBid);
    }
    // 允许卖家或者最高出价的买家在拍卖结束后提取余额。如果拍卖未结束，则只有卖家可以提取余额。
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

