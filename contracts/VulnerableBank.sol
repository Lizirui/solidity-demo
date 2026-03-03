// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No funds");

        // ❌ 漏洞所在：先转账，后扣款
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");

        // 还没执行到这里，黑客就又进来了
        balances[msg.sender] = 0;
    }
}