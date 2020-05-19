/* 
gridLineOfSightClear(target1X, target1Y, target2X, target2Y)
*/

_x = argument0;
_y = argument1;

#macro yellAlertRange 10
		
var yellBaddies = ds_list_create();
collision_rectangle_list(_x-yellAlertRange, _y-yellAlertRange, _x+yellAlertRange, _y+yellAlertRange, objBaddy1, false, true, yellBaddies, false);
for(var i=0; i<ds_list_size(yellBaddies); i++)
{
	var eachBaddy = yellBaddies[| i];
	if(eachBaddy.mood == b1Mood_Idle)
	{
		eachBaddy.mood = b1Mood_Chase;
		eachBaddy.image_index = b1Frames_mouthStart;
		eachBaddy.mouthCounter = irandom(b1Ani_mouthOpenRandom)+b1Ani_mouthOpenPlus;		
		eachBaddy.lastSeenX = lastSeenX;
		eachBaddy.lastSeenY = lastSeenY;
		eachBaddy.lastSeenDir = lastSeenDir;
		audio_play_sound_on(eachBaddy.emitter, eachBaddy.voiceSound, 0, round(b1Audio_falloffDist-eachBaddy.dist));
		baddy_yell(eachBaddy.x, eachBaddy.y);
	}
}