// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../contracts/StoreNumber.sol";

contract StoreNumberTest is Test {
    StoreNumber private _storeNumber;

    function setUp() public {
        _storeNumber = new StoreNumber(0);
    }

    function testGetInitialValue() public {
        assertEq(_storeNumber.get(), 0);
    }

    function testSetValue() public {
        uint256 x = 300;
        _storeNumber.set(x);
        assertEq(_storeNumber.get(), 300);
    }
}
