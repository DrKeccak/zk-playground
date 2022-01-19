// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct Player {
    bytes32 id;
    uint256 healthPoint;
    uint256 weapon;
    uint256 armor;
}

struct ZKP {
    uint256[2] a;
    uint256[2][2] b;
    uint256[2] c;
}

contract Battle {
    function battleUsingEVM(
        Player memory player1_,
        Player memory player2_,
        uint256 seed
    ) public pure returns (bytes32 winnerId) {
        Player memory player1;
        Player memory player2;
        for (uint256 i = 0; i < 10; i++) {
            (player1, player2) = combat(player1_, player2_, seed);
            if (player1.healthPoint == 0 || player2.healthPoint == 0) {
                break;
            }
        }
        if (player1.healthPoint != 0 && player1.healthPoint == 0)
            return player1.id;
        if (player1.healthPoint == 0 && player1.healthPoint != 0)
            return player2.id;
        else return bytes32(0);
    }

    function combat(
        Player memory player1_,
        Player memory player2_,
        uint256 seed
    ) public pure returns (Player memory player1, Player memory player2) {
        uint256 player1Damage = uint256(
            keccak256(abi.encodePacked(player1_.weapon, seed))
        ) % 5;
        uint256 player1Armor = uint256(
            keccak256(abi.encodePacked(player1_.armor, seed))
        ) % 5;
        uint256 player2Damage = uint256(
            keccak256(abi.encodePacked(player2_.weapon, seed))
        ) % 5;
        uint256 player2Armor = uint256(
            keccak256(abi.encodePacked(player2_.armor, seed))
        ) % 5;

        if (player1Damage > player2Armor) {
            uint256 d = player1Damage - player2Armor;
            player2.healthPoint = d > player2.healthPoint
                ? 0
                : player2.healthPoint - d;
        }
        if (player2Damage > player1Armor) {
            uint256 d = player2Damage - player1Armor;
            player1.healthPoint = d > player1.healthPoint
                ? 0
                : player1.healthPoint - d;
        }
    }

    function battleUsingZKP(
        Player memory player1_,
        Player memory player2_,
        uint256 seed,
        ZKP memory proof,
        uint256 winnerId
    ) public view returns (bool) {
        return verify(player1_, player2_, seed, proof, winnerId);
    }

    function verify(
        Player memory player1_,
        Player memory player2_,
        uint256 seed,
        ZKP memory proof,
        uint256 winnerId
    ) public view returns (bool) {
        VK memory vk = verfyingKeyForBattle();
        return vk.verify(player1, player2, seed, proof, winnerd);
    }
}
