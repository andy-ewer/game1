/* 
gridLineOfSightBlockersCount(target1X, target1Y, target2X, target2Y)
*/

_x0 = argument0;
_y0 = argument1;
_x1 = argument2;
_y1 = argument3;

var tiles = gridLineOfSight(_x0, _y0, _x1, _y1);
var cnt = 0;
for(var i=0; i<array_length_1d(tiles);i++)
{
	var tile = tiles[i];
	var tileData = tilemap_get(blockers.blockingMapId, tile[0], tile[1]);
	var tileIndex = tile_get_index(tileData);
	var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
	if(tileIndex && !isDestroyed)
	{
		cnt++;
	}
}
return cnt;