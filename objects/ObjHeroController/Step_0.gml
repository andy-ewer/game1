//************
//INIT
//************

//get current hero blocking grid cell
var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x, target.y);
var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x, target.y);

var isControlEnabled = true;


//************
//DOORS
//************

//clear the previous highlights
tilemap_clear(root.blockers.overMapId, 0);

//check each direction
for(var i=0; i< array_length_1d(checkDirs); i++)
{
	//apply offsets
	var checkDir = checkDirs[i];
	var checkGridX = gridX + checkDir[0];
	var checkGridY = gridY + checkDir[1];
		
	//get offset tile
	var tileMap = tilemap_get(root.blockers.blockingMapId, checkGridX, checkGridY);
		
	//if not destroyed
	var tileIndex = tile_get_index(tileMap);
	var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
	if(!isDestroyed)
	{

		//grab the data for the cell
		var tileDamage = root.blockers.tileDamage[# checkGridX, checkGridY];
			
		//found an open door
		if(tileDamage[tileInfo_type] == tileType_doorOpen)	
		{
			
			//close door
			if(root.controls.isUsePressed)
			{
				tileIndex -= blockingTilesetWidth;
				tileMap = tile_set_index(tileMap, tileIndex);	
				tileMap = tilemap_set(root.blockers.blockingMapId, tileMap, checkGridX, checkGridY);

				tileDamage[tileInfo_type] = tileType_doorClosed;
				root.blockers.tileDamage[# checkGridX, checkGridY] = tileDamage;
			}
				
			//highlight door
			else
			{
				var tileMap = tilemap_get(root.blockers.overMapId, checkGridX, checkGridY);
				tileMap = tile_set_index(tileMap, 1);
				tileMap = tilemap_set(root.blockers.overMapId, tileMap, checkGridX, checkGridY);
			}
		
		}
			
		//found a closed door
		else if(tileDamage[tileInfo_type] == tileType_doorClosed)
		{
			//open door
			if(root.controls.isUsePressed)
			{			
					tileIndex += blockingTilesetWidth;
					tileMap = tile_set_index(tileMap, tileIndex);					
					tileMap = tilemap_set(root.blockers.blockingMapId, tileMap, checkGridX, checkGridY);
				
					tileDamage[tileInfo_type] = tileType_doorOpen;
					root.blockers.tileDamage[# checkGridX, checkGridY] = tileDamage;
			}
			
			//highlight door
			else
			{
				var tileMap = tilemap_get(root.blockers.overMapId, checkGridX, checkGridY);
				tileMap = tile_set_index(tileMap, 1);
				tileMap = tilemap_set(root.blockers.overMapId, tileMap, checkGridX, checkGridY);
				
				var top = (checkGridY) * blockingTileSizePixels - heroMove_wallBufferBottom;
				var bottom = (checkGridY+1) * blockingTileSizePixels + heroMove_wallBufferTop;
				var left = (checkGridX) * blockingTileSizePixels - heroMove_wallBufferX;
				var right = (checkGridX+1) * blockingTileSizePixels + heroMove_wallBufferX;
				
				var vertCenter = top + (bottom - top) / 2;
				var horiCenter = left + (right - left) / 2;
				
				var isClearOfDoor = target.y < top 
									||
									target.y > bottom 
									||
									target.x < left
									||
									target.x > right;					
				isOnClosedDoor = !isClearOfDoor;
					
				if(isOnClosedDoor)
				{
					isControlEnabled = false;
					moveSpeed = heroMove_max;
					
					var tileDamage = root.blockers.tileDamage[# checkGridX, checkGridY];
					var tileOrient = tileDamage[tileInfo_orient];
					if(tileOrient == tileOrient_vert)
					{
						if(target.y < vertCenter)
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
						if(target.x < horiCenter)
						{
							moveDir = 180;	
						}
						else
						{
							moveDir = 0;	
						}
					}
				}
			}
		}	
	}
}


//************
//CONTROLS
//************

if(isControlEnabled)
{

	//MOVE
	if(root.controls.isMovePressed)
	{	
		//regular walking
		if(!target.isAttacking)
		{
			//apply acceleration
		    moveSpeed += heroMove_acceleration;
			moveSpeed = min(moveSpeed, heroMove_max);		
		}
	
		//walking while attacking
		else 
		{		
			//too fast
			if(moveSpeed > heroMove_maxAttack) 
			{
				//woah there slow down buddy
				moveSpeed -= heroMove_braking;
			}
		
			//at or under speed limit
			else 
			{
				//apply acceleration
			    moveSpeed += heroMove_acceleration;
				moveSpeed = min(moveSpeed, heroMove_maxAttack);
			}
		}
	
		//only record the direction when pressed so braking/momentum continues in same direction
		moveDir = point_direction(0, 0, root.controls.moveXInput, root.controls.moveYInput);	
	}
	else
	{
		//apply braking
		moveSpeed -= heroMove_braking;
		moveSpeed = max(moveSpeed, heroMove_min);
	}
}


//************
//MOVEMENT
//************

if(moveSpeed > 0)
{
	target.isMoving = true;
	
	//calculate movement
	var moveSpeedFrame = moveSpeed * root.timing.secondsPassed;
	deltaX = (lengthdir_x(moveSpeedFrame, moveDir));
	deltaY = (lengthdir_y(moveSpeedFrame, moveDir)); 

	//try to move - XY
	var isBlocked = check4Points(target, deltaX, deltaY, isControlEnabled);
	if(!isBlocked) 
	{
		//move
	    target.x += deltaX;
	    target.y += deltaY;
	}
	else 
	{
		//try to slide into an empty or destroyed tile - X		
		var isBlocked = check4Points(target, deltaX, 0, isControlEnabled);
		if(!isBlocked)
		{
			//move only along X
			target.x += deltaX;	
			deltaY = 0;
		}
		else 
		{
			//try to slide into an empty or destroyed tile - Y
			var isBlocked = check4Points(target, 0, deltaY, isControlEnabled);
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



//************
//AUDIO
//************

//update 3d audio
audio_listener_position(target.x, target.y, 0);
audio_listener_velocity(deltaX, deltaY, 0);	


