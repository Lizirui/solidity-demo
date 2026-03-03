// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1. 引入 OpenZeppelin 的重入锁合约
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// 2. 使用 "is" 关键字继承合约功能
contract SecureBank is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // 3. 添加 "nonReentrant" 修饰符
    // 这个修饰符会自动在函数前后加锁，黑客即便重入也会被踢出去
    function withdraw() public nonReentrant {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No funds");

        // 即使我们这里依然用“先转账后扣款”的坏习惯
        // nonReentrant 也能保住我们的资金安全
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Tranfer failed");

        balances[msg.sender] = 0;
    }
}