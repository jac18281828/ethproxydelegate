// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

import "../contracts/StructuredStore.sol";

/// @notice upgradeable storage service
contract StorageService is Store, UUPSUpgradeable, Initializable {
    error NotOwner(address sender);

    StructuredStore internal _store;
    address private _owner;

    modifier onlyOwner() {
        if (_owner != address(0x0) && msg.sender != _owner) revert NotOwner(msg.sender);
        _;
    }

    function initialize(address _storeaddr, address _ownerAddr) public initializer {
        _store = StructuredStore(_storeaddr);
        _owner = _ownerAddr;
    }

    function set(int256 value) public virtual {
        _store.set(value, msg.sender);
    }

    function get() public view returns (int256) {
        return _store.get(msg.sender);
    }

    function _authorizeUpgrade(address) internal virtual override(UUPSUpgradeable) onlyOwner {}
}
