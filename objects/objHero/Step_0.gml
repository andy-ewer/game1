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
		image_index = idleRegular;		
		blinkCounter = initBlinkCounter;
		poseCounter = initPoseCounter;
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
		else if(blinkCounter < (0-blinkLength))
		{
			image_index--;
			blinkCounter = irandom(blinkRandom)+blinkRandomPlus;
		}

		//change pose status, unless blinking. will happen after blink.
		if(blinkCounter > 0 and poseCounter < 0)
		{
			image_index = choose(idleRegular, idleSmile, idleLeft, idleRight, idleDown); //random pose
			poseCounter = irandom(poseRandom)+poseRandomPlus;
		}
	}
}
