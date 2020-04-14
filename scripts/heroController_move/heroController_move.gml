if(moveSpeed > 0)
{
	target.isMoving = true;
	
	//calculate movement
	var moveSpeedFrame = moveSpeed * root.timing.secondsPassed;
	deltaX = (lengthdir_x(moveSpeedFrame, moveDir));
	deltaY = (lengthdir_y(moveSpeedFrame, moveDir)); 

	//try to move - XY
	var isBlocked = heroController_check4Points(deltaX, deltaY);
	if(!isBlocked) 
	{
		//move
	    target.x += deltaX;
	    target.y += deltaY;
	}
	else 
	{
		//try to slide into an empty or destroyed tile - X		
		var isBlocked = heroController_check4Points(deltaX, 0);
		if(!isBlocked)
		{
			//move only along X
			target.x += deltaX;	
			deltaY = 0;
		}
		else 
		{
			//try to slide into an empty or destroyed tile - Y
			var isBlocked = heroController_check4Points(0, deltaY);
			if(!isBlocked)
			{
				//move only along Y
				target.y += deltaY;	
				deltaX = 0;
			}
			else
			{
				//these values are still used to set audio velocity
				deltaX = 0;
				deltaY = 0;
			}
		}
	}
	
	//edge collision
	target.x = min( max(target.x, hero_roomBorderBlocking), (room_width - hero_roomBorderBlocking));
	target.y = min( max(target.y, hero_roomBorderBlocking), (room_height - hero_roomBorderBlocking));	
}
else 
{
	//target animation doesn't stop moving until braking completed	
	target.isMoving = false;
}
target.depth = -target.y;