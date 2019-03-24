//: ![The real head of the household?](Neon/Menu/Title/Title1.png)
/*:
 # GIBYS TRAVEL

 `GIBYS TRAVEL` is a Gravity Puzzle, where you as the player help our
 portagonist `GIBY` to find the exit and solve the puzzle.

 ![The real head of the household?](Neon/Giby/Giby_Side_Walk.png)
 `GIBY` is small and cute character with the ability to alter gravity.

 - - -

 ## Controls:

 1. **Alter Gravity:**

    `GIBY` has the ability to reverse the gravity of its surroundings.
    To do so, just tap `GIBY` once and gravity will be reversed.

 2. **Move `GIBY`:**

    You can move `GIBY` by dragging and holding `GIBY` in a direction.
    However keep in mind `GIBY` can only move to the right or left.
    If you want to move upwards or downwards you need to change the gravity.

 - - -

 ## Settings:
 You can use the built-in settings to disable or enable functionality:

 * **Enable Music:**

    Enables or disables the background music.

 * **Change Theme:**

    Allows you to switch between the two provided themes `.neon` and `.bold`.

 - - -

 ## Recommended Way to Play
 It is recommended to play the game in Landscape Mode, as the view otherwise may get streched.

 - - -
 */

// Lets import PlaygroundSupport framework to use Playground specific features.
import PlaygroundSupport

// We load the game and start it right away
// We need to keep reference to the game, so it does not get deallocated.
let game = GibysTravelGame()

// No we assign our gameView to playgrounds liveView
// so it gets rendered on the right.
PlaygroundPage.current.liveView = game.view

/*:

 ## Technologies

 This playground mainly takes advantage of SpriteKit and UIKit.

 - - -

 ## Music
 The background music is released under ccbysa2.5 Creative Commons License,
 therefore I need to credit the artist El Wud for the song No Gravity.

 [No Gravity by El Wud](https://ia601306.us.archive.org/8/items/NoGravity/No%20Gravity.mp3)
 */
