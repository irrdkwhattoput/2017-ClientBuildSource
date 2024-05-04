package com.angrybirds.engine.controllers
{
   import flash.events.KeyboardEvent;
   
   public interface ILevelMainController
   {
       
      
      function init() : void;
      
      function addEventListeners() : void;
      
      function removeEventListeners() : void;
      
      function addScore(param1:int) : void;
      
      function getScore() : int;
      
      function getEagleScore() : int;
      
      function update(param1:Number) : void;
      
      function keyUp(param1:KeyboardEvent) : void;
      
      function keyDown(param1:KeyboardEvent) : void;
      
      function checkForLevelEnd() : void;
   }
}
