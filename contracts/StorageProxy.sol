// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "../contracts/StorageService.sol";

contract StorageProxy is ERC1967Proxy {
    constructor(address _sImplementation)
        ERC1967Proxy(_sImplementation, abi.encodeWithSelector(StorageService(address(0)).initialize.selector))
    {}

    function implementation() public view returns (address) {
        return _implementation();
    }

    function upgrade(address _sImplementation) public {
        _upgradeToAndCallUUPS(_sImplementation, "", false);
    }
}
