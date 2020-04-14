moveSpeedFrame = 0;

//steps are erratic
stepCounter -= root.timing.ticksPassed;
if(stepCounter<0)
{
	if(image_index == b1Frames_idleEnd)
	{
		image_index = b1Frames_idleStart;
	}
	else if(image_index == b1Frames_walkEnd)
	{
		image_index = b1Frames_walkStart;
	}
	else if(image_index == b1Frames_mouthEnd)
	{
		image_index = b1Frames_mouthStart;
	}	
	else
	{
		image_index++;
	}
	stepCounter = irandom(b1Ani_stepRandom)+b1Ani_stepPlus;
}

