// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EduToken.sol";

contract Game_Platform {
    EduToken public token;
    address public admin;

    mapping(address => uint256) public inGameBalances;

    event TokensSpent(address indexed student, uint256 amount);

    constructor(EduToken _token) {
        token = _token;
        admin = msg.sender;
    }

    function spendTokens(uint256 amount) external {
        require(token.balanceOf(msg.sender) >= amount, "Insufficient token balance");

        token.burn(msg.sender, amount);
        inGameBalances[msg.sender] += amount;

        emit TokensSpent(msg.sender, amount);
    }

    function setAdmin(address newAdmin) external {
        require(msg.sender == admin, "Only admin can set a new admin");
        admin = newAdmin;
    }
}