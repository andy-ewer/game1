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
#macro distMultiplierMax 10 //this is the distance over which the bump shove power fades.

//mood values
#macro baddyMoodIdle 0
#macro baddyMoodChase 1

//idle movement random timings
#macro idleDirectionCounterRandom 200
#macro idleDirectionCounterPlus 10

#macro idleDirectionAngleRandom 60

//tracking baddy mood behaviour
mood = baddyMoodIdle;
sightDistance = 6; //in blocking tile grid units
idleDirection = 0;
idleDirectionCounter = 0;

//color filter
image_blend = make_colour_hsv(random(255), random(255), 255);

//inits for tracking animations
stepCounter=0;
mouthCounter=0;

//speeds
#macro walkSpeed 10
#macro mouthSpeed 30
#macro bumpSpeed 10
#macro idleSpeed 5
#macro idleBumpSpeed 5

depth = round(-y);

voiceGridDistance = 20;
voiceSound = choose(sndBaddy1, sndBaddy2, sndBaddy3, sndBaddy4, sndBaddy5, sndBaddy6, sndBaddy7, sndBaddy8);
voicePitch = 0.8 + ( irandom(1)*0.6 );

//image_xscale = 1 + ((irandom(20)-5)/100);
//image_Yscale = 1 + ((irandom(30))/100);