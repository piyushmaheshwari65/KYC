pragma solidity ^0.6.12;

contract KYCDetails{
    
    //type of proof
    enum IDType{
      Adhaar,
      PAN,
      Passport,
      VoterID,
      DrivingLicense,
      RationCard
    }
    
    //KYC Verification State
    enum State{
        Approved,
        Rejected,
        Pending
    }
    
    //KYC User details
    struct UserDetails {
      address userAddress;
      string name;
      string residentAddress;
      uint phoneNo;
      IDType idType;
      string id;
      State state;
      mapping(address=>bool) readAccessAllow; // contains the address of users who have permission to read the userDetails
    }


    address admin;
    mapping(address => UserDetails) kycDetails; // contains the userDetails with their address                                                                                                                                
    
    //Set Admin Address
    constructor() public{
        admin = msg.sender;
    } 

    // Verfies if the transaction is started only by admin
    modifier onlyAdmin{
        require(admin == msg.sender,"Admin Access Only");
        _;
    }
    
    //verifies if the transaction is started only by user
    modifier onlyOwner{
        require(kycDetails[msg.sender].userAddress==msg.sender,"Only User is Allowed to Update Details");
        _;
    }
    
    // check is user address who started the transaction has permission to view the user details
    modifier onlyReadAccess(address custAddress){
        require(kycDetails[custAddress].readAccessAllow[msg.sender]==true,"Permission Denied");
        _;
    }
    
    event createDetailsEvent(address createdBy); // Event triggers when new user is created
    event readDetailsEvent(address readBy); // Event triggers whensome initiates read  userdetails
    event updateDetailsEvent(string resAddress, uint phNo); // Event triggers when user updates his details
    event verifyDetailsEvent(address verifierAddress); // Event triggers when user KYC Details is verfied.
    
    //user uploads his details for KYC Verification
    function uploadKYCDetails(string memory _name,string memory _residentAddress, uint _phoneno, uint8 _idType,string memory _id) external {
        emit createDetailsEvent( msg.sender);
        address custAddress = msg.sender;
        kycDetails[custAddress].userAddress = custAddress;
        kycDetails[custAddress].name = _name;
        kycDetails[custAddress].residentAddress =_residentAddress;
        kycDetails[custAddress].phoneNo=_phoneno;
        kycDetails[custAddress].idType = IDType(_idType);
        kycDetails[custAddress].id = _id;
        kycDetails[custAddress].state = State.Pending;
        kycDetails[custAddress].readAccessAllow[custAddress]=true;
        kycDetails[custAddress].readAccessAllow[admin]=true;
    }
    
    //user updates contact details
    function updateContactDetails(string memory _residentialAddress, uint _phNo) external onlyOwner{
        kycDetails[msg.sender].residentAddress =_residentialAddress;
        kycDetails[msg.sender].phoneNo=_phNo;
        kycDetails[msg.sender].state = State.Pending;
        emit updateDetailsEvent(_residentialAddress,_phNo);
        
    }
    
    //Bank or any other verification authority validates the user KYC details
    function validateKYCDetails(address custAddress, bool state) external onlyAdmin{
        if(state){
            kycDetails[custAddress].state = State.Approved;
        } else{
            kycDetails[custAddress].state = State.Rejected;
        }
    }
    
    // Any institution can validate users KYC status
    function verifyKYCStatus(address custAddress) public view returns(string memory){
//       emit verifyDetailsEvent( msg.sender);
       return string(abi.encodePacked("KYC Verification Status: ", getStatus(kycDetails[custAddress].state)));
    }
    
    //institutions with permission can view users KYC Details 
    function getKYCDetails(address custAddress) external view onlyReadAccess(custAddress) returns(string memory,string memory,uint, string memory){
        //emit readDetailsEvent(msg.sender);
        return(kycDetails[custAddress].name,kycDetails[custAddress].residentAddress, kycDetails[custAddress].phoneNo,getStatus(kycDetails[custAddress].state));
        
    }
    
    //user can add permission for other institutions to view his data
    function addUserPermission(address allowReadAccessAddress) external onlyOwner{
        kycDetails[msg.sender].readAccessAllow[allowReadAccessAddress]=true;
        
    }
    
    //user can revoke permission of any institution 
    function removeUserPermission(address removeReadAccessAddress) external onlyOwner{
        delete kycDetails[msg.sender].readAccessAllow[removeReadAccessAddress];
    }
    
    // returns status enum as string
    function getStatus(State state) public pure returns(string memory){
         if(state == State.Pending){
            return "Pending";
        } else if(state == State.Approved){
            return "Approved";
        }else{
            return "Rejected";
        }
    }
}
