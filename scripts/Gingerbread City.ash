since r17981;

import <vprops.ash>;

// ***************************
//          To Do            *
// ***************************

// Optionally allow executing partial plan if insufficient adventures.
//     If so, handle running out of turns before completing the plan.
// Make Mood configurable

// ***************************
//        Requirements       *
// ***************************

// You need access to The Gingerbread City (obviously)
// You do not need to have all Gingerbread City zones unlocked.
// You do not need any city upgrades
//
// Preconfigured outfit (configurable)
//    "Gingerbread City" - for adventuring in the Gingerbread City
// CCS configured
// HP & MP restoration configured
// Mood configured
//
// Choice adventures that can pop up unexpectedly in the Gingerbread
// City must have a decision other than "Show in Browser" configured.
//    Haunted Doghouse 1, 2, 3
//    Violet Fog
// (Turtle Taming adventures will always take the only option)
//
// KoLmafia maintains the following settings to track the permanent
// state of your Gingerbread City.
//
//    gingerbreadCityAvailable		true if used a Build-a-City Gingerbread kit
//    gingerAdvanceClockUnlocked	true if purchased "clock" upgrade
//    gingerExtraAdventures		true if purchased "turns" upgrade
//    gingerRetailUnlocked		true if purchased "retail" upgrade
//    gingerSewersUnlocked		true if purchased "sewers" upgrade
//
// If you did these things outside of KoLmafia (or before KoLmafia
// strted tracking them), use the CLI to set them appropriately.
//
//     set PROPERTY=VALUE

// ***************************
//       Configuration       *
// ***************************

//-------------------------------------------------------------------------
// All of the configuration variables have default values, which apply
// to any character who does not override the variable using the
// appropriate property.
//
// You can edit the default here in the script and it will apply to all
// characters which do not override it.
//
// define_property( PROPERTY, TYPE, DEFAULT )
// define_property( PROPERTY, TYPE, DEFAULT, COLLECTION )
// define_property( PROPERTY, TYPE, DEFAULT, COLLECTION, DELIMITER )
//
// Otherwise, you can change the value for specific characters in the gCLI:
//
//     set PROPERTY=VALUE
//
// Both DEFAULT and a property VALUE will be normalized
//
// All properties used directly by this script start with "VGC."
//-------------------------------------------------------------------------

// If you want to advance the clock and spend 5 fewer turns in The
// Gingerbread City, you can do that.

boolean vgc_advance_clock = define_property( "VGC.AdvanceClock", "boolean", "false" ).to_boolean();

// The following are valid adventuring locations in the Gingerbread
// City. Specifying any other location results in an invalid plan
//
// Gingerbread Civic Center
// Gingerbread Industrial Zone
// Gingerbread Upscale Retail District
// Gingerbread Sewers
// Gingerbread Train Station
//
// If any of the following are "none", adventuring ceases in Gingerbread City at that phase

location vgc_morning = define_property( "VGC.Morning", "location", "none" ).to_location();
location vgc_afternoon = define_property( "VGC.Afternoon", "location", "none" ).to_location();
location vgc_night = define_property( "VGC.Night", "location", "none" ).to_location();

// You have a wide variety of options for Noon:
//
// "candy"				collect candy in Train Station 
// "lever"				enlarge alligators in sewers
// "schedule"				study the train schedule
// "fancy marzipan briefcase"		off-hand item that decreases combat frequency and lasts until rollover
// "retail"				city upgrade: buy for 1,000 sprinkles; open retail district
// "sewers"				city upgrade: buy for 1,000 sprinkles; open sewers
// "turns"				city upgrade: buy for 1,000 sprinkles; ten extra turns
// "clock"				city upgrade: buy for 1,000 sprinkles; digital clock
// "column"				allows a fight with Judge Fudge at midnight
// "briefcase full of sprinkles"	turn in blackmail photos
// "creme brulee torch"			buy for 25 sprinkles; opens civic center midnight choice
// "candy crowbar"			buy for 50 sprinkles; opens train station midnight choice
// "candy screwdriver"			buy for 100 sprinkles; opens train station midnight choice
// "teethpick"				buy for 1000 sprinkles; opens train station midnight choice
// "robbery"				requires robbery outfit; activates vigilantes
// "gingerbread dog treat"		buy for 200 sprinkles; opens civic center midnight choice
// "pumpkin spice candle"		buy for 140 sprinkles; opens train station midnight choice
// "gingerbread spice latte"		buy for 50 sprinkles; +10 Familiar Weight potion
// "gingerbread trousers"		buy for 500 sprinkles; part of Gingerbread Best outfit
// "gingerbread waistcoat"		buy for 500 sprinkles; part of Gingerbread Best outfit
// "gingerbread tophat"			buy for 500 sprinkles; part of Gingerbread Best outfit
// "photo counter"			turn in fruit-leather negatives or pick up gingerbread blackmail photos
//
// An invalid choice will be treated as "candy"

string vgc_noon = define_property( "VGC.Noon", "string", "candy" );

// You have a wide variety of options for Midnight:
//
// "sewer"				adventure normally in sewer; no choice
// "mainstat"				gain muscle, mysticality, or moxie, depending on your class
// "Judge Fudge"			fight Judge Fudge: activated by "column" at noon
// "Muscle"				gain muscle stats; eventually activates a train station midnight choice
// "Mysticality"			gain mysticality stats; eventually allows purchase of teethpick
// "Moxie"				gain moxie stats
// "broken chocolate pocketwatch"	part of Gingerbread Best outfit; requires "pumpkin spice candle" at noon
// "meat"				5,000 Meat; requires "candy crowbar" at noon
// "fat loot token"			requires "candy crowbar" at noon
// "sprinkles"				250 sprinkles; requires "candy crowbar" at noon
// "priceless diamond"			requires "candy crowbar" at noon
// "pristine fish scales"		5 pristine fish scales; requires "candy crowbar" at noon
// "fruit-leather negatives"		gain item: one time only, requires activation by Muscle option
// "dig"				gain items; requires teethpick in inventory; becomes unavailable after sugar raygun
// "counterfeit city"			buy for 300 sprinkles
// "gingerbread moneybag"		requires creme brulee torch in inventory
// "gingerbread cigarettes"		buy for 5 sprinkles
// "chocolate puppy"			requires gingerbread dog treat in inventory
// "gingerbread pistol"			buy for 300 sprinkles
// "ginger beer"			requires gingerbread mug in inventory
// "spare chocolate parts"		required to convert broken chocolate pocketwatch to chocolate pocketwatch
// "GNG-3-R"				fight GNG-3-R; requires (and consumes) gingerservo
// "tattoo"				buy for 100,000 sprinkles
// "fake cocktail"			potion: MP +50, MP Regen 20-30
// "high-end ginger wine"		requires Gingerbread Best outfit; EPIC booze
// "fancy chocolate sculpture"		buy for 300 sprinkles; chocolate
// "Pop Art: a Guide"			buy for 1,000 sprinkles; grants skill: Fifteen Minutes of Flame
// "No Hats as Art"			buy for 1,000 sprinkles; grants skill: Ceci N'Est Pas Un Chapeau
//
// An invalid choice will be treated as "mainstat"

