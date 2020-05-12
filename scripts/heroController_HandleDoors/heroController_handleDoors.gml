


//clear the previous highlights
tilemap_clear(root.blockers.highlightMapId, 0);

//check each direction
for(var i=0; i< array_length_1d(root.blockers.dirOffsets); i++)
{
	//apply offsets
	var checkDir = root.blockers.dirOffsets[i];
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
		var tileInfo = root.blockers.tileInfo[# checkGridX, checkGridY];

		//highlight door
		if(tileInfo[tileInfo_type] == tileType_doorOpen || tileInfo[tileInfo_type] == tileType_doorClosed)	
		{
			var tileInfo = root.blockers.tileInfo[# checkGridX, checkGridY];
			var tileOrient = tileInfo[tileInfo_orient];

			var overTileIndex = 1;
			if(tileOrient == tileOrient_vert)
			{
				overTileIndex = 2;
			}
			if(tileOrient == tileOrient_hori)
			{
				overTileIndex = 3;
			}				
				
			var tileMap = tilemap_get(root.blockers.highlightMapId, checkGridX, checkGridY);
			tileMap = tile_set_index(tileMap, overTileIndex);
			tileMap = tilemap_set(root.blockers.highlightMapId, tileMap, checkGridX, checkGridY);		
		}

		//found an open door
		if(tileInfo[tileInfo_type] == tileType_doorOpen)	
		{			
			//close door
			if(root.controls.isUsePressed)
			{
				tileIndex -= blockingTilesetWidth;
				tileMap = tile_set_index(tileMap, tileIndex);	
				tileMap = tilemap_set(root.blockers.blockingMapId, tileMap, checkGridX, checkGridY);

				tileInfo[tileInfo_type] = tileType_doorClosed;
				root.blockers.tileInfo[# checkGridX, checkGridY] = tileInfo;
			}
		}
			
		//found a closed door
		else if(tileInfo[tileInfo_type] == tileType_doorClosed)
		{
			//open door
			if(root.controls.isUsePressed)
			{			
				tileIndex += blockingTilesetWidth;
				tileMap = tile_set_index(tileMap, tileIndex);					
				tileMap = tilemap_set(root.blockers.blockingMapId, tileMap, checkGridX, checkGridY);
				
				tileInfo[tileInfo_type] = tileType_doorOpen;
				root.blockers.tileInfo[# checkGridX, checkGridY] = tileInfo;
			}
			
			//bounce out of closed door
			else
			{
			
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