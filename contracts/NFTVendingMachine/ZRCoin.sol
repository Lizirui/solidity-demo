// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ZRCoin is ERC20 {
    constructor() ERC20("ZRCOIN", "ZR") {
        // 初始给自己印 100 万个 ZR 币
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}