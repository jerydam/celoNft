// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";

contract MyNft is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable, ERC721Burnable, EIP712, ERC721Votes {
    mapping(uint256 => string) private _tokenNames;
    mapping(uint256 => string) private _tokenSymbols;

    constructor() ERC721("MyNft", "MNFT") Ownable() EIP712("MyNft", "1") {}

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri, string memory name, string memory symbol) external onlyOwner {
        uint256 tokenId = totalSupply();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _setTokenName(tokenId, name);
        _setTokenSymbol(tokenId, symbol);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _setTokenName(uint256 tokenId, string memory name) internal {
        _tokenNames[tokenId] = name;
    }

    function _setTokenSymbol(uint256 tokenId, string memory symbol) internal {
        _tokenSymbols[tokenId] = symbol;
    }
}
