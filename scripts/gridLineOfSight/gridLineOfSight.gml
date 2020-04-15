/* 
gridLineOfSight(target1X, target1Y, target2X, target2Y)

this is Bresenham's line algorithm which I found in javascript and just ported over.
don't ask me how it works.
*/

_x0 = argument0;
_y0 = argument1;
_x1 = argument2;
_y1 = argument3;

var returnArray;
var returnArrayCnt = -1;

var tmp;
var steep = abs(_y1-_y0) > abs(_x1-_x0);
if(steep)
{
	//swap x0,y0
	tmp = _x0; 
	_x0 = _y0; 
	_y0 = tmp;
 
	//swap x1,y1
	tmp = _x1; 
	_x1 = _y1; 
	_y1 = tmp;
}
 
var signVal = 1;
if(_x0 > _x1)
{
	signVal = -1;
	_x0 *= -1;
	_x1 *= -1;
}
var dx = _x1-_x0;
var dy = abs(_y1-_y0);
var err = ((dx/2));
var ystep = _y0 < _y1 ? 1:-1;
var yVal = _y0;

 
for(var xVal=_x0; xVal<=_x1; xVal++)
{	
	if(steep)
	{
		returnArrayCnt++;
		var thisVal = array_create(2);
		thisVal[0] = yVal;
		thisVal[1] = signVal*xVal;
		returnArray[returnArrayCnt] = thisVal;
	} 
	else 
	{
		returnArrayCnt++;
		var thisVal = array_create(2);
		thisVal[0] = signVal*xVal;
		thisVal[1] = yVal;
		returnArray[returnArrayCnt] = thisVal;
	}	
	
	err = (err - dy);
	if(err < 0)
	{
		yVal += ystep;
		err += dx;
	}
}

return returnArray;