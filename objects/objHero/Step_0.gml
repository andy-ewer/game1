if(isMoving)
{	
	sprite_index = sprHeroWalk; //keep walking
} 
else
{
	if(sprite_index != sprHeroIdle) //fresh idle state, reset values
	{		
		sprite_index = sprHeroIdle;
		image_index = idleRegular;		
		blinkCounter = initBlinkCounter;
		poseCounter = initPoseCounter;
	}
	else //continue idle state
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