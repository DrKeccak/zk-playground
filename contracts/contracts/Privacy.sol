// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "hardhat/console.sol";
struct ZKP {
    uint256[2] a;
    uint256[2][2] b;
    uint256[2] c;
}

contract Privacy {
    bytes32 private hashedPassword;
    bytes32 private salt = keccak256("salt");

    function mintWithPassword(uint256 val, string memory password) public view {
        require(hashedPassword == keccak256(abi.encodePacked(password, salt)));
        // mint something here
    }

    function mintWithZKP(uint256 val, ZKP memory zkp) public {
        verify(hashedPassword, salt, zkp);
    }

    function verify(
        bytes32 hashedPassword,
        bytes32 salt,
        ZKP memory proof
    ) public view returns (bool) {
        VK memory vk = verfyingKeyForPassword();
        return vk.verify(hashedPassword, salt, proof);
    }
}
