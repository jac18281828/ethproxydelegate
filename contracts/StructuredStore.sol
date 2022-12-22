// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

import "../contracts/Store.sol";
import "../contracts/NumberStore.sol";

/// @notice eternal storage for storage service
contract StructuredStore is Ownable {
    error NotInitialized(address sender);

    mapping(address => Store) public _number;

    function set(int256 value, address _sender) public virtual onlyOwner {
        NumberStore _store = new NumberStore(value);
        _number[_sender] = _store;
    }

    function get(address _sender) public view returns (int256) {
        Store _store = _number[_sender];
        if (address(_store) == address(0x0)) revert NotInitialized(msg.sender);
        return _store.get();
    }
}
