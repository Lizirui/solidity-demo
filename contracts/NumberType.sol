// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NumberType {
    // 状态变量：它会永久存储在区块链上
    uint256 public myNumber;

    // 修改数据的函数
    function set(uint256 _num) public  {
        myNumber = _num;
    }
    //   function set(uint256 _num) private  {
    //     myNumber = _num;
    // }

    // 读取数据的函数 (虽然 public 变量会自动生成 getter，但手写一个有助于理解)
    function get() public view returns (uint256) {
        return myNumber;
    }
}

// uint256: 这是一个数据类型，代表“256位无符号整数”。在区块链上存储数据是需要消耗 Gas（手续费）的，选择合适的类型非常重要。
// public: 这是一个可见性修饰符。它不仅允许外部调用该函数，如果是变量，Solidity 还会自动为你创建一个“查询”函数。
// view: 告诉编译器这个函数只读，不会修改区块链上的状态。