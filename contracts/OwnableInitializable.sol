// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

abstract contract OwnableInitializable {
    error NotInitialized();
    error OwnerInitialized(address owner);
    error NotOwner(address sender);

    event OwnershipTransferred(address _from, address _to);

    address internal _owner;

    modifier onlyInitialized() {
        if (_owner == address(0x0)) revert NotInitialized();
        _;
    }

    modifier notInitialized() {
        if (_owner != address(0x0)) revert OwnerInitialized(_owner);
        _;
    }

    modifier onlyOwner() {
        if (owner() != msg.sender) revert NotOwner(msg.sender);
        _;
    }

    function ownerInitialize(address _delegateOwner) internal notInitialized {
        _owner = _delegateOwner;
        emit OwnershipTransferred(address(0x0), _owner);
    }

    function owner() public view onlyInitialized returns (address) {
        return _owner;
    }

    function transferOwnership(address _delegateOwner) external onlyOwner {
        address _current = _owner;
        _owner = _delegateOwner;
        emit OwnershipTransferred(_current, _owner);
    }
}
