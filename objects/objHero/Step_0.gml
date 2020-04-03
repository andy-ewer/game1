//scale movement to time
var secondsPassed = delta_time/1000000;
var moveSpeedFrame = moveSpeed*secondsPassed;

//get 8 directions from WASD
var moveXInput = 0;
var moveYInput = 0;
for (var i = 0; i < array_length_1d(heroKey); i++) 
{
    var this_key = heroKey[i];
    if keyboard_check(this_key) 
	{
        var this_angle = i*90;
        moveXInput += lengthdir_x(1, this_angle);
        moveYInput += lengthdir_y(1, this_angle);
    }
}
 
var isMoving = ( point_distance(0,0,moveXInput,moveYInput) > 0 );


if(!isMoving) //idle 
{
	if(sprite_index != sprHeroIdle) //fresh idle state, reset
	{		
		sprite_index = sprHeroIdle;
		blinkCounter = initBlinkCounter;
		poseCounter = initPoseCounter;
		image_index = idleRegular;		
	}
	else //continue idle state
	{	
		//increment stuff
		blinkCounter--;
		poseCounter--;

		//start blink
		if(blinkCounter == 0)
		{
			image_index += 1;	
		}

		//end blink
		else if(blinkCounter < (0-blinkLength))
		{
			image_index -= 1;
			blinkCounter = irandom(blinkRandom)+blinkRandomPlus;
		}

		//change pose status if not currently blinking
		if(blinkCounter > 0 and poseCounter < 0)
		{
			image_index = choose(idleRegular, idleSmile, idleLeft, idleRight, idleDown);
			poseCounter = irandom(poseRandom)+poseRandomPlus;
		}
	}
}
else //moving
{
	//do move
	sprite_index = sprHeroWalk;
    var moveDir = point_direction(0,0,moveXInput,moveYInput);
    x += lengthdir_x(moveSpeedFrame, moveDir);
    y += lengthdir_y(moveSpeedFrame, moveDir);
	depth = -y;
} 
