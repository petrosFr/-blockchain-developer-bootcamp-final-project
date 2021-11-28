// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

import "./Ownable.sol";


/// @title A scholarship smart contract
/// @author Subhi Issa
/// @notice You can use this contract for using a collateral on a smart contract as a security for a commitment in a scholarship

contract Scholarships is Ownable {
    //address payable public manager;
    uint256 public collateral; 
    uint256 public scholarshipId; //scholarshiId; //number of scholarships
    address payable [] public acceptedStudents;

    struct Scholarship {
        string name;
        uint256 totalSeats;
        uint256 takenSeats;
        bool isOpen;
        uint256 pool;
        address payable [] students;
    }

    struct Student {
        uint studentId;
        string  name;
        address payable addressStudent;
        uint256 mark1;
        uint256 mark2;
        uint256 percentage;
        bool isPassed;
    }
    
    mapping(uint256 => Scholarship) public scholarships;
    mapping(uint256 => Student) public students;
        
    event LogScholarshipAdded(
        string name,
        uint256 grantsAvailable,
        uint256 scholarshipId
    );
    
    event LogAddStudent(address student, uint256 scholarshipId);
    event LogScholarshipClosed(
        string name,
        uint256 grantsAvailable,
        uint256 scholarshipId
    );
    
    event LogScholarshipWinner(uint256 _scholarshipId, address _winner);
    event LogSendPrize(address student, uint256 balance, uint256 eventId);
    event LogSearchScholarship(uint256 _scholarshipId); 
    constructor() {
        scholarshipId = 0;
        collateral = 1 ether;
    }
    

    // @notice add a shcolarship 
    // @dev This function is to add a scholarship by the owner
    // @param _name The name of scholarship
    // @param _numSeats The number of seats in this scholarship
    // @return The id of the scholarship (starting by 0)
    function addScholarship(string memory _name, uint256 _numSeats) public onlyOwner returns (uint256)
    {
        Scholarship memory newScholarship = Scholarship(
            _name,
            _numSeats,
            0,
            true,
            0,
            new address payable [](0)
        );
        require(_numSeats > 0 ,'There is no places for this scholarship');
        scholarships[scholarshipId] = newScholarship;
        emit LogScholarshipAdded(_name, newScholarship.totalSeats, scholarshipId);
        scholarshipId++;
        return scholarshipId - 1;
    }
    
    // @notice search for a specific scholarship
    // @dev This function is to search a scholarship by the owner
    // @param _scholarshipId The Id of the scholarship
    // @return The name of the scholarship, the total of seats, number of taken seats, the status of the scholarship (open/close)
    // and the pool of funds
    function searchForScholarship(uint256 _scholarshipId) public view onlyOwner returns (string memory name,
            uint256 totalSeats,
            uint256 takenSeats,
            bool isOpen,
            uint256 _pool
        )
    {
        if (_scholarshipId + 1 > scholarshipId) {
            revert("Invalid index");
        } else {
            return (
                scholarships[_scholarshipId].name,
                scholarships[_scholarshipId].totalSeats,
                scholarships[_scholarshipId].takenSeats,
                scholarships[_scholarshipId].isOpen,
                scholarships[_scholarshipId].pool
            );
        }
    }
    
    mapping(address => bool) whiteList;
    mapping(address => bool) successList;


    // @notice add student address to a white list
    // @dev This function is to add the address of the selected studented to the white list, 
    // the student can register his name only in cas his address in the white list
    // @param _scholarshipId The Id of the scholarship
    // @param _studentAddress The address of the accepted student
    function addToWhiteList(uint256 _scholarshipId, address _studentAddress) public onlyOwner{
        require(scholarships[_scholarshipId].takenSeats < scholarships[_scholarshipId].totalSeats, "Sorry, there is no places for this scholarship!");
        require(!whiteList[_studentAddress],"This address is already inserted");
        scholarships[_scholarshipId].takenSeats++;
        whiteList[_studentAddress] = true;
        acceptedStudents.push(payable(_studentAddress));
    }
    

    // @notice Enroll in the scholarship
    // @dev This function is to enroll for a scholarship
    // @param _scholarshipId The Id of the scholarship
    // @param _studentId The Id of the student
    // @param _name The name of the student
    function enroll(uint256 _scholarshipId,uint256 _studentId,string memory _name) public payable {
        //console.log(msg.sender);
        if(whiteList[msg.sender]) {
            require(scholarships[_scholarshipId].isOpen == true, "This scholarship is closed");
            //require(scholarships[_scholarshipId].grantSold < scholarships[_scholarshipId].totalGrants, "Sorry, there is no places! OR The scholarship is not exsit");
            require(msg.value >= collateral,"Insufficient funds for your scholarship");
            students[_studentId]=Student(_studentId,_name,payable(msg.sender),0,0,0,false);
            scholarships[_scholarshipId].pool += collateral;
            payable(msg.sender).transfer(msg.value - collateral); //sending back change

            emit LogAddStudent(msg.sender, _scholarshipId);
        }else {
            revert("We regret to inform you that you were not selected to receive this award");
        }
    }
    
    // @notice Close a scholarship
    // @dev This function is close a scholarship
    // @param _scholarshipId The Id of the scholarship
    function scholarshipDeadline(uint256 _scholarshipId) public onlyOwner {
        if (_scholarshipId + 1 > scholarshipId) {
            revert("Invalid index");
        } else {
            scholarships[_scholarshipId].isOpen = false;
            emit LogScholarshipClosed(
                scholarships[_scholarshipId].name,
                scholarships[_scholarshipId].totalSeats,
                scholarshipId
            );
        }
    }

    // @notice Add the result for a student
    // @dev This function is to add the results of a specific student. This results are 2 values
    // if the final result is greater than 70%, we consider this student as a successful student. So, he can widthdraw the Ethereum to his address
    // @param _studentId The Id of the student
    // @param _mark1 The first mark
    // @param _mark2 The second mark
    function marksManagmt(uint _studentId, uint _mark1, uint _mark2) public onlyOwner returns (bool){
        uint256 totalMarks;
        uint256 percent;
        /**
         * @dev calculating totalMarks and percentage
         */
        
        totalMarks = _mark1 + _mark2;
        
        percent = totalMarks / 2;
        
        students[_studentId].percentage = percent;
        
        if (students[_studentId].percentage > 70){
            //successList.push(students[_studentId].addressStudent);
            successList[students[_studentId].addressStudent] = true;
            return (students[_studentId].isPassed=true);
        } else {
            return (students[_studentId].isPassed=false);
        }
    }
    
    // @notice Withdraw the collateral
    // @dev This function is to Withdraw the collateral
    // @param _scholarshipId The Id of the scholarship
    // @param _studentId The Id of the student
    function studentWithdraw(uint256 _scholarshipId, uint256 _studentId) public payable {
        require(scholarships[_scholarshipId].isOpen == false,"scholarship is still open");
        //require(msg.sender == scholarships[_scholarshipId].sucess);
        require(students[_studentId].isPassed == true,'You have failed');
        if (successList[msg.sender]){
            scholarships[_scholarshipId].pool -= collateral;
            payable(msg.sender).transfer(collateral);
        }else{
            revert("Failed student");
        }
    }
}