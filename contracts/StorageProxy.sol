// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "../contracts/StorageService.sol";
import "../contracts/StructuredStore.sol";

contract StorageProxy is ERC1967Proxy {
    address internal immutable _storeAddr;

    constructor(address _sImplementation, address _store)
        ERC1967Proxy(_sImplementation, abi.encodeWithSelector(StorageService.initialize.selector, _store, address(this)))
    {
        _storeAddr = _store;
    }

    function upgrade(address _sImplementation) public {
        _upgradeTo(_sImplementation);
    }
}
