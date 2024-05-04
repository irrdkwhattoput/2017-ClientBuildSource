package com.angrybirds.popup.tutorial
{
   import com.rovio.states.transitions.AbstractTransition;
   import com.rovio.states.transitions.TransitionData;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   
   public class TutorialTransition extends AbstractTransition
   {
      
      public static const EVENT_LOOP:String = "transition_lop";
      
      public static const DEFAULT_FRAMERATE:Number = 1000 / 24;
       
      
      protected var mFrameTimeMilliSeconds:Number;
      
      protected var mMillisecondsFromLastUpdate:int;
      
      protected var mFinishedAnimationCount:int;
      
      protected var mAnimationCount:int;
      
      protected var mStageQuality:String = "best";
      
      public function TutorialTransition(animations:Vector.<MovieClip>, stage:Stage, frameRateOfAnimation:Number = 41.666666666666664)
      {
         super(animations,stage);
         this.mFinishedAnimationCount = 0;
         this.mAnimationCount = animations.length;
         this.mFrameTimeMilliSeconds = frameRateOfAnimation;
         this.mMillisecondsFromLastUpdate = 0;
      }
      
      protected function runAnimation(index:int) : void
      {
         var stopAnimation:Boolean = false;
         var loopAnimation:Boolean = false;
         var loopLabel:String = null;
         var defaultLabel:String = null;
         var startLabel:String = null;
         var targetMC:MovieClip = mRunnableAnimations[index];
         if(mStopAnimation && !mWaitForAnimationsToFinish)
         {
            stopAnimation = true;
         }
         else
         {
            stopAnimation = shouldStopAnimation(targetMC,mStopAnimation);
         }
         if(stopAnimation)
         {
            loopAnimation = mTransitionData.loop && !mStopAnimation;
            if(loopAnimation)
            {
               if(targetMC.name == "MovieClip_TutorialClip" && mTransitionData.type == TransitionData.TRANSITION_TYPE_RUN)
               {
                  loopLabel = "loop_run";
                  targetMC.gotoAndStop(loopLabel);
                  dispatchEvent(new Event(EVENT_LOOP));
               }
               else
               {
                  defaultLabel = mTransitionData.defaultStartLabel != "" ? mTransitionData.defaultStartLabel : "";
                  startLabel = mTransitionData.startLabel != "" ? mTransitionData.startLabel : defaultLabel;
                  if(startLabel != "")
                  {
                     targetMC.gotoAndStop(startLabel);
                  }
                  else
                  {
                     targetMC.gotoAndStop(1);
                  }
               }
            }
            else
            {
               mRunnableAnimations.splice(index,1);
               ++this.mFinishedAnimationCount;
            }
         }
         else
         {
            targetMC.nextFrame();
         }
      }
      
      protected function runAnimations() : void
      {
         for(var i:int = mRunnableAnimations.length - 1; i >= 0; i--)
         {
            this.runAnimation(i);
         }
      }
      
      override protected function update(deltaTime:Number) : void
      {
         this.mMillisecondsFromLastUpdate += deltaTime;
         while(this.mMillisecondsFromLastUpdate >= this.mFrameTimeMilliSeconds)
         {
            this.runAnimations();
            this.mMillisecondsFromLastUpdate -= this.mFrameTimeMilliSeconds;
            if(this.mFinishedAnimationCount >= this.mAnimationCount)
            {
               if(stage && mTransitionData.stageQuality != "")
               {
                  stage.quality = this.mStageQuality;
               }
               mIsRunning = false;
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
      }
      
      override public function start(data:TransitionData) : void
      {
         super.start(data);
         this.mAnimationCount = mRunnableAnimations.length;
         this.mFinishedAnimationCount = 0;
         if(stage && data.stageQuality != "")
         {
            this.mStageQuality = stage.quality;
            stage.quality = data.stageQuality;
         }
      }
   }
}
