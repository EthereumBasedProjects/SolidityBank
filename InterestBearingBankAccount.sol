// Bank Account Class interacting with Compound to Bear Interest
pragma solidity >=0.7.0 <0.9.0; 

/**
 * Interface to interact with Compound
*/
interface cETH {
    
    function mint() external payable; // Allowing minting, depositing into compound
    function redeem(uint redeemTokens) external returns (uint); // Withdrawal or Redeem from Compound

    function exchangeRateStored() external view returns (uint); // Calculates exchange rate from Ctoken
    function balanceOf(address owner) external view returns (uint256 balance); // Gets Token Balance of Given Address
}

contract InterestBearingBankAccount {

    uint totalContractBalance = 0; // Tracks Balance on Contract

    address COMPOUND_CETH_ROPSTEN_ADDRESS = 0x859e9d8a4edadfEDb5A2fF311243af80F85A91b8;
    cETH ceth = cETH(COMPOUND_CETH_ROPSTEN_ADDRESS);

    function getContractBalance() public view returns(uint){
        return totalContractBalance;
    }
    
    // Mappings for Address Balances & Depost Times
    mapping(address => uint) balances;
    mapping(address => uint) depositTimestamps;
    
    // Adds balance to contract. Timestamps used for Interest
    function addBalance() public payable {
        balances[msg.sender] = msg.value;
        totalContractBalance = totalContractBalance + msg.value;
        depositTimestamps[msg.sender] = block.timestamp;
    }
    
    // Get balance of any provided address
    function getBalance(address userAddress) public view returns(uint) {
        uint principal = balances[userAddress];
        uint timeElapsed = block.timestamp - depositTimestamps[userAddress]; // Time in Seconds
        return principa l + uint((principal * 10 * timeElapsed) / (100 * 365 * 24 * 60 * 60)); // Simple interest of 0.1%  per year
    }
    
    // Withdraw All Money in Contract for Sender
    function withdraw() public payable {
        address payable withdrawTo = payable(msg.sender);
        uint amountToTransfer = getBalance(msg.sender);
        withdrawTo.transfer(amountToTransfer);
        totalContractBalance = totalContractBalance - amountToTransfer;
        balances[msg.sender] = 0;
    }
    
    // Add Money to Contract
    function addMoneyToContract() public payable {
        totalContractBalance += msg.value;
    }

    
}
