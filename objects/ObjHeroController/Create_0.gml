//movement
#macro heroMove_min 0
#macro heroMove_max 50
#macro heroMove_maxAttack 20
#macro heroMove_acceleration 4
#macro heroMove_braking 2

#macro heroMove_wallBufferX 4
#macro heroMove_wallBufferTop 7
#macro heroMove_wallBufferBottom 1

#macro hero_roomBorderBlocking 20

#macro heroAttack_range 10

//create instance to control
target = instance_create_layer(200, 300, "Instances", objHero);


//init
moveSpeed = heroMove_min;
target.depth = -target.y;
moveDir = point_direction(0, 0, 0, 0);
deltaX = 0;
deltaY = 0;
isControlEnabled = true;
gridX = 0
gridY = 0;

//audio
audio_listener_orientation(0,1,0,0,0,1);
audio_play_sound(sndDum, 1, false);



