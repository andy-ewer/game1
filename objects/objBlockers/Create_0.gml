//used to keep track of damage (cols) for rows.
#macro blockingTilesetWidth 4
#macro blockingTilesetHeight 22
#macro blockingTileSizePixels 16

//damage values per node
#macro tileInfo_currentDamage 0
#macro tileInfo_maxDamage 1
#macro tileInfo_type 2
#macro tileInfo_orient 3
#macro tileInfo_wallIndexOffset 4

//tiletype
#macro tileType_default 0
#macro tileType_doorOpen 1
#macro tileType_doorClosed 2
#macro tileType_wall 3
#macro tileType_indestructable 4

//tile orientation
#macro tileOrient_none 0
#macro tileOrient_vert 1
#macro tileOrient_hori 2

//blocking layer
var blockingLayerId = layer_get_id("tilesBlocking");
blockingMapId = layer_tilemap_get_id(blockingLayerId);

//over layer
var highlightLayerId = layer_get_id("tilesHighlight");
highlightMapId = layer_tilemap_get_id(highlightLayerId);

//keeping track of tile damage for every blocking tile in the map
tileInfo = ds_grid_create(
	tilemap_get_width(blockingMapId), 
	tilemap_get_height(blockingMapId)
);

//some tiles can have special behaviour like doors
var tileType = array_create(blockingTilesetHeight, tileType_default);
var tileOrient = array_create(blockingTilesetHeight, tileOrient_none);
var tileWallIndexOffset = array_create(blockingTilesetHeight, 0);

//different HP for tiles
var cnt = -1;
var maxDamageByRow = array_create(blockingTilesetHeight);

//top row not being used currently
maxDamageByRow[++cnt] = 0;

//wall rows
maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

maxDamageByRow[++cnt] = 800;
tileType[cnt] = tileType_wall;
tileWallIndexOffset[cnt] = 1;

//door rows
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

maxDamageByRow[++cnt] = 0;
tileType[cnt] = tileType_indestructable;


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

		//set value wall set offset
		damageItem[tileInfo_wallIndexOffset] = tileWallIndexOffset[row];

		//apply to grid
		tileInfo[# i,j] = damageItem;
	}	
}

//offsets for cells in 4 directions plus here
var dirs = array_create(5);
var dirCnt = -1;
//here
var dir = array_create(2);
dir[0] = 0;
dir[1] = 0;	
dirs[++dirCnt] = dir;
//n
var dir = array_create(2);
dir[0] = 0;
dir[1] = -1;	
dirs[++dirCnt] = dir;
//e
var dir = array_create(2);
dir[0] = -1;
dir[1] = 0;
dirs[++dirCnt] = dir;
//s
var dir = array_create(2);
dir[0] = 0;
dir[1] = 1;
dirs[++dirCnt] = dir;
//w
var dir = array_create(2);
dir[0] = 1;
dir[1] = 0;
dirs[++dirCnt] = dir;

dirOffsets = dirs;
