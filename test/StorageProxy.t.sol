// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "forge-std/Test.sol";

import "../contracts/NumberStore.sol";
import "../contracts/StructuredStore.sol";
import "../contracts/StorageProxy.sol";
import "../contracts/Store.sol";
import "../contracts/StorageService.sol";

contract StorageProxyTest is Test {
    address private constant _OTHER = address(0xffff);

    StorageProxy private _proxy;
    StorageService private _store;

    function setUp() public {
        StorageService _storage = new StorageService();
        StructuredStore _eternalStore = new StructuredStore();
        _proxy = new StorageProxy(address(_storage), address(_eternalStore));
        _eternalStore.transferOwnership(address(_proxy));
        _store = StorageService(address(_proxy));
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
        UUPSUpgradeable _uups = UUPSUpgradeable(address(_proxy));
        _uups.upgradeTo(address(_ustore));
        vm.startPrank(_OTHER, _OTHER);
        // set previously - still set (eternal storage)
        assertEq(_store.get(), 0x22);
        _store.set(0x22);
        // bizaro answer -34
        assertEq(_store.get(), -34);
        vm.stopPrank();
    }

    function testUpgradeFlip() public {
        vm.prank(_OTHER, _OTHER);
        _store.set(0x22);
        Store _ustore = new BizaroStorageService();
        UUPSUpgradeable _uups = UUPSUpgradeable(address(_proxy));
        _uups.upgradeTo(address(_ustore));
        _uups.upgradeTo(address(new StorageService()));
        vm.startPrank(_OTHER, _OTHER);
        assertEq(_store.get(), 0x22);
        _store.set(0x13);
        // not bizaro
        assertEq(_store.get(), 0x13);
        vm.stopPrank();
    }

    function testUpgradeNotOwner() public {
        Store _ustore = new BizaroStorageService();
        UUPSUpgradeable _uups = UUPSUpgradeable(address(_proxy));
        vm.expectRevert(abi.encodeWithSelector(OwnableInitializable.NotOwner.selector, _OTHER));
        vm.prank(_OTHER, _OTHER);
        _uups.upgradeTo(address(_ustore));
    }

    function testUpgradeKeepsDataAndOwner() public {
        vm.prank(_OTHER, _OTHER);
        _store.set(0x22);
        Store _ustore = new UpgradeService();
        UUPSUpgradeable _uups = UUPSUpgradeable(address(_proxy));
        _uups.upgradeTo(address(_ustore));
        vm.startPrank(_OTHER, _OTHER);
        _store.set(0x23);
        assertEq(_store.get(), 35);
        vm.stopPrank();
    }
}

// recreational purposes only - sets value to negative of value
contract BizaroStorageService is StorageService {
    function set(int256 value) public override {
        _store.set(-value, msg.sender);
    }
}

contract UpgradeService is StorageService {
    function getStore() public view returns (Store) {
        return this;
    }
}
