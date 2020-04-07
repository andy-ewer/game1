//SETTINGS

//idle animation frames
#macro heroIdleRegular 0 
#macro heroIdleSmile 2 
#macro heroIdleLeft 4
#macro heroIdleRight 6
#macro heroIdleDown 8

//blink settings
#macro heroBlinkLength 6
#macro heroBlinkRandom 400
#macro heroBlinkRandomPlus 20

//pose settings
#macro heroPoseRandom 1000
#macro heroPoseRandomPlus 60

//initial values for idle animations
#macro heroInitBlinkCounter 100;
#macro heroInitPoseCounter 300;

//sprite size
var scale = 1;


//INIT

//set values
blinkCounter = heroInitBlinkCounter;
poseCounter = heroInitPoseCounter;
image_index = heroIdleRegular;
image_xscale = scale;
image_yscale = scale;

//controller updates these values
isMoving = false;
isAttacking = false;

randomize();