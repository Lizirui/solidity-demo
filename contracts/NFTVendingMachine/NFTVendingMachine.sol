// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; // 引入权限控制

// 定义我们要调用的 NFT 接口
interface IFairNFT {
    function mint(address to) external; 
}

contract NFTVendingMachine is Ownable {
    IERC20 public token;
    IFairNFT public nft;
    uint256 public constant PRICE = 100 * 10 ** 18; // 100 ZR

    constructor(address _token, address _nft) Ownable(msg.sender) {
        token = IERC20(_token);
        nft = IFairNFT(_nft);
    }

    function buyNFT() public {
        // 1. 售卖机从用户手里扣 100 个 LEE (需要用户先 approve)
        // 钱会转到售卖机合约里，也可以改成转给 owner
        bool success = token.transferFrom(msg.sender, address(this), PRICE);
        require(success, "Payment failed");

        // 2. 售卖机命令 NFT 合约给用户发货
        nft.mint(msg.sender);
    }

    /**
     * @dev 管理员提现：把合约收到的所有 LEECOIN 转给管理员
     */
    function withdrawTokens() public onlyOwner {
        // 1. 查一下售卖机现在存了多少 LEECOIN
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No tokens to withdraw");

        // 2. 将代币转给管理员
        // 这里用的是 transfer，因为钱已经在售卖机合约里了
        token.transfer(owner(), balance);
    }
} 