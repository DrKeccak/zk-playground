// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "hardhat/console.sol";
struct ZKP {
    uint256[2] a;
    uint256[2][2] b;
    uint256[2] c;
}

contract Scaling {
    uint256 private tmp;

    modifier gasMeter(string memory message) {
        uint256 start = gasleft();
        _;
        uint256 end = gasleft();
        console.log("%s(%s gas)", message, start - end);
    }

    function hash5000Times(bytes32 val) public view returns (bytes32 result) {
        result = val;
        for (uint256 i = 0; i < 5000; i++) {
            result = sha256(abi.encodePacked(result));
        }
    }

    function hash5000timesUsingZKP(bytes32 val, bytes32 result, ZKP memory proof) public {
        verify(val, result, proof);
    }

    function verify(
        bytes32 val,
        bytes32 result,
        ZKP memory proof
    ) public view returns (bool) {
        VK memory vk = verfyingKeyForScaling();
        return vk.verify(val, result, proof);
    }
}
