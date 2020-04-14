//I am used by the hero to check collision with the blocking tiles against 4 points 
//I directly reference a bunch of hero macros so that would have to be sorted out to make me more general


//ARGS
var target = argument0;
var deltaX = argument1;
var deltaY = argument2;
var isControlEnabled = argument3;


//TILES AT 4 POINTS

//corner TL
var tileData1 = tilemap_get_at_pixel(root.blockers.blockingMapId, target.x + deltaX - heroMove_wallBufferX, target.y + deltaY - heroMove_wallBufferTop);
var gridX1 = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x + deltaX - heroMove_wallBufferX, target.y + deltaY - heroMove_wallBufferTop);
var gridY1 = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x + deltaX - heroMove_wallBufferX, target.y + deltaY - heroMove_wallBufferTop);		
var tileIndex1 = tile_get_index(tileData1);
var tileDamage1 = root.blockers.tileDamage[# gridX1, gridY1];

var isDestroyed1 = ((tileIndex1+1) mod blockingTilesetWidth == 0);
var isDoorOpen1 = (tileDamage1[tileInfo_type] == tileType_doorOpen);
var isDoorClosed1 = (tileDamage1[tileInfo_type] == tileType_doorClosed);
	
//corner BL
var tileData2 = tilemap_get_at_pixel(root.blockers.blockingMapId, target.x + deltaX - heroMove_wallBufferX, target.y + deltaY + heroMove_wallBufferBottom);
var gridX2 = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x + deltaX - heroMove_wallBufferX, target.y + deltaY + heroMove_wallBufferBottom);
var gridY2 = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x + deltaX - heroMove_wallBufferX, target.y + deltaY + heroMove_wallBufferBottom);		
var tileIndex2 = tile_get_index(tileData2);
var tileDamage2 = root.blockers.tileDamage[# gridX2, gridY2];

var isDestroyed2 = ((tileIndex2+1) mod blockingTilesetWidth == 0);
var isDoorOpen2 = (tileDamage2[tileInfo_type] == tileType_doorOpen);
var isDoorClosed2 = (tileDamage2[tileInfo_type] == tileType_doorClosed);

//corner BR
var tileData3 = tilemap_get_at_pixel(root.blockers.blockingMapId, target.x + deltaX + heroMove_wallBufferX, target.y + deltaY - heroMove_wallBufferTop);
var gridX3 = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x + deltaX + heroMove_wallBufferX, target.y + deltaY - heroMove_wallBufferTop);
var gridY3 = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x + deltaX + heroMove_wallBufferX, target.y + deltaY - heroMove_wallBufferTop);		
var tileIndex3 = tile_get_index(tileData3);
var tileDamage3 = root.blockers.tileDamage[# gridX3, gridY3];

var isDestroyed3 = ((tileIndex3+1) mod blockingTilesetWidth == 0);
var isDoorOpen3 = (tileDamage3[tileInfo_type] == tileType_doorOpen);
var isDoorClosed3 = (tileDamage3[tileInfo_type] == tileType_doorClosed);

//corner TR
var tileData4 = tilemap_get_at_pixel(root.blockers.blockingMapId, target.x + deltaX + heroMove_wallBufferX, target.y + deltaY + heroMove_wallBufferBottom);
var gridX4 = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x + deltaX + heroMove_wallBufferX, target.y + deltaY + heroMove_wallBufferBottom);
var gridY4 = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x + deltaX + heroMove_wallBufferX, target.y + deltaY + heroMove_wallBufferBottom);		
var tileIndex4 = tile_get_index(tileData4);
var tileDamage4 = root.blockers.tileDamage[# gridX4, gridY4];

var isDestroyed4 = ((tileIndex4+1) mod blockingTilesetWidth == 0);
var isDoorOpen4 = (tileDamage4[tileInfo_type] == tileType_doorOpen);
var isDoorClosed4 = (tileDamage4[tileInfo_type] == tileType_doorClosed);


//RESULTS

//work out if any of the 4 points are blovked
var isBlocked1 = tileData1 && !isDestroyed1 && !isDoorOpen1 && !( isDoorClosed1 && !isControlEnabled );
var isBlocked2 = tileData2 && !isDestroyed2 && !isDoorOpen2 && !( isDoorClosed2 && !isControlEnabled );
var isBlocked3 = tileData3 && !isDestroyed3 && !isDoorOpen3 && !( isDoorClosed3 && !isControlEnabled );
var isBlocked4 = tileData4 && !isDestroyed4 && !isDoorOpen4 && !( isDoorClosed4 && !isControlEnabled );

//if any point is blocked, the hero is blocked
var isBlocked = isBlocked1 || isBlocked2 || isBlocked3 || isBlocked4;

return isBlocked;