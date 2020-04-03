//steps are erratic
stepCounter--;
if(stepCounter<0)
{
	image_index++;
	if(image_index == 4)
	{
		image_index = 0;		
	} 
	else if(image_index == 0)
	{
		image_index = 5;
	}
	stepCounter = irandom(40)+10;
}

//mouth opens and closes
mouthCounter--;
if(mouthCounter<0)
{

	if(image_index < 4)
	{
		image_index+= 4;
		mouthCounter = irandom(400)+400;	
	}
	else
	{
		image_index-= 4;
		mouthCounter = irandom(100)+10;	
	}
	
}