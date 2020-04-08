//kep back from edge of room
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
#macro baddyMoodLastSeen 2
#macro baddyMoodFinalLook 3

//idle movement random timings
#macro idleDirectionCounterRandom 200
#macro idleDirectionCounterPlus 10

//final look length
#macro finalLookCounterRandom 600
#macro finalLookCounterPlus 100

//affects randdom turning while idle
#macro idleDirectionAngleRandom 60

//tracking baddy mood behaviour
mood = baddyMoodIdle;
idleSightDistance = 6; //in blocking tile grid units
alertSightDistance = 60; 
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

//audio
voiceGridDistance = 20;
voiceSound = choose(sndBaddy1, sndBaddy2, sndBaddy3, sndBaddy4, sndBaddy5, sndBaddy6, sndBaddy7, sndBaddy8);
emitter = audio_emitter_create();
audio_emitter_position(emitter,x,y,0);
audio_emitter_falloff(emitter, 0, cameraWidth, 2);
audio_falloff_set_model(audio_falloff_linear_distance);
audio_emitter_pitch(emitter, 0.8 + ( irandom(1)*0.6 ));

//keeping track of last position hero was visible at
#macro lastSeenArrivedRange 60
lastSeenX = 0;
lastSeenY = 0;
lastDir = 0;
finalLookCounter = 0;
sightClear = false;
sightCounter = 0;
#macro updateSightTicks 30

depth = round(-y);
