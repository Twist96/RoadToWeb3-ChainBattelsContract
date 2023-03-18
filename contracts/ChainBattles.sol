// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    struct stats {
        uint256 level;
        uint256 speed;
        uint256 hp;
        uint256 strength;
    }

    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    mapping(uint256 => stats) public _tokenIdsToStats;

    constructor() ERC721("ChainBattles", "CBTLS") {}

    function generateCharater(
        uint256 tokenId
    ) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = _tokenIdsToStats[tokenId].level;
        return levels.toString();
    }

    function getToeknURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"describe": "Battles on chain",',
            '"image": "',
            generateCharater(tokenId),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _tokenIdsToStats[newItemId] = stats(0, 10, 10, 10);
        _setTokenURI(newItemId, getToeknURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing Token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        require(
            _tokenIdsToStats[tokenId].level < 100,
            "You have reach maximum training level of 100"
        );
        stats memory currentStats = _tokenIdsToStats[tokenId];
        stats memory newStats = stats(
            currentStats.level + 1,
            currentStats.speed + generateRandomNumber(),
            currentStats.hp + generateRandomNumber(),
            currentStats.strength + generateRandomNumber()
        );
        _tokenIdsToStats[tokenId] = newStats;
        _setTokenURI(tokenId, getToeknURI(tokenId));
    }

    function generateRandomNumber() public view returns (uint) {
        uint randomNumber = (uint(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        ) % 10) + 1;
        return randomNumber;
    }
}

// uint256 level;
//         uint256 speed;
//         uint256 hp;
//         uint256 strength;
