# Bombcrypto-AHK-Autoclicker

My own autoclicker for Bombcrypto. Used when sleeping. For educational only, do not use public autocliker or bot software unless its made by you or you are 100% certain its safe.

In this code, I used what I called a Pixel Trigger algorithm. So instead of timed clicks, the code will wait for a specific color of pixel on the screen. When that specific pixel is detected, the program will continue to the next piece of code. If the specific pixel is not detected within a time limit (1 minute in my code), go to error_handler function. From my experience testing this thing, works much more efficient and reliable than timed clicks.

I also use this pixel trigger to detect whether the game is in "normal" state (inside the treasure hunt map) or not. If not, go to error_handler function. From the Unity loading screen, the program will automatically log in into the game using of course, pixel trigger.
