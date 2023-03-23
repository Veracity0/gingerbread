import <Gingerbread City.ash>;

void main( string plan )
{
    void usage()
    {
	print( "Available plans:" );
	print();
	print( "alligators - bigger alligators, adventure in sewer" );
	print( "candy - advance clock, adventure in retail district, get candy" );
	print( "gingerbeard - adventure in retail district, banish tech bro" );
	print( "gingerservo - adventure in industrial zone, banish mugger" );
	print( "chocolate - adventure in retail district until midnigth, get fancy chocolate sculpture" );
	print( "robbery - activate vigilantes" );
    }

    void log_property( string name )
    {
	print( name + "=" + get_property( name ) );
    }

    void log_set_property( string name, string value )
    {
	set_property( name, value );
	log_property( name );
    }

    void log_default_property( string name, string def )
    {
	string value = property_exists( name ) ? get_property( name ) : def;
	print( name + "=" + value );
    }

    switch ( plan ) {
    case "alligators":
	log_set_property( "VGC.AdvanceClock", "false" );
	log_set_property( "VGC.Morning", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Noon", "lever" );
	log_set_property( "VGC.Afternoon", "Gingerbread Sewers" );
	log_set_property( "VGC.Midnight", "high-end ginger wine" );
	log_set_property( "VGC.Night", "Gingerbread Sewers" );
	log_set_property( "VGC.Banishes", "" );
	break;
    case "candy":
	log_set_property( "VGC.AdvanceClock", "true" );
	log_set_property( "VGC.Morning", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Noon", "candy" );
	log_set_property( "VGC.Afternoon", "none" );
	log_set_property( "VGC.Banishes", "" );
	break;
    case "gingerbeard":
	log_set_property( "VGC.AdvanceClock", "false" );
	log_set_property( "VGC.Morning", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Noon", "column" );
	log_set_property( "VGC.Afternoon", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Midnight", "Judge Fudge" );
	log_set_property( "VGC.Night", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Banishes", "gingerbread tech bro" );
	break;
    case "gingerservo":
	log_set_property( "VGC.AdvanceClock", "false" );
	log_set_property( "VGC.Morning", "Gingerbread Industrial District" );
	log_set_property( "VGC.Noon", "column" );
	log_set_property( "VGC.Afternoon", "Gingerbread Industrial District" );
	log_set_property( "VGC.Midnight", "Judge Fudge" );
	log_set_property( "VGC.Night", "Gingerbread Industrial District" );
	log_set_property( "VGC.Banishes", "gingerbread mugger" );
	break;
    case "chocolate":
	log_set_property( "VGC.AdvanceClock", "true" );
	log_set_property( "VGC.Morning", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Noon", "column" );
	log_set_property( "VGC.Afternoon", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Midnight", "fancy chocolate sculpture" );
	log_set_property( "VGC.Night", "none" );
	log_set_property( "VGC.Banishes", "gingerbread tech bro" );
	break;
    case "robbery":
	log_set_property( "VGC.AdvanceClock", "false" );
	log_set_property( "VGC.Morning", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Noon", "robbery" );
	log_set_property( "VGC.Afternoon", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Midnight", "high-end ginger wine" );
	log_set_property( "VGC.Night", "Gingerbread Upscale Retail District" );
	log_set_property( "VGC.Banishes", "" );
	break;
    default:
	usage();
	print();
	log_default_property( "VGC.AdvanceClock", "false" );
	log_default_property( "VGC.Morning", "none" );
	log_default_property( "VGC.Noon", "candy" );
	log_default_property( "VGC.Afternoon", "none" );
	log_default_property( "VGC.Midnight", "mainbstat" );
	log_default_property( "VGC.Night", "none" );
	log_default_property( "VGC.Banishes", "" );
	break;
    }

    log_default_property( "VGC.AbortForCounters", "false" );
    log_default_property( "VGC.Outfit", "Gingerbread City" );
    log_default_property( "VGC.Familiar", "Chocolate Lab" );
    log_property( "VGC.Quest" );

    // Extract the (possibly adjusted) settings into variables
    reload_vgc_settings();

    // Find out where we are today
    vgc_calculate_turns();

    print();
    if ( vgc_ginger_turns_used >= vgc_ginger_turns_today ) {
	// We have used all of our turns for today.
	// Give forecast for tomorrow.
	print( "Validating current plan using tomorrow's turns (1-" + vgc_ginger_turns_max + "):" );
	validate_gingerbread_plan( 0 );
    } else {
	// We have available turns left today.
	// Describe what we will do today
	print( "Validating current plan using today's remaining turns (" + ( vgc_ginger_turns_used + 1 ) + "-" + vgc_ginger_turns_today + "):" );
	validate_gingerbread_plan( vgc_ginger_turns_used );
    }
    print();
}