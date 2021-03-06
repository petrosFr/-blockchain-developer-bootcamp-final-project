# -blockchain-developer-bootcamp-final-project
ConsenSys Academy’s 2021 Ethereum Developer Bootcamp Final Project

## Using a collateral on a smart contract as security for a commitment in a scholarship

There are a lot of universities and organizations that propose scholarships for students to continue their studies and improve their competencies in different domains! As there is a limited number of scholarships, the challenge for the organizers and supervisors is to give these scholarships to the students who deserve them.

This project is designed for providers of grants (donors) to propose a scholarship to students on condition of commitment in scholarships (an academic year, a training, or an internship). The student (or his guarantor) will have to add Ethereum as a collateral. At the end of the scholarship, the student can withdraw the Ethereum to his address (or guarantor's address) when she passes a test at the end or does the research she had to, otherwise, this collateral will not be restored to the student and will be used to fund a new opportunity for a new student.
We believe that this project helps the donors to propose scholarships without questioning if the costs of the scholarship will be misused from the student, moreover studentss will have to take this scholarship seriously so that they don't lose the collateral.

## Problem

Providing scholarships based on only the student's profile is not always a fair decision. There is a room for mismanagement of funds and untimely distribution in the case of having a lot of candidates.
My proposed project is not helpful in making the decision of who deserves the scholarship better, but it guarantees that the student will pass the required tests at the end of the scholarship or use his collateral to propose a new chance for a new student.

## Solution

Storing scholarship funds in smart contracts reduces the risk of money mismanagement by using a collateral on a smart contract. The smart contract is responsible for:
- Initializing contracts for the scholarship.
- Creating a whitelist for accepted candidates.
- Allowing the chosen candidate to apply for the scholarship.
- Collecting all the students' collaterals.
- Restoring collateral funds to the successful students at the end of the scholarship.

## Deployed Dapp url:
https://petrosfr.github.io/scholarshipSmartContract/

## Directory structure:

- contracts: Smart contracts that are deployed in Ropsten Test Network.
- interface: Project's frontend (HTML, CSS, JS).
- migrations: Migration files for deploying contracts in contracts directory.
- test: Tests for smart contracts.

## Starting the Application

The project serves to show, create, compilate, test and interface interaction with the Ethereum network via wallets such as MetaMask.

Technologies used include:

1. Truffle for migration and testing.
2. Web3 technologies.
3. MetaMask integration.

## How to run this project locally:
### Prerequisites

- Node.js >=v14
- Truffle and Metamask
- Npm

### Contracts

- Run npm install in projet root to install Truffle build and smart contracts dependencies.
- `truffle migrate --network development`.
- Run tests in Truffle console: `truffle test`.

### Frontend

- `cd client`.
- `npm install http-server -g`.
- `http-server`.
- Open `http://localhost:8080/index`.


### Workflow:
- Select Admin.
- Add a scholarship (Name and number of seats).
- Add candidate address for this scholraship (Index 0).
- Show the information of the student using scholarshipId.
- Go back to login page.
- Select student.
- As a student: add shcolarshipId, studentId and Name of student(using the address student adding in the previous step).
- Go back to login page.
- Select Admin.
- Add studentId, mark1 and mark2 (using the owner address).
- Go back to login page.
- Select student.
- As a student add shcolarshipId, studentId to widthraw the collateral(using the address student adding in the previous step).
- If the percentage of the results greater than 70% the Ethereum collateral will be withdrawn to his address, otherwise, this collateral will not be restored to the student.


## Screencast link
https://youtu.be/-l6aVqmsYDM

## Public Ethereum wallet for certification:
0xAE4855bE1935FFF4cB85C0fe63465aF30f25bC71

## Github url:
https://github.com/petrosFr/-blockchain-developer-bootcamp-final-project

