// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public returns (uint256) {
        function (uint256, uint256) pure returns (uint256) _add;
        assembly {
            _add := sub(codesize(), 4)
        }
        number = _add(number, 1);
        return number;
    }
}