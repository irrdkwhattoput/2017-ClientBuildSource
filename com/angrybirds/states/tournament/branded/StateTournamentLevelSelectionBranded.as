package com.angrybirds.states.tournament.branded
{
   import com.angrybirds.data.level.LevelManager;
   import com.angrybirds.states.tournament.StateTournamentLevelSelection;
   import com.angrybirds.tournament.TournamentLevelButton;
   import com.angrybirds.tournament.TournamentModel;
   import com.angrybirds.utils.MovieClipFrameLabelTool;
   import com.rovio.assets.AssetCache;
   import com.rovio.data.localization.LocalizationManager;
   import com.rovio.ui.Components.UIButtonRovio;
   import com.rovio.ui.Views.UIView;
   import com.rovio.ui.Views.ViewXMLLibrary;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public class StateTournamentLevelSelectionBranded extends StateTournamentLevelSelection
   {
      
      private static const BG_INSTANCE_NAME:String = "CombinedBackground";
      
      private static const CAMPAIGN_BUTTON_INSTANCE_NAME:String = "CampaignButton";
      
      private static const TITLE_SIGN_CONTAINER_INSTANCE_NAME:String = "MovieClip_TitleSignContainer";
      
      private static const BANNER_INSTANCE_NAME:String = "banner";
      
      private static const BG_NAME_PREFIX:String = "LEVEL_SELECTION_BG_";
      
      private static const TITLE_SIGN_NAME_SUFFIX:String = "TITLE_SIGN_";
      
      private static const TITLE_TEXT_CONTAINER_NAME_SUFFIX:String = "TITLE_TEXT_";
      
      private static const BANNER_NAME_SUFFIX:String = "BANNER_";
      
      private static const PILLAR_1_NAME_SUFFIX:String = "PILLAR_1_";
      
      private static const PILLAR_2_NAME_SUFFIX:String = "PILLAR_2_";
      
      private static const PILLAR_3_NAME_SUFFIX:String = "PILLAR_3_";
      
      private static const PILLAR_INSTANCE_NAME:String = "pillar";
      
      public static const STATE_NAME:String = "TournamentState";
       
      
      public function StateTournamentLevelSelectionBranded(levelManager:LevelManager, localizationManager:LocalizationManager, initState:Boolean = false, name:String = "TournamentState")
      {
         super(levelManager,localizationManager,initState,name);
      }
      
      override protected function init() : void
      {
         var bgContainer:MovieClip = null;
         var bgMC:MovieClip = null;
         var titleContainer:MovieClip = null;
         var title:MovieClip = null;
         var textContainer:MovieClip = null;
         var titleTextMc:MovieClip = null;
         var bannerContainer:MovieClip = null;
         var banner:MovieClip = null;
         var pillar1Container:MovieClip = null;
         var pillar1:MovieClip = null;
         var pillar2Container:MovieClip = null;
         var pillar2:MovieClip = null;
         var pillar3Container:MovieClip = null;
         var pillar3:MovieClip = null;
         mUIView = new UIView(this);
         mUIView.init(ViewXMLLibrary.mLibrary.Views.View_BrandedTournament[0]);
         var brandedFrameLabel:String = TournamentModel.instance.tournamentRules.brandedFrameLabel;
         MovieClipFrameLabelTool.setStopToLabel(mUIView.getItemByName("CombinedBackground").mClip,"DEFAULT");
         MovieClipFrameLabelTool.setStopToLabel(mUIView.getItemByName("TitleSignContainer").mClip,"DEFAULT");
         MovieClipFrameLabelTool.setStopToLabel(mUIView.getItemByName("TextContainer").mClip,"DEFAULT");
         MovieClipFrameLabelTool.setStopToLabel(mUIView.getItemByName("Banner_Info").mClip,"DEFAULT");
         var bgName:String = BG_NAME_PREFIX + brandedFrameLabel;
         var cls:Class = AssetCache.getAssetFromCache(bgName,false);
         if(cls)
         {
            bgContainer = mUIView.getItemByName("CombinedBackground").mClip;
            bgContainer.removeChild(bgContainer.getChildByName(BG_INSTANCE_NAME));
            bgMC = new cls();
            bgMC.name = BG_INSTANCE_NAME;
            bgContainer.addChild(bgMC);
         }
         var titleSignName:String = TITLE_SIGN_NAME_SUFFIX + brandedFrameLabel;
         var titleClass:Class = AssetCache.getAssetFromCache(titleSignName,false);
         if(titleClass)
         {
            titleContainer = mUIView.getItemByName("TitleSignContainer").mClip;
            titleContainer.removeChild(titleContainer.getChildByName(TITLE_SIGN_CONTAINER_INSTANCE_NAME));
            title = new titleClass();
            title.name = TITLE_SIGN_CONTAINER_INSTANCE_NAME;
            titleContainer.addChild(title);
         }
         var titleTextContainerName:String = TITLE_TEXT_CONTAINER_NAME_SUFFIX + brandedFrameLabel;
         var titleTextContainerClass:Class = AssetCache.getAssetFromCache(titleTextContainerName,false);
         if(titleTextContainerClass)
         {
            textContainer = mUIView.getItemByName("TextContainer").mClip;
            textContainer.removeChild(textContainer.getChildByName(TEXT_CONTAINER_INSTANCE_NAME));
            titleTextMc = new titleTextContainerClass();
            titleTextMc.name = TEXT_CONTAINER_INSTANCE_NAME;
            textContainer.addChild(titleTextMc);
         }
         var bannerName:String = BANNER_NAME_SUFFIX + brandedFrameLabel;
         var bannerCls:Class = AssetCache.getAssetFromCache(bannerName,false);
         if(bannerCls)
         {
            bannerContainer = mUIView.getItemByName("Banner_Info").mClip;
            bannerContainer.removeChild(bannerContainer.getChildByName(BANNER_INSTANCE_NAME));
            banner = new bannerCls();
            banner.name = BANNER_INSTANCE_NAME;
            bannerContainer.addChild(banner);
         }
         
         // pillager
         var pillar1Name:String = PILLAR_1_NAME_SUFFIX + brandedFrameLabel;
         var pillar1Cls:Class = AssetCache.getAssetFromCache(pillar1Name,false);
         if(pillar1Cls)
         {
            pillar1Container = mUIView.getItemByName("StarPillarPlaceHolder1").mClip;
            pillar1Container.removeChild(pillar1Container.getChildByName(PILLAR_INSTANCE_NAME));
            pillar1 = new pillar1Cls();
            pillar1.name = PILLAR_INSTANCE_NAME;
            pillar1Container.addChild(pillar1);
         }
         var pillar2Name:String = PILLAR_2_NAME_SUFFIX + brandedFrameLabel;
         var pillar2Cls:Class = AssetCache.getAssetFromCache(pillar2Name,false);
         if(pillar2Cls)
         {
            pillar2Container = mUIView.getItemByName("StarPillarPlaceHolder2").mClip;
            pillar2Container.removeChild(pillar2Container.getChildByName(PILLAR_INSTANCE_NAME));
            pillar2 = new pillar2Cls();
            pillar2.name = PILLAR_INSTANCE_NAME;
            pillar2Container.addChild(pillar2);
         }
         var pillar3Name:String = PILLAR_3_NAME_SUFFIX + brandedFrameLabel;
         var pillar3Cls:Class = AssetCache.getAssetFromCache(pillar3Name,false);
         if(pillar3Cls)
         {
            pillar3Container = mUIView.getItemByName("StarPillarPlaceHolder3").mClip;
            pillar3Container.removeChild(pillar3Container.getChildByName(PILLAR_INSTANCE_NAME));
            pillar3 = new pillar3Cls();
            pillar3.name = PILLAR_INSTANCE_NAME;
            pillar3Container.addChild(pillar3);
         }
      }
      
      override protected function makeLevelButton(levelNumber:int, levelObject:Object, uiButton:UIButtonRovio) : TournamentLevelButton
      {
         var levelButton:TournamentLevelButton = super.makeLevelButton(levelNumber,levelObject,uiButton);
         levelButton.setBrand(TournamentModel.instance.tournamentRules.brandedFrameLabel);
         return levelButton;
      }
      
      override protected function getCampaignButtonFromBG() : SimpleButton
      {
         var bgContainer:MovieClip = mUIView.getItemByName("CombinedBackground").mClip;
         return SimpleButton((bgContainer.getChildByName(BG_INSTANCE_NAME) as DisplayObjectContainer).getChildByName(CAMPAIGN_BUTTON_INSTANCE_NAME));
      }
   }
}
