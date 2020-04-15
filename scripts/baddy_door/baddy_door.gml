
var moveDir = 0;				
var vertCenter = (thisY + 0.5) * blockingTileSizePixels;
var horiCenter = (thisX + 0.5) * blockingTileSizePixels;
var tileOrient = tileInfo[tileInfo_orient];
var moveSpeedFrame = b1Speed_mouth * root.timing.secondsPassed;

if(tileOrient == tileOrient_vert)
{
	if(y < vertCenter)
	{
		moveDir = 90;	
	}
	else
	{
		moveDir = 270;
	}			
}

else if(tileOrient == tileOrient_hori)
{
	if(x < horiCenter)
	{
		moveDir = 180;	
	}
	else
	{
		moveDir = 0;	
	}
}


x += (lengthdir_x(moveSpeedFrame, moveDir));
y += (lengthdir_y(moveSpeedFrame, moveDir));