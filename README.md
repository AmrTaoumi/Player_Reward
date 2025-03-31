Player-Reward-MIPS-Assembly

The game consists of a simple walled environment. The player ('P') can move around the environment using the keyboard to collect different rewards ('R'). The game extension implements an enemy ('E') that blocks the player's path.

The rules for the creation of the game are as follows:

    The game must be presented to the user via the ‘Display’ device in MARS 4.5
    The user should be able to interact with the game via the ‘Keyboard’ device in the lower part of the same window.
    The user should be able to use the ‘WASD’ keys to move the player around the environment.
    Each collected reward should contribute 5 points to the player’s score.
    When a reward is collected, a new reward should appear in a di↵erent randomly-allocated location in the environment.
    The score should be presented to the user at the top of the display in the form ‘Score: 25’.
    If the player collides with a wall (i.e. tries to move into the wall), or if the player reaches 100 points, the game should end.
    When the game ends, the display should be cleared and a message displayed saying ‘GAME OVER’, along with the final score.

Structure:
The folder "basegame" contains the first version of the game, without the implementation of an enemy. While folder "basegame+extention" contains a new file called "extention.asm" that handles enemy behaviour.
