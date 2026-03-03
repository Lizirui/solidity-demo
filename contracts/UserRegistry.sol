// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UserRegistry {
    // 1. 布尔型 (bool)：只有 true 或 false
    bool public isContractActive = true;

    // 2. 地址型 (address)：以太坊账号的唯一标识（20字节）
    address public owner;

    // 3. 字符串 (string)：存储文本数据
    string public userName;

    // 构造函数：在合约部署的那一刻执行一次
    constructor() {
        // msg.sender 是一个全局变量，代表当前调用合约的人
        owner = msg.sender;
    }

    // 修改用户名
    function setUsername(string memory _name) public {
        userName = _name;
    }

    // 检查调用者是否为管理员
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    // 只有合约主人可以关闭合约
    function deactivate() public {
        // require(条件, "报错信息");
        require(msg.sender == owner, "Caller is not the owner");
        
        isContractActive = false;
    }

    function checkVale(uint256 _x) public pure returns (string memory) {
        if (_x > 10) {
            return "Greater than 10";
        } else {
            return "10 or less";
        }
    }

}

// address: 这是以太坊最特殊的数据类型。每个钱包、每个合约都有一个唯一的地址。

// msg.sender: 这是一个极其重要的全局变量。无论谁调用函数，msg.sender 都会自动指向那个人的地址。它是实现权限控制（例如：只有主人能提钱）的基础。

// string memory: 在 Solidity 中，字符串比较复杂。memory 关键字告诉 EVM 这个字符串只是临时存在内存中，不需要永久存储在开销昂贵的“状态变量”区域（除非它是定义在函数外的变量）。

// 权限校验：msg.sender == owner 确保了只有存储在 owner 变量里的那个地址才能通过检查。

// 安全性：如果黑客尝试调用这个函数，require 会检测到 msg.sender 不是主人，直接报错并停止执行，isContractActive 的状态也就不会被改变。

// 报错信息：第二个参数 "Caller is not the owner" 会在调试控制台中显示，方便你快速定位为什么交易失败了。