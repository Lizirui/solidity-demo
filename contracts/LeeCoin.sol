// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1. 引入 OpenZeppelin 的标准 ERC20 合约
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// 引入权限控制合约
import "@openzeppelin/contracts/access/Ownable.sol";

// 2. 使用 "is" 继承 ERC20 的所有功能（转账、授权、查询余额等）
// 继承 ERC20 和 Ownable
contract LeeCoin is ERC20, Ownable {
    // 3. 构造函数：设置代币名称和符号
    // Ownable 的构造函数需要传入一个初始管理员地址
    constructor(uint256 initialSupply) 
        ERC20("LeeCoin", "LEE") 
        Ownable(msg.sender)
    {
        // 4. 铸造代币：初始发行量全部给到部署者
        // initialSupply * 10**decimals() 是为了处理小数点（通常是 18 位）
        _mint(msg.sender, initialSupply * 10**decimals());
    }

    // 只有管理员（Owner）可以调用的增发函数
    // 增发（只有管理员可以，单位是个）
    function mint(address to, uint256 amount) public onlyOwner {
        // 直接调用底层 _mint 函数
        _mint(to, amount * 10 ** decimals());
    }

    // 销毁（任何人都可以销毁自己的币，单位是个）
    function burn(uint256 amount) public {
        // _burn 是 ERC20 内部函数，会自动检查余额是否足够
        _burn(msg.sender, amount * 10 ** decimals());
    }
}
