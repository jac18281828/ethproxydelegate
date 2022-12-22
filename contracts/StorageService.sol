// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

import "../contracts/Store.sol";
import "../contracts/NumberStore.sol";

contract StorageService is Store, Ownable, UUPSUpgradeable, Initializable {
    error NotInitialized(address sender);

    mapping(address => Store) public _number;

    function initialize() public initializer {}

    function set(int256 value) public virtual {
        NumberStore _store = new NumberStore(value);
        _number[msg.sender] = _store;
    }

    function get() public view returns (int256) {
        Store _store = _number[msg.sender];
        if (address(_store) == address(0x0)) revert NotInitialized(msg.sender);
        return _store.get();
    }

    function _authorizeUpgrade(address) internal virtual override(UUPSUpgradeable) onlyOwner {}
}
