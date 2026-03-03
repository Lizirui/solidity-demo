// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 自定义错误定义在合约外，可以被多个合约共用
// 是否可以写在别的文件，被多个合约调用
error InsufficientBalance(uint256 available, uint256 required);
error NotOwner();

contract ErrorBank {
    address public owner;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    // 存款
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // 取款：演示高效报错
    function withdraw(uint256 _amount) public  {
        // 使用 if + revert 代替 require
        if (balances[msg.sender] < _amount) {
            // 报错时抛出自定义错误，并带上当前数据
            revert InsufficientBalance(balances[msg.sender], _amount);
        }

        // 修改账本
        balances[msg.sender] -= _amount;

        // 执行转账
        (bool success, ) = msg.sender.call{value: _amount}("");

        // 转账失败仍需处理
        if (!success) {
            revert("Transfer failed");
        }
    }

    // 只有 owner 能查看合约总额
    function getContractBalance() public view returns (uint256) {
       if (msg.sender != owner) {
            revert NotOwner();
        }
        return address(this).balance;
    }
}