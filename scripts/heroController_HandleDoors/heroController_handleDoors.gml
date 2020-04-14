
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