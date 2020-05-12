var tileData = argument0;
var gridX = argument1;
var gridY = argument2;
var emitter = argument3;
var dist = argument4;


//randomly flips rubble texture for more variety
if(irandom(1)==0)
{
	tileData = tile_set_flip(tileData, true);
}
audio_play_sound_on(emitter, sndTileBreak, 0, round(b1Audio_falloffDist-dist));
		
		
//if a tile is destroyed that is supporting either side of a door, the door is also destroyed. because this makes doors a lot simpler.				
//check each direction
for(var j=1; j< array_length_1d(root.blockers.dirOffsets); j++)
{
	//apply offsets
	var checkDir = root.blockers.dirOffsets[j];
	var checkGridX = gridX + checkDir[0];
	var checkGridY = gridY + checkDir[1];
		
	//get offset tile	
	var checkTileData = tilemap_get(root.blockers.blockingMapId, checkGridX, checkGridY);
	var checkTileIndex = tile_get_index(checkTileData);
						
	var checkIsDestroyed = ((checkTileIndex+1) mod blockingTilesetWidth == 0);
	if(!checkIsDestroyed)
	{
		//grab the data for the cell
		var checkTileInfo = root.blockers.tileInfo[# checkGridX, checkGridY];
		
		//handle doors
		if(checkTileInfo[tileInfo_type]==tileType_doorOpen || checkTileInfo[tileInfo_type]==tileType_doorClosed)
		{
			//set to destroyed (last) frame in row
			checkTileIndex = checkTileIndex - (checkTileIndex mod blockingTilesetWidth) + blockingTilesetWidth-1;
								
			//apply changes to the tile
			checkTileData = tile_set_index(checkTileData, checkTileIndex);
			checkTileData = tilemap_set(root.blockers.blockingMapId, checkTileData, checkGridX, checkGridY);								
		}
		
		//handle walls
		if(checkTileInfo[tileInfo_type]==tileType_wall)
		{
			var removalMask = 0;
			
			//each of these values represents a 4 bit mask which has one of the 4 cardinal directions removed
			switch(j)
			{
				//n
				case 1:
					removalMask = 13; //TODO: figure out why N and S work inverse to how I had worked it out on paper a while back
				break;
				
				//e
				case 2:
					removalMask = 11;
				break;
				
				//s
				case 3:
					removalMask = 7;
				break;
				
				//w
				case 4:
					removalMask = 14;
				break;
			}
			
			//get the details for the tile to change
			var row = ((checkTileIndex) div blockingTilesetWidth);
			var offsetRow = row - checkTileInfo[tileInfo_wallIndexOffset]; //this is the row within the current set of walls equivalent to a 4 bit number
			var col = ((checkTileIndex) mod blockingTilesetWidth);
			
			//bitwise AND the current value against the appropriate mask to remove that side only
			var newOffsetRow = offsetRow & removalMask;
			var newRow = newOffsetRow + checkTileInfo[tileInfo_wallIndexOffset];
			var newIndex = (newRow * blockingTilesetWidth) + col;
			
			//apply changes to the tile
			checkTileData = tile_set_index(checkTileData, newIndex);
			checkTileData = tilemap_set(root.blockers.blockingMapId, checkTileData, checkGridX, checkGridY);			
		}		
	}
}	