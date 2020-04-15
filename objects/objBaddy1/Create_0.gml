//behaviour values
#macro b1Behaviour_lastSeenArrivedRange 2 //stops herd jostling over a destination. in blocking tile grid units
#macro b1Behaviour_updateSightTicks 30 //in ticks
#macro b1Behaviour_idleSightDistance 6 //in blocking tile grid units
#macro b1Behaviour_alertSightDistance 60  //in blocking tile grid units
#macro b1Behaviour_distMultiplierMax 10 //this is the distance over which the bump shove power fades, in room pixels.
#macro b1Behaviour_roomBorderBlocking 10 //keep back from edge of room, in room pixels

//animation frame indexes
#macro b1Frames_idleStart 0 
#macro b1Frames_idleEnd 3
#macro b1Frames_walkStart 4
#macro b1Frames_walkEnd 7 
#macro b1Frames_mouthStart 8
#macro b1Frames_mouthEnd 11

//animation random timings in ticks
#macro b1Ani_mouthClosedRandom 300
#macro b1Ani_mouthClosedPlus 100
#macro b1Ani_mouthOpenRandom 200
#macro b1Ani_mouthOpenPlus 50
#macro b1Ani_stepRandom 20
#macro b1Ani_stepPlus 5

//moods
#macro b1Mood_Idle 0
#macro b1Mood_Chase 1
#macro b1Mood_LastSeen 2
#macro b1Mood_FinalLook 3

//idle movement random ranges
#macro b1Idle_directionCounterRandom 200 //in ticks
#macro b1Idle_directionCounterPlus 10
#macro b1Idle_directionAngleRandom 60 //as an angle

//final look length in ticks
#macro b1Final_lookCounterRandom 600
#macro b1Final_lookCounterPlus 100

//speeds in room pixels per second
#macro b1Speed_walk 10
#macro b1Speed_mouth 30
#macro b1Speed_bump 10
#macro b1Speed_idle 5
#macro b1Speed_idleBump 5

//audio
#macro b1Audio_falloffDist 480
#macro b1Audio_falloffFactor 2 //this seems to work so when at 2, sound begins at 1/2 falloffDist away
#macro b1Audio_pitchMin 0.8
#macro b1Audio_pitchMax 2.4

//tracking mood behaviour
mood = b1Mood_Idle;
idleDirection = irandom(360);
idleDirectionCounter = 0;
lastDirX = 0;
lastDirY = 0;

//tracking animations
stepCounter=0;
mouthCounter=0;

//tracking last position hero was visible at
lastSeenX = 0;
lastSeenY = 0;
lastSeenDir = 0;
finalLookCounter = 0;
sightClear = false;
sightCounter = 0;
dist = 0;

//movement
deltaX = 0;
deltaY = 0;

//audio
emitter = audio_emitter_create();
audio_emitter_position(emitter,x,y,0);
audio_emitter_falloff(emitter, 0, b1Audio_falloffDist, b1Audio_falloffFactor);
audio_falloff_set_model(audio_falloff_linear_distance);

//customise this instance of the baddy
image_blend = make_colour_hsv(random(255), random(255), 255); //apply random color filter to each instance
voiceSound = choose(sndBaddy1, sndBaddy2, sndBaddy3, sndBaddy4, sndBaddy5, sndBaddy6, sndBaddy7, sndBaddy8);
var pitch = b1Audio_pitchMin + ( random(1)*(b1Audio_pitchMax-b1Audio_pitchMin));
audio_emitter_pitch(emitter, pitch);
depth = round(-y);

