//SETTINGS

//idle animation frames
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

//sprite size
var scale = 1;


//INIT

//set values
blinkCounter = initBlinkCounter;
poseCounter = initPoseCounter;
image_index = idleRegular;
image_xscale = scale;
image_yscale = scale;

//controller updates these values
isMoving = false;
isAttacking = false;

