## Design patttern used

1. Access Control Design Patterns: Ownable design pattern used in five functions: addScholarship(), searchForScholarship(), addToWhiteList(), scholarshipDeadline and marksManagmt(). These functions do not need to be used by anyone else apart from the contract creator, i.e. the party that is responsible for managing the scholarship operations.
2. Inheritance and Interfaces: Scholarships contract inherits the OpenZeppelin Ownable contract to enable ownership for one managing a scholarship.
3. Optimizing Gas: by creating more efficient Solidity code through avoiding loops.