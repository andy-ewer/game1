dir = argument0;

if (dir >= 360){
		dir -= 360;
}
if (dir < 0){
		dir += 360;
}

return dir;