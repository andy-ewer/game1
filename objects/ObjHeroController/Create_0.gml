//movement
#macro heroMove_min 0
#macro heroMove_max 50
#macro heroMove_maxAttack 20
#macro heroMove_acceleration 4
#macro heroMove_braking 2

#macro heroMove_wallBufferX 4
#macro heroMove_wallBufferTop 8
#macro heroMove_wallBufferBottom 0

#macro hero_roomBorderBlocking 10

//create instance to control
target = instance_create_layer(200, 300, "Instances", objHero);


//init
moveSpeed = heroMove_min;
target.depth = -target.y;
moveDir = point_direction(0, 0, 0, 0);
deltaX = 0;
deltaY = 0;

//audio
audio_listener_orientation(0,1,0,0,0,1);
audio_play_sound(sndDum, 1, false);


//offsets for cells in 4 directions plus here
checkDirs = array_create(5);
var checkDirCnt = -1;
//here
var checkDir = array_create(2);
checkDir[0] = 0;
checkDir[1] = 0;	
checkDirs[++checkDirCnt] = checkDir;
//left
var checkDir = array_create(2);
checkDir[0] = -1;
checkDir[1] = 0;	
checkDirs[++checkDirCnt] = checkDir;
//right
var checkDir = array_create(2);
checkDir[0] = +1;
checkDir[1] = 0;
checkDirs[++checkDirCnt] = checkDir;
//up
var checkDir = array_create(2);
checkDir[0] = 0;
checkDir[1] = -1;
checkDirs[++checkDirCnt] = checkDir;
//down
var checkDir = array_create(2);
checkDir[0] = 0;
checkDir[1] = +1;
checkDirs[++checkDirCnt] = checkDir;

//highlight tracking
highlightList = ds_list_create();

