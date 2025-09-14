
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResumeRegistry {
    address public owner;

    mapping(address => bool) public issuers;
    mapping(address => mapping(address => string)) private resumes;
    mapping(address => address[]) private resumeIssuers;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyIssuer() {
        require(issuers[msg.sender], "Not issuer");
        _;
    }

    function registerIssuer(address issuer) external onlyOwner {
        issuers[issuer] = true;
    }

    function issueResume(address subject, string memory cid) external onlyIssuer {
        resumes[subject][msg.sender] = cid;
        resumeIssuers[subject].push(msg.sender);
    }

    function getResume(address subject, address issuer) external view returns (string memory) {
        return resumes[subject][issuer];
    }

    function getLatestResume(address subject) external view returns (address, string memory) {
        require(resumeIssuers[subject].length > 0, "No resume");
        address latestIssuer = resumeIssuers[subject][resumeIssuers[subject].length - 1];
        return (latestIssuer, resumes[subject][latestIssuer]);
    }
}
