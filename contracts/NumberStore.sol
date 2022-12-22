// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "../contracts/Store.sol";

contract NumberStore is Store {
    int256 private _number;

    constructor(int256 _init) {
        _number = _init;
    }

    function set(int256 _value) public {
        _number = _value;
    }

    function get() public view returns (int256) {
        return _number;
    }
}
