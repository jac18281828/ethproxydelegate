// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

interface Store {
    function set(int256 value) external;

    function get() external view returns (int256);
}

interface ProxyableStore is Store {
    function initialize(address _storeaddr, address _ownerAddr) external;
}
