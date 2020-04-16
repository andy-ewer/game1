//application starts here

//create the top level instances
timing = instance_create_layer(-100, -100, "Instances", objTiming);
controls = instance_create_layer(-100, -100, "Instances", objControls);
heroController = instance_create_layer(-100, -100, "Instances", objHeroController);
camera = instance_create_layer(-100, -100, "Instances", objCamera);
blockers = instance_create_layer(-100, -100, "Instances", objBlockers);
baddyController = instance_create_layer(-100, -100, "Instances", objBaddyController);


//offsets for cells in 4 directions plus here
var dirs = array_create(5);
var dirCnt = -1;
//here
var dir = array_create(2);
dir[0] = 0;
dir[1] = 0;	
dirs[++dirCnt] = dir;
//left
var dir = array_create(2);
dir[0] = -1;
dir[1] = 0;	
dirs[++dirCnt] = dir;
//right
var dir = array_create(2);
dir[0] = +1;
dir[1] = 0;
dirs[++dirCnt] = dir;
//up
var dir = array_create(2);
dir[0] = 0;
dir[1] = -1;
dirs[++dirCnt] = dir;
//down
var dir = array_create(2);
dir[0] = 0;
dir[1] = +1;
dirs[++dirCnt] = dir;

dirOffsets = dirs;