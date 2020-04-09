
//************
//ATTACK
//************

if(isAttacking)
{
	if(sprite_index != sprHeroAttack)
	{
		//start a new attack
		sprite_index = sprHeroAttack; 
		image_index = 0;
	}
	else
	{
		//!!! work out the issue with calculating the perfect end point. currently detects 
		//!!! first tick of last frame. workaround is extra frame.
		
		//detect final frame
		if (image_index >= image_number-1) 
		{
			isAttacking = false;
		}
	}	
}


//************
//MOVE
//************

else if(isMoving)
{	
	sprite_index = sprHeroWalk; //keep walking
} 


//************
//IDLE
//************

else
{
	//fresh idle state, reset values
	if(sprite_index != sprHeroIdle) 
	{		
		sprite_index = sprHeroIdle;
		image_index = heroIdle_regular;		
		blinkCounter = heroInit_blinkCounter;
		poseCounter = heroInit_poseCounter;
		isBlinking = false;		
	}
	
	//continue existing idle state
	else 
	{
		//counting down
		blinkCounter -= timing.ticksPassed;
		poseCounter -= timing.ticksPassed;

		//start blink
		if(blinkCounter <= 0)
		{
			if(!isBlinking)
			{
				image_index++;	//matching blink frame is always +1 of current idle frame.
				isBlinking = true;
				blinkCounter = heroBlink_length;
			}
			else
			{
				image_index--;
				isBlinking = false;
				blinkCounter = irandom(heroBlink_random)+heroBlink_randomPlus;
			}
		}

		//change pose status, unless blinking. will happen after blink.
		if(blinkCounter > 0 and poseCounter < 0)
		{
			image_index = choose(heroIdle_regular, heroIdle_smile, heroIdle_left, heroIdle_right, heroIdle_down); //random pose
			poseCounter = irandom(heroPose_random)+heroPose_randomPlus;
		}
	}
}
