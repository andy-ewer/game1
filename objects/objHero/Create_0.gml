//sprite size
var scale = 4;

//animation frames
#macro idleRegular 0 
#macro idleSmile 2 
#macro idleLeft 4
#macro idleRight 6
#macro idleDown 8

//blink settings
#macro blinkLength 6
#macro blinkRandom 400
#macro blinkRandomPlus 20

//pose settings
#macro poseRandom 1000
#macro poseRandomPlus 60

//initial values for idle animations
#macro initBlinkCounter 100;
#macro initPoseCounter 300;
blinkCounter = initBlinkCounter;
poseCounter = initPoseCounter;
image_index = idleRegular;

//sprite scaling
image_xscale = scale;
image_yscale = scale;

//movement
moveSpeed = 60;
heroKey[0] = ord("D");
heroKey[1] = ord("W");
heroKey[2] = ord("A");
heroKey[3] = ord("S");

depth = -y;