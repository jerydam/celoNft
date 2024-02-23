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
    using SafeMath for uint256;

    uint256 private _nextTokenId;
    mapping(address => bool) private _hasMinted;

    constructor(address initialOwner)
        ERC721("MyNft", "MNFT")
        Ownable(initialOwner)
        EIP712("MyNft", "1")
    {}

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) external onlyOwner {
        // Validate recipient address and URI
        require(to != address(0), "Invalid recipient address");
        require(bytes(uri).length > 0, "URI must not be empty");

        // Check if address has already minted a token
        require(!_hasMinted[to], "Address has already minted a token");

        // Mint the token using the counter-based approach
        uint256 tokenId = _nextTokenId;
        _safeMint(to, tokenId);

        // Set the token URI
        _setTokenURI(tokenId, uri);

        // Mark address as successfully minted
        _hasMinted[to] = true;

        // Increment the next token ID
        _nextTokenId = _nextTokenId.add(1);

        // Emit event for successful minting
        emit Minted(tokenId, to, uri);
    }

    function hasMintedSuccessfully(address account) external view returns (bool) {
        return _hasMinted[account];
    }

    function getAllMintedSuccessfully() external view returns (address[] memory) {
        uint256 count = 0;
        address[] memory result = new address[](_nextTokenId);

        for (uint256 i = 0; i < _nextTokenId; i++) {
            address owner = ownerOf(i);
            if (_hasMinted[owner]) {
                result[count] = owner;
                count++;
            }
        }

        // Resize the result array to the actual count
        assembly {
            mstore(result, count)
        }

        return result;
    }

    function _update(address to, uint256 tokenId, address auth) internal override(ERC721, ERC721Enumerable, ERC721Pausable, ERC721Votes) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable, ERC721Votes) {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
