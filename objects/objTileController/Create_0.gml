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

//init tile damage grids
for(var i=0; i< tilemap_get_width(blockingMapId); i++)
{
	for(var j=0; j< tilemap_get_height(blockingMapId); j++)
	{
		var damageItem;
		damageItem[tileCurrentDamage] = 0;
		damageItem[tileMaxDamage] = 100;
		tileDamage[# i,j] = damageItem;
	}	
}
