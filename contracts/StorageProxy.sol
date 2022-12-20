// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../contracts/StorageService.sol";

contract StorageProxy is Ownable {
    TransparentUpgradeableProxy private immutable proxy;

    constructor(address _sImplementation) {
        proxy = new TransparentUpgradeableProxy(
            _sImplementation,
            address(this),
            abi.encodeWithSelector(StorageService(address(0)).initialize.selector)
        );
    }

    function upgrade(address _sImplementation) public onlyOwner {
        proxy.upgradeTo(_sImplementation);
    }

    function implementation() public returns (address) {
        return proxy.implementation();
    }
}
