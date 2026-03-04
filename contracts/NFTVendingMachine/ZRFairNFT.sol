// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ZRFailNFT is ERC721, Ownable {
    uint256 public nextTokenId;
    // 记录谁被授权可以铸造（比如售卖机合约）
    mapping(address => bool) public isMinter;

    constructor() ERC721("ZRFair", "ZRF") Ownable(msg.sender) {}

    // 管理员设置谁有权铸造
    function setMinter(address _minter, bool _status) public onlyOwner {
        isMinter[_minter] = _status;
    }

    function mint(address to) public {
        // 只有管理员或者被授权的售卖机可以 mint
        require(msg.sender == owner() || isMinter[msg.sender], "Not authorized to mint");
        _safeMint(to, nextTokenId++);
    }
}