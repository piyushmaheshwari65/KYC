# KYCDetails
 
Know your customer or KYC procedure is used by the bank to verify the identity of the customer. To implement the KYC in the blockchain the following features are implemented -

●	User must upload his details for KYC Validation
●	Bank or any other institution must validate the KYC details.
●	Any Institution must be able to access the State of the KYC Validation of the user.
●	Users must add permission to other addresses to read the User KYC Details.
●	Users must be able to revoke permission access to other addresses.
●	Users/Institutions who have user’s permission must be able to access the user’s KYC Details.


Features
User Details Data Structure 

●	userAddress -> address 
●	name -> string 
●	residentAddress -> string 
●	phoneNo -> uint 
●	idType -> IDType (enum:  Adhaar, PAN, Passport, VoterID, DrivingLicense, RationCard )
●	Id -> string 
●	state -> State (enum: Approved, Rejected, Pending )
●	readAccessAllow -> mapping(address=>bool) 


Uploading the KYC details

●	User uploads the following details - 
○	Name 
○	Contact number
○	Address of user
○	Document Type
○	Document ID
○	Bank Address
○	Id type like adhaar, PAN etc
○	Id
○	State - Active, Pending or Rejected
●	Request Parameters: name, addr, phoneno, idtype and id
●	Response Parameter: null
●	Function visibility: External - needs to be called only from outside the contract. 
●	Once the user uploads the details and the transaction is successful, the user KYC object is created with status “Verification Pending”.


Validating the KYC details

●	The admin of the smart contract will only be able to validate the KYC Details.
●	The bank will enter the input of boolean type to Approve or Reject the KYC Object.
●	Request Parameters: userAddress , boolean (specifies Accept or reject of the contract)
●	Response Parameters: null
●	Function visibility: External - needs to be called only from outside the contract. 
●	Modifiers: can be accessed only by admin


Verify KYC Status

●	Verify the KYC details of the user
●	Returns if the KYC is valid or not
●	Request Parameters:  user address
●	Response Parameters: returns string of value "KYC Verification Status: " + status of KYC details like Approve or Reject or Pending
●	Function visibility: External - needs to be called only from outside the contract. 


Accessing KYC details

●	The KYC Object can be accessed by anyone whose address is present in the read permission list.
●	Request Parameters:  user address
●	Response Parameters: name, resaddress, phoneno and state
●	 Function visibility: External - needs to be called only from outside the contract. 
●	Modifiers: can be accessed only institutions who have been granted permission by user


Add Read Permission

●	User can add the address of the organization/institution who can access the KYC Details.
●	Request Parameters:  user address
●	Response Parameters: null
●	Function visibility: External - needs to be called only from outside the contract. 
●	Modifier: can only be access by user


Revoke Read Permission

●	User can revoke the address of the organization/institution that can access the KYC Details.
●	Request Parameters:  user address
●	Response Parameters: null
●	Function visibility: External - needs to be called only from outside the contract. 
●	Modifier:  can only be access by user



 



