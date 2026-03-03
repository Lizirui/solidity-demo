// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventBank {
    mapping(address => uint256) public balances;

    // 1. 定义事件 (通常首字母大写)
    // indexed 关键字允许我们在区块链日志中快速搜索这个地址
    event Deposit(address indexed user, uint256 amount, uint256 time);
    event Withdraw(address indexed user, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Amount must > 0");

        balances[msg.sender] += msg.value;

        // 2. 触发事件 (使用 emit 关键字)
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        // 触发取款事件
        emit Withdraw(msg.sender, _amount);
    }
}