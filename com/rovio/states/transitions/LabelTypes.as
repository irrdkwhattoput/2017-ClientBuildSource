package com.rovio.states.transitions
{
   public class LabelTypes
   {
      
      public static const DELIMITER:String = "_";
      
      public static const ACTION_START:String = "start";
      
      public static const ACTION_END:String = "end";
      
      public static const ACTION_EXIT:String = "exit";
      
      public static const ANIMATION_RUN:String = "run";
      
      public static const ANIMATION_TRANSITION_IN:String = "transition_in";
      
      public static const ANIMATION_TRANSITION_OUT:String = "transition_out";
      
      public static const DEFAULT:String = "default";
       
      
      public function LabelTypes()
      {
         super();
      }
      
      public static function generateStartRunLabel() : String
      {
         return ACTION_START + DELIMITER + ANIMATION_RUN;
      }
      
      public static function generateStartTransitionInDefaultLabel() : String
      {
         return ACTION_START + DELIMITER + ANIMATION_TRANSITION_IN + DELIMITER + DEFAULT;
      }
      
      public static function generateStartTransitionOutDefaultLabel() : String
      {
         return ACTION_START + DELIMITER + ANIMATION_TRANSITION_OUT + DELIMITER + DEFAULT;
      }
      
      public static function generateStartTransitionInLabel(targetState:String = "") : String
      {
         var labelName:String = ACTION_START + DELIMITER + ANIMATION_TRANSITION_IN;
         return labelName + (targetState != "" ? DELIMITER + targetState.toLowerCase() : "");
      }
      
      public static function generateStartTransitionOutLabel(targetState:String = "") : String
      {
         var labelName:String = ACTION_START + DELIMITER + ANIMATION_TRANSITION_OUT;
         return labelName + (targetState != "" ? DELIMITER + targetState.toLowerCase() : "");
      }
   }
}