string vgc_midnight = define_property( "VGC.Midnight", "string", "mainstat" );

// There are several once-per ascension "quests" available in the
// Gingerbread City.
//
// "blackmail"				(7 days) gain a briefcase full of sprinkles
// "raygun"				(10 days) gain a sugar raygun
// "blackmail+raygun"			(14 days) both of the above
//
// You specify what you want to do at Noon and Midnight, using the
// appropriate properties, and if you also specify a quest, this script
// will detect where you are in your progress and will override one or
// both of those properties in order to progress in your chosen quest.
//
// On days when only one of the Noon or Midnight choices is needed to
// advance the quest, the other will use your configured setting.
//
// When you complete the quest, this script will recognize that and no
// longer override your Noon or Midnight choices.

string vgc_quest = define_property( "VGC.Quest", "string", "" );

// You can specify monsters to banish if you are looking for particular drops
//
// We will use Licorice Rope (if available) on dudes. Licorice Rope can
// be used multiple times, but only the most recent dude is banished. A
// monster banished with this skill still drops sprinkles, although it
// gives no stats or other items.

monster_set vgc_banish = define_property( "VGC.Banishes", "monster", "", "set" );

// The preconfigured outfit to wear while adventuring in The Gingerbread City

string vgc_outfit = define_property( "VGC.Outfit", "string", "Gingerbread City" );

// The familiar to take adventuring in The Gingerbread City

familiar vgc_familiar = define_property( "VGC.Familiar", "familiar", "Chocolate Lab" ).to_familiar();

// Should we abort the script for an unexpected NC (presumably a counter)?
//
// Ideally, you'd set up a Counter Script and it would handle it and
// allow the script just continue, but if you want this script to abort
// to let you to handle the counter manually, set this to true. You can
// continue the script by simply running it again.

boolean vgc_abort_for_counters = define_property( "VGC.AbortForCounters", "boolean", "false" ).to_boolean();

// Cumulative records. Not configurable.

static string VGC_SPENT_SETTING = "VGC.TotalSpent";
static string VGC_SPRINKLES_SETTING = "VGC.TotalSprinkles";
static string VGC_TURNS_SETTING = "VGC.TotalTurns";

// ***************************
//        Constants          *
// ***************************

static location GINGERBREAD_CIVIC_CENTER = $location[ Gingerbread Civic Center ];
static location GINGERBREAD_INDUSTRIAL_ZONE = $location[ Gingerbread Industrial Zone ];
static location GINGERBREAD_RETAIL_DISTRICT = $location[ Gingerbread Upscale Retail District ];
static location GINGERBREAD_SEWERS = $location[ Gingerbread Sewers ];
static location GINGERBREAD_TRAIN_STATION = $location[ Gingerbread Train Station ];

// ***************************
//       Combat Filters      *
// ***************************

location vgc_current_zone;	// Set by do_adventure()
location vgc_licorice_banished_zone = $location[ none ];
boolean vgc_pickpocket_available = false;
boolean vgc_pocket_crumbs_available = false;
boolean vgc_licorice_rope_available = false;

string gingerbread_filter( int round, monster mon, string page )
{ 
    static boolean pocket_crumbs = false;

    if ( round == 0 ) {
	pocket_crumbs = !vgc_pocket_crumbs_available;
    }

    if ( vgc_pickpocket_available && can_still_steal() ) {
	return "\"pickpocket\"";
    }

    // Try to banish a dude with with Licorice Rope. This is useable
    // multiple times, but has a queue size of one, so if you banish a
    // second dude, the first is no longer banished.
    //
    // If the plan involves adventuring in multiple zones, it might be
    // reasonable to list multiple dudes from different zones.
    //
    // Since a licorice banished dude still drops sprinkles, one could
    // use it to simply collect sprinkles, but since no items or stats
    // are forthcoming from doing that, we're not going to support that;
    // only a single dude will be licorice banished from a given zone.
    if ( vgc_licorice_rope_available &&
	 vgc_licorice_banished_zone != vgc_current_zone &&
	 mon.phylum == $phylum[ dude ] &&
	 vgc_banish contains mon ) {
	vgc_licorice_banished_zone = vgc_current_zone;
	vgc_licorice_rope_available = false;
	return "skill Licorice Rope";
    }

    if ( !pocket_crumbs ) {
	pocket_crumbs = true;
	return "skill Pocket Crumbs";
    }

    return "";
}

// ***************************
//        Validation         *
// ***************************

static item COUNTERFEIT_CITY = $item[ counterfeit city ];
static item BLOWTORCH = $item[ creme brulee torch ];
static item CANDY_CROWBAR = $item[ candy crowbar ];
static item CANDY_DOG_COLLAR = $item[ candy dog collar ];
static item DOG_TREAT = $item[ gingerbread dog treat ];
static item FRUIT_LEATHER_NEGATIVES = $item[ fruit-leather negatives ];
static item GINGERBREAD_BLACKMAIL_PHOTOS = $item[ gingerbread blackmail photos ];
static item GINGERBREAD_MUG = $item[ gingerbread mug ];
static item GINGERSERVO = $item[ gingerservo ];
static item PUMPKIN_SPICE_CANDLE = $item[ pumpkin spice candle ];
static item SPRINKLES = $item[ sprinkles ];
static item TEETHPICK = $item[ teethpick ];

// The following is a stand-in for the outfit
static item GINGERBREAD_BEST = $item[ candy dress shoes ];

// The following is a stand-in for outfit: gingerbread mask, gingerbread pistol, gingerbread moneybag
static item ROBBERY_OUTFIT = $item[ gingerbread pistol ];

static item GINGERBREAD_MASK = $item[ gingerbread mask ];
static item GINGERBREAD_PISTOL = $item[ gingerbread pistol ];
static item GINGERBREAD_MONEYBAG = $item[ gingerbread moneybag ];

// A Gingerbread City choice.
//
// You have the option to get these at Noon and Midnight in various
// locations. Some have prerequisites:
//
// - Wearing a particular outfit
// - Wearing a particular piece of equipment
// - Having a particular item in inventory
// - Having enough sprinkles in inventory to purchase an item
// - Once only per ascension

record GingerChoice {
    location zone;	// Where this choice appears
    int sprinkles;	// Sprinkles spent for this choice
    item tool;		// Required item in inventory
    int choice1;	// choice #
    int option1;	// option number
    int choice2;	// choice #
    int option2;	// option number
};

static GingerChoice NO_CHOICE = new GingerChoice();

// A set of choices available at Noon

// Defaults to use in each Noon location if your desired choice is unavailable

static GingerChoice NOON_COLUMN = new GingerChoice( GINGERBREAD_CIVIC_CENTER, 0, $item[ none ], 1202, 2 );
static GingerChoice NOON_CANDY = new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, $item[ none ], 1204, 1 );
static GingerChoice NOON_INDUSTRIAL_NONE = new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 0, $item[ none ], 1206, 6 );
static GingerChoice NOON_RETAIL_NONE = new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 0, $item[ none ], 1208, 9 );

