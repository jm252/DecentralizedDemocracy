pragma solidity ^0.8.0;

contract VoterVerification {
    mapping(bytes => bool) public verifiedProofs;

    event VerificationCompleted(bytes proof);

    function verifyVoter(string memory name, string memory driversLicense, string memory 
    socialSecurity) public{
        bytes memory zkProof = generateZkProof(name, driversLicense, socialSecurity);
        verifiedProofs[zkProof] = true;
        emit VerificationCompleted(zkProof);
    }

    function generateZkProof(string memory name, string memory driversLicense, string memory 
    socialSecurity) internal pure returns(bytes memory) {
        // Add ZK proof generation logic here
        // For the sake of this example, concatenate the three input strings and return the result
        string memory input = string(abi.encodePacked(name, driversLicense, socialSecurity));
        return bytes(input);
    }

    function verifyZkProof(bytes memory zkProof) public view returns(bool) {
        // Add ZK proof verification logic here
        // For the sake of this example, always return true
        return verifiedProofs[zkProof];
    }
}

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    VoterVerification public voterVerification;

    uint256 numCandidates = 0; 

    constructor(address verificationAddress) {
        voterVerification = VoterVerification(verificationAddress);
    }

    function setCandidates(string memory candidate1, string memory candidate2) public {
        candidates[0] = Candidate(candidate1, 0);
        candidates[1] = Candidate(candidate2, 0);
        numCandidates +=2;
    }

    function addCandidate(string memory candidate) public{
        candidates[numCandidates] = Candidate(candidate, 0); 
        numCandidates += 1; 
    }

    function vote(uint candidateIndex, bytes memory zkProof) public {
        require(voterVerification.verifyZkProof(zkProof), "Invalid ZK proof");
        require(candidateIndex < 2, "Invalid candidate index");
        candidates[candidateIndex].voteCount += 1;
    }

    function getCandidateName(uint candidateIndex) public view returns(string memory) {
        require(candidateIndex < 2, "Invalid candidate index");
        return candidates[candidateIndex].name;
    }

    function getCandidateVoteCount(uint candidateIndex) public view returns(uint) {
        require(candidateIndex < 2, "Invalid candidate index");
        return candidates[candidateIndex].voteCount;
    }

    // function isVerified(bytes memory zkProof) public view returns(bool) {
    //     (bool success, bytes memory result) = voterVerificationAddress.staticcall(abi.encodeWithSignature("isVerified(bytes)", zkProof));
    //     require(success, "Call to VoterVerification contract failed");
    //     return abi.decode(result, (bool));
    // }

    // function verifyVoter(string memory name, string memory driversLicense, string memory socialSecurity) public {
    //     (bool success, ) = voterVerificationAddress.call(abi.encodeWithSignature("verifyVoter(string,string,string)", name, driversLicense, socialSecurity));
    //     require(success, "Call to VoterVerification contract failed");
    // }
}

