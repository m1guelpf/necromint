//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

struct Ghost {
    address contractAddress;
    uint256 tokenId;
}

contract Necromint is Ownable, ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => Ghost) internal _ghostMap;
    mapping(bytes32 => bool) internal _uniqueMap;

    constructor() ERC721("Necromint", "DEAD") {}

    function resurrect(IERC721Metadata spirit, uint256 soul) external returns (uint256) {
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        Ghost storage ghost = _ghostMap[tokenId];

        require(tokenId < 6669, "max supply");
        require(!_uniqueMap[keccak256(abi.encodePacked(spirit, soul))], "already resurrected");
        require(spirit.ownerOf(soul) == address(0x000000000000000000000000000000000000dEaD), "token not in cementery (yet?)");

        ghost.tokenId = soul;
        ghost.contractAddress = address(spirit);
        _uniqueMap[keccak256(abi.encodePacked(spirit, soul))] = true;

        _mint(_msgSender(), tokenId);

        return tokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "token does not exist");
        Ghost memory ghost = _ghostMap[tokenId];

        return IERC721Metadata(ghost.contractAddress).tokenURI(ghost.tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
        ERC721Enumerable._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
