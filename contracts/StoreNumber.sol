// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "../contracts/Store.sol";

contract StoreNumber is Store {
    uint256 private _number;
    address private _cognate;

    modifier requireFriend() {
        require(msg.sender == _cognate, "Not allowed");
        _;
    }

    constructor(uint256 _init) {
        _cognate = msg.sender;
        _number = _init;
    }

    function set(uint256 _value) public requireFriend {
        _number = _value;
    }

    function get() public view returns (uint256) {
        return _number;
    }
}
