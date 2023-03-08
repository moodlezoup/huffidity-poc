// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";


contract CounterHuffidity is Test {
    constructor() {
        bytes memory solidityCode = type(Counter).runtimeCode;
        bytes memory huffCode = (HuffDeployer.deploy("Add")).code;

        // console.logBytes(solidityCode);
        // console.logBytes(huffCode);

        assembly {
            let concatenated := mload(0x40)
            let solidityCodeLen := mload(solidityCode)
            let huffCodeLen := mload(huffCode)

            pop(staticcall(
                gas(), 
                0x04, 
                add(solidityCode, 0x20),
                solidityCodeLen,
                concatenated,
                solidityCodeLen
            ))

            pop(staticcall(
                gas(), 
                0x04, 
                add(huffCode, 0x20),
                huffCodeLen,
                add(concatenated, solidityCodeLen),
                huffCodeLen
            ))

            return(concatenated, add(solidityCodeLen, huffCodeLen))
        }
    }

    function number() external view returns (uint256) {}
    function setNumber(uint256) external {}
    function increment() external {}
}


contract CounterTest is Test {
    CounterHuffidity public counter;

    function setUp() public {
        counter = new CounterHuffidity();
        console.logBytes(address(counter).code);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
