// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimedBank {
    // struct 结构体
    struct User {
        uint256 balance;
        uint256 lastDeposit;
    }

    mapping(address => User) public users;

    // 定义锁定期：24 小时 (为了调试方便，你也可以改成 1 minutes)
    // uint256 public constant LOCK_TIME = 24 hours;
    uint256 public constant LOCK_TIME = 3 minutes;

    function deposit() public payable {
        require(msg.value > 0, "Send Ether");

        users[msg.sender].balance += msg.value;
        users[msg.sender].lastDeposit = block.timestamp; // 更新存款时间
    }

    function withdraw(uint256 _amount) public {
        // storage：相当于“指针”。修改 user 变量的值，会直接同步修改区块链上的 users 映射数据。
        // memory：相当于“深拷贝”。修改变量只会影响内存，函数运行结束就丢弃了，不会改动区块链数据。
        // 在处理结构体（Struct）时，如果你想更新数据，必须使用 storage。
        User storage user = users[msg.sender];

        // 核心逻辑：检查是否过了锁定期
        // 当前时间 >= 上次存款时间 + 24小时
        require(block.timestamp >= user.lastDeposit + LOCK_TIME, "Funds are locked! Wait 24 hours.");

        require(user.balance >= _amount, "Insufficient balance");

        user.balance -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
    }

    // 辅助函数：查看距离解锁还有多久（秒）
    function timeLeft(address _user) public view returns (uint256) {
        if (block.timestamp >= users[_user].lastDeposit + LOCK_TIME) {
            return 0;
        } else {
            return (users[_user].lastDeposit + LOCK_TIME) - block.timestamp;
        }
    }
}