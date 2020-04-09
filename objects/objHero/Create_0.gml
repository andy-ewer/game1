//SETTINGS

//idle animation frames
#macro heroIdle_regular 0 
#macro heroIdle_smile 2 
#macro heroIdle_left 4
#macro heroIdle_right 6
#macro heroIdle_down 8

//blink settings
#macro heroBlink_length 6
#macro heroBlink_random 400
#macro heroBlink_randomPlus 20

//pose settings
#macro heroPose_random 1000
#macro heroPose_randomPlus 60

//initial values for idle animations
#macro heroInit_blinkCounter 100;
#macro heroInit_poseCounter 300;

//INIT

//set values
blinkCounter = heroInit_blinkCounter;
isBlinking = false;
poseCounter = heroInit_poseCounter;
image_index = heroIdle_regular;
var scale = 1;
image_xscale = scale;
image_yscale = scale;

//controller updates these values
isMoving = false;
isAttacking = false;

randomize();