// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../contracts/Store.sol";
import "../contracts/NumberStore.sol";
import "../contracts/StorageProxy.sol";

contract StorageProxyTest is Test {
    address private constant _OTHER = address(0xfff);

    StorageProxy private _proxy;
    StorageService private _store;

    function setUp() public {
        StorageService _storage = new StorageService();
        _proxy = new StorageProxy(address(_storage));
        _store = StorageService(_proxy.implementation());
    }

    function testSet() public {
        _store.set(200);
        assertEq(_store.get(), 200);
    }

    function testSetOther() public {
        vm.prank(_OTHER, _OTHER);
        _store.set(0x22);
        vm.prank(_OTHER, _OTHER);
        assertEq(_store.get(), 0x22);
    }

    function testFailNotSet() public view {
        _store.get();
    }

    function testUpgrade() public {
        vm.prank(_OTHER, _OTHER);
        _store.set(0x22);
        Store _ustore = new BizaroStorageService();
        _proxy.upgrade(address(_ustore));
        _store = StorageService(_proxy.implementation());
        vm.startPrank(_OTHER, _OTHER);
        _store.set(0x22);
        assertEq(_store.get(), -34);
        vm.stopPrank();
    }

    function testUpgradeKeepsDataAndOwner() public {
        vm.prank(_OTHER, _OTHER);
        _store.set(0x22);
        Store _ustore = new UpgradeService();
        _proxy.upgrade(address(_ustore));
        _store = StorageService(_proxy.implementation());
        vm.startPrank(_OTHER, _OTHER);
        _store.set(0x23);
        assertEq(_store.get(), 35);
        vm.stopPrank();
    }
}

// recreational purposes only - sets value to negative of value
contract BizaroStorageService is StorageService {
    function set(int256 value) public override {
        _number[msg.sender] = new NumberStore(-value);
    }
}

contract UpgradeService is StorageService {
    function getStore() public view returns (Store) {
        if (address(_number[msg.sender]) == address(0x0)) revert NotInitialized(msg.sender);
        return _number[msg.sender];
    }
}
