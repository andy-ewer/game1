switch(sprite_index)
{
	case sprBaddy2:
		sprite_index = choose(sprBaddy2Death1, sprBaddy2Death2);
	break;
	default:
		sprite_index = choose(sprBaddy1Death1, sprBaddy1Death2);
	break;
}
