#macro roomBorderBlocking 10

//animation frames
#macro walkStart 0 
#macro walkEnd 3 
#macro mouthStart 4
#macro mouthEnd 7

//animation random timings
#macro mouthClosedRandom 300
#macro mouthClosedPlus 100
#macro mouthOpenRandom 200
#macro mouthOpenPlus 50

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

//speeds
#macro regularSpeed 20
#macro mouthSpeed 40
moveSpeed = regularSpeed;
bumpSpeed = 10;

//blocking layer
blockingLayerId = layer_get_id("tilesBlocking");
blockingMapId = layer_tilemap_get_id(blockingLayerId);

depth = round(-y);


image_index = mouthStart;