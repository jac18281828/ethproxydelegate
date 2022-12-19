// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

interface Store {
    function set(uint256 value) external;

    function get() external view returns (uint256);
}
