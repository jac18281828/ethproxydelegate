// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "../contracts/Store.sol";
import "../contracts/StoreNumber.sol";

contract StorageService {
    // delegate
    StoreNumber private _number;

    constructor() {
        _number = new StoreNumber(0);
    }

    function set(uint256 value) public {
        _number.set(value);
    }

    function get() public view returns (uint256) {
        return _number.get();
    }

    function getStore() public view returns (Store) {
        return _number;
    }
}
