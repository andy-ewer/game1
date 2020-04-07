//SETTINGS
//movement
#macro heroMoveSpeedMin 0
#macro heroMoveSpeedMax 50
#macro heroMoveSpeedMaxAttack 20
#macro heroMoveSpeedAcceleration 4
#macro heroMoveSpeedBraking 2

//camera
#macro cameraWidth 480
#macro cameraHeight 270
#macro cameraXBorder 40
#macro cameraYBorder 20

//create instance to control
target = instance_create_layer(200, 100, "Instances", objHero);

//keys
heroKey[0] = ord("D");
heroKey[1] = ord("W");
heroKey[2] = ord("A");
heroKey[3] = ord("S");
heroKeyAttack = ord(" ");

//init
moveSpeed = heroMoveSpeedMin;
target.depth = -target.y;
moveDir = point_direction(0, 0, 0, 0);

//view
view_enabled = true;
view_set_visible(0, true);
view_set_wport(0, cameraWidth);
view_set_hport(0, cameraHeight);

//camera
cameraX = target.x - (cameraWidth/2);
cameraY = target.y - (cameraHeight/2);
var limitedCameraX = min( max(cameraX, 0), room_width);
var limitedCameraY = min( max(cameraY, 0), room_height);
camera_set_view_pos(view_camera[0], limitedCameraX, limitedCameraY);
camera_set_view_size(view_camera[0], cameraWidth, cameraHeight);

//
audio_listener_orientation(0,1,0,0,0,1);
audio_play_sound(sndDum, 1, false);

