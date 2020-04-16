var tileData = argument0;
var gridX = argument1;
var gridY = argument2;
var emitter = argument3;
var dist = argument4;

var tileInfo = root.blockers.tileInfo[# gridX, gridY];	
var tileIndex = tile_get_index(tileData);

tileInfo[tileInfo_currentDamage] += root.timing.ticksPassed; //1 damage per tick at target frame rate, scaled to the actual frame rate

//if we have gone over max damage, increment to next damage step and reset damage done to 0.
if(tileInfo[tileInfo_currentDamage] >= tileInfo[tileInfo_maxDamage])
{
	tileIndex++;
	tileData = tile_set_index(tileData, tileIndex);

	//tile destroyed!
	if((tileIndex+1) mod blockingTilesetWidth == 0)
	{
		//randomly flips rubble texture for more variety
		if(irandom(1)==0)
		{
			tileData = tile_set_flip(tileData, true);
		}
		audio_play_sound_on(emitter, sndTileBreak, 0, round(b1Audio_falloffDist-dist));

		//if a tile is destroyed that is supporting either side of a door, the door is also destroyed. because this makes doors a lot simpler.				
		//check each direction
		for(var j=1; j< array_length_1d(root.dirOffsets); j++)
		{
			//apply offsets
			var checkDir = root.dirOffsets[j];
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
				if(checkTileInfo[tileInfo_type]==tileType_doorOpen || checkTileInfo[tileInfo_type]==tileType_doorClosed)
				{
					//set to destroyed (last) frame in row
					checkTileIndex = checkTileIndex - (checkTileIndex mod blockingTilesetWidth) + blockingTilesetWidth-1;
								
					//apply changes to the tile
					checkTileData = tile_set_index(checkTileData, checkTileIndex);
					checkTileData = tilemap_set(root.blockers.blockingMapId, checkTileData, checkGridX, checkGridY);								
				}
			}
		}					
	}
	else
	{
		audio_play_sound_on(emitter, sndTileDamage, 0, round(b1Audio_falloffDist-dist));
	}
	tileInfo[tileInfo_currentDamage] = 0;					
}
				
//apply changes to the tile
tileData = tilemap_set(root.blockers.blockingMapId, tileData, gridX, gridY);
				
//apply change to the damage on this tile
root.blockers.tileInfo[# gridX, gridY] = tileInfo;