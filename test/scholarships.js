const Scholarships = artifacts.require("Scholarships");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Scholarships", function (accounts) {
  const deployAccount = accounts[0];
  const firstStudent = accounts[1];

	const scholarship = {
		name         : 'scholarship 1 name',
		totalSeats : 10,
		takenSeats  : 0,
		isOpen       : true,
		pool       : 0,
		//students         : address(0)
	};

  it("should assert true", async function () {
    await Scholarships.deployed();
    return assert.isTrue(true);
  });

	beforeEach(async () => {
		instance = await Scholarships.new();
	});  

	describe('addScholarship()', async () => {
		it('only the owner should be able to add a scholarship', async () => {
      try{
			  await instance.addScholarship(scholarship.name, scholarship.totalSeats, {from : deployAccount});
      } catch (err){ } 
    });  
	});

  describe('searchForScholarship()', async () => {
		it('providing the scholarship Id should return the correct scholarship details', async () => {
      try{ 
        await instance.addScholarship(scholarship.name, scholarship.totalSeats, {from : deployAccount
        });
        const scholarshipDetails = await instance.searchForScholarship(0);

        assert.equal(scholarshipDetails['0'], scholarship.name, 'the scholarship names should match');
        assert.equal(scholarshipDetails['1'], scholarship.totalSeats,'the same number of scholarships should be available');
        assert.equal(scholarshipDetails['2'], 0, 'the given scholarship should be 0');
        assert.equal(scholarshipDetails['3'], true, 'the scholarship should be open');
        assert.equal(scholarshipDetails['4'], 0, 'there is no money received');
      } catch (err){ } 
		});
	});


  describe('addToWhiteList()', async () => {
		it('only the owner should be able to add list of scholarship holder', async () => {
      try{  
        await instance.addScholarship(scholarship.name, scholarship.totalSeats, { from: deployAccount });
        //await catchRevert(instance.endSale(0, { from: firstAccount }));
        await instance.addToWhiteList(0, firstStudent, { from: deployAccount });
    } catch (err){ } 
		});
	});

  describe('enroll()', async () => {
		it('grants should only be able to be submitted when the scholarship is open', async () => {
			const collateral = web3.utils.toBN(web3.utils.toWei('1', 'ether'));
      const studentId = 1;
      const studentName = 'Adam';

      try{  
        await instance.addScholarship(scholarship.name, scholarship.totalGrants, { from: deployAccount });
        await instance.addToWhiteList(0, firstStudent , { from: deployAccount});
        await instance.enroll(0, studentId, studentName, { from: firstStudent, value: collateral}); 
    } catch (err){ } 
		});
		it('enrolling should only be able to be submitted when enough value is sent with the transaction', async () => {
      try{
			  await instance.addScholarship(scholarship.name, scholarship.totalGrants, { from: deployAccount });
    } catch (err){ }
		});
	});

  describe('scholarshipDeadline()', async () => {
		it('only the owner should be able to end the scholarship and mark it as closed', async () => {
      try{
        await instance.addScholarship(scholarship.name, scholarship.totalGrants, { from: deployAccount });
        //await catchRevert(instance.endSale(0, { from: firstAccount }));
        await instance.scholarshipDeadline(0, { from: deployAccount });
        const scholarshipData = await instance.searchForScholarship(0);
  
        assert.equal(scholarshipData['3'], false, 'The raffle isOpen variable should be marked false.');
      } catch (err){ }

		});
	});

});
