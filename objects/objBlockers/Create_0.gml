//used to keep track of damage (cols) for rows.
#macro blockingTilesetWidth 4
#macro blockingTilesetHeight 25
#macro blockingTileSizePixels 16

//damage values per node
#macro tileInfo_currentDamage 0
#macro tileInfo_maxDamage 1
#macro tileInfo_type 2
#macro tileInfo_orient 3

//tiletype
#macro tileType_default 0
#macro tileType_doorOpen 1
#macro tileType_doorClosed 2

//tile orientation
#macro tileOrient_none 0
#macro tileOrient_vert 1
#macro tileOrient_hori 2

//blocking layer
blockingLayerId = layer_get_id("tilesBlocking");
blockingMapId = layer_tilemap_get_id(blockingLayerId);

//over layer
overLayerId = layer_get_id("tilesOver");
overMapId = layer_tilemap_get_id(overLayerId);

//keeping track of tile damage
tileDamage = ds_grid_create(
	tilemap_get_width(blockingMapId), 
	tilemap_get_height(blockingMapId)
);

//some tiles can have special behaviour like doors
var tileType = array_create(blockingTilesetHeight, tileType_default);
var tileOrient = array_create(blockingTilesetHeight, tileOrient_none);

//different HP for tiles
var cnt = -1;
var maxDamageByRow = array_create(blockingTilesetHeight);

//
maxDamageByRow[++cnt] = 0;
maxDamageByRow[++cnt] = 1000;
maxDamageByRow[++cnt] = 100;

//walls
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;
maxDamageByRow[++cnt] = 800;

//doors
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorClosed;
tileOrient[cnt] = tileOrient_hori;
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorOpen;
tileOrient[cnt] = tileOrient_hori;
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorClosed;
tileOrient[cnt] = tileOrient_hori;
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorOpen;
tileOrient[cnt] = tileOrient_hori;
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorClosed;
tileOrient[cnt] = tileOrient_vert;
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorOpen;
tileOrient[cnt] = tileOrient_vert;
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorClosed;
tileOrient[cnt] = tileOrient_vert;
maxDamageByRow[++cnt] = 400;
tileType[cnt] = tileType_doorOpen;
tileOrient[cnt] = tileOrient_vert;

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

		//set value for tile orientation
		damageItem[tileInfo_orient] = tileOrient[row];

		//apply to grid
		tileDamage[# i,j] = damageItem;
	}	
}
