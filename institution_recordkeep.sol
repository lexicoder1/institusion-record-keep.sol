pragma solidity ^0.8.0;
//A particular financial institution is looking to have their records stored onchain
//and looking to have an *external *`identifier` tied to each customers Details....
//the identifier should be the keccak256 hash of the customer’s name and time of registration ,
//each customer can also approve another customer to view their details[meaning that only admins
//and approved customers have the right to view another customer’s data]....
//For simplicity purposes, the Bank is looking to have a separate contract that has all *setter* functions
//and another contract that has all the *getter * functions(Interacting with each other of course)..
//Finally, they want an interface for all the contracts they have......
//NOTE: USE THE APPROPRIATE FUNCTION AND VARIABLE VISIBILITY SPECIFIERS
contract vivo{
    struct customers{
        string name;
        uint age;
        uint timeOfRegistration;
        address add;
    }
    //  bytes32  customerID;
     address owner;
     address admin;
mapping (bytes32 => customers) customersDets;
mapping (address=> mapping (address=>bool)) approved;
mapping (address=>bool) check;
mapping (address=>bytes32) addresstoid;
uint public time;
constructor(){
    admin =msg.sender;
}
function createCustomerDetails(string  memory _name, uint _age) public{
    require(check[msg.sender]==false);
  bytes32 customerID = keccak256(abi.encodePacked(_name,block.timestamp));
    customers storage _customer = customersDets[customerID];
    _customer.name= _name;
    _customer.age= _age;
    addresstoid[msg.sender]=customerID;
    _customer.timeOfRegistration=block.timestamp;
    _customer.add=msg.sender;
    check[msg.sender]=true;
}
function approve(address add)public{
    owner=msg.sender;
    approved[owner][add]=true;
}
function admincheck(address add)public view returns(customers memory){
    require (msg.sender==admin);
    return customersDets[ addresstoid[add]];
}
function customercheck()public view returns(customers memory){
    return customersDets[ addresstoid[msg.sender]];
}
function checkinganothercustomerdetails(address _owner)public view returns(customers memory){
    require(approved[_owner][msg.sender]==true,'you have not been approved');
    return customersDets[ addresstoid[_owner]];
}
// function gettime(string  memory _name, uint _time)public  {
//   bytes32 g=  keccak256(abi.encodePacked(_name,_time));
//   customers memory d = customersDets[customerID];
//     // require(msg.sender==d.add);
//     // return d.timeOfRegistration;
// }
}
