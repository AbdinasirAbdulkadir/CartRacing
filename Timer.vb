RANDOMIZE TIMER  ' Initialize random seed

' Define the possible events
CONST boost = 1
CONST obstacle = 2

' Generate a random event
eventCode = INT(RND * 2) + 1  ' Random number between 1 and 2 to decide the event

' Generate the intensity of the event (between 1 and 5)
intensity = INT(RND * 5) + 1

' Output the event code and intensity so it can be read by the Ruby or C++ program
PRINT eventCode; ","; intensity
