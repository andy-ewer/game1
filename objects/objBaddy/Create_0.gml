#macro roomBorderBlocking 10

//animation frames
#macro walkStart 0 
#macro walkEnd 3 
#macro mouthStart 4
#macro mouthEnd 7

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
sightDistance = 5; //in blocking tile grid units

//color filter
image_blend = make_colour_hsv(random(255), random(255), 255);

//inits for tracking animations
stepCounter=0;
mouthCounter=0;

//speeds
#macro regularSpeed 20
#macro mouthSpeed 40
moveSpeed = regularSpeed;
bumpSpeed = 20;

depth = round(-y);

image_index = walkStart;