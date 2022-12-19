// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../contracts/StorageService.sol";

contract StorageServiceTest is Test {
    StorageService private _service;

    function setUp() public {
        _service = new StorageService();
    }

    function testSet() public {
        _service.set(200);
        assertEq(_service.get(), 200);
    }

    function testFailSetInternalStore() public {
        Store _store = _service.getStore();
        _store.set(128);
    }
}
