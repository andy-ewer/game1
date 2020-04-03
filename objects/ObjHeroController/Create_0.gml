//setttings
#macro moveSpeedMin 0
#macro moveSpeedMax 150
#macro moveSpeedMaxAttack 20
#macro moveSpeedAcceleration 5
#macro moveSpeedBraking 5

//create instance to control
target = instance_create_layer(100, 100, "Instances", objHero);

//keys
heroKey[0] = ord("D");
heroKey[1] = ord("W");
heroKey[2] = ord("A");
heroKey[3] = ord("S");
heroKeyAttack = ord(" ");

//init
moveSpeed = moveSpeedMin;
target.depth = -target.y;
moveDir = point_direction(0, 0, 0, 0);