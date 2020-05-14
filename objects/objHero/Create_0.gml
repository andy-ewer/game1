//this is mostly conserned with display and animation. the controller has the other stuff.

//SETTINGS

//idle animation frame indexes
#macro heroIdle_regular 0 
#macro heroIdle_smile 2 
#macro heroIdle_left 4
#macro heroIdle_right 6
#macro heroIdle_down 8

//blink settings, in ticks
#macro heroBlink_length 6
#macro heroBlink_random 400
#macro heroBlink_randomPlus 20

//pose settings, in ticks
#macro heroPose_random 400
#macro heroPose_randomPlus 60

//attack settings, in ticks per frame
#macro heroAttack_frames 3

//initial values for idle animations, in ticks
#macro heroInit_blinkCounter 100
#macro heroInit_poseCounter 300

//INIT

//set values
blinkCounter = heroInit_blinkCounter;
isBlinking = false;
poseCounter = heroInit_poseCounter;
heroAttackCounter = 0;

//health
stamina = 100;
#macro staminaDelayInit 100
staminaDelay = 0;
#macro staminaRegainRate 2

//update appearance
image_index = heroIdle_regular;
var scale = 1;
image_xscale = scale;
image_yscale = scale;

//controller updates these values
isMoving = false;
isAttacking = false;

//weapons
weapon = instance_create_layer(0, 0, "Instances", objWeapon);

//be like, totally random
//randomize();