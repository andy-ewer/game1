var tileData = argument0;
var gridX = argument1;
var gridY = argument2;
var emitter = argument3;
var dist = argument4;

var tileInfo = root.blockers.tileInfo[# gridX, gridY];	

if(tileInfo[tileInfo_type] != tileType_indestructable)
{
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
			destroyTile(tileData, gridX, gridY, emitter, dist);
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
}