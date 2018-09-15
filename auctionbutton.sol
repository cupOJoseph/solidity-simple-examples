
pragma solidity ^0.4.8;                  //specify compiler version
//this is a comment!

//an auction to pick the name of my new koi fish
contract Auctionbutton { 
        
    address owner;
    uint256 current_price;
    uint end_auction_time;
    string name;
    
    uint256 balance;
    
    //event for being sent ether. Dont send the contract ether directly, use the bid function.
    event Receive(uint value);
    
    //required fuctinons:
    // -constructor
    // -make a bid function
    // -owner cashout
    // -getter for current price and name.
    
    //constructor will initialize global variables
    // initial name foobar
    //initial price E0.005
    constructor() public{
        owner = msg.sender;
        current_price = 0.005 ether;
        //end time is current time plus 2 weeks = (2weeks*7days*24hours*60minutes*60seconds)= 1209600
        end_auction_time = now + 1209600;
        name = "foo bar";
        
        balance = 0;//make it easier to withdraw
    }
    
    //owner can cashout
    function cashout() public{
       require(msg.sender == owner);
       
       owner.transfer(balance);
       //could set balance to 0. but dont have to, just incase someone sends more eth to the address.
    }
    
    function cashout_custom(uint amount) public{
        require(msg.sender == owner);
        owner.transfer(amount);
    }
    
    function getName() view public returns(string){
        return name;
    }
    
    function getPrice() view public returns(uint256){
        return current_price;
    }
    
    //auction function 
    //users can pay more than current max to set the name
    //all funds go to owner
    //at the end of auction time, no more bids, name is final. (this could be done a few different ways)
    function bid(string _name) public payable{
        require(msg.value > current_price); //funds sent must be greater than top bid 
        require(block.timestamp <= end_auction_time); //time must not be after end of auction
        
        //the bid is higher than current and the auction is still live.
        balance = balance + msg.value;
        name = _name;
        current_price = msg.value;
        
    }
    
    //this will fire if funds are sent directly to the contract. (dont do it)
    function () public  payable {
        emit Receive(msg.value);
    }
    
    
}
