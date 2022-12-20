// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../contracts/Store.sol";
import "../contracts/StorageProxy.sol";

contract StorageProxyTest is Test {
    address private constant _OTHER = address(0xfff);

    StorageProxy private _proxy;
    Store private _store;

    function setUp() public {
        StorageService _storage = new StorageService();
        _proxy = new StorageProxy(address(_storage));
        _store = Store(_proxy.implementation());
    }

    function testSet() public {
        _store.set(200);
        assertEq(_store.get(), 200);
    }

    function testSetOther() public {
        vm.prank(_OTHER, _OTHER);
        _store.set(0x22);
        assertEq(_store.get(), 0);
        vm.prank(_OTHER, _OTHER);
        assertEq(_store.get(), 0x22);
    }

    function testUpgrade() public {
        Store _ustore = new BizaroStorageService();
        _proxy.upgrade(address(_ustore));
        _store = Store(_proxy.implementation());
        vm.prank(_OTHER, _OTHER);
        _store.set(0x22);
        vm.prank(_OTHER, _OTHER);
        assertEq(_store.get(), -34);
    }
}

// recreational purposes only - sets value to negative of value
contract BizaroStorageService is Initializable, Store {
    mapping(address => int256) public _number;

    function initialize() public initializer {}

    function set(int256 value) public {
        _number[msg.sender] = -value;
    }

    function get() public view returns (int256) {
        return _number[msg.sender];
    }
}
