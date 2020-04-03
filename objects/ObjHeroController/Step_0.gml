//scale movement to time
var secondsPassed = delta_time/1000000;
var moveSpeedFrame = moveSpeed*secondsPassed;

//get movement in 8 directions from WASD
var moveXInput = 0;
var moveYInput = 0;
for (var i = 0; i < array_length_1d(heroKey); i++) 
{
    var this_key = heroKey[i];
    if keyboard_check(this_key) 
	{
        var this_angle = i*90;
        moveXInput += lengthdir_x(1, this_angle);
        moveYInput += lengthdir_y(1, this_angle);
    }
}

//attack key action
if keyboard_check(heroKeyAttack)
{
	target.isAttacking = true;
}

//update target state for animation
target.isMoving = ( point_distance(0,0,moveXInput,moveYInput) > 0 );

//apply movement to instance
if(target.isMoving)
{
    var moveDir = point_direction(0,0,moveXInput,moveYInput);
    target.x += lengthdir_x(moveSpeedFrame, moveDir);
    target.y += lengthdir_y(moveSpeedFrame, moveDir);
	target.depth = -target.y;
}	