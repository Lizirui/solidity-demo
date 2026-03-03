// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankWithList {
    struct User {
        // 余额
        uint256 balance; 
        // 最后一次存款的时间（Unix 时间戳）
        uint256 lastDeposit; 
    }

    // 状态变量
    // 地址映射到结构体
    mapping(address => User) public users;
    // 用户名单数组
    address[] public userList;
    // 合约管理员
    address public owner;

    constructor() {
        // 谁部署，就是管理员
        owner = msg.sender;
    }

    // 存款函数：记录余额和时间
    function deposit() public payable {
        require(msg.value > 0, "Must send some Ether");

        // 如果是新用户（余额为 0），加入名单
        if (users[msg.sender].balance == 0) {
            userList.push(msg.sender);
        }

        // 更新结构体数据
        users[msg.sender].balance += msg.value;
        users[msg.sender].lastDeposit = block.timestamp;
    }

    // 取款函数：用户取回自己的钱
    function withdraw(uint256 _amount) public {
        require(users[msg.sender].balance >= _amount, "Insufficient balance");

        // 1. 更新账本（先扣款，防攻击）
        users[msg.sender].balance -= _amount;

        // 2. 真实转账
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
    }

    // 管理员功能：给所有人发 0.1 Ether 奖金
    function distributeBonuses() public payable {
        require(msg.sender == owner, "Only owner can do this");
        uint256 reward = 0.1 ether;
        require(msg.value >= userList.length * reward, "Not enough bonus sent");

        for(uint256 i = 0; i < userList.length; i++) {
            address userAddr = userList[i];
            users[userAddr].balance += reward;
        }
    }

    // 查看总用户数
    function getUserCount() public view returns (uint256) {
        return userList.length;
    }
}