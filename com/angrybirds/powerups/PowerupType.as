package com.angrybirds.powerups
{
   public class PowerupType
   {
      
      public static const POWERUP_BUNDLE_ID:String = "PowerupBundle";
      
      public static const sBirdFood:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("BirdFood","Power Potion","Button_PowerUp1","POWERUP1",["BirdFoodSubscriptionTournament"],"Supersize your bird! Power Potion turns any bird into a pig-popping giant!","Supersize your birds! Infinite Power Potion for this week\'s tournament.");
      
      public static const sExtraSpeed:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("ExtraSpeed","King Sling","Button_PowerUp2","POWERUP2",["ExtraSpeedSubscriptionTournament"],"Fling your birds with style AND speed. Upgrade to the almighty King Sling for maximum power and velocity!","Hail to the sling! Infinite King Sling for this week\'s tournament.");
      
      public static const sLaserSight:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("LaserSight","Sling Scope","Button_PowerUp3","POWERUP3",["LaserSightSubscriptionTournament"],"Looking for the perfect shot? Use Sling Scope laser targeting for pinpoint precision!","Aim to please! Infinite Sling Scope for this week\'s tournament.");
      
      public static const sEarthquake:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("Earthquake","Birdquake","Button_PowerUp4","POWERUP4",["EarthquakeSubscriptionTournament"],"Rattle the battle! Use the Birdquake to bring pigs\' defenses crashing to the ground!","Rattle the battle! Infinite Birdquake for this week\'s tournament.",false);
      
      public static const sMushroom:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("Mushroom","Mushbloom","Button_PowerUp5","POWERUP5",null,"Create a mighty bloom of mushrooms beneath the pigs and topple their towers! Only useable in the Pig Tales levels.");
      
      public static const sTntDrop:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("TNTDrop","Tnt Drop","Button_PowerUp6","POWERUP6",["TNTDropSubscriptionDay","TNTDropSubscriptionTournament"]);
      
      public static const sPumpkinDrop:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("ExchangedItem","Pumpkin Drop","Button_PowerUp7","POWERUP7",null);
      
      public static const sMightyEagle:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("MightyEagle","Mighty Eagle","Button_PowerUpMightyEagle","POWERUP_MIGHTY_EAGLE",null,"Summon the Mighty Eagle to wreak havoc on the pigs and collect Total Destruction feathers. Only useable in story levels.","Summon the Mighty Eagle to wreak havoc on the pigs and collect Total Destruction feathers. Only useable in story levels.",false);
      
      public static const sExtraBird:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("ExtraBird","Wingman","Button_PowerUpWingman","POWERUP_WINGMAN",["ExtraBirdSubscriptionDay","ExtraBirdSubscriptionTournament"],"Call the Wingman to demolish your enemies and impress your friends.","Call the Wingman! Infinite Wingman for this week\'s tournament.",false);
      
      public static const sWeek2Bundle:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("Xmas2013W2","The Tournament Bundle",null,null,null,"Enjoy infinite power-ups for this week\'s tournament. Includes Wingman and every power-up.","Enjoy infinite power-ups for this week\'s tournament. Includes Wingman and every power-up.",false);
      
      public static const sWeek3Bundle:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("Xmas2013W3","The Tournament Bundle",null,null,null,"Enjoy infinite power-ups for this week\'s tournament. Includes Wingman and every power-up.","Enjoy infinite power-ups for this week\'s tournament. Includes Wingman and every power-up.",false);
      
      public static const sWeek4Bundle:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("Xmas2013W4","The Tournament Bundle",null,null,null,"Enjoy infinite power-ups for this week\'s tournament. Includes Wingman and every power-up.","Enjoy infinite power-ups for this week\'s tournament. Includes Wingman and every power-up.",false);
      
      public static const sPowerupBundle:com.angrybirds.powerups.PowerupDefinition = new com.angrybirds.powerups.PowerupDefinition("PowerupBundle","Power-Up Pack",null,null,null,"Each pack contains a Wingman, Power Potion, Sling Scope, King Sling and Birdquake making it the perfect solution to all your piggy problems.","Each pack contains a Wingman, Power Potion, Sling Scope, King Sling and Birdquake making it the perfect solution to all your piggy problems.",false);
      
      private static const sAllSpecialPowerups:Array = [sWeek2Bundle,sWeek3Bundle,sWeek4Bundle];
      
      public static const sExemptedFromLevelPowerupLimit:Array = [sExtraBird.identifier,sMightyEagle.identifier];
      
      public static const sAllPowerups:Array = [sBirdFood,sExtraSpeed,sLaserSight,sEarthquake,sTntDrop,sPumpkinDrop,sMightyEagle,sExtraBird,sMushroom];
      
      public static const sPowerupsTournament:Array = [sBirdFood,sExtraSpeed,sLaserSight,sEarthquake,sExtraBird];
      
      public static const sPowerupsStorymode:Array = [sBirdFood,sExtraSpeed,sLaserSight,sEarthquake,sMightyEagle,sExtraBird];
      
      public static const sPowerupsStorymodeWonderland:Array = [sBirdFood,sExtraSpeed,sLaserSight,sEarthquake,sMushroom,sMightyEagle,sExtraBird];
       
      
      public function PowerupType()
      {
         super();
      }
      
      public static function get allPowerups() : Array
      {
         return sAllPowerups.concat();
      }
      
      public static function getPowerupByEventName(eventName:String) : com.angrybirds.powerups.PowerupDefinition
      {
         var powerupDefinition:com.angrybirds.powerups.PowerupDefinition = null;
         for each(powerupDefinition in sAllPowerups)
         {
            if(powerupDefinition.eventName == eventName)
            {
               return powerupDefinition;
            }
         }
         return null;
      }
      
      public static function getPowerupBySubscriptionName(subscriptionName:String) : com.angrybirds.powerups.PowerupDefinition
      {
         var powerupDefinition:com.angrybirds.powerups.PowerupDefinition = null;
         for each(powerupDefinition in sAllPowerups)
         {
            if(powerupDefinition.subscriptionNames != null)
            {
               if(powerupDefinition.subscriptionNames.indexOf(subscriptionName) != -1)
               {
                  return powerupDefinition;
               }
            }
         }
         return null;
      }
      
      public static function getPowerupByID(id:String) : com.angrybirds.powerups.PowerupDefinition
      {
         var powerupDefinition:com.angrybirds.powerups.PowerupDefinition = null;
         for each(powerupDefinition in sAllPowerups)
         {
            if(powerupDefinition.identifier == id)
            {
               return powerupDefinition;
            }
         }
         return null;
      }
      
      public static function getSpecialPowerupByID(id:String) : com.angrybirds.powerups.PowerupDefinition
      {
         var powerupDefintion:com.angrybirds.powerups.PowerupDefinition = null;
         for each(powerupDefintion in sAllSpecialPowerups)
         {
            if(powerupDefintion.identifier == id)
            {
               return powerupDefintion;
            }
         }
         return null;
      }
   }
}