// Choices requiring post-processing
static GingerChoice NOON_RETAIL = new GingerChoice( GINGERBREAD_CIVIC_CENTER, 1000, $item[ none ], 1202, 3, 1210, 1 );
static GingerChoice NOON_SEWERS = new GingerChoice( GINGERBREAD_CIVIC_CENTER, 1000, $item[ none ], 1202, 3, 1210, 2 );
static GingerChoice NOON_TURNS = new GingerChoice( GINGERBREAD_CIVIC_CENTER, 1000, $item[ none ], 1202, 3, 1210, 3 );

// All configurable Noon choices

static GingerChoice [string] ginger_noon_choices = {
    "candy" : NOON_CANDY,
    "lever" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, $item[ none ], 1204, 2 ),
    "schedule" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, $item[ none ], 1204, 3 ),
    "fancy marzipan briefcase" : new GingerChoice( GINGERBREAD_CIVIC_CENTER, 0, $item[ none ], 1202, 1 ),
    "column" : NOON_COLUMN,
    "retail" : NOON_RETAIL,
    "sewers" : NOON_SEWERS,
    "turns" : NOON_TURNS,
    "clock" : new GingerChoice( GINGERBREAD_CIVIC_CENTER, 1000, $item[ none ], 1202, 3, 1210, 4 ),
    "briefcase full of sprinkles" : new GingerChoice( GINGERBREAD_CIVIC_CENTER, 0, GINGERBREAD_BLACKMAIL_PHOTOS, 1202, 4 ),
    "creme brulee torch" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 25, $item[ none ], 1206, 1 ),
    "candy crowbar" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 50, $item[ none ], 1206, 2 ),
    "candy screwdriver" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 100, $item[ none ], 1206, 3 ),
    "teethpick" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 1000, $item[ none ], 1206, 4 ),
    "robbery" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 0, ROBBERY_OUTFIT, 1206, 5 ),
    "gingerbread dog treat" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 200, $item[ none ], 1208, 1 ),
    "pumpkin spice candle" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 140, $item[ none ], 1208, 2 ),
    "gingerbread spice latte" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 50, $item[ none ], 1208, 3 ),
    "gingerbread trousers" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 500, $item[ none ], 1208, 4 ),
    "gingerbread waistcoat" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 500, $item[ none ], 1208, 5 ),
    "gingerbread tophat" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 500, $item[ none ], 1208, 6 ),
    "photo counter" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 0, $item[ none ], 1208, 8 ),
};

// Unsupported:
//
// "robbery" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 0, ROBBERY_OUTFIT, 1208, 7 ),
// We already have this in Gingerbread Industrial District

// Defaults to use in each Midnight location if your desired choice is unavailable

static GingerChoice GINGER_MUSCLE = new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, $item[ none ], 1205, 1 );
static GingerChoice GINGER_MYSTICALITY = new GingerChoice( GINGERBREAD_CIVIC_CENTER, 0, $item[ none ], 1203, 1 );
static GingerChoice GINGER_MOXIE = new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 0, $item[ none ], 1207, 1, 1212, 2 );
static GingerChoice MIDNIGHT_FAKE_COCKTAIL = new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 0, $item[ none ], 1209, 1 );
static GingerChoice MIDNIGHT_SPARE_PARTS = new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 0, $item[ none ], 1207, 2, 1213, 1 );
static GingerChoice MIDNIGHT_GINGER_WINE = new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 0, GINGERBREAD_BEST, 1209, 2, 1214, 1 );

// All configurable Midnight choices

static GingerChoice [string] ginger_midnight_choices = {
    "sewer" : new GingerChoice( GINGERBREAD_SEWERS ),
    "Judge Fudge" : new GingerChoice( GINGERBREAD_CIVIC_CENTER ),
    "Muscle" : GINGER_MUSCLE,
    "broken chocolate pocketwatch" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, PUMPKIN_SPICE_CANDLE, 1205, 2 ),
    "meat" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, CANDY_CROWBAR, 1205, 3, 1211, 1 ),
    "fat loot token" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, CANDY_CROWBAR, 1205, 3, 1211, 2 ),
    "sprinkles" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, CANDY_CROWBAR, 1205, 3, 1211, 3 ),
    "priceless diamond" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, CANDY_CROWBAR, 1205, 3, 1211, 4 ),
    "pristine fish scales" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, CANDY_CROWBAR, 1205, 3, 1211, 5 ),
    "fruit-leather negatives" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, $item[ none ], 1205, 4 ),
    "dig" : new GingerChoice( GINGERBREAD_TRAIN_STATION, 0, TEETHPICK, 1205, 5 ),
    "Mysticality" : GINGER_MYSTICALITY,
    "counterfeit city" : new GingerChoice( GINGERBREAD_CIVIC_CENTER, 300, $item[ none ], 1203, 2 ),
    "gingerbread moneybag" : new GingerChoice( GINGERBREAD_CIVIC_CENTER, 0, BLOWTORCH, 1203, 3 ),
    "gingerbread cigarettes" : new GingerChoice( GINGERBREAD_CIVIC_CENTER, 5, $item[ none ], 1203, 4 ),
    "chocolate puppy" : new GingerChoice( GINGERBREAD_CIVIC_CENTER, 0, DOG_TREAT, 1203, 5 ),
    "gingerbread pistol" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 300, $item[ none ], 1207, 1, 1212, 1 ),
    "Moxie" : GINGER_MOXIE,
    "ginger beer" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 0, GINGERBREAD_MUG, 1207, 1, 1212, 3 ),
    "spare chocolate parts" : MIDNIGHT_SPARE_PARTS,
    "GNG-3-R" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 0, GINGERSERVO, 1207, 2, 1213, 2 ),
    "tattoo" : new GingerChoice( GINGERBREAD_INDUSTRIAL_ZONE, 100000, $item[ none ], 1207, 3 ),
    "fake cocktail" : MIDNIGHT_FAKE_COCKTAIL,
    "high-end ginger wine" : MIDNIGHT_GINGER_WINE,
    "fancy chocolate sculpture" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 300, GINGERBREAD_BEST, 1209, 2, 1214, 2 ),
    "Pop Art: a Guide" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 1000, GINGERBREAD_BEST, 1209, 2, 1214, 3 ),
    "No Hats as Art" : new GingerChoice( GINGERBREAD_RETAIL_DISTRICT, 1000, GINGERBREAD_BEST, 1209, 2, 1214, 4 ),
};

// Always-available defaults for each choice adventure

static GingerChoice [int] ginger_default_choices = {
    1202 : NOON_COLUMN,
    1203 : GINGER_MYSTICALITY,
    1204 : NOON_CANDY,
    1205 : GINGER_MUSCLE,
    1206 : NOON_INDUSTRIAL_NONE,
    1207 : GINGER_MOXIE,
    1208 : NOON_RETAIL_NONE,
    1209 : MIDNIGHT_FAKE_COCKTAIL,
    1212 : GINGER_MOXIE,
    1213 : MIDNIGHT_SPARE_PARTS,
    1214 : MIDNIGHT_GINGER_WINE
};

// Midnight choices for "mainstat"

static GingerChoice [stat] GINGER_STATS = {
    $stat[ muscle] : GINGER_MUSCLE,
    $stat[ mysticality] : GINGER_MYSTICALITY,
    $stat[ moxie] : GINGER_MOXIE
};

static boolean [location] GINGERBREAD_ZONES = {
    GINGERBREAD_CIVIC_CENTER : true,
    GINGERBREAD_INDUSTRIAL_ZONE : true,
    GINGERBREAD_RETAIL_DISTRICT : true,
    GINGERBREAD_SEWERS : true,
    GINGERBREAD_TRAIN_STATION : true
};

// Quest plans

typedef string[2] vgc_choice_pair;
typedef vgc_choice_pair[] vgc_quest_plan;

static vgc_quest_plan [string] vgc_quests = {
    "blackmail" :
    {
	{ "", "Muscle" },
	{ "", "Muscle" },
	{ "", "Muscle" },
	{ "", "fruit-leather negatives" },
	{ "photo counter", "" },
	{ "photo counter", "" },
	{ "briefcase full of sprinkles", "" },
    },
    "raygun" :
    {
	{ "", "Mysticality" },
	{ "", "Mysticality" },
	{ "", "Mysticality" },
	{ "teethpick", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
    },
    "blackmail+raygun" :
    {
	{ "", "Muscle" },
	{ "", "Muscle" },
	{ "", "Muscle" },
	{ "", "fruit-leather negatives" },
	{ "photo counter", "Mysticality" },
	{ "photo counter", "Mysticality" },
	{ "briefcase full of sprinkles", "Mysticality" },
	{ "teethpick", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
	{ "", "dig" },
    },
};

void vgc_override_choices( string quest )
{
    if ( vgc_quest == "" || vgc_quest == "none" ) {
	// Do nothing and say nothing
	return;
    }

    if ( !( vgc_quests contains vgc_quest ) ) {
	print( "Unknown quest: \"" + vgc_quest + "\"; ignoring." );
	return;
    }

    // Get the expected plan for the quest
    vgc_quest_plan plan = vgc_quests[ quest ];

    int determine_blackmail_progress()
    {
	// If we have accomplished the blackmail, we are done
	if ( get_property( "gingerBlackmailAccomplished" ).to_boolean() ) {
	    return 7;
	}
	// If we have the blackmail photos, we need to turn them in
	if ( item_amount( GINGERBREAD_BLACKMAIL_PHOTOS ) > 0  ) {
	    return 6;
	}
	// If we have dropped off the negatives, we need to pick them up
	if ( get_property( "gingerNegativesDropped" ).to_boolean() ) {
	    return 5;
	}
	// If we have the fruit-leather negatives, we need to drop them off
	if ( item_amount( FRUIT_LEATHER_NEGATIVES ) > 0  ) {
	    return 4;
	}
	// If we have opened the extra track, we need to ride it
	if ( get_property( "gingerSubwayLineUnlocked" ).to_boolean() ) {
	    return 3;
	}
	// Otherwise, we need to keep digging
	return min( max( get_property( "gingerMuscleChoice" ).to_int(), 0 ), 2 );
    }

    int determine_raygun_progress()
    {
	// If we have dug 7 times, we are done
	int dig_count = get_property( "gingerDigCount" ).to_int();
	if ( dig_count == 7 ) {
	    return 10;
	}
	// If we have a teethpick, we need to keep digging
	if ( item_amount( TEETHPICK ) > 0  ) {
	    return min( dig_count + 3, 9 );
	}
	// If we have studied enough, we need to get a teethpick and
	// start digging.
	int study_count = get_property( "gingerLawChoice" ).to_int();
	if ( study_count >= 3 ) {
	    return 3;
	}
	// Otherwise, we need to study some more
	return study_count;
    }

    // Determine how far we are into the selected quest.
    int blackmail_progress = determine_blackmail_progress();
    int raygun_progress = determine_raygun_progress();

    int determine_combined_progress()
    {
	// The first 4 days of this plan are the same as the blackmail plan
	if ( blackmail_progress < 4 ) {
	    return blackmail_progress;
	}

	// The next 3 days overlap the other two plans.
	if ( blackmail_progress < 7 ) {
	    // If we have already made progress in the raygun plan,
	    // we don't need to overlap.
	    if ( raygun_progress > blackmail_progress - 4 ) {
		plan = vgc_quests[ "blackmail" ];
	    }
	    return blackmail_progress;
	}

	// If the have completed the blackmail plan without making
	// enough progress in the raygun plan, make up for that
	if ( raygun_progress < 3 ) {
	    plan = vgc_quests[ "raygun" ];
	    return raygun_progress;
	}

	// The last 7 days of the plan are the same as the last 7 days
	// of the raygun plan.

	return raygun_progress + 4;
    }

    int combined_progress = determine_combined_progress();

    int day;
    string noon;
    string midnight;

    void override_quest( string quest, int progress )
    {
	if ( vgc_quest != quest ) {
	    return;
	}

	if ( progress == count( plan ) ) {
	    print( "\"" + quest + "\" quest is complete!" );
	    vgc_quest = "";
	    return;
	}

	day = progress + 1;

	vgc_choice_pair choices = plan[ progress ];
	noon = choices[ 0 ];
	midnight = choices[ 1 ];
    }

    // Determine which day of which quest has the choices we need today
    override_quest( "blackmail", blackmail_progress );
    override_quest( "raygun", raygun_progress );
    override_quest( "blackmail+raygun", combined_progress );

    if ( vgc_quest != "" ) {
	print( "Day " + day + " of quest \"" + vgc_quest + "\"" );
    }

    if ( noon != "" ) {
	print( "Overriding noon choice: \"" + vgc_noon + "\" -> \"" + noon + "\"" );
	vgc_noon = noon;
    }

    if ( midnight != "" ) {
	print( "Overriding midnight choice: \"" + vgc_midnight + "\" -> \"" + midnight + "\"" );
	vgc_midnight = midnight;
    }
}

GingerChoice vgc_noon_choice;
GingerChoice vgc_midnight_choice;
int vgc_noon_turn;
int vgc_midnight_turn;
int vgc_last_turn;

GingerChoice vgc_candy_choice;
GingerChoice vgc_mainstat_choice;

void reload_vgc_settings()
{
    vgc_advance_clock = define_property( "VGC.AdvanceClock", "boolean", "false" ).to_boolean();
    vgc_morning = define_property( "VGC.Morning", "location", "none" ).to_location();
    vgc_afternoon = define_property( "VGC.Afternoon", "location", "none" ).to_location();
    vgc_night = define_property( "VGC.Night", "location", "none" ).to_location();
    vgc_noon = define_property( "VGC.Noon", "string", "candy" );
    vgc_midnight = define_property( "VGC.Midnight", "string", "mainstat" );
    vgc_quest = define_property( "VGC.Quest", "string", "" );
    vgc_banish = define_property( "VGC.Banishes", "monster", "", "set" );
    vgc_outfit = define_property( "VGC.Outfit", "string", "Gingerbread City" );
    vgc_familiar = define_property( "VGC.Familiar", "familiar", "Chocolate Lab" ).to_familiar();
}

boolean validate_gingerbread_plan( int first_turn )
{
    boolean zone_unlocked( location zone, GingerChoice noon_choice )
    {
	return zone == GINGERBREAD_SEWERS ?
	    ( noon_choice == NOON_SEWERS || get_property( "gingerSewersUnlocked" ).to_boolean() ) :
	    zone == GINGERBREAD_RETAIL_DISTRICT ?
	    ( noon_choice == NOON_RETAIL || get_property( "gingerRetailUnlocked" ).to_boolean() ) :
	    true;
    }

    boolean unavailable_noon_choice( string noon )
    {
	switch ( noon ) {
	case "photo counter":
	    return
		   // If we have fruit-leather negatives in inventory, we can
		   // drop them off at the photo counter.
		!( item_amount( FRUIT_LEATHER_NEGATIVES ) > 0 ||
		   // If we have dropped them off, don't have blackmail
		   // photos, and have not completed blackmail, we can pick
		   // them up at the photo counter.
		   ( get_property( "gingerNegativesDropped" ).to_boolean() &&
		     item_amount( GINGERBREAD_BLACKMAIL_PHOTOS ) == 0 ||
		     !get_property( "gingerBlackmailAccomplished" ).to_boolean() ) );
	case "retail":
	    return get_property( "gingerRetailUnlocked" ).to_boolean();
	case "sewers":
	    return get_property( "gingerSewersUnlocked" ).to_boolean();
	case "turns":
	    return get_property( "gingerExtraAdventures" ).to_boolean();
	case "clock":
	    return get_property( "gingerAdvanceClockUnlocked" ).to_boolean();
	}
	return false;
    }

    boolean unavailable_midnight_choice( string midnight )
    {
	switch ( midnight ) {
	case "fruit-leather negatives":
	    return 
		// Unavailable if we have not opened the subway line
		!get_property( "gingerSubwayLineUnlocked" ).to_boolean() ||
		// Or we already picked up the negatives
		item_amount( FRUIT_LEATHER_NEGATIVES ) > 0 ||
		// Or we have dropped them off at the photo counter
		get_property( "gingerNegativesDropped" ).to_boolean() ||
		// Or we have picked up the blackmail photos
		item_amount( GINGERBREAD_BLACKMAIL_PHOTOS ) > 0 ||
		// Or have completed the blackmail
		get_property( "gingerBlackmailAccomplished" ).to_boolean();
	}

	return false;
    }

    boolean invalid_choice_sequence( string noon, string midnight )
    {
	switch ( midnight ) {
	case "Judge Fudge":
	    return noon != "column";
	case "gingerbread moneybag":
	    return noon != "creme brulee torch";
	case "broken chocolate pocketwatch":
	    return noon != "pumpkin spice candle";
	case "meat":
	case "fat loot token":
	case "sprinkles":
	case "priceless diamond":
	case "pristine fish scales":
	    return noon != "candy crowbar";
	}
	return false;
    }

    // If we don't think we've unlocked all the city improvements, go
    // look at the Gingerbread City, since 3 of the 4 are visible
    if ( !get_property( "gingerAdvanceClockUnlocked" ).to_boolean() ||
	 !get_property( "gingerSewersUnlocked" ).to_boolean() ||
	 !get_property( "gingerRetailUnlocked" ).to_boolean() ) {
	visit_url( "place.php?whichplace=gingerbreadcity" );
    }

    stat mainstat = my_primestat();

    vgc_mainstat_choice = GINGER_STATS[ mainstat ];
    vgc_candy_choice = ginger_noon_choices[ "candy" ];

    // If you configured a quest, override noon and midnight choices, as
    // appropriate, before validating.
    vgc_override_choices( vgc_quest );

    // Examine all settings and make sure they make sense.
    // Preprocess a few of them.

    int current_turn = first_turn + 1;

    int vgc_morning_turns = 9;
    vgc_noon_turn = 10;

    // If we have not yet adventured, see if we will advance the clock
    if ( current_turn == 1 && vgc_advance_clock ) {
	if ( get_property( "gingerAdvanceClockUnlocked" ).to_boolean() ) {
	    print( "Advance the clock by five minutes" );
	    vgc_morning_turns = 3;
	    vgc_noon_turn = 5;
	    current_turn++;
	} else {
	    print( "You have not unlocked the Digital Clock upgrade." );
	    vgc_advance_clock = false;
	}
    }
    // If we have already adventured, see if we advanced the clock.
    else if ( current_turn > 1 ) {
	if ( get_property( "_gingerbreadClockAdvanced" ).to_boolean() ) {
	    // We did. Morning is shortened!
	    vgc_morning_turns = 3;
	    vgc_noon_turn = 5;
	}
    }

    // If we already adventured, perhaps we have used up some or all
    // morning turns
    if ( current_turn < vgc_noon_turn ) {
	// Nope. Validate the location.
	if ( vgc_morning == $location[ none ] ) {
	    // Wants to abort plan before morning. Whatever.
	    print( "Adventuring in The Gingerbread City stops." );
	    vgc_last_turn = current_turn;
	    return true;
	}

	if ( !( GINGERBREAD_ZONES contains vgc_morning ) ) {
	    print( "Morning zone '" + vgc_morning + "' is not in The Gingerbread City" );
	    return false;
	}

	if ( !zone_unlocked( vgc_morning, NO_CHOICE ) ) {
	    print( "Morning zone '" + vgc_morning + "' is not available to you." );
	    return false;
	}

	print( "Adventure for " + ( vgc_noon_turn - current_turn ) + " turns in " +  vgc_morning );

	// Advance to noon
	current_turn = vgc_noon_turn;
    }

    // If we have already adventured, perhaps we have used a noon choice
    if ( current_turn <= vgc_noon_turn ) {
	// Nope. Validate the choice
	if ( ginger_noon_choices contains vgc_noon ) {
	    vgc_noon_choice = ginger_noon_choices[ vgc_noon ];
	    if ( !zone_unlocked( vgc_noon_choice.zone, NO_CHOICE ) ) {
		print( "Noon choice '" + vgc_noon + "' is in zone '" + vgc_noon_choice.zone + "', which is not available to you; using 'candy'." );
		vgc_noon = "candy";
		vgc_noon_choice = vgc_candy_choice;
	    } else if ( unavailable_noon_choice( vgc_noon ) ) {
		print( "Noon choice '" + vgc_noon + "' is not available to you; using 'candy'." );
		vgc_noon = "candy";
		vgc_noon_choice = vgc_candy_choice;
	    }
	} else {
	    print( "Noon choice '" + vgc_noon + "' is invalid; using 'candy'" );
	    vgc_noon = "candy";
	    vgc_noon_choice = vgc_candy_choice;
	}

	print( "Look for \"" + vgc_noon + "\" in the " + vgc_noon_choice.zone + " on turn " + vgc_noon_turn );

	// Advance to the afternoon
	current_turn++;
    }

    vgc_midnight_turn = vgc_noon_turn + 10;

    // If we already adventured, perhaps we have used up some or all
    // afternoon turns
    if ( current_turn < vgc_midnight_turn ) {
	// Nope. Validate the location.
	if ( vgc_afternoon == $location[ none ] ) {
	    // Wants to abort plan before afternoon
	    print( "Adventuring in The Gingerbread City stops." );
	    vgc_last_turn = current_turn;
	    return true;
	}

	if ( !( GINGERBREAD_ZONES contains vgc_afternoon ) ) {
	    print( "Afternoon zone '" + vgc_afternoon + "' is not in The Gingerbread City" );
	    return false;
	}

	if ( !zone_unlocked( vgc_afternoon, vgc_noon_choice ) ) {
	    print( "Afternoon zone '" + vgc_afternoon + "' is not available to you." );
	    return false;
	}

	print( "Adventure for " + ( vgc_midnight_turn - current_turn ) + " turns in " +  vgc_afternoon );

	// Advance to midnight
	current_turn = vgc_midnight_turn;
    }

    // If we have already adventured, perhaps we have used a midnight choice
    if ( current_turn <= vgc_midnight_turn ) {
	// Nope. Validate the choice
	if ( vgc_midnight == "mainstat" ) {
	    vgc_midnight = mainstat.to_string();
	    vgc_midnight_choice = vgc_mainstat_choice;
	} else if ( invalid_choice_sequence( vgc_noon, vgc_midnight ) ) {
	    print( "Midnight choice '" + vgc_midnight + "' is not available with '" + vgc_noon + "' at noon; using 'mainstat'" );
	    vgc_midnight = mainstat.to_string();
	    vgc_midnight_choice = vgc_mainstat_choice;
	} else if ( ginger_midnight_choices contains vgc_midnight ) {
	    vgc_midnight_choice = ginger_midnight_choices[ vgc_midnight ];
	    if ( !zone_unlocked( vgc_midnight_choice.zone, vgc_noon_choice ) ) {
		print( "Midnight choice '" + vgc_midnight + "' is in zone '" + vgc_midnight_choice.zone + "', which is not available to you; using mainstat." );
		vgc_midnight = mainstat.to_string();
		vgc_midnight_choice = vgc_mainstat_choice;
	    } else if ( unavailable_midnight_choice( vgc_midnight ) ) {
		print( "Midnight choice '" + vgc_midnight + "' is not available to you; using 'mainstat'." );
		vgc_midnight = mainstat.to_string();
		vgc_midnight_choice = vgc_mainstat_choice;
	    }
	} else {
	    print( "Midnight choice '" + vgc_midnight + "' is invalid; using 'mainstat'" );
	    vgc_midnight = mainstat.to_string();
	    vgc_midnight_choice = vgc_mainstat_choice;
	}

	print( "Look for \"" + vgc_midnight + "\" in the " + vgc_midnight_choice.zone + " on turn " + vgc_midnight_turn );

	// Advance to the night
	current_turn++;
    }

    // If we are purchasing the city upgrade that grants extra turns, or
    // have already purchased it, 10 more turns available after midnight
    boolean extra_turns = vgc_noon_choice == NOON_TURNS || get_property( "gingerExtraAdventures" ).to_boolean();
    vgc_last_turn = vgc_midnight_turn + ( extra_turns ? 10 : 0 );

    // If we already adventured, perhaps we have used up some or all
    // night turns
    if ( current_turn < vgc_last_turn ) {
	// Nope. Validate the location.
	if ( vgc_night == $location[ none ] ) {
	    // Wants to abort plan before night.
	    print( "Adventuring in The Gingerbread City stops." );
	    vgc_last_turn = current_turn;
	    return true;
	}

	if ( !( GINGERBREAD_ZONES contains vgc_night ) ) {
	    print( "Night zone '" + vgc_night + "' is not in The Gingerbread City" );
	    return false;
	}

	if ( !zone_unlocked( vgc_night, vgc_noon_choice ) ) {
	    print( "Night zone '" + vgc_night + "' is not available to you." );
	    return false;
	}

	print( "Adventure for " + ( vgc_last_turn - current_turn + 1 ) + " turns in " +  vgc_night );
    }

    print( "Adventuring in The Gingerbread City stops." );

    return true;
}

// ***************************
//       Master Control      *
// ***************************

int vgc_ginger_turns_used;
int vgc_ginger_turns_max;
int vgc_ginger_turns_today;
int vgc_sprinkles_spent;

void vgc_calculate_turns()
{
    vgc_ginger_turns_used = get_property( "_gingerbreadCityTurns" ).to_int();
    vgc_ginger_turns_max = 20 + ( get_property( "gingerExtraAdventures" ).to_boolean() ? 10 : 0 );
    vgc_ginger_turns_today = vgc_ginger_turns_max - ( get_property( "_gingerbreadClockAdvanced" ).to_boolean() ? 5 : 0 );
}

void vgc_between_battle_checks()
{
    // Call this between fights initiated via visit_url to keep your
    // mood up-to-date and to recover HP and MP, as specified by your
    // recoveryScript or your configured recovery settings.
    mood_execute( -1 );
    restore_hp( 0 );
    restore_mp( 0 );
}

boolean advance_gingerbread_clock()
{
    if ( !vgc_advance_clock ) {
	set_property( "choiceAdventure1215", "2" );
	return false;
    }

    set_property( "choiceAdventure1215", "1" );
    adv1( GINGERBREAD_CIVIC_CENTER, 0, "gingerbread_filter" );
    return true;
}

static boolean [int] vgc_generic_turtle_choices = $ints[
    327,	// Puttin' it on Wax
    328,	// Never Break the Chain
    329,	// Don't Be Alarmed, Now
    344,	// Silent Strolling
    941,	// This Turtle Rocks!
    942,	// Even Tamer Than Usual
    943,	// Really Sticking Her Neck Out
    944,	// More Like... Hurtle
    945,	// Musk! Musk! Musk!
    946,	// Armchair Quarterback
    957,	// It Came from Beneath the Sewer? Great!
    958,	// Close, but Yes Cigar
];

static boolean [int] vgc_hallowiener_dog_choices = $ints[
    1106,	// Wooof! Wooooooof!
    1107,	// Playing Fetch*
    1108,	// Your Dog Found Something Again
];

void execute_gingerbread_choice( GingerChoice reward, GingerChoice alternate )
{
    GingerChoice todo = reward;

    // We already ensured that the location is available to us.
    // Does this require more sprinkles than we have?
    if ( todo.sprinkles > item_amount( SPRINKLES ) ) {
	todo = alternate;
    }

    // Does it require an item or an outfit?
    switch ( todo.tool ) {
    case $item[ none ]:
	break;
    case GINGERBREAD_BEST:
	if ( have_outfit( "Gingerbread Best" ) ) {
	    outfit( "Gingerbread Best" );
	} else {
	    todo = alternate;
	}
	break;
    case ROBBERY_OUTFIT:
	if ( available_amount( GINGERBREAD_MASK ) > 0 &&
	     available_amount( GINGERBREAD_PISTOL ) > 0 &&
	     available_amount( GINGERBREAD_MONEYBAG ) > 0 ) {
	    retrieve_item( 1, GINGERBREAD_MASK );
	    equip( GINGERBREAD_MASK );
	    retrieve_item( 1, GINGERBREAD_PISTOL );
	    equip( GINGERBREAD_PISTOL );
	    retrieve_item( 1, GINGERBREAD_MONEYBAG );
	    equip( GINGERBREAD_MONEYBAG );
	} else {
	    todo = alternate;
	}
	break;
    case GINGERSERVO:
	if ( equipped_amount( GINGERSERVO ) > 0 ) {
	    // Will be removed
	} else if ( available_amount( GINGERSERVO ) > 0 ) {
	    // But it doesn't have to be equipped
	    retrieve_item( 1, GINGERSERVO );
	} else {
	    todo = alternate;
	}
	break;
    case BLOWTORCH:
    case CANDY_CROWBAR:
    case DOG_TREAT:
    case GINGERBREAD_BLACKMAIL_PHOTOS:
    case GINGERBREAD_MUG:
    case PUMPKIN_SPICE_CANDLE:
    case TEETHPICK:
	// These must be in inventory
	if ( available_amount( todo.tool ) > 0 ) {
	    retrieve_item( 1, todo.tool );
	} else {
	    todo = alternate;
	}
	break;
    }

    // Prepare for a fight
    string filter = "gingerbread_filter";
    vgc_between_battle_checks();

    // Loop until we see the expected choice or no choice
    string page;
    int choice;

    while (true ) {
	page = visit_url( todo.zone.to_url() );

	// Judge Fudge replaces choice1
	if ( page.contains_text( "fight.php" ) ) {
	    run_combat( filter );
	    return;
	}

	// Otherwise, it's a bug if we don't find a choice
	if ( !page.contains_text( "choice.php" ) ) {
	    return;
	}

	choice = last_choice();

	// If we found the expected choice, carry on
	if ( choice == todo.choice1 ) {
	    break;
	}

	// We expect Noon or Midnight, but find something else entirely

	// Hallowiener dog. Does this advance the clock here? Assume not and that the expected choice is up next.
	if ( vgc_hallowiener_dog_choices contains choice ) {
	    // Execute the choice with the configured Hallowiener Dog choice option and try again
	    run_choice( -1 );
	    continue;
	}

	// Turtle taming. Elsewhere in Gingerbread City, that advances the clock.
	// Assume that it does not do so here and that the expected choice is up next.
	if ( vgc_generic_turtle_choices contains choice ) {
	    // Execute the choice with the only option and try again
	    run_choice( 1 );
	    continue;
	}

	// It is a different unexpected choice. What to do?
	abort( "Unexpected choice " + choice + ". Do what you want with it and run this script again to continue in the Gingerbread City. " );
    }

    // It is the expected choice. Make sure the option we want is available.
    int option = todo.option1;

    if ( !( available_choice_options() contains option ) ) {
	// Switch to the default option for this choice
	GingerChoice gc = ginger_default_choices[ choice ];
	print( "Expected choice/option " + todo.choice1 + "/" + option + " is unavailable; submitting " + choice + "/" + gc.option1 );
	todo = gc;
	option = gc.option1;
    }

    // It is an appropriate choice for this location. Submit it
    page = visit_url( "choice.php?pwd&whichchoice=" + choice + "&option=" + option );

    // No known fights from a first round choice. But if we get one, handle it.
    if ( page.contains_text( "fight.php" ) ) {
	run_combat( filter );
	return;
    }

    // Many options have only a single choice
    if ( !page.contains_text( "choice.php" ) ) {
	// Account for the sprinkles we spent
	vgc_sprinkles_spent += todo.sprinkles;
	return;
    }

    // Choices can redirect to other choices. Follow step 2.
    choice = last_choice();
    option = todo.option2;

    // Make sure we're at the choice we expected and that the option we want is available.
    if ( choice != todo.choice2 || !( available_choice_options() contains option ) ) {
	// Switch to the default option for this choice
	GingerChoice gc = ginger_default_choices[ choice ];
	print( "Expected choice/option " + todo.choice2 + "/" + option + " is unavailable; submitting " + choice + "/" + gc.option1 );
	todo = gc;
	option = gc.option1;
    }

    // It is a choice. Submit it
    page = visit_url( "choice.php?pwd&whichchoice=" + choice + "&option=" + option );

    // GNG-3-R comes after choice2
    if ( page.contains_text( "fight.php" ) ) {
	run_combat( filter );
	return;
    }

    // Account for the sprinkles we spent
    vgc_sprinkles_spent += todo.sprinkles;

    // If we bought a city upgrade, more of the plan may be available.
    if ( reward == NOON_TURNS ) {
	vgc_last_turn += 10;
    }
}

static boolean [int] vgc_noon_choices = $ints[
   1202,	// Noon in the Civic Center
   1204,	// Noon at the Train Station
   1206,	// Noon in the Industrial Zone
   1208,	// Upscale Noon
];

static boolean [int] vgc_midnight_choices = $ints[
   1203,	// Midnight in the Civic Center
   1205,	// Midnight at the Train Station
   1207,	// Midnight in the Industrial Zone
   1209,	// Upscale Midnight
];

int vgc_increment_property( string setting, int delta )
{
    int value = get_property( setting ).to_int() + delta;
    if ( delta != 0 ) {
	set_property( setting, value );
    }
    return value;
}

void execute_gingerbread_plan()
{
    boolean zone_unlocked( location zone )
    {
	return zone == GINGERBREAD_SEWERS ?
	    get_property( "gingerSewersUnlocked" ).to_boolean() :
	    zone == GINGERBREAD_RETAIL_DISTRICT ?
	    get_property( "gingerRetailUnlocked" ).to_boolean() :
	    true;
    }

    void suit_up( familiar fam, item famequip )
    {
	outfit( vgc_outfit );
	use_familiar( fam );
	equip( famequip );
    }

    void do_adventure( int turns, location loc )
    {
	// Setup for the combat filter
	vgc_current_zone = loc;
	vgc_pickpocket_available = true;
	vgc_pocket_crumbs_available = have_equipped( $item[ Pantsgiving ] );
	vgc_licorice_rope_available = have_skill( $skill[ Licorice Rope ] );

	string url = loc.to_url();
	while ( turns > 0 ) {
	    vgc_between_battle_checks();
	    string page = visit_url( url );
	    if ( page.contains_text( "fight.php" ) ) {
		run_combat( "gingerbread_filter" );
		turns--;
	    } else if ( page.contains_text( "choice.php" ) ) {
		// Unexpected choice.
		int choice = last_choice();
		if ( vgc_noon_choices[ choice ] ) {
		    // What to do?
		    abort( "Unexpected Noon in the " + loc );
		} else if ( vgc_midnight_choices[ choice ] ) {
		    // What to do?
		    abort( "Unexpected Midnight in the " + loc );
		} else if ( vgc_generic_turtle_choices[ choice ] ) {
		    // You have no choice but to try to tame turtles
		    run_choice( 1 );
		    // KoL bug: turtle taming advances time
		    vgc_increment_property( "_gingerbreadCityTurns", 1 );
		    turns--;
		} else {
		    // The Violet Fog can pop up in the Gingerbread
		    // City.  Using it does not count as a "turn", as
		    // far as advancing time is concerned. Automate.
		    run_choice( -1 );
		}
	    } else if ( vgc_abort_for_counters ) {
		// Unexpected non-fight/non-choice.  An expiring counter
		// can result in a blank page.  That doesn't take a
		// turn, but if we abort, the user can handle it
		// manually and run the script again to continue.
		abort( "Unexpected counter (probably). Do what you want with it and run this script again to continue in the Gingerbread City. " );
	    } else {
		// Unexpected non-fight/non-choice.  An expiring counter
		// can result in a blank page. So, don't count as a turn
		// spent.
	    }
	}
    }

    int first_turn = vgc_ginger_turns_used;
    int last_turn = vgc_last_turn;

    if ( first_turn >= last_turn ) {
	return;
    }
 
    print( "Farming sprinkles" );

    // Decide how to equip familiar
    item famequip =
	available_amount( CANDY_DOG_COLLAR ) > 0 ?
	CANDY_DOG_COLLAR :
	familiar_equipped_equipment( vgc_familiar );

    // *** Execute the plan!

    int current_turn = first_turn + 1;
    
    if ( current_turn == 1 && advance_gingerbread_clock() ) {
	current_turn++;
    }

    // Morning in The Gingerbread City
    if ( vgc_morning == $location[ none ] ) {
	return;
    }

    int noon_turn = vgc_noon_turn;

    if ( current_turn < noon_turn ) {
	if ( !zone_unlocked( vgc_morning ) ) {
	    print( vgc_morning + " is not available.", "red" );
	    return;
	}

	int turns = noon_turn - current_turn;
	suit_up( vgc_familiar, famequip );
	do_adventure( turns, vgc_morning );
	current_turn += turns;
    }

    if ( current_turn == noon_turn ) {
	// Noon in The Gingerbread City
	execute_gingerbread_choice( vgc_noon_choice, vgc_candy_choice );
	current_turn++;
    }

    // Afternoon in The Gingerbread City
    if ( vgc_afternoon == $location[ none ] ) {
	return;
    }

    int midnight_turn = vgc_midnight_turn;

    if ( current_turn < midnight_turn ) {
	if ( !zone_unlocked( vgc_afternoon ) ) {
	    print( vgc_afternoon + " is not available.", "red" );
	    return;
	}

	int turns = midnight_turn - current_turn;
	suit_up( vgc_familiar, famequip );
	do_adventure( turns, vgc_afternoon );
	current_turn += turns;
    }

    if ( current_turn == midnight_turn ) {
	// Midnight in The Gingerbread City
	execute_gingerbread_choice( vgc_midnight_choice, vgc_mainstat_choice );
	current_turn++;
    }

    // Night in The Gingerbread City
    if ( vgc_night == $location[ none ] ) {
	return;
    }

    if ( current_turn < last_turn ) {
	if ( !zone_unlocked( vgc_night ) ) {
	    print( vgc_night + " is not available.", "red" );
	    return;
	}

	int turns = last_turn - current_turn + 1;
	suit_up( vgc_familiar, famequip );
	do_adventure( turns, vgc_night );
    }
}

void gingerbread_city()
{
    boolean gingerbread_city_available()
    {
	// See if we have permanent access to the Gingerbread City.
	if ( get_property( "gingerbreadCityAvailable" ).to_boolean() ) {
	    return true;
	}

	// See if we have access today to Gingerbread City
	if ( get_property( "_gingerbreadCityToday" ).to_boolean() ) {
	    return true;
	}

	// We might, if we've opened it outside KoLmafia. Visit the
	// mountains and look.
	visit_url( "mountains.php" );
	if ( get_property( "_gingerbreadCityToday" ).to_boolean() ) {
	    return true;
	}

	// We do not. See if we have a counterfeit city available to us
	if ( available_amount( COUNTERFEIT_CITY ) > 0 ) {
	    return user_confirm( "You don't have access to the Gingerbread City today, but a counterfeit city is available to you. Retrieve and use it?" ) &&
		   retrieve_item( 1, COUNTERFEIT_CITY ) &&
		   use( 1, COUNTERFEIT_CITY );
	}

	return false;
    }

    // Determine current state of progress through Gingerbread City
    vgc_calculate_turns();

    // If we have used our full allotment of turns for the day, nothing to do or say.
    if ( vgc_ginger_turns_used >= vgc_ginger_turns_today ) {
	return;
    }

    // You can't be falling-down drunk
    if ( my_inebriety() > inebriety_limit() ) {
	print( "You are too drunk to adventure in the Gingerbread City." );
	return;
    }

    // You have to have access to the Gingerbread City
    if ( !gingerbread_city_available() ) {
	print( "The Gingerbread City is not available. Acquire and use a counterfeit city and try again." );
	return;
    }

    // Validate settings
    if ( !validate_gingerbread_plan( vgc_ginger_turns_used ) ) {
	return;
    }

    // Make sure we have enough turns left to execute the plan
    int available = my_adventures();
    int needed = vgc_last_turn - vgc_ginger_turns_used;
    if ( available < needed ) {
	// *** Perhaps user_confirm() to allow executing partial plan.
	string message = "That plan requires " + needed + " turns but you only have " + available + " left.";
	print( message );
	return;
    }

    string pnum( int n )
    {
	buffer pnum( buffer b, int n )
	{
	    buffer pnum_helper( buffer b, int n, int level )
	    {
		if ( n >= 10 ) {
		    pnum_helper( b, n / 10, level + 1 );
		}
		b.append( to_string( n % 10 ) );
		if ( level > 0 && level % 3 == 0 ) {
		    b.append( "," );
		}
		return b;
	    }

	    if ( n < 0 ) {
		b.append( "-" );
		n = -n;
	    }
	    return pnum_helper( b, n, 0 );
	}

	buffer b;
	return pnum( b, n ).to_string();
    }

    int spa( int sprinkles, int turns )
    {
	return turns == 0 ? sprinkles : ( sprinkles / turns );
    }

    int initial_sprinkles = available_amount( SPRINKLES );
    int initial_turns = total_turns_played();
    try {
	execute_gingerbread_plan();
    } finally {
	int spent_delta = vgc_sprinkles_spent;
	int spent_total = vgc_increment_property( VGC_SPENT_SETTING, spent_delta );
	int sprinkles_delta = available_amount( SPRINKLES ) - initial_sprinkles + spent_delta;
	int turn_delta = total_turns_played() - initial_turns;
	int sprinkle_total = vgc_increment_property( VGC_SPRINKLES_SETTING, sprinkles_delta );
	int turn_total = vgc_increment_property( VGC_TURNS_SETTING, turn_delta );
	int run_spa = spa( sprinkles_delta, turn_delta );
	int cumulative_spa = spa( sprinkle_total, turn_total );

	print( "Gained " + pnum( sprinkles_delta ) + " sprinkles in " + pnum( turn_delta ) + " turns. Sprinkles/Adventure = " + pnum( run_spa ) );
	print( "Cumulative = " + pnum( sprinkle_total ) + " sprinkles in " + pnum( turn_total ) + " turns. Sprinkles/Adventure = " + pnum( cumulative_spa ) );
	print( "Spent " + pnum( spent_delta ) + " sprinkles. Cumulative = " + pnum( spent_total ) );
    }
}

void main()
{
    gingerbread_city();
}