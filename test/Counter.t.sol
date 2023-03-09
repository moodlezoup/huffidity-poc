// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/Counter.sol";
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";


contract CounterHuffidity {
    constructor() {
        bytes memory solidityCode = type(Counter).runtimeCode;
        bytes memory huffCode = (HuffDeployer.deploy("Add")).code;

        assembly {
            let solidityCodeLen := mload(solidityCode)
            let huffCodeLen := mload(huffCode)

            mstore(
              add(add(solidityCode, 32), solidityCodeLen),
              mload(add(huffCode, 32))
            )

            return(add(solidityCode,32), add(solidityCodeLen, huffCodeLen))
        }
    }

    function number() external view returns (uint256) {}
    function setNumber(uint256) external {}
    function increment() external returns (uint256) {}
}


contract CounterTest is Test {
    CounterHuffidity public counter;

    function setUp() public {
        counter = new CounterHuffidity();
        console.logBytes(address(counter).code);
    }

    function testIncrement() public {
        assertEq(counter.increment(), 1);
        assertEq(counter.increment(), 2);
    }
}
