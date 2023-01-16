Author: Kirin Hardinger


--- Setting up the environment ---
You will first need to download Godot game engine from https://godotengine.org/ I used version 3.4.4 but more recent versions should still function the same.

To import the project, launch Godot into the Project Manager and find the project.godot file in the folder. You should then be able to launch the project and edit the scenes.

All of the code is written in GDScript, the native Godot language. It's very similar to Python and documentation can be found here: https://docs.godotengine.org/en/stable/index.html

There are no additional libraries/plugins necessary.


--- Assets ---
In the directory, there are several assets that the project uses. Under res://images/ you can find images for pipe and water tiles, soap animations, water animations, arrows, check marks, etc. Animations include .png files of individual frames. Under res://resources/ there is a font and a .mp3 background music file.


--- Scene management ---
The Main node sets active scenes, loads instances of levels, and handles the enable of the pause screen.

Removing an instance of a level scene is done by the particular level itself if the level was completed fully. Otherwise, if the level was exited using the pause screen, the Main node will handle removing the instance.

Returning to the level selection screen is done within the Main node.


--- Levels ---
Every level has target units to be achieved by the player, shown by the Score label. Players change the cost of pipes and watch the water flow down different pipe paths of different capacities.

Players can hover over pipes, connectors, and showers to show a tooltip. The pipe tooltip shows current capacity and cost, the connector tooltip provides a definition, and the shower tooltip shows current units received.

Water flow is achieved using animated sprites and a tilemap system. A timer node is created to set the speed of water tiles being placed, causing the animated water tiles to spawn one-by-one through the pipes. Buttons are disabled during the animation to prevent the player from changing the cost of pipes.

Completing a level (units required = units sent) removes the instance of that particular level and then calls back to the Main node to return to the level selection screen. A check mark is shown on the level to show the player that they have successfuly completed the level and the next level's button is enabled to allow the player to continue the game.


---- Building the game ---
At any time, the game can be tested as an application by clicking the play button in the top right corner of the editor. To test the game in the default browser, you can click on the "Run in Browser" button in the top right corner of the editor.

The game can be built for HTML5 (or other platforms) within the editor through Project > Export > HTML5 (Runnable) > Export All.


--- Known bugs/missing features ---
* Tooltips continue to display/update when the pause menu is activated
* No end game screen
* No scoreboard or player database