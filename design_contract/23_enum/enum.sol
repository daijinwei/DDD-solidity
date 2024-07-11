// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnumHomework{
    enum OrderStatus {
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Cancelled
    }

    struct Order{
        address buyer;
        OrderStatus status;
    }

    Order[] orders;
    Order public order = Order(msg.sender, OrderStatus(0));
    function updateStatus(OrderStatus _status) external {
        order.status = _status;
    }

    function getStatus() external view returns(OrderStatus) {
        return order.status;
    }
    function resetStatus() external {
        order.status = OrderStatus(0);
    }
}
