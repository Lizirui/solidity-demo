// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1. 引入 ERC721 标准库
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    // 用于追踪下一个要生成的 ID
    uint256 public nextTokenId;

    // 构造函数：设置 NFT 系列的名称和缩写
    constructor() ERC721("LeeCollection", "LEE_NFT") Ownable(msg.sender) {}

    /**
     * @dev 铸造函数：将一个新的 NFT 发送给指定地址
     * 每次调用，Id 都会自增 1
     */
    function mint(address to) public {
        uint256 tokenId = nextTokenId;

        // 调用底层 _safeMint 函数，它比 _mint 更安全（会检查接收者是否能处理 NFT）
        _safeMint(to, tokenId);

        // 更新 ID，确保下一个 NFT 是唯一的
        nextTokenId++;
    }

    /**
     * @dev 覆盖父类函数：告诉钱包和平台，去哪里找这张画的信息
     * 实际开发中会返回一个像 "https://api.mysite.com/nft/" 的链接
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return "https://ipfs.io/ipfs/QmYourHash/";
    }
}