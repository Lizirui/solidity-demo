// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 定义自定义错误，比 require 字符串更省 Gas
error MintPriceNotPaid();
error MaxLimitReached();
error WithdrawFialed();

contract FairNFT is ERC721, Ownable {
    uint256 public nextTokenId;

    // 设置常量：价格 0.1 ETH，限购 1 个
    uint256 public constant MINT_PRICE = 1 ether;
    uint256 public constant MAX_PER_WALLET = 1;

    // 记录每个地址铸造了多少个
    mapping(address => uint256) public mintedCount;

    // 初始化时，设置系列名称为 "FairLee"，简称 "FLEE"
    constructor() ERC721("FairLee", "FLEE") Ownable(msg.sender) {}

    /**
     * @dev 核心铸造函数
     */
    function mint() public payable {
        // 1. 检查：钱够不够？
        if(msg.value < MINT_PRICE) {
            revert MintPriceNotPaid();
        }

        // 2. 检查：是否超过限购额度？
        if(mintedCount[msg.sender] >= MAX_PER_WALLET) {
            revert MaxLimitReached();
        }

        // 3. 执行：先记账（防止重入的习惯）
        mintedCount[msg.sender] += 1;

        uint256 tokenId = nextTokenId;
        nextTokenId++;

        // 4. 发货：使用安全铸造
        _safeMint(msg.sender, tokenId);
    }

    /**
     * @dev 管理员提现函数
     */
    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        // 将合约所有余额转给管理员 (Owner)
        (bool success, ) = owner().call{value: amount}("");

        if (!success) {
            revert WithdrawFialed();
        }
    }
}