# Bombcrypto-AHK-Autoclicker

My own autoclicker for Bombcrypto. Used when sleeping.

In this code, I used what I called a Pixel Trigger algorithm. So instead of timed clicks, the code will wait for a specific color of pixel on the screen. When that specific pixel is detected, the program will continue to the next piece of code. If the specific pixel is not detected within a time limit (1 minute in my code), go to error_handler function. From my experience testing this thing, works much more efficient and reliable than timed clicks.
