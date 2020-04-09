//values used throughout code to scale everything to time even as the 
//actual frame rate diverges from the target frame rate.

//a multiplier for time based movement
//store speeds as room pixels per second and then multiply by secondsPassed each step.
secondsPassed = delta_time / 1000000;

//a value mostly used to scale for tick based timing.
//decrement/increment counters by this value instead of 1 each step. 
//don't use == to end counters! use any of < > <= >=
ticksPassed = secondsPassed * timing_targetFrameRate;
