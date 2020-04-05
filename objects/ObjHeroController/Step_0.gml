//scale movement to time
var secondsPassed = delta_time / 1000000;
var moveSpeedFrame = moveSpeed * secondsPassed;

//get movement in 8 directions from WASD
var moveXInput = 0;
var moveYInput = 0;
for (var i = 0; i < array_length_1d(heroKey); i++) 
{
    var this_key = heroKey[i];
    if keyboard_check(this_key) 
	{
        var this_angle = i * 90;
        moveXInput += lengthdir_x(1, this_angle);
        moveYInput += lengthdir_y(1, this_angle);
    }
}
var isMovePressed = (point_distance(0, 0, moveXInput, moveYInput) > 0);

if(isMovePressed)
{	
	//regular walking
	if(!target.isAttacking)
	{
		//apply acceleration
	    moveSpeed += moveSpeedAcceleration;
		moveSpeed = min(moveSpeed, moveSpeedMax);		
	}
	
	//walking while attacking
	else 
	{		
		//too fast
		if(moveSpeed > moveSpeedMaxAttack) 
		{
			//woah there slow down buddy
			moveSpeed -= moveSpeedBraking;
		}
		
		//at or under speed limit
		else 
		{
			//apply acceleration
		    moveSpeed += moveSpeedAcceleration;
			moveSpeed = min(moveSpeed, moveSpeedMaxAttack);
		}
	}
	
	//only record the direction when pressed so braking/momentum continues in same direction
	moveDir = point_direction(0, 0, moveXInput, moveYInput);	
}
else
{
	//apply braking
	moveSpeed -= moveSpeedBraking;
	moveSpeed = max(moveSpeed, moveSpeedMin);
}

//attack key action
if keyboard_check(heroKeyAttack)
{
	target.isAttacking = true;
}

if(moveSpeed > 0)
{	
	//calculate movement
	var deltaX = (lengthdir_x(moveSpeedFrame, moveDir));
	var deltaY = (lengthdir_y(moveSpeedFrame, moveDir)); 

	//tile layer collision	
	if(!tilemap_get_at_pixel(tileController.blockingMapId, target.x + deltaX, target.y + deltaY)) 
	{
		//apply movement to instance
	    target.x += deltaX;
	    target.y += deltaY;
	}
	else if(!tilemap_get_at_pixel(tileController.blockingMapId, target.x + deltaX, target.y))
	{
		//apply move
		target.x += deltaX;	
	}
	else if(!tilemap_get_at_pixel(tileController.blockingMapId, target.x, target.y + deltaY))
	{
		//apply move
		target.y += deltaY;	
	}	
	
	//edge collision
	target.x = min( max(target.x, roomBorderBlocking), (room_width - roomBorderBlocking));
	target.y = min( max(target.y, roomBorderBlocking), (room_height - roomBorderBlocking));	

	//get camera center
	centerCameraX = (cameraX + cameraWidth/2);
	centerCameraY = (cameraY + cameraHeight/2);

	//if target outside middle area, camera follows
	if(abs(target.x - centerCameraX) > cameraXBorder)
	{
		cameraX	+= deltaX;
	}
	if(abs(target.y - centerCameraY) > cameraYBorder)
	{
		cameraY	+= deltaY;
	}

	//limit camera to room
	var limitedCameraX = min( max(cameraX, 0), (room_width-cameraWidth));
	var limitedCameraY = min( max(cameraY, 0), (room_height-cameraHeight));

    //actually move the camera
	camera_set_view_pos(view_camera[0], limitedCameraX, limitedCameraY);	
}

//target animation doesn't stop moving until braking completed
target.isMoving = (moveSpeed > 0);

target.depth = -target.y;
