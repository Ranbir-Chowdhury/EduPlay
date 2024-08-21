// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EduToken is ERC20 {
    address public admin;

    constructor() ERC20("EduToken", "EDU") {
        admin = msg.sender;
        _mint(admin, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == admin, "Only admin can mint tokens");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        require(msg.sender == admin, "Only admin can burn tokens");
        _burn(from, amount);
    }
}