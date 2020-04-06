#macro roomBorderBlocking 10

//animation frames
#macro idleStart 0 
#macro idleEnd 3
#macro walkStart 4
#macro walkEnd 7 
#macro mouthStart 8
#macro mouthEnd 11

//animation random timings
#macro mouthClosedRandom 300
#macro mouthClosedPlus 100
#macro mouthOpenRandom 200
#macro mouthOpenPlus 50

#macro stepRandom 20
#macro stepPlus 5
#macro distMultiplierMax 10

//mood values
#macro baddyMoodIdle 0
#macro baddyMoodChase 1

mood = baddyMoodIdle;
sightDistance = 6; //in blocking tile grid units
idleDirection = irandom(360);

//color filter
image_blend = make_colour_hsv(random(255), random(255), 255);

//inits for tracking animations
stepCounter=0;
mouthCounter=0;

//speeds
#macro walkSpeed 20
#macro mouthSpeed 40
#macro bumpSpeed 20
#macro idleSpeed 10


depth = round(-y);

