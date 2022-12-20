// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../contracts/Store.sol";

contract StorageService is Initializable, Store {
    mapping(address => int256) public _number;

    function initialize() public initializer {}

    function set(int256 value) public {
        _number[msg.sender] = value;
    }

    function get() public view returns (int256) {
        return _number[msg.sender];
    }
}
