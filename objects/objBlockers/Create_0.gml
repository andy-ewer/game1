//used to keep track of damage (cols) for rows.
#macro blockingTilesetWidth 5

//damage values per node
#macro tileInfo_currentDamage 0
#macro tileInfo_maxDamage 1
#macro tileInfo_type 2

//tiletype
#macro tileType_default 0
#macro tileType_door 1


//blocking layer
blockingLayerId = layer_get_id("tilesBlocking");
blockingMapId = layer_tilemap_get_id(blockingLayerId);

//keeping track of tile damage
tileDamage = ds_grid_create(
	tilemap_get_width(blockingMapId), 
	tilemap_get_height(blockingMapId)
);

//different HP for tiles
var maxDamageByRow = array_create(8);
maxDamageByRow[0] = 1000;
maxDamageByRow[1] = 100;
maxDamageByRow[2] = 800;
maxDamageByRow[3] = 800;
maxDamageByRow[4] = 800;
maxDamageByRow[5] = 800;
maxDamageByRow[6] = 800;
maxDamageByRow[7] = 800;
maxDamageByRow[8] = 100;

//some tiles can have special behaviour like doors
var tileType = array_create(8, tileType_default);
tileType[8] = tileType_door;

//init tile damage grid
for(var i=0; i< tilemap_get_width(blockingMapId); i++)
{
	for(var j=0; j< tilemap_get_height(blockingMapId); j++)
	{
		//set value for tracking damage
		var damageItem = array_create(1);
		damageItem[tileInfo_currentDamage] = 0;
		
		//set value for max damage 
		var tileData = tilemap_get(blockingMapId, i, j);
		var tileIndex = tile_get_index(tileData);
		var row = tileIndex div blockingTilesetWidth;
		damageItem[tileInfo_maxDamage] = maxDamageByRow[row];
		
		//set value for tile type
		damageItem[tileInfo_type] = tileType[row];

		//apply to grid
		tileDamage[# i,j] = damageItem;
	}	
}
