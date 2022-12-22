// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../contracts/StorageService.sol";
import "../contracts/StructuredStore.sol";

contract StorageServiceTest is Test {
    address private constant _OTHER = address(0xfff);

    StorageService private _service;

    function setUp() public {
        _service = new StorageService();
        StructuredStore _store = new StructuredStore();
        _store.transferOwnership(address(_service));
        _service.initialize(address(_store), address(this));
    }

    function testSet() public {
        _service.set(200);
        assertEq(_service.get(), 200);
    }

    function testSetOther() public {
        vm.prank(_OTHER, _OTHER);
        _service.set(0x22);
        vm.prank(_OTHER, _OTHER);
        assertEq(_service.get(), 0x22);
    }

    function testFailNotSet() public view {
        _service.get();
    }
}
