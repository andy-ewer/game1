audio_listener_position(x, y, 0);

//ATTACK
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


//MOVE
else if(isMoving)
{	
	sprite_index = sprHeroWalk; //keep walking
} 


//IDLE
else
{
	//fresh idle state, reset values
	if(sprite_index != sprHeroIdle) 
	{		
		sprite_index = sprHeroIdle;
		image_index = heroIdleRegular;		
		blinkCounter = heroInitBlinkCounter;
		poseCounter = heroInitPoseCounter;
	}
	
	//continue existing idle state
	else 
	{	
		//counting down
		blinkCounter--;
		poseCounter--;

		//start blink
		if(blinkCounter == 0)
		{
			image_index++;	//matching blink frame is always +1 of current idle frame.
		}

		//end blink
		else if(blinkCounter < (0-heroBlinkLength))
		{
			image_index--;
			blinkCounter = irandom(heroBlinkRandom)+heroBlinkRandomPlus;
		}

		//change pose status, unless blinking. will happen after blink.
		if(blinkCounter > 0 and poseCounter < 0)
		{
			image_index = choose(heroIdleRegular, heroIdleSmile, heroIdleLeft, heroIdleRight, heroIdleDown); //random pose
			poseCounter = irandom(heroPoseRandom)+heroPoseRandomPlus;
		}
	}
}
