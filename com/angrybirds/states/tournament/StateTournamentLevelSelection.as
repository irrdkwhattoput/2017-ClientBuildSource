package com.angrybirds.states.tournament
{
   import com.angrybirds.AngryBirdsEngine;
   import com.angrybirds.data.ChallengeVO;
   import com.angrybirds.data.DataModelFriends;
   import com.angrybirds.data.ExceptionUserIDsManager;
   import com.angrybirds.data.FriendListItemVO;
   import com.angrybirds.data.ItemsInventory;
   import com.angrybirds.data.OpenGraphData;
   import com.angrybirds.data.UserTournamentScoreVO;
   import com.angrybirds.data.level.LevelManager;
   import com.angrybirds.friendsbar.FriendsBar;
   import com.angrybirds.friendsbar.data.CachedFacebookFriends;
   import com.angrybirds.friendsdatacache.CachedFriendDataVO;
   import com.angrybirds.friendsdatacache.FriendsDataCache;
   import com.angrybirds.league.LeagueModel;
   import com.angrybirds.league.events.LeagueEvent;
   import com.angrybirds.popups.ChallengePopup;
   import com.angrybirds.popups.ErrorPopup;
   import com.angrybirds.popups.PopupLayerIndexFacebook;
   import com.angrybirds.popups.qualifier.QualifierInterruptedPopUp;
   import com.angrybirds.shoppopup.TabbedShopPopup;
   import com.angrybirds.shoppopup.serveractions.ClientStorage;
   import com.angrybirds.spiningwheel.SpinningWheelController;
   import com.angrybirds.spiningwheel.events.SpinningWheelEvent;
   import com.angrybirds.states.StateBaseLevel;
   import com.angrybirds.states.StateCredits;
   import com.angrybirds.states.StateFacebookMainMenuSelection;
   import com.angrybirds.tournament.TournamentLevelButton;
   import com.angrybirds.tournament.TournamentStarPillar;
   import com.angrybirds.tournament.TournamentModel;
   import com.angrybirds.tournament.campaign.CampaignDefinition;
   import com.angrybirds.tournament.events.TournamentEvent;
   import com.angrybirds.tournamentEvents.IEventManager;
   import com.angrybirds.tournamentEvents.TournamentEventManager;
   import com.angrybirds.tournamentpopups.TournamentResultsPopup;
   import com.angrybirds.wallet.IWalletContainer;
   import com.angrybirds.wallet.Wallet;
   import com.rovio.assets.AssetCache;
   import com.rovio.data.localization.LocalizationManager;
   import com.rovio.externalInterface.ExternalInterfaceHandler;
   import com.rovio.server.RetryingURLLoader;
   import com.rovio.server.RetryingURLLoaderErrorEvent;
   import com.rovio.sound.SoundEngine;
   import com.rovio.ui.Components.Helpers.UIComponentInteractiveRovio;
   import com.rovio.ui.Components.Helpers.UIComponentRovio;
   import com.rovio.ui.Components.Helpers.UIEventListenerRovio;
   import com.rovio.ui.Components.UIButtonRovio;
   import com.rovio.ui.Views.UIView;
   import com.rovio.ui.Views.ViewXMLLibrary;
   import com.rovio.ui.popup.PopupPriorityType;
   import com.rovio.utils.FacebookAnalyticsCollector;
   import com.rovio.utils.analytics.INavigable;
   import data.user.FacebookUserProgress;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   public class StateTournamentLevelSelection extends StateBaseLevel implements INavigable, IWalletContainer
   {
      public static const STATE_NAME:String = "TournamentState";
      
      protected static const TEXT_CONTAINER_INSTANCE_NAME:String = "TextContainer";
      
      protected static const CAMPAIGN_BUTTON_HOLDER:String = "campaign_button_holder";
      
      private static const STARPILLAR_EXTRA_GAP:int = -20;
      
      private static const STARPILLAR_NO_GAP:int = 0;
      
      private static const LOADING_STEP_INDEX_INFO:int = 0;
      
      private static const LOADING_STEP_INDEX_SCORE:int = 1;
      
      private static const LOADING_STEP_INDEX_STANDINGS:int = 2;
      
      private static const LOADING_STEP_INDEX_LEAGUE:int = 3;
      
      private static var smActivatedEventManager:IEventManager;
      
      private static var smCheckTournamentEventButtonState:Boolean;
      
      private static var smActivateTournamentEventPopup:Boolean;
      
      private static var smTournamentNameOriginalY:Number = 0;
      
      private static const UPDATE_ROUNDS_TO_SCALE_UI:int = 5;
      
      private static var mCutscenesAvailability:Array = [true,false,false,false];
       
      
      private var mPlayers:Array;
      
      private var mContentType:Array;
      
      private var mTournamentInitLoader:RetryingURLLoader;
      
      protected var mLevelNames:Array;
      
      protected var mTimeAtDataInject:int = 0;
      
      protected var mLevelButtons:Vector.<TournamentLevelButton>;
      
      protected var mTournamentModel:TournamentModel;
      
      protected var pillar1:TournamentStarPillar;
      
      protected var pillar2:TournamentStarPillar;
      
      protected var pillar3:TournamentStarPillar;
      
      private var mShowShareScoreWindowOnNextLoop:Boolean;
      
      private var mRemoveLoadingScreenOnNextLoop:Boolean;
      
      private var mLoadingSteps:Vector.<Boolean>;
      
      private var mActiveCampaign:CampaignDefinition;
      
      private var mPreviousButtonVisibilitySet:Boolean = false;
      
      private var mSpinButton:UIComponentRovio;
      
      private var mMoreGamesButton:UIComponentRovio;
      
      private var mDailyRewardController:SpinningWheelController;
      
      private var mDaysLeftTF:TextField;
      
      private var mBannerInfoTF:TextField;
      
      private var mTitleTF:TextField;
      
      private var mAnimateSpinningWheelNotifier:Boolean;
      
      private var mNotificationBounceStartTimer:uint;
      
      private const TIME_DELAY_TO_SHOW_SPIN_NOTIFIER_BOUNCE:uint = 2000;
      
      private var mSpinNotifierVisible:Boolean;
      
      private var mPreviousResultButton:UIComponentRovio;
      
      private var mCampaignButton:SimpleButton;
      
      private var mQualifierInterruptedPopUp:QualifierInterruptedPopUp;
      
      private var mWallet:Wallet;
      
      private var mUseWallet:Boolean;
      
      private var mUIScaledToFullScreenCounter:int;
      
      private var mUIScaledToNormalCounter:int;
      
      protected var mChallengeButton:UIComponentRovio;
      
      private var mShareButtonHolder:UIComponentRovio;
      
      private var mPreviousScreenWidth:Number;
      
      private var HALLOWEEN_LEVEL_IDS:Array;
      
      private var XMAS_LEVEL_IDS:Array;
      
      public function StateTournamentLevelSelection(levelManager:LevelManager, localizationManager:LocalizationManager, initState:Boolean = false, name:String = "TournamentState")
      {
         this.mContentType = [97,112,112,108,105,99,97,116,105,111,110,47,106,115,111,110];
         this.HALLOWEEN_LEVEL_IDS = ["2000-279","2000-271","2000-267","2000-269"];
         this.XMAS_LEVEL_IDS = ["2000-303","2000-307","2000-313","2000-315"];
         this.mTournamentModel = TournamentModel.instance;
         this.mDailyRewardController = SpinningWheelController.instance;
         super(levelManager,initState,name,localizationManager);
      }
      
      protected static function get dataModel() : DataModelFriends
      {
         return DataModelFriends(AngryBirdsBase.singleton.dataModel);
      }
      
      public static function isCutsceneAvailable(index:int) : Boolean
      {
         if(index < 1)
         {
            return false;
         }
         if(index > 5)
         {
            return false;
         }
         return mCutscenesAvailability[index - 1];
      }
      
      public static function activateTournamentEventButtonStateCheck() : void
      {
         smCheckTournamentEventButtonState = true;
      }
      
      public static function resetActiveTournamentEventButton() : void
      {
         smCheckTournamentEventButtonState = true;
         smActivatedEventManager = null;
      }
      
      public static function activateTournamentEventPopup() : void
      {
         smActivateTournamentEventPopup = true;
      }
      
      protected function onCurrentTournamentInfoLoaded(event:TournamentEvent) : void
      {
         if(this.mLoadingSteps)
         {
            this.mLoadingSteps[LOADING_STEP_INDEX_INFO] = true;
         }
      }
      
      protected function onCurrentTournamentScoreLoaded(event:TournamentEvent) : void
      {
         if(this.mLoadingSteps)
         {
            this.mLoadingSteps[LOADING_STEP_INDEX_SCORE] = true;
         }
      }
      
      protected function onCurrentTournamentStandingsLoaded(event:TournamentEvent) : void
      {
         if(this.mLoadingSteps)
         {
            this.mLoadingSteps[LOADING_STEP_INDEX_STANDINGS] = true;
         }
         else
         {
            this.tournamentInfoLoadingComplete();
         }
      }
      
      protected function onTournamentReloaded(event:TournamentEvent) : void
      {
         this.removeWallet(this.mWallet);
         this.tournamentInfoLoadingComplete();
      }
      
      override protected function init() : void
      {
         mUIView = new UIView(this);
         mUIView.init(ViewXMLLibrary.mLibrary.Views.View_Tournament[0]);
         this.mLoadingSteps = new Vector.<Boolean>();
         this.mRemoveLoadingScreenOnNextLoop = false;
      }
      
      override public function activate(previousState:String) : void
      {
         super.activate(previousState);
         FacebookAnalyticsCollector.getInstance().trackScreenView(FacebookAnalyticsCollector.SCREEN_EVENT_TOURNAMENT_LEVEl_SELECTION_SCREEN);
         this.mUIScaledToFullScreenCounter = 0;
         this.mUIScaledToNormalCounter = 0;
         this.setTitleInfoTexts();
         this.displayLoadingText(true);
         this.initNavigationButtons();
         activateTournamentEventButtonStateCheck();
         this.mPreviousResultButton = mUIView.getItemByName("Button_PreviousResults");
         this.mChallengeButton = mUIView.getItemByName("Button_Challenge");
         this.mChallengeButton.visible = false;
         this.mLoadingSteps = new Vector.<Boolean>();
         this.mLoadingSteps[LOADING_STEP_INDEX_INFO] = false;
         this.mLoadingSteps[LOADING_STEP_INDEX_SCORE] = false;
         this.mLoadingSteps[LOADING_STEP_INDEX_STANDINGS] = false;
         this.mTournamentModel.addEventListener(TournamentEvent.CURRENT_TOURNAMENT_INFO_INITIALIZED,this.onCurrentTournamentInfoLoaded);
         this.mTournamentModel.addEventListener(TournamentEvent.CURRENT_TOURNAMENT_LEVEL_SCORES_LOADED,this.onCurrentTournamentScoreLoaded);
         this.mTournamentModel.addEventListener(TournamentEvent.CURRENT_TOURNAMENT_STANDINGS_LOADED,this.onCurrentTournamentStandingsLoaded);
         this.mTournamentModel.addEventListener(TournamentEvent.TOURNAMENT_RELOAD,this.onTournamentReloaded);
         AngryBirdsEngine.smLevelMain.clearLevel();
         AngryBirdsEngine.smLevelMain.setVisible(false);
         (AngryBirdsEngine.smApp as AngryBirdsFacebook).setPopupButtonFriendsBar(FriendsBar.SIDEBAR_BUTTON_STATE_NONE);
         if(mUIView.getItemByName("TournamentCutsceneSelection"))
         {
            mUIView.getItemByName("TournamentCutsceneSelection").setVisibility(false);
         }
         (AngryBirdsEngine.smApp as AngryBirdsFacebook).setFriendsBarData(FriendsBar.SCORE_LIST_EMPTY);
         this.mTournamentModel.loadData();
         if(LeagueModel.instance.active)
         {
            this.mLoadingSteps[LOADING_STEP_INDEX_LEAGUE] = false;
            LeagueModel.instance.addEventListener(LeagueEvent.ALL_DATA_LOADED,this.onAllLeagueDataLoaded);
            LeagueModel.instance.loadData();
         }
         this.showQualifierInterrupted();
         this.mPreviousScreenWidth = AngryBirdsEngine.getCurrentScreenWidth();
      }
      
      private function showQualifierInterrupted() : void
      {
         if(!this.mTournamentModel.hasShownQualifierInterruptPopUp() && this.mTournamentModel.hasQualifierInterrupted && ItemsInventory.instance.bundleHandler.isBundleClaimable(TournamentModel.QUALIFIER_INTERRUPTED_BUNDLE))
         {
            if(this.mQualifierInterruptedPopUp == null)
            {
               this.mQualifierInterruptedPopUp = new com.angrybirds.popups.qualifier.QualifierInterruptedPopUp(PopupLayerIndexFacebook.NORMAL,PopupPriorityType.DEFAULT);
            }
            this.mTournamentModel.shownQualifierInterruptPopUp(true);
            AngryBirdsBase.singleton.popupManager.openPopup(this.mQualifierInterruptedPopUp);
         }
      }
      
      private function initNavigationButtons() : void
      {
         if(this.mMoreGamesButton == null)
         {
            // commented for podium implementation
            // this.mMoreGamesButton = mUIView.getItemByName("MoreGamesButton");
         }
         if(this.mSpinButton == null)
         {
            this.mSpinButton = mUIView.getItemByName("Button_SpinningWheel");
         }
         this.mNotificationBounceStartTimer = 0;
         this.setSpinNotifierVisibility(false);
         this.mDailyRewardController.addEventListener(SpinningWheelEvent.SPIN_REWARD_RECEIVED,this.cbOnSpinRewardReceived);
         this.mDailyRewardController.addEventListener(SpinningWheelEvent.NEW_SPIN_AVAILABLE,this.cbOnNewSpinAvailable);
         if(this.mDailyRewardController.isDailyRewardDataLoading())
         {
            this.mSpinButton.setEnabled(false);
            this.mSpinButton.mClip.alpha = 0.5;
         }
         else if(this.mDailyRewardController.isSpinAvailable())
         {
            this.mAnimateSpinningWheelNotifier = true;
            this.setSpinNotifierVisibility(true);
         }
      }
      
      private function cbOnSpinRewardReceived(event:SpinningWheelEvent) : void
      {
         this.setSpinNotifierVisibility(false);
      }
      
      private function cbOnNewSpinAvailable(event:SpinningWheelEvent) : void
      {
         this.mSpinButton.setEnabled(true);
         this.mSpinButton.mClip.alpha = 1;
         var spinAvailable:Boolean = this.mDailyRewardController.isSpinAvailable();
         this.mAnimateSpinningWheelNotifier = spinAvailable;
         this.setSpinNotifierVisibility(spinAvailable);
      }
      
      private function animateSpinNotifier() : void
      {
         var mc:MovieClip = MovieClip(this.mSpinButton.mClip.getChildByName("notifier"));
         mc.gotoAndPlay(1);
      }
      
      private function setSpinNotifierVisibility(val:Boolean) : void
      {
         var mc:MovieClip = MovieClip(this.mSpinButton.mClip.getChildByName("notifier"));
         mc.visible = val;
         mc.gotoAndStop(1);
         this.mSpinNotifierVisible = val;
      }
      
      private function onAllLeagueDataLoaded(e:LeagueEvent) : void
      {
         if(this.mLoadingSteps)
         {
            this.mLoadingSteps[LOADING_STEP_INDEX_LEAGUE] = true;
         }
         LeagueModel.instance.removeEventListener(LeagueEvent.ALL_DATA_LOADED,this.onAllLeagueDataLoaded);
         if(LeagueModel.instance.unconcludedResult)
         {
            StateTournamentResults.resultType = StateTournamentResults.RESULTS_SCREEN;
            if(AngryBirdsEngine.smApp.getCurrentState() == StateTournamentLevelSelection.STATE_NAME || AngryBirdsEngine.smApp.getCurrentState() == StateFacebookMainMenuSelection.STATE_NAME)
            {
               setNextState(StateTournamentResults.STATE_NAME);
            }
         }
      }
      
      private function displayLoadingText(value:Boolean) : void
      {
         mUIView.getItemByName("loadingTournament").setVisibility(value);
         this.removeWallet(this.mWallet);
      }
      
      private function onError(e:Event) : void
      {
         if(e.type == RetryingURLLoaderErrorEvent.THIRD_PARTY_COOKIES_DISABLED)
         {
            this.showErrorPopup(ErrorPopup.ERROR_THIRD_PARTY_COOKIES_DISABLED);
         }
         else
         {
            this.showErrorPopup(ErrorPopup.ERROR_GENERAL);
         }
      }
      
      private function getContentType() : String
      {
         return this.getText(this.mContentType);
      }
      
      private function getText(data:Array) : String
      {
         var i:int = 0;
         var name:String = "";
         for each(i in data)
         {
            name += String.fromCharCode(i);
         }
         return name;
      }
      
      private function tournamentInfoLoadingComplete() : void
      {
         var campaignUI:UIComponentRovio = null;
         var cls:Class = null;
         var shareBrandName:String = null;
         if(this.mTournamentModel.containsLevel(AngryBirdsFacebook.smLevelToOpen))
         {
            this.startLevel(AngryBirdsFacebook.smLevelToOpen);
            AngryBirdsFacebook.smLevelToOpen = null;
            return;
         }
         if(!mUIView)
         {
            return;
         }
         this.setLevelButtons();
         this.updateScoreData();
         (AngryBirdsEngine.smApp as AngryBirdsFacebook).setVisibleButtonFriendsBar(FriendsBar.SIDEBAR_BUTTON_STATE_INFO);
         this.updateTimeLeft();
         this.updateInfoText();
         this.displayLoadingText(false);
         AngryBirdsBase.singleton.playThemeMusic();
         if(this.mTitleTF)
         {
            this.mTitleTF.text = this.mTournamentModel.tournamentPrettyName;
         }
         if(this.mTournamentModel)
         {
            this.mActiveCampaign = this.mTournamentModel.activateTournamentCampaign(this.mTournamentModel.brandedTournamentAssetId);
         }
         else
         {
            this.mActiveCampaign = null;
         }
         this.mUseWallet = true;
         if(this.mActiveCampaign)
         {
            this.mCampaignButton = this.getCampaignButtonFromBG();
            if(this.mCampaignButton)
            {
               this.mCampaignButton.addEventListener(MouseEvent.CLICK,this.cbOnCampaignButtonClicked);
               this.mUseWallet = false;
            }
            else
            {
               campaignUI = mUIView.getItemByName(CAMPAIGN_BUTTON_HOLDER);
               if(campaignUI)
               {
                  cls = AssetCache.getAssetFromCache(this.mActiveCampaign.campaignSprite,false);
                  if(cls)
                  {
                     campaignUI.mClip.removeChildren();
                     campaignUI.mClip.addChild(new cls());
                     campaignUI.setVisibility(true);
                     this.mUseWallet = false;
                  }
               }
            }
         }
         this.mShareButtonHolder = mUIView.getItemByName("share_button_holder");
         if(Boolean(this.mShareButtonHolder) && Boolean(this.mTournamentModel.shareButtonData))
         {
            shareBrandName = "SHARE_BUTTON_" + this.mTournamentModel.tournamentRules.brandedFrameLabel;
            cls = AssetCache.getAssetFromCache(shareBrandName,false);
            if(cls)
            {
               this.mShareButtonHolder.mClip.removeChildren();
               this.mShareButtonHolder.mClip.addChild(new cls());
               this.mShareButtonHolder.mClip.addEventListener(MouseEvent.CLICK,this.onShareButtonClicked,false,0,true);
            }
         }
         if(this.mUseWallet)
         {
            this.addWallet(new Wallet(this,true,true,false,true));
         }
         this.showTournamentEventInfoPopup();
         if(smActivateTournamentEventPopup && Boolean(smActivatedEventManager))
         {
            smActivatedEventManager.openEventPopup();
            smActivateTournamentEventPopup = false;
         }
         this.mUIScaledToFullScreenCounter = 0;
         this.mUIScaledToNormalCounter = 0;
      }
      
      private function showTournamentEventInfoPopup() : void
      {
         if(!smActivatedEventManager)
         {
            return;
         }
         if(DataModelFriends(AngryBirdsBase.singleton.dataModel).clientStorage.hasItemBeenSeen(smActivatedEventManager.ID))
         {
            return;
         }
         var popupOpened:Boolean = smActivatedEventManager.openInfoPopup();
         if(popupOpened)
         {
            SoundEngine.playSound("league_promotion_diamond",SoundEngine.DEFAULT_CHANNEL_NAME);
            DataModelFriends(AngryBirdsBase.singleton.dataModel).clientStorage.storeData(ClientStorage.SEEN_ITEMS_STORAGE_NAME,[smActivatedEventManager.ID]);
         }
      }
      
      private function cbOnCampaignButtonClicked(event:MouseEvent) : void
      {
         this.mTournamentModel.campaignClicked();
      }
      
      protected function getCampaignButtonFromBG() : SimpleButton
      {
         return null;
      }
      
      private function setTitleInfoTexts() : void
      {
         var uiComp:UIComponentRovio = mUIView.container.getItemByName("TextContainer");
         var titleTextContainer:MovieClip = MovieClip(uiComp.mClip.getChildByName(TEXT_CONTAINER_INSTANCE_NAME));
         this.mDaysLeftTF = TextField((titleTextContainer.getChildByName("DaysLeftTextfield") as DisplayObjectContainer).getChildByName("text"));
         this.mBannerInfoTF = TextField((titleTextContainer.getChildByName("Textfield_Banner_Info") as DisplayObjectContainer).getChildByName("text"));
         this.mTitleTF = TextField(titleTextContainer.getChildByName("Textfield_TournamentName"));
      }
      
      private function updateButtonPreviousResults() : void
      {
         var leagueModel:LeagueModel = LeagueModel.instance;
         var prevResult:Object = leagueModel.previousResult;
         var available:Boolean = Boolean(leagueModel.unconcludedResult) || prevResult && prevResult.t && prevResult.t.players.length > 0;
         if(available)
         {
            if(prevResult && prevResult.t && Boolean(prevResult.t.qualifier) && Boolean(prevResult.l) && prevResult.l.pli.tn == "QUALIFIER")
            {
               available = false;
            }
         }
         if(this.mPreviousResultButton)
         {
            if(available)
            {
               this.mPreviousResultButton.setEnabled(true);
               this.mPreviousResultButton.mClip.alpha = 1;
               this.mPreviousButtonVisibilitySet = true;
            }
            else
            {
               this.mPreviousResultButton.setEnabled(false);
               this.mPreviousResultButton.mClip.alpha = 0.5;
            }
         }
      }
      
      private function showPopups() : void
      {
         if(this.mTournamentModel.tournamentRules.tournamentResults)
         {
            this.showTournamentResultsPopup();
         }
         else
         {
            this.showTournamentResultsPopup();
         }
         var tournamentPopupId:String = FacebookUserProgress.BRANDED_TOURNAMENT_TUTORIAL + "_" + this.mTournamentModel.tournamentRules.tournamentName;
         if(this.mTournamentModel.tournamentRules.tournamentName == TournamentModel.STANDARD_TOURNAMENT_NAME)
         {
            tournamentPopupId = FacebookUserProgress.TOURNAMENT_TUTORIAL;
         }
      }
      
      override public function deActivate() : void
      {
         super.deActivate();
         if(this.pillar1)
         {
            this.pillar1.dispose();
         }
         if(this.pillar2)
         {
            this.pillar2.dispose();
         }
         if(this.pillar3)
         {
            this.pillar3.dispose();
         }
         this.mTournamentModel.removeEventListener(TournamentEvent.CURRENT_TOURNAMENT_INFO_INITIALIZED,this.onCurrentTournamentInfoLoaded);
         this.mTournamentModel.removeEventListener(TournamentEvent.CURRENT_TOURNAMENT_LEVEL_SCORES_LOADED,this.onCurrentTournamentScoreLoaded);
         this.mTournamentModel.removeEventListener(TournamentEvent.CURRENT_TOURNAMENT_STANDINGS_LOADED,this.onCurrentTournamentStandingsLoaded);
         this.mDailyRewardController.removeEventListener(SpinningWheelEvent.SPIN_REWARD_RECEIVED,this.cbOnSpinRewardReceived);
         this.mDailyRewardController.removeEventListener(SpinningWheelEvent.NEW_SPIN_AVAILABLE,this.cbOnNewSpinAvailable);
         this.mPreviousButtonVisibilitySet = false;
         this.mTournamentModel.removeEventListener(TournamentEvent.TOURNAMENT_RELOAD,this.onTournamentReloaded);
         this.mLevelNames = this.mTournamentModel.levelIDs;
         mLevelManager.resetPreviousLevel();
         if(this.mActiveCampaign)
         {
            mUIView.getItemByName(CAMPAIGN_BUTTON_HOLDER).setVisibility(false);
            if(this.mCampaignButton)
            {
               this.mCampaignButton.removeEventListener(MouseEvent.CLICK,this.cbOnCampaignButtonClicked);
            }
         }
         smActivatedEventManager = null;
         this.removeWallet(this.mWallet);
      }
      
      private function updateScoreData() : void
      {
         var you:Object = null;
         var player:Object = null;
         var friendData:CachedFriendDataVO = null;
         var scoreVO:UserTournamentScoreVO = null;
         var yourId:String = null;
         var yourFriendData:CachedFriendDataVO = null;
         var yourName:String = null;
         var levelsTotalScore:int = 0;
         var i:int = 0;
         this.mTimeAtDataInject = getTimer();
         var scoreData:Array = [];
         this.mPlayers = [];
         var tournamentPlayingFriends:Array = this.mTournamentModel.getTournamentPlayingFriends();
         CachedFacebookFriends.challengeCandidates = new Vector.<UserTournamentScoreVO>();
         var lowestCoinReward:int = 0;
         for each(player in tournamentPlayingFriends)
         {
            friendData = FriendsDataCache.getFriendData(player.uid);
            if(friendData)
            {
               if(friendData.name)
               {
                  player.n = friendData.name;
               }
            }
            if(player.n == null)
            {
               player.n = "";
            }
            if(player.uid == (AngryBirdsBase.singleton.dataModel.userProgress as FacebookUserProgress).userID)
            {
               you = player;
            }
            if(player.c)
            {
               lowestCoinReward = int(player.c);
            }
            else
            {
               player.c = lowestCoinReward;
            }
            scoreVO = UserTournamentScoreVO.fromServerObject(player);
            if(scoreVO.canBeChallenged)
            {
               if(CachedFacebookFriends.challengedIDs.indexOf(scoreVO.userId) == -1)
               {
                  CachedFacebookFriends.challengeCandidates.push(scoreVO);
               }
            }
            else
            {
               scoreData.push(scoreVO);
            }
            this.mPlayers.push(scoreVO);
         }
         if(you == null)
         {
            yourId = (AngryBirdsBase.singleton.dataModel.userProgress as FacebookUserProgress).userID;
            yourFriendData = FriendsDataCache.getFriendData(yourId);
            yourName = !!yourFriendData ? yourFriendData.name : "You";
            you = {
               "r":tournamentPlayingFriends.length + 1,
               "uid":yourId,
               "n":yourName
            };
            levelsTotalScore = 0;
            for(i = 0; i < this.mLevelNames.length; i++)
            {
               levelsTotalScore += FacebookUserProgress(AngryBirdsBase.singleton.dataModel.userProgress).getTournamentScoreForLevel(this.mLevelNames[i]);
            }
            you.p = levelsTotalScore;
            this.mPlayers.push(UserTournamentScoreVO.fromServerObject(you));
            scoreData.push(UserTournamentScoreVO.fromServerObject(you));
         }
         if(OpenGraphData.getObjectId(OpenGraphData.CHALLENGE_TO_TOURNAMENT))
         {
            for(i = 0; i < scoreData.length; i++)
            {
               scoreData[i].rank = i + 1;
            }
         }
         (AngryBirdsEngine.smApp as AngryBirdsFacebook).setFriendsBarData(FriendsBar.SCORE_LIST_TYPE_TOURNAMENT,scoreData);
         QualifierInterruptedPopUp.setFriendsData(scoreData);
         this.updateTimeLeft();
         this.updateInfoText();
		 this.updateStarPillars(you.r);
      }
      
      protected function updateInfoText() : void
      {
         var displayInfoBanner:* = this.mTournamentModel.info.length > 0;
         mUIView.getItemByName("Banner_Info").setVisibility(displayInfoBanner);
         this.mBannerInfoTF.visible = displayInfoBanner;
         this.mBannerInfoTF.text = this.mTournamentModel.info;
      }
      
      private function addChallengePlates(scoreData:Array) : void
      {
         var playingFriend:CachedFriendDataVO = null;
         var found:Boolean = false;
         var tournamentFriend:UserTournamentScoreVO = null;
         var foundUserID:String = null;
         var foundUserName:String = null;
         var allPlayingFriends:Vector.<CachedFriendDataVO> = FriendsDataCache.getPlayingFriendsOnly();
         for each(playingFriend in allPlayingFriends)
         {
            found = false;
            for each(tournamentFriend in this.mPlayers)
            {
               if(playingFriend.userID == tournamentFriend.userId)
               {
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               foundUserID = "";
               if(playingFriend.userID)
               {
                  foundUserID = playingFriend.userID;
               }
               foundUserName = "";
               if(playingFriend.name)
               {
                  foundUserName = playingFriend.name;
               }
               scoreData.push(new ChallengeVO(foundUserID,foundUserName,"",!ExceptionUserIDsManager.instance.canSendChallengeRequestTo(foundUserID)));
            }
         }
      }
      
      protected function setLevelButtons() : void
      {
         var button:UIButtonRovio = null;
         this.mLevelButtons = new Vector.<TournamentLevelButton>();
         this.mLevelNames = this.mTournamentModel.levelIDs;
         var buttonCoordinates:Object = this.getButtonCoordinates();
         for(var i:int = 0; i < 6; i++)
         {
            button = UIButtonRovio(mUIView.getItemByName("LevelButton" + (i + 1)));
            if(i < this.mLevelNames.length)
            {
               button.mClip.TextField_LevelNum.text.text = i + 1 + "";
               button.visible = true;
               /* button.x = buttonCoordinates.buttonGap * (i + 1);
               button.y = buttonCoordinates.buttonY; */
               this.mLevelButtons.push(this.makeLevelButton(i + 1,this.mTournamentModel.levelObjects[i],button));
            }
            else
            {
               button.visible = false;
            }
         }
      }
      
      private function getButtonCoordinates() : Object
      {
         var obj:Object = new Object();
         obj.buttonGap = AngryBirdsEngine.getCurrentScreenWidth() / 7;
         obj.buttonY = AngryBirdsEngine.getCurrentScreenHeight() >> 1;
         obj.centerX = AngryBirdsEngine.getCurrentScreenWidth() >> 1;
         return obj;
      }
      
      protected function makeLevelButton(levelNumber:int, levelObject:Object, uiButton:UIButtonRovio) : TournamentLevelButton
      {
         return new TournamentLevelButton(levelNumber,levelObject,this,uiButton,this.mTournamentModel,dataModel.shopListing,dataModel.virtualCurrencyModel,FacebookUserProgress(dataModel.userProgress));
      }
      
      private function getTournamentVOByRank(rank:int) : UserTournamentScoreVO
      {
         var player:FriendListItemVO = null;
         if(rank <= this.mPlayers.length)
         {
            player = this.mPlayers[rank - 1];
            if(player is UserTournamentScoreVO)
            {
               (player as UserTournamentScoreVO).rank = rank;
               return player as UserTournamentScoreVO;
            }
         }
         return null;
      }
      
      private function updateStarPillars(rank:int) : void
      {
         var players:int = int(this.mPlayers.length);
         if(players == 1)
         {
            this.addPillar1(null);
            this.addPillar2(this.getTournamentVOByRank(rank));
            this.addPillar3(null);
         }
         else if(players == 2)
         {
            this.addPillar1(this.getTournamentVOByRank(1));
            this.addPillar2(this.getTournamentVOByRank(2));
            this.addPillar3(null);
         }
         else
         {
            if(players <= 2)
            {
               throw new Error("No players in the array!");
            }
            if(rank >= 3)
            {
               this.addPillar1(this.getTournamentVOByRank(1));
               this.addPillar2(this.getTournamentVOByRank(rank - 1));
               this.addPillar3(this.getTournamentVOByRank(rank));
               if(rank >= 4)
               {
                  if(this.pillar2)
                  {
                     this.pillar2.x = STARPILLAR_NO_GAP; // STARPILLAR_EXTRA_GAP;
                  }
                  if(this.pillar3)
                  {
                     this.pillar3.x = STARPILLAR_NO_GAP; // STARPILLAR_EXTRA_GAP;
                  }
               }
               else
               {
                  if(this.pillar2)
                  {
                     this.pillar2.x = STARPILLAR_NO_GAP;
                  }
                  if(this.pillar3)
                  {
                     this.pillar3.x = STARPILLAR_NO_GAP;
                  }
               }
            }
            else
            {
               this.addPillar1(this.getTournamentVOByRank(1));
               this.addPillar2(this.getTournamentVOByRank(2));
               this.addPillar3(this.getTournamentVOByRank(3));
            }
         }
      }
      
      override protected function onUIInteraction(eventIndex:int, eventName:String, component:UIEventListenerRovio) : void
      {
         switch(eventName)
         {
            case "BACK":
               SoundEngine.playSound("Menu_Back",SoundEngine.UI_CHANNEL);
               setNextState(StateFacebookMainMenuSelection.STATE_NAME);
               break;
            case "SPINNING_WHEEL":
               SoundEngine.playSound("Menu_Confirm",SoundEngine.UI_CHANNEL);
               this.mDailyRewardController.showSpinningWheel();
               FacebookAnalyticsCollector.getInstance().trackDailySpinUIAction(FacebookAnalyticsCollector.DAILY_SPIN_USER_ACTION_SPIN_ICON_CLICKED);
               break;
            case "PREVIOUS_RESULTS":
               SoundEngine.playSound("Menu_Confirm",SoundEngine.UI_CHANNEL);
               if(!LeagueModel.instance.active)
               {
                  setNextState(StateLastWeeksTournamentResults.STATE_NAME);
               }
               else
               {
                  StateTournamentResults.resultType = StateTournamentResults.PREVIOUS_WEEK;
                  setNextState(StateTournamentResults.STATE_NAME);
               }
               break;
            case "LEVEL_1":
               this.levelClicked(0);
               break;
            case "LEVEL_2":
               this.levelClicked(1);
               break;
            case "LEVEL_3":
               this.levelClicked(2);
               break;
            case "LEVEL_4":
               this.levelClicked(3);
               break;
            case "LEVEL_5":
               this.levelClicked(4);
               break;
            case "LEVEL_6":
               this.levelClicked(5);
               break;
            case "showCredits":
               setNextState(StateCredits.STATE_NAME);
               break;
            case "CUTSCENE_1":
            case "CUTSCENE_2":
            case "CUTSCENE_3":
            case "CUTSCENE_4":
            case "CUTSCENE_5":
               this.gotoCutsceneState(int(eventName.charAt(eventName.length - 1)));
               break;
            case "SPECIAL_STORE":
               SoundEngine.playSound("Menu_Confirm",SoundEngine.UI_CHANNEL);
               AngryBirdsBase.singleton.popupManager.openPopup(new TabbedShopPopup(PopupLayerIndexFacebook.NORMAL,PopupPriorityType.DEFAULT));
               break;
            case "CHALLENGE":
               SoundEngine.playSound("Menu_Confirm",SoundEngine.UI_CHANNEL);
               AngryBirdsBase.singleton.popupManager.openPopup(new com.angrybirds.popups.ChallengePopup(PopupLayerIndexFacebook.NORMAL,PopupPriorityType.DEFAULT));
               break;
            case "MORE_GAMES":
               SoundEngine.playSound("Menu_Confirm",SoundEngine.UI_CHANNEL);
               try
               {
                  AngryBirdsBase.singleton.exitFullScreen();
                  navigateToURL(new URLRequest("http://www.rovio.com/games"),"_blank");
               }
               catch(e:Error)
               {
               }
         }
         if(smActivatedEventManager)
         {
            smActivatedEventManager.onUIInteraction(eventName);
         }
         this.mTournamentModel.campaignUIInteractionEvent(eventName);
      }
      
      protected function levelClicked(levelIndex:int) : void
      {
         SoundEngine.playSound("Menu_Confirm",SoundEngine.UI_CHANNEL);
         var levelId:String = String(this.mLevelNames[levelIndex]);
         var levelObject:Object = this.mTournamentModel.levelObjects[levelIndex];
         var levelButton:TournamentLevelButton = this.mLevelButtons[levelIndex];
         if(this.mTournamentModel.isLevelOpen(levelId))
         {
            this.startLevel(levelId);
         }
         else if(levelButton.canPurchase && !this.mTournamentModel.levelBeingUnlocked)
         {
            levelButton.purchase();
         }
      }
      
      private function gotoCutsceneState(index:int) : void
      {
         var levelId:String = "";
         if(this.mTournamentModel.tournamentRules.tournamentName.indexOf("HALLOWEEN") != -1)
         {
            levelId = String(this.HALLOWEEN_LEVEL_IDS[index - 1]);
         }
         if(this.mTournamentModel.tournamentRules.tournamentName.indexOf("XMAS") != -1)
         {
            levelId = String(this.XMAS_LEVEL_IDS[index - 1]);
         }
         mLevelManager.loadLevel(mLevelManager.getValidLevelId(levelId.toLowerCase()));
         setNextState(StateTournamentCutScenePlain.STATE_NAME);
      }
      
      protected function startLevel(levelId:String) : void
      {
         mLevelManager.loadLevel(mLevelManager.getValidLevelId(levelId.toLowerCase()));
         setNextState(StateTournamentCutScene.STATE_NAME);
      }
      
      protected function updateTimeLeft() : void
      {
         var timeLeftPretty:Array = this.mTournamentModel.getTournamentTimeLeftAsPrettyString();
         this.mDaysLeftTF.text = timeLeftPretty[0] + " Left"; /* " left!"; */
         this.mDaysLeftTF.textColor = timeLeftPretty[1];
         timeLeftPretty = null;
      }
      
      override protected function update(deltaTime:Number) : void
      {
         var levelButton:TournamentLevelButton = null;
         var isLoadingCompleted:Boolean = false;
         super.update(deltaTime);
         if(this.mAnimateSpinningWheelNotifier)
         {
            this.mNotificationBounceStartTimer += deltaTime;
            if(this.mNotificationBounceStartTimer >= this.TIME_DELAY_TO_SHOW_SPIN_NOTIFIER_BOUNCE)
            {
               this.mAnimateSpinningWheelNotifier = false;
               this.animateSpinNotifier();
            }
         }
         if(smCheckTournamentEventButtonState)
         {
            if(smActivatedEventManager)
            {
               smActivatedEventManager.updateEventButtonState();
               smCheckTournamentEventButtonState = false;
               this.mUIScaledToFullScreenCounter = 0;
               this.mUIScaledToNormalCounter = 0;
            }
            else if(TournamentEventManager.instance.isEventActivated())
            {
               smActivatedEventManager = TournamentEventManager.instance.getActivatedEventManager();
               smActivatedEventManager.initEventButton(mUIView);
            }
         }
         if(!this.mPreviousButtonVisibilitySet)
         {
            this.updateButtonPreviousResults();
         }
         if(this.mLoadingSteps)
         {
            for each(isLoadingCompleted in this.mLoadingSteps)
            {
               if(!isLoadingCompleted)
               {
                  break;
               }
            }
            if(isLoadingCompleted)
            {
               this.mLoadingSteps = null;
               this.tournamentInfoLoadingComplete();
            }
         }
         this.updateTimeLeft();
         for each(levelButton in this.mLevelButtons)
         {
            levelButton.update();
         }
         if(this.mRemoveLoadingScreenOnNextLoop)
         {
            this.displayLoadingText(false);
            (AngryBirdsEngine.smApp as AngryBirdsFacebook).setVisibleButtonFriendsBar(FriendsBar.SIDEBAR_BUTTON_STATE_INFO);
            this.mRemoveLoadingScreenOnNextLoop = false;
         }
         if(this.mPreviousScreenWidth != AngryBirdsEngine.getCurrentScreenWidth())
         {
            this.mUIScaledToFullScreenCounter = 0;
            this.mUIScaledToNormalCounter = 0;
            this.mPreviousScreenWidth = AngryBirdsEngine.getCurrentScreenWidth();
         }
      }
      
      private function updateCutSceneButtons() : void
      {
         var currentWeek:int = 0;
         var isLastLevelCompleted:* = false;
         var levelId:String = null;
         var cutSceneButton:UIButtonRovio = null;
         var isCutSceneAvailable:Boolean = false;
         if(this.mTournamentModel.levelIDs.length > 0)
         {
            currentWeek = this.getCurrentXmasWeek();
            if(mUIView.getItemByName("TournamentCutsceneSelection"))
            {
               mUIView.getItemByName("TournamentCutsceneSelection").setVisibility(currentWeek > 1 && currentWeek <= 4);
            }
            isLastLevelCompleted = (AngryBirdsBase.singleton.dataModel.userProgress as FacebookUserProgress).getTournamentScoreForLevel(this.XMAS_LEVEL_IDS[3]) > 0;
            mCutscenesAvailability[1] = currentWeek >= 3;
            mCutscenesAvailability[2] = currentWeek >= 4;
            mCutscenesAvailability[3] = currentWeek >= 4 && isLastLevelCompleted;
         }
         if(!this.mTournamentModel.tournamentRules)
         {
            return;
         }
         for(var i:int = 0; i < this.XMAS_LEVEL_IDS.length; i++)
         {
            levelId = "";
            if(this.mTournamentModel.tournamentRules.tournamentName.indexOf("XMAS") != -1)
            {
               levelId = String(this.XMAS_LEVEL_IDS[i]);
            }
            cutSceneButton = mUIView.getItemByName("CutsceneButton" + int(i + 1)) as UIButtonRovio;
            if(cutSceneButton)
            {
               isCutSceneAvailable = isCutsceneAvailable(i + 1);
               if(isCutSceneAvailable)
               {
                  cutSceneButton.setComponentState(UIComponentInteractiveRovio.COMPONENT_STATE_ACTIVE_DEFAULT);
               }
               else
               {
                  cutSceneButton.setComponentState(UIComponentInteractiveRovio.COMPONENT_STATE_DISABLED);
                  cutSceneButton.setComponentVisualState(UIComponentInteractiveRovio.COMPONENT_STATE_ACTIVE_DEFAULT);
               }
            }
         }
      }
      
      private function getCurrentXmasWeek() : int
      {
         var currentWeek:int = 1;
         switch(this.mTournamentModel.levelIDs[0])
         {
            case this.XMAS_LEVEL_IDS[0]:
               currentWeek = 2;
               break;
            case this.XMAS_LEVEL_IDS[1]:
               currentWeek = 3;
               break;
            case this.XMAS_LEVEL_IDS[2]:
            case this.XMAS_LEVEL_IDS[3]:
               currentWeek = 4;
         }
         return currentWeek;
      }
      
      protected function showErrorPopup(type:String) : void
      {
         var popup:ErrorPopup = new ErrorPopup(PopupLayerIndexFacebook.ALERT,PopupPriorityType.TOP,type);
         AngryBirdsBase.singleton.popupManager.openPopup(popup);
      }
      
      protected function showTournamentResultsPopup(type:String = null) : void
      {
         var popup:TournamentResultsPopup = new TournamentResultsPopup(PopupLayerIndexFacebook.NORMAL,PopupPriorityType.TOP,false);
         AngryBirdsBase.singleton.popupManager.openPopup(popup);
      }
      
      public function getName() : String
      {
         return STATE_NAME;
      }
      
      override protected function updateUIScale() : void
      {
         var buttonCoordinates:Object = null;
         var i:int = 0;
         var buttonX:Number = NaN;
         var buttonSpace:int = 0;
         var levelButton:UIButtonRovio = null;
         if(!this.mLevelNames || this.mLevelNames.length == 0 || this.mUseWallet && !this.mWallet)
         {
            return;
         }
         if((AngryBirdsEngine.smApp as AngryBirdsFacebook).isFullScreenMode())
         {
            if(this.mUIScaledToFullScreenCounter < UPDATE_ROUNDS_TO_SCALE_UI)
            {
               this.mUIScaledToNormalCounter = 0;
               if(this.mWallet)
               {
                  this.mWallet.walletClip.scaleX = StateFacebookMainMenuSelection.SCALE_LEVEL_BUTTONS_IN_FULL_SCREEN;
                  this.mWallet.walletClip.scaleY = StateFacebookMainMenuSelection.SCALE_LEVEL_BUTTONS_IN_FULL_SCREEN;
               }
               buttonCoordinates = this.getButtonCoordinates();
               for(i = 1; i <= this.mLevelNames.length; i++)
               {
                  levelButton = mUIView.getItemByName("LevelButton" + i) as UIButtonRovio;
                  /* levelButton.scaleX = StateFacebookMainMenuSelection.SCALE_LEVEL_BUTTONS_IN_FULL_SCREEN;
                  levelButton.scaleY = StateFacebookMainMenuSelection.SCALE_LEVEL_BUTTONS_IN_FULL_SCREEN;
                  levelButton.x = buttonCoordinates.buttonGap * i;
                  levelButton.y = buttonCoordinates.buttonY; */
               }
               buttonX = Number(buttonCoordinates.centerX);
               if(smActivatedEventManager)
               {
                  // commented for podium implementation
                  /* if(this.mChallengeButton)
                  {
                     buttonX = buttonCoordinates.centerX - buttonCoordinates.buttonGap;
                  }
                  smActivatedEventManager.updateEventButtonUIScale(buttonX,buttonCoordinates.buttonY + (this.mSpinButton.y - buttonCoordinates.buttonY) / 2);
                  buttonX = buttonCoordinates.centerX + buttonCoordinates.buttonGap; */
               }
               if(this.mChallengeButton)
               {
                  this.mChallengeButton.x = buttonX;
                  this.mChallengeButton.y = buttonCoordinates.buttonY + (this.mSpinButton.y - buttonCoordinates.buttonY) / 2;
               }
               if(this.mShareButtonHolder)
               {
                  this.mShareButtonHolder.mClip.visible = true;
                  this.mShareButtonHolder.x = AngryBirdsEngine.getCurrentScreenWidth() >> 1;
                  this.mShareButtonHolder.y = buttonCoordinates.buttonY + (this.mSpinButton.y - buttonCoordinates.buttonY) / 2;
               }
               buttonSpace = mUIView.getItemByName("Button_PreviousResults").x - mUIView.getItemByName("Button_Back").x;
               
               // commented and added for podium implementation
               // this.mSpinButton.x = mUIView.getItemByName("Button_Back").x + buttonSpace / 3;
               // this.mMoreGamesButton.x = mUIView.getItemByName("Button_Back").x + buttonSpace / 3 * 2;
               this.mSpinButton.x = mUIView.getItemByName("Button_PreviousResults").x + buttonSpace / -8;
               
               ++this.mUIScaledToFullScreenCounter;
            }
         }
         else if(this.mUIScaledToNormalCounter < UPDATE_ROUNDS_TO_SCALE_UI)
         {
            this.mUIScaledToFullScreenCounter = 0;
            if(this.mWallet)
            {
               this.mWallet.walletClip.scaleX = 1;
               this.mWallet.walletClip.scaleY = 1;
            }
            buttonCoordinates = this.getButtonCoordinates();
            for(i = 1; i <= this.mLevelNames.length; i++)
            {
               levelButton = mUIView.getItemByName("LevelButton" + i) as UIButtonRovio;
               /* levelButton.scaleX = 1;
               levelButton.scaleY = 1;
               levelButton.x = buttonCoordinates.buttonGap * i;
               levelButton.y = buttonCoordinates.buttonY; */
            }
            buttonX = Number(buttonCoordinates.centerX);
            if(smActivatedEventManager)
            {
               // commented for podium implementation
               /* if(this.mChallengeButton)
               {
                  buttonX = buttonCoordinates.centerX - buttonCoordinates.buttonGap;
               }
               smActivatedEventManager.updateEventButtonUIScale(buttonX,buttonCoordinates.buttonY + (this.mSpinButton.y - buttonCoordinates.buttonY) / 2);
               buttonX = buttonCoordinates.centerX + buttonCoordinates.buttonGap; */
            }
            if(this.mChallengeButton)
            {
               this.mChallengeButton.x = buttonX;
               this.mChallengeButton.y = buttonCoordinates.buttonY + (this.mSpinButton.y - buttonCoordinates.buttonY) / 2;
            }
            if(this.mShareButtonHolder)
            {
               this.mShareButtonHolder.mClip.visible = true;
               this.mShareButtonHolder.x = AngryBirdsEngine.getCurrentScreenWidth() >> 1;
               this.mShareButtonHolder.y = buttonCoordinates.buttonY + (this.mSpinButton.y - buttonCoordinates.buttonY) / 2;
            }
            buttonSpace = mUIView.getItemByName("Button_PreviousResults").x - mUIView.getItemByName("Button_Back").x;
            
            // commented and added for podium implementation
            // this.mSpinButton.x = mUIView.getItemByName("Button_Back").x + buttonSpace / 3;
            // this.mMoreGamesButton.x = mUIView.getItemByName("Button_Back").x + buttonSpace / 3 * 2;
            this.mSpinButton.x = mUIView.getItemByName("Button_PreviousResults").x + buttonSpace / -8;
            
            ++this.mUIScaledToNormalCounter;
         }
      }
      
      protected function addPillar1(tournamentScoreVO:UserTournamentScoreVO) : void
      {
         if(tournamentScoreVO == null)
         {
            return;
         }
         this.pillar1 = new TournamentStarPillar(tournamentScoreVO,1,this.starPillarOwnDefinition,this.starPillarEnemyDefinition);
         mUIView.getItemByName("StarPillarPlaceHolder1").mClip.addChild(this.pillar1);
      }
      
      protected function addPillar2(tournamentScoreVO:UserTournamentScoreVO) : void
      {
         if(tournamentScoreVO == null)
         {
            return;
         }
         this.pillar2 = new TournamentStarPillar(tournamentScoreVO,2,this.starPillarOwnDefinition,this.starPillarEnemyDefinition);
         mUIView.getItemByName("StarPillarPlaceHolder2").mClip.addChild(this.pillar2);
      }
      
      protected function addPillar3(tournamentScoreVO:UserTournamentScoreVO) : void
      {
         if(tournamentScoreVO == null)
         {
            return;
         }
         this.pillar3 = new TournamentStarPillar(tournamentScoreVO,3,this.starPillarOwnDefinition,this.starPillarEnemyDefinition);
         mUIView.getItemByName("StarPillarPlaceHolder3").mClip.addChild(this.pillar3);
      }
      
      protected function get starPillarOwnDefinition() : String
      {
         return "StarpillarOwn";
      }
      
      protected function get starPillarEnemyDefinition() : String
      {
         return "StarpillarEnemy";
      }
      
      public static function numberFormat(number:*, maxDecimals:int = 2, forceDecimals:Boolean = false, siStyle:Boolean = false) : String
      {
         var j:int = 0;
         var i:int = 0;
         var inc:Number = Math.pow(10,maxDecimals);
         var str:String = String(Math.round(inc * Number(number)) / inc);
         var sep:int = !!(hasSep = str.indexOf(".") == -1) ? int(str.length) : int(str.indexOf("."));
         var ret:* = (hasSep && !forceDecimals ? "" : (!!siStyle ? "," : ".")) + str.substr(sep + 1);
         if(forceDecimals)
         {
            for(j = 0; j <= maxDecimals - (str.length - (!!hasSep ? sep - 1 : sep)); ret += "0",j++)
            {
            }
         }
         while(i + 3 < (str.substr(0,1) == "-" ? sep - 1 : sep))
         {
            ret = (!!siStyle ? "." : ",") + str.substr(sep - (i = i + 3),3) + ret;
         }
         return str.substr(0,sep - i) + ret;
      }
      
      public function addWallet(wallet:Wallet) : void
      {
         this.mWallet = wallet;
      }
      
      public function removeWallet(wallet:Wallet) : void
      {
         if(this.mWallet)
         {
            wallet.dispose();
         }
         wallet = null;
      }
      
      public function get wallet() : Wallet
      {
         return this.mWallet;
      }
      
      public function get walletContainer() : Sprite
      {
         // commented and added for podium implementation
         // return mUIView.movieClip;
         return null;
      }
      
      protected function onShareButtonClicked(e:MouseEvent) : void
      {
         if(Boolean(this.mTournamentModel.shareButtonData) && Boolean(this.mTournamentModel.shareButtonData.url))
         {
            ExternalInterfaceHandler.performCall("shareURL",this.mTournamentModel.shareButtonData.url);
         }
      }
   }
}
