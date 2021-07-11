pragma solidity ^0.5.7;

contract Will {

    address owner; // address is unique to solidity
    uint fortune;
    bool isDeceased;
    
    address payable[] familyWallets;
    
    mapping (address => uint) inheritance;
    
    function setInheritance(address payable wallet, uint inheritAmount) public onlyOwner {
        familyWallets.push(wallet);
        inheritance[wallet] = inheritAmount;
    }
    
    // Public, essentially an endpoint (or at least logic that can be made available to an endpoint)
    constructor() public payable { // constructor executes upon deployment
        // public means that the function can be called within the contract and outside of it by someone else or another contract.
        // payable lets the function send and receive ether. When the contract receives ether, it stores it in its own address
        
        owner = msg.sender; // msg.sender is global variable represtative of address CALLING the function
        fortune = msg.value; // msg.value is amount of either sent to the function
        isDeceased = false;
    }
    
    // essentially these modifiers are being used as assertions against the input data.
    // we could add them to the function, but this allows it to be more flexible and use less code (gas)
    modifier onlyOwner {
        require (msg.sender == owner); // require throws if everything inside there doesn't compute to true
        _;
    }
    
    modifier mustBeDeceased {
        require (isDeceased == true);
        _;
    }
    
    // Private, can only be called WITHIN the contract.
    function payout() private mustBeDeceased{
        for (uint i=0; i<familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }
    }
    
    function deceased() public onlyOwner {
        isDeceased = true;
        payout();
    }

}