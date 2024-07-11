// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VehicleContract{
    struct Vehicle{
        string make;
        uint year;
        address owner;
    }
    Vehicle[] public vehicles;
    // 三种初始化车辆的方法
    Vehicle tesla = Vehicle("tesla", 2020, msg.sender);
    Vehicle toyota = Vehicle({make: "toyota", year:2020, owner:msg.sender});
 

    // update
    function updateCarYears(uint _year)external {
        tesla.year = _year;
    }
}
