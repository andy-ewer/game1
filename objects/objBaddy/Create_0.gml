#macro herdDensityFactor 4

//animation frames
#macro walkStart 0 
#macro walkEnd 4 
#macro mouthStart 5

//animation random timings
#macro walkRandom 400
#macro walkPlus 400
#macro mouthRandom 100
#macro mouthPlus 10
#macro stepRandom 20
#macro stepPlus 5


//sprite size
var scale  = 1;
image_xscale = scale;
image_yscale = scale;

//color filter
image_blend = make_colour_hsv(random(255), random(255), 255);

//inits for tracking animations
stepCounter=0;
mouthCounter=0;

//walking speed
moveSpeed = 30;

//blocking layer
layerId = layer_get_id("tilesBlocking");
mapId = layer_tilemap_get_id(layerId);

depth = -y;
