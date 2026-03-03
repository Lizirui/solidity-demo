// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    // 核心代码：建立地址到余额的映射
    mapping(address => uint256) public balances;
    // 新增：用于记录管理员
    address payable public owner; 

    constructor() payable {
        // msg.sender 是部署合约的人
        // msg.value 是部署时发送的金额
        // 记录谁部署了这个合约
        owner = payable(msg.sender);
        balances[msg.sender] = msg.value;
    }

    // 存款函数：将发送的以太币记录在调用者的名下
    function deposit() public payable {
        // msg.value 是用户此次发送的以太币数量（单位：wei）
        balances[msg.sender] += msg.value;
    }
    // 提款函数：演示如何更新 mapping
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        // 实际转账逻辑逻辑此处略，重点看 mapping 更新
    }
    function withdrawAll() public {
        // 1. 检查权限
        require(msg.sender == owner, "Only owner can withdraw");

        // 2. 获取合约当前所有的钱
        uint256 amount = address(this).balance;

        // 3. 执行转账：把钱发给 owner
        // (bool success, ) 是为了接收转账是否成功的反馈
        (bool success, ) = owner.call{value: amount}('');
        
        // 4. 检查转账是否成功
        require(success, "Transfer failed");
    }
}