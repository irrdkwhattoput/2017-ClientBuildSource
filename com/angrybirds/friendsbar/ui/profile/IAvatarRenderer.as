package com.angrybirds.friendsbar.ui.profile
{
   import com.angrybirds.avatarcreator.components.Avatar;
   import flash.display.BitmapData;
   
   public interface IAvatarRenderer
   {
       
      
      function render(param1:String, param2:Function, param3:int = 50, param4:Boolean = false, param5:Object = null, param6:Avatar = null, param7:int = 0, param8:Boolean = false, param9:Number = 0.4) : BitmapData;
      
      function renderWithAvatar(param1:Avatar) : void;
      
      function processQueue() : void;
   }
}
