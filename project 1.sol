// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChooseYourAdventure {

    // Struct to represent a Game Story
    struct Story {
        uint256 id;
        string text; 
        uint256[] choices; // Choices that the player can select (next Story IDs)
    }

    // Mapping of story ID to story details
    mapping(uint256 => Story) public stories;

    // Current story ID for each player
    mapping(address => uint256) public playerProgress;

    // Event when a player selects an option
    event PlayerAction(address indexed player, uint256 storyId, uint256 choiceId);

    // Constructor to initialize the stories
    constructor() {
        // Create initial stories (Example)
        stories[0] = Story({
            id: 0,
            text: "You are in a dark forest. Do you go left or right?",
            choices: [1,2]
        });

        stories[1] = Story({
            id: 1,
            text: "You chose the left path and encounter a wild animal. Do you fight or run?",
            choices: [3, 4]
        });

        stories[2] = Story({
            id: 2,
            text: "You chose the right path and find a treasure chest. Do you open it or leave?",
            choices: [5, 6]
        });

        stories[3] = Story({
            id: 3,
            text: "You fight the animal and lose. Game Over.",
            choices: [] // No more choices, end of the story
        });

        stories[4] = Story({
            id: 4,
            text: "You run away and find a safe place. You win!",
            choices: [] // No more choices, end of the story
        });

        stories[5] = Story({
            id: 5,
            text: "You open the chest and find gold. You win!",
            choices: [] // No more choices, end of the story
        });

        stories[6] = Story({
            id: 6,
            text: "You leave the chest and walk away. Game Over.",
            choices: [] // No more choices, end of the story
        });
    }

    // Function to start or continue the game for a player
    function play(uint256 choiceId) public {
        uint256 currentStoryId = playerProgress[msg.sender];

        // Ensure the choice is valid
        require(choiceId < stories[currentStoryId].choices.length, "Invalid choice.");

        // Update the player's progress based on the choice
        uint256 nextStoryId = stories[currentStoryId].choices[choiceId];
        playerProgress[msg.sender] = nextStoryId;

        // Emit an event for the player's action
        emit PlayerAction(msg.sender, currentStoryId, choiceId);
    }

    // Function to get the current story text for the player
    function getCurrentStory() public view returns (string memory) {
        uint256 currentStoryId = playerProgress[msg.sender];
        return stories[currentStoryId].text;
    }

    // Function to check if the game has ended for the player
    function isGameOver() public view returns (bool) {
        uint256 currentStoryId = playerProgress[msg.sender];
        return stories[currentStoryId].choices.length == 0; // If no more choices, game is over
    }

    // Function to start a new game for the player
    function startNewGame() public {
        playerProgress[msg.sender] = 0; // Reset to the beginning of the story
    }
}
