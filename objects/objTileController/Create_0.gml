
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
		tileDamage[# i,j] = 0;
		
		var tileData = tilemap_get(blockingMapId, i, j);
		var tileIndex = tile_get_index(tileData);
		

	}	
}
