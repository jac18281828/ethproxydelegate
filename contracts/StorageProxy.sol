// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "../contracts/Store.sol";
import "../contracts/StructuredStore.sol";

contract StorageProxy is ERC1967Proxy {
    address internal immutable _storeAddr;

    constructor(
        address _sImplementation,
        address _store
    ) ERC1967Proxy(_sImplementation, abi.encodeWithSelector(ProxyableStore.initialize.selector, _store, msg.sender)) {
        _storeAddr = _store;
    }
}
