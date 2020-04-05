#macro blockingTilesetWidth 5

//damage values per node
#macro tileCurrentDamage 0
#macro tileMaxDamage 1

//blocking layer
blockingLayerId = layer_get_id("tilesBlocking");
blockingMapId = layer_tilemap_get_id(blockingLayerId);

//keeping track of tile damage
tileDamage = ds_grid_create(
	tilemap_get_width(blockingMapId), 
	tilemap_get_height(blockingMapId)
);

maxDamageByRow[0] = 2000;
maxDamageByRow[1] = 100;

//init tile damage grid
for(var i=0; i< tilemap_get_width(blockingMapId); i++)
{
	for(var j=0; j< tilemap_get_height(blockingMapId); j++)
	{
		//set value for tracking damage
		var damageItem = array_create(1);
		damageItem[tileCurrentDamage] = 0;
		
		//set value for max damage 
		var tileData = tilemap_get(blockingMapId, i, j);
		var tileIndex = tile_get_index(tileData);
		var row = tileIndex div 5;
		damageItem[tileMaxDamage] = maxDamageByRow[row];

		//apply to grid
		tileDamage[# i,j] = damageItem;
	}	
}
