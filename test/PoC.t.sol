// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "./utils.sol";
import "../src/PoC.sol";

error CallReverted(uint8 call, bytes data);

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
}

/// @title Proof of Concept Test
/// @notice DO NOT USE ON ANY PUBLIC NETWORK
/// @dev https://book.getfoundry.sh/forge/writing-tests
contract PoCTest is Test {

    // ---------------------------------------------------------------------------------------------
    // VARIABLES

    address caller = address(0xCAFebAbEfFFffffFf0202FFfFFFfFF7CFF7247C9);
    uint256 balance = 0x4caa3c6a768242a3c88c0;

    address weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    // ---------------------------------------------------------------------------------------------
    // EXPLOIT TEST

    /// @notice Test the PoC here.
    function testPoC() public {
        vm.deal(caller, balance);
        vm.startPrank(caller);

        console.log("----- BALANCES BEFORE -----");
        uint256 wethBalance = IERC20(weth).balanceOf(caller);
        console.log("ETH");
        console.log(caller.balance);
        console.log("WETH");
        console.log(wethBalance);
        console.log("SUM");
        console.log(caller.balance + wethBalance);

        bool success;
        bytes memory returndata;

        (success, returndata) = weth.call{value: balance}("");

        if (!success) revert CallReverted(0, returndata);

        (success, returndata) = weth.call(hex"2e1a7d4d00000000000000000000000000000000000000000000000000038d7ea4c6800100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");

        if (!success) revert CallReverted(1, returndata);

        (success, returndata) = weth.call(hex"a9059cbb000000000000000000000000cafebabefffffffff0202fffffffff7cff7247c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");

        if (!success) revert CallReverted(2, returndata);

        console.log("----- BALANCES AFTER -----");
        wethBalance = IERC20(weth).balanceOf(caller);
        console.log("ETH");
        console.log(caller.balance);
        console.log("WETH");
        console.log(wethBalance);
        console.log("SUM");
        console.log(caller.balance + wethBalance);
    }
}
