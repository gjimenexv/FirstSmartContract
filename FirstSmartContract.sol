// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    //This is an enum to define valid values for a variables
     enum State {Active,Inactive}

    //This is a struct to create kind of a object.
    struct Project {
        string id;
        string name;
        string description;
        address payable author;
        State state;
        uint256 funds;
        uint256 fundraisingGoal;
    }
    //This is a struct declaration
    Project public project;

    //This is a event use to provide logs un execution runtime
    event ProjectFunded(string projectId, uint256 value);
    //This is a event use to provide logs un execution runtime
    event ProjectStateChanged(string id, State state);

    constructor(
        string memory _id,
        string memory _name,
        string memory _description,
        uint256 _fundraisingGoal
    ) {
       //This is a struct build. attribute order matters.
        project = Project(
            _id,
            _name,
            _description,
            payable(msg.sender),
            State.Active,
            0,
            _fundraisingGoal
        );
    }
    //This is modifier to define in a function who can invoke it
    modifier isAuthor() {
        require(
            project.author == msg.sender,
            "You need to be the project author"
        );
        _;
    }
    //This is modifier to define in a function who can invoke it
    modifier isNotAuthor() {
        require(
            project.author != msg.sender,
            "As author you can not fund your own project"
        );
        _;
    }

    function fundProject() public payable isNotAuthor {
        //Validation using requiere to avoid funding when state is Inactive
        require(project.state != State.Inactive, "The project can not receive funds");
        //Validation using requiere to avoid funding of zero.
        require(msg.value > 0, "Fund value must be greater than 0");
        project.author.transfer(msg.value);
        project.funds += msg.value;
        //Invoke the event kind to provide the relevant info
        emit ProjectFunded(project.id, msg.value);
    }

    function changeProjectState(State newState) public isAuthor {
        require(project.state != newState, "New state must be different");
        project.state = newState;
        //Invoke the event kind to provide the relevant info
        emit ProjectStateChanged(project.id, newState);
    }
}
