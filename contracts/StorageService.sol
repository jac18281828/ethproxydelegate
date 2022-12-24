// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../contracts/StructuredStore.sol";
import "../contracts/OwnableInitializable.sol";

/// @notice upgradeable storage service
contract StorageService is Store, UUPSUpgradeable, Initializable, OwnableInitializable {
    event UpgradeAuthorized(address sender, address owner);
    StructuredStore internal _store;

    function initialize(address _storeaddr, address _ownerAddr) public initializer {
        _store = StructuredStore(_storeaddr);
        ownerInitialize(_ownerAddr);
    }

    function set(int256 value) public virtual {
        _store.set(value, msg.sender);
    }

    function get() public view returns (int256) {
        return _store.get(msg.sender);
    }

    // solhint-disable-next-line no-empty-blocks
    function _authorizeUpgrade(address _caller) internal virtual override(UUPSUpgradeable) onlyOwner {
        emit UpgradeAuthorized(_caller, owner());
    }
}
