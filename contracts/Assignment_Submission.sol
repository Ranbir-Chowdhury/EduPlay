// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EduToken.sol";

contract AssignmentSubmission {
    EduToken public token;
    address public admin;

    struct Assignment {
        uint256 submissionTime;
        uint256 grade;
        bool graded;
    }

    mapping(address => mapping(uint256 => Assignment)) public assignments;
    mapping(address => uint256) public lastSubmitted;

    uint256 public rewardRate = 100;

    event AssignmentSubmitted(address indexed student, uint256 assignmentId, uint256 timestamp);
    event AssignmentGraded(address indexed student, uint256 assignmentId, uint256 grade, uint256 tokensAwarded);

    constructor(EduToken _token) {
        token = _token;
        admin = msg.sender;
    }

    function submitAssignment(uint256 assignmentId) external {
        require(assignments[msg.sender][assignmentId].submissionTime == 0, "Assignment already submitted");

        assignments[msg.sender][assignmentId] = Assignment(block.timestamp, 0, false);
        lastSubmitted[msg.sender] = block.timestamp;

        emit AssignmentSubmitted(msg.sender, assignmentId, block.timestamp);
    }

    function gradeAssignment(address student, uint256 assignmentId, uint256 grade) external {
        require(msg.sender == admin, "Only admin can grade assignments");
        require(assignments[student][assignmentId].submissionTime != 0, "Assignment not submitted");
        require(!assignments[student][assignmentId].graded, "Assignment already graded");

        assignments[student][assignmentId].grade = grade;
        assignments[student][assignmentId].graded = true;

        uint256 timeTaken = block.timestamp - assignments[student][assignmentId].submissionTime;
        uint256 tokensAwarded = calculateReward(grade, timeTaken);

        token.mint(student, tokensAwarded);

        emit AssignmentGraded(student, assignmentId, grade, tokensAwarded);
    }

    function calculateReward(uint256 grade, uint256 timeTaken) internal view returns (uint256) {
        uint256 speedMultiplier = 10000 / timeTaken;
        return (grade * rewardRate * speedMultiplier) / 100;
    }

    function setRewardRate(uint256 newRate) external {
        require(msg.sender == admin, "Only admin can set reward rate");
        rewardRate = newRate;
    }
}