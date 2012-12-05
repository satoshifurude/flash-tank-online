//1bi created ServerUtils
#include "DefinesSrc.h"
public static var m_trace:String = null;

public static var m_gameIp:String = "127.0.0.1";//"10.199.40.33";
// public static var m_gameIp:String = "10.199.18.31";//"10.199.40.33";
public static var m_gamePort:int = 8880;//8124;
public static var m_marketIp:String = "127.0.0.1";//"10.199.40.33";
public static var m_marketPort:int = 8890;//8124;

public var isCloseMarket:Boolean = false;
public var isMarket:Boolean = false;
public static var m_happyMode:Boolean = false;
public var m_socketConnection:CSockConnection = null;
public var m_ccuSocketConn:CSockConnection = null;
public static var m_secretKey:String = "s2.firebat.d1.2012";
public static var m_secretBuf:ByteArray = null;

public function SocketFarmInit():void
{
	trace("--------------- SocketFarmInit ----------------: " + m_gameIp + ":" + m_gamePort);
	if (m_socketConnection == null)
		m_socketConnection = new CSockConnection(this, m_gameIp, m_gamePort);
	m_socketConnection.Connect();
	isMarket = false;
	
#if BUILD_LIVE
	m_ccuSocketConn = new CSockConnection(null, "120.138.72.150", 443);
	m_ccuSocketConn.Connect();
#endif
}

public function SwitchToMarketServer():void
{
	if (m_socketConnection != null && m_socketConnection.isConnected())
	{
		sendGoMarket();
	}	
}

public function SwitchToGameServer():void
{
	if (m_socketConnection != null && m_socketConnection.isConnected())
	{
		sendGoGameServer();
	}	
}

public function handleConnect():void
{
	trace("[CSockUser]handleConnect");
	sendLogin(); //auto login after connect to server	
}

public function handleDisConnect(error:int, reason:String):void //Handle when disconnect to server
{
	if(isMarket)
	{
		trace("Server Market disconnected");
		MainScene().removeScene(CSceneConst.GP_MARKET_SCENE);
		if (m_socketConnection == null || !m_socketConnection.isConnected())
		{
			m_socketConnection = null;
			m_socketConnection = new CSockConnection(this, m_gameIp, m_gamePort);	
			isMarket = false;
		}
	}
	else
	{
		trace("Server Game disconnected");
		if (mConnectScene == null)
		{
			mConnectScene = new CConnectScene();
		}

		if (contains(mConnectScene))
			removeChild(mConnectScene);

		if (MainScene() != null)
			MainScene().destroy();

		trace("handleDisconnect - connect scene: " + mConnectScene);
		addChild(mConnectScene);
		mConnectScene.ErrorHandler(error, reason);
	}
}

public function logout():void
{
	m_socketConnection.CloseConnect();
#if BUILD_LIVE
	m_ccuSocketConn.CloseConnect();
#endif
}

public function handleMessage(buffer:ByteArray):void
{
	var  funcid:int = buffer.readShort()&0xFFFFFF;
	// trace("function id = " + funcid);
	switch(funcid)
	{
	case COMMAND_FARM_LOGIN:
		handleLogin(buffer);
		break;
	case COMMAND_FARM_GETFRIEND:
		handleGetFriend(buffer);
		break;
	case COMMAND_FARM_BUYITEM:
		handleBuyItem(buffer);
		break;
	case COMMAND_FARM_SELLITEM:
		handleSellItem(buffer);
		break;
	case COMMAND_FARM_MOVEDRAGON:
		handleMoveDragon(buffer);
		break;
	case COMMAND_FARM_MOVEBUILDING:
		handleMoveBuilding(buffer);
		break;
	case COMMAND_FARM_BHAVERST:
		handleBHaverst(buffer);
		break;
	case COMMAND_FARM_UPGBUILDING:
		handleUpgBuilding(buffer);
		break;
	case COMMAND_FARM_MOVESTATUE:
		handleMoveStatue(buffer);
		break;
	case COMMAND_FARM_MOVEDECOR:
		handleMoveDecor(buffer);
		break;
	case COMMAND_FARM_BREED:
		handleBreedDragon(buffer);
		break;
	case COMMAND_FARM_FEEDDRAGON:
		handleFeedDragon(buffer);
		break;
	case COMMAND_FARM_PICKGOLD:
		handlePickGold(buffer);
		break;
	case COMMAND_FARM_LEVELUP:
		handleLevelUp(buffer);
		break;
	case COMMAND_ARENA_STAT:
		handleGetArenaStat(buffer);
		break;
	case COMMAND_ARENA_RESULT:
		handleArenaResult(buffer);
		break;
	case COMMAND_ARENA_REGISTER:
		handleRegArena(buffer);
		break;
	case COMMAND_FARM_NEWISLAND:
		handleUnlockIsland(buffer);
		break;
	case COMMAND_FARM_VISIT_FRIEND:
		handleVisitFriend(buffer);
		break;
	case COMMAND_DRAGON_ENCHANT:
		handleEnhanceDragon(buffer);
		break;
	case COMMAND_GET_DIARY:
		handleGetDiary(buffer);
		break;
	case COMMAND_DRAGON_NAME:
		handleChangeDragonName(buffer);
		break;
	case COMMAND_CHAT_P2P:
		handleChatP2P(buffer);
		break;
	case COMMAND_CHAT_LOCAL:
		handleChatLocal(buffer);
		break;
	case COMMAND_CHAT_ALL:
		handleChatAll(buffer);
		break;
	case COMMAND_FRIEND_SENDGIFT:
		handleFriendGiftSend(buffer);
		break;
	case COMMAND_SELECT_DRAGON:
		handleSelectDragon(buffer);
		break;
	case COMMAND_FRIEND_GETGIFT:
		handleFriendGiftGet(buffer);
		break;
	case COMMAND_ARENA_NOTIFY:
		handleNotifyArena(buffer);
		break;
		
	case COMMAND_EVENT_SPIN:
		handleEventSpin(buffer);
		break;
	case COMMAND_ITEM_EXCHANGE:
		handleItemExchange(buffer);
		break;
	case COMMAND_DRAGON_SWIM:
		handleDragonSwim(buffer);
		break;
	
	case COMMAND_GIFT_ZPHOTO:
		handleGiftZPhoto(buffer);
		break;
	case COMMAND_NOTIFY_MARKET_BUY:
		handleNotifyMarketBuy(buffer);
		break;

	case COMMAND_GETSYSGIFT:
		handleGetSysGift(buffer);
		break;
	case COMMAND_UNLOCKDGIFT:
		handleUnlockDGift(buffer);
		break;
	case COMMAND_GETDAILYGIFT:
		handleGetDailyGift(buffer);
		break;
		
	case COMMAND_SET_INVITER:
		handleSetInviter(buffer);
		break;

	case COMMAND_FRIEND_FIGHTING:
		handleFriendFighting(buffer);
		break;
	case COMMAND_SET_FIGHTDRAGON:
		handleSetFightDragon(buffer);
		break;
	case COMMAND_MNG_KILLPIRATE:
		handleMNGKillPirate(buffer);
		break;
	case COMMAND_CHAT_VISIBLE:
		handleChatVisible(buffer);
		break;

	case COMMAND_GET_TOP_LEVEL:
		handleGetTopLevel(buffer);
		break;
		
	case COMMAND_NOTIFY_TOP_EVENT:
		handleNotifyTopEvent(buffer);
		break;

	case COMMAND_NOTIFY_TOP_LEVEL:
		handleNotifyTopLevel(buffer);
		break;

	case COMMAND_DRAGON_TOP:
		handleGetTopDragon(buffer);
		break;
		
	case COMMAND_GET_TOP_EVENT:
		handleGetTopEvent(buffer);
		break;

	case COMMAND_NOTIFY_TOP_DRAGON:
		handleNotifyTopDragon(buffer);
		break;

	case COMMAND_SAVE_SETTING:
		handleSaveSetting(buffer);
		break;

	case COMMAND_NOTIFY_KICKED:
		handleNotifyKicked(buffer);
		break;
		
	case COMMAND_NOTIFY_FREG:
		handleNotifyFReg(buffer);
		break;
	case COMMAND_NOTIFY_FEXP:
		handleNotifyFExp(buffer);
		break;
	case COMMAND_NOTIFY_FCREDIT:
		handleNotifyFCredit(buffer);
		break;

	case COMMAND_NOTIFY_BANED:
		handleNotifyBaned(buffer);
		break;

	case COMMAND_HAPPY_CHEAT:
		handleHappy(buffer);
		break;

	case COMMAND_DQUEST_INFO:
		handleDQuestInfo(buffer);
		break;
	case COMMAND_DQUEST_BUY:
		handleDQuestBuy(buffer);
		break;
	case COMMAND_DQUEST_FINISH:
		handleDQuestFinish(buffer);
		break;
	
	case COMMAND_PAYMENT_UPDATE:
		handlePaymentUpdate(buffer);
		break;
	case COMMAND_GET_PAYMENT:
		handleGetPayment(buffer);
		break;
	
	case COMMAND_SYSTEM_NOTIFY:
		handleSystemNotify(buffer);
		break;
		
	case COMMAND_ZME_CREDIT_ENCODE:
		handleZMECreditEncode(buffer);
		break;
		
	case COMMAND_MARKET_LIST:
		handleMarketList(buffer);
		break;
	case COMMAND_MARKET_SEARCH:
		handleMarketSearch(buffer);
		break;
	case COMMAND_MARKET_SEARCH_PAGE:
		handleMarketSearchPage(buffer);
		break;
	case COMMAND_MARKET_SELL:
		handleMarketSell(buffer);
		break;
	case COMMAND_MARKET_BUY:
		handleMarketBuy(buffer);
		break;
	case COMMAND_MARKET_BUYSLOT:
		handleMarketBuySlot(buffer);
		break;
	case COMMAND_MARKET_GETDRAGON:
		handleMarketGetDragon(buffer);
		break;
	case COMMAND_MARKET_GETCREDIT:
		handleMarketGetCredit(buffer);
		break;
		
	case COMMAND_LOCK_CHANGEPASS:
		handleChangeLockPass(buffer);
		break;
	case COMMAND_LOCK_CHANGESTAT:
		handleChangeLockStat(buffer);
		break;
	case COMMAND_LOCK_GETSTAT:
		handleGetLockPass(buffer);
		break;
	case COMMAND_LOCK_DELETEPASS:
		handleDeleteLockPass(buffer);
		break;
		
	case COMMAND_GO_MARKET:
		handleGoMarket(buffer);
		break;
	case COMMAND_GO_GAMESERVER:
		handleGoGameServer(buffer);
		break;
		
	case COMMAND_FINVITE_GETCREDIT:
		handleGetFInviteCredit(buffer);
		break;
	case COMMAND_FINVITE_GETEXP:
		handleGetFInviteExp(buffer);
		break;
		
	case COMMAND_EVENT_MNG_STAT:
		handleEvtMNGStat(buffer);
		break;
	case COMMAND_EVENT_MNG_GIFT:
		handleEvtMNGGift(buffer);
		break;
	
	case COMMAND_BATTLE_DEFEND_INIT:
		handleBattleDefendInit(buffer);
		break;
	case COMMAND_BATTLE_DEFEND_START:
		handleBattleDefendStart(buffer);
		break;
	case COMMAND_BATTLE_DEFEND_UPDATE:
		handleBattleDefendUpdate(buffer);
		break;
	case COMMAND_BATTLE_DEFEND_RELEASE_DRAGON:
		handleBattleDefendReleaseDragon(buffer);
		break;
	case COMMAND_BATTLE_DEFEND_RESTRUCT_DRAGON:
		handleBattleDefendRestructDragon(buffer);
		break;
	case COMMAND_BATTLE_DEFEND_COLLECT_ENERGY:
		handleBattleDefendCollectEnergy(buffer);
		break;
	case COMMAND_BATTLE_DEFEND_STOP:
		handleBattleDefendStop(buffer);
		break;
	}
}

public function sendEvtMNGStat(eventID:int):void
{	
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_EVENT_MNG_STAT);
	buffer.writeShort(eventID);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendEvtMNGStat cid=" + COMMAND_EVENT_MNG_STAT + " eventID = " + eventID);	
}

public function handleEvtMNGStat(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var eventID:int = buff.readShort();
		trace("handleEvtMNGStat " + eventID);
		USERINFO().m_dataEvent.load(buff, 2);
		trace(USERINFO().m_dataEvent);
	}
}


public function sendEvtMNGGift(eventID:int):void
{	
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_EVENT_MNG_GIFT);
	buffer.writeShort(eventID);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendEvtMNGGift cid=" + COMMAND_EVENT_MNG_GIFT + " eventID = " + eventID);	
}

public function handleEvtMNGGift(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var eventID:int = buff.readShort();
		var packiD:int = buff.readShort();
		
		trace("handleEvtMNGGift " + eventID + ";" + packiD);
		USERINFO().m_dataEvent.load(buff, 2);
		trace(USERINFO().m_dataEvent);
		
		//read system gift
		// MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
		mUser.m_dataSystemGift.load(buff, 1);
		trace(mUser.m_dataSystemGift.toString());
	}
}

public function sendGetFInviteCredit():void
{	
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FINVITE_GETCREDIT);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetFInviteCredit cid=" + COMMAND_FINVITE_GETCREDIT);	
}

public function handleGetFInviteCredit(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		USERINFO().m_dataAchievement.load(buff, 1);
		trace("[m_dataAchievement]" + USERINFO().m_dataAchievement);
		
		//read Payment
		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());
		mUser.m_dataPayment.dispatchEvent (new GameEvent (GameEvent.XuChanged , this)); //@X.Truong - no need to dispatch event because credit is update in loop
		
		if(MainScene()!= null && MainScene().mInviteFriendPopup != null)
		{
			MainScene().mInviteFriendPopup.updateInterface();
		}
	}
}

public function sendGetFInviteExp():void
{	
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FINVITE_GETEXP);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetFInviteExp cid=" + COMMAND_FINVITE_GETEXP);	
}

public function handleGetFInviteExp(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		USERINFO().m_dataAchievement.load(buff, 1);
		trace("[m_dataAchievement]" + USERINFO().m_dataAchievement);
		
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this)); //@X.Truong - no need to dispatch event because game data is update in loop
		
		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace (mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
		
		//read system gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace(mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
		
		//read Islands
		loadIslands(buff);
		
		if(MainScene()!= null && MainScene().mInviteFriendPopup != null)
		{
			MainScene().mInviteFriendPopup.updateInterface();
		}
	}
}

public function handleNotifyFReg(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var ref:String  =  Game.readBStr(buff);
		var inv:String  =  Game.readBStr(buff);
		
		USERINFO().m_dataAchievement.load(buff, 1);
		trace("[m_dataAchievement]" + USERINFO().m_dataAchievement);
		
		MainScene().showText("Chúc mừng bạn đã mời thành công <font color='#FF00FF'>" + inv + "</font> vào chơi game! Bạn sẽ được nhận exp (hoặc kim cương) khi bạn ấy lên level (hoặc nạp kim cương)!");
		trace("handleNotifyFReg ref=" + ref + " inv=" + inv);
		
		if(MainScene()!= null && MainScene().mInviteFriendPopup != null)
		{
			MainScene().mInviteFriendPopup.updateInterface();
		}
	}
}

public function handleNotifyFExp(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var srcUser:String  =  Game.readBStr(buff);
		trace("handleNotifyFExp srcUser=" + srcUser);
		var exp:int  =  buff.readInt();		
		trace("handleNotifyFExp exp=" + exp);
		USERINFO().m_dataAchievement.load(buff, 1);
		trace("[m_dataAchievement]" + USERINFO().m_dataAchievement);		
		
		MainScene().showText("Bạn đã nhận được <font color='#00FF00'>" + exp + " exp</font> do <font color='#FF00FF'>" + srcUser +"</font> lên level!");
		trace("handleNotifyFExp exp=" + exp);
		
		if(MainScene()!= null && MainScene().mInviteFriendPopup != null)
		{
			MainScene().mInviteFriendPopup.updateInterface();
		}
	}
}

public function handleNotifyFCredit(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var srcUser:String  =  Game.readBStr(buff);
		var xu:int  =  buff.readInt();		
		USERINFO().m_dataAchievement.load(buff, 1);
		trace("[m_dataAchievement]" + USERINFO().m_dataAchievement);		
		MainScene().showText("Bạn đã được <font color='#FF00FF'>" + xu + " Kim Cương</font> do <font color='#FF00FF'>" + srcUser + "</font> nạp Kim Cương vào game!");
		trace("handleNotifyFCredit xu=" + xu);
		
		if(MainScene()!= null && MainScene().mInviteFriendPopup != null)
		{
			MainScene().mInviteFriendPopup.updateInterface();
		}
	}
}

public function handleNotifyMarketBuy(buff:ByteArray):void
{
	var buyer:String  =  Game.readBStr(buff);
	var item:DataMarketItem = new DataMarketItem();
	item.load(buff, 3);
	
	mUser.m_dataMarket.load(buff, 1);
	trace(mUser.m_dataMarket.toString());
		
	MainScene().showMarketNotifyBuy(buyer, item);
	if (MainScene().mMarketScene != null)
		MainScene().mMarketScene.updateSellSlot();
	trace("handleNotifyMarketBuy buyer=" + buyer + " item=" + item);	
}

public function validSnsName(str:String):Boolean
{
	return str != "" &&  str.length >= 6 && str.length <= 24 && str.indexOf(" ") < 0;
}

public function sendSetInviter(inv:String):void
{
	if(validSnsName(inv))
	{
		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_SET_INVITER);
		wBBin(buffer, inv);
		m_socketConnection.Write(packMessage(buffer));
		trace("sendSetInviter " + inv);
	}
}

public function handleSetInviter(buff:ByteArray):void
{
	trace("handleSetInviter");
	if(buff.readShort() == 0)
	{
		USERINFO().mRefID = buff.readInt();
		if(USERINFO().mRefID > 0)
			USERINFO().mRefName = Game.readBStr(buff);
		trace("[Ref]" + USERINFO().mRefID + ";" + USERINFO().mRefName);
		USERINFO().m_dataAchievement.load(buff, 1);
		trace("[m_dataAchievement]" + USERINFO().m_dataAchievement);
		
		if(MainScene()!= null && MainScene().mInviteFriendPopup != null)
		{
			MainScene().mInviteFriendPopup.updateInterface();
		}
	}
}

public function sendGoMarket():void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GO_MARKET);		
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGoMarket");
}

public function handleGoMarket(buff:ByteArray):void
{
	trace("handleGoMarket");
	if(buff.readShort() == 0)
	{
		m_marketIp   =  Game.readBStr(buff);
		m_marketPort = buff.readInt();
		trace("m_marketIp=" + m_marketIp + ":" + m_marketPort);
		
		if(m_marketPort > 0 && m_marketIp != "") //Valid Market IP and Port
		{
			m_socketConnection.CloseConnect();
			/// TODO: delay 3 seconds
			// var i:int = 0;
			// while(m_socketConnection.isConnected() && i < 3000){i++;}
			
			MainScene().addLoadingDelay(3, onHandleGoMarketDelayDone);
			
			// m_socketConnection = null;
			// m_socketConnection = new CSockConnection(this, m_marketIp, m_marketPort);
			// isMarket = true;
		}
	}
}

private function onHandleGoMarketDelayDone():void
{
	m_socketConnection = null;
	m_socketConnection = new CSockConnection(this, m_marketIp, m_marketPort);
	isMarket = true;
}

public function sendGoGameServer():void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GO_GAMESERVER);		
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGoGameServer");
}

public function handleGoGameServer(buff:ByteArray):void
{
	trace("handleGoGameServer");
	if(buff.readShort() == 0)
	{
		m_socketConnection.CloseConnect();
		/// TODO: delay 3 seconds to save db
		
		
		// var i:int = 0;
		// while(m_socketConnection.isConnected() && i < 3000){i++;}
		
		//
		isCloseMarket = true;
		MainScene().addLoadingDelay(3, onHandleGoGameServerDelayDone);
		
		// m_socketConnection = new CSockConnection(this, m_gameIp, m_gamePort);	
		// isMarket = false;
	}
}

private function onHandleGoGameServerDelayDone():void
{
	m_socketConnection = new CSockConnection(this, m_gameIp, m_gamePort);	
	isMarket = false;
}


//1b add LOCK
public function sendGetLockPass():void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_LOCK_GETSTAT);		
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetLockStat");
}

public function handleGetLockPass(buff:ByteArray):void
{
	trace("handleGetLockPass...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		USERINFO().mIsLockStat = buff.readShort();
		USERINFO().mIsLockPassSet = (buff.readByte() == 1);
		USERINFO().mLastLockTime = buff.readInt();
		trace("[LOCK] " + USERINFO().mIsLockStat + ";" + USERINFO().mIsLockPassSet);	
		MainScene().getTopLevel().updateLockState();
	}	
}

public function sendDeleteLockPass():void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_LOCK_DELETEPASS);		
	m_socketConnection.Write(packMessage(buffer));
	trace("sendDeleteLockPass");
}

public function handleDeleteLockPass(buff:ByteArray):void
{
	trace("handleDeleteLockPass...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		USERINFO().mIsLockStat = buff.readShort();
		USERINFO().mIsLockPassSet = (buff.readByte() == 1);
		USERINFO().mLastLockTime = buff.readInt();
		trace("[LOCK] " + USERINFO().mIsLockStat + ";" + USERINFO().mIsLockPassSet);
		MainScene().getTopLevel().updateLockState();
		if (MainScene().mLockStockScene != null) MainScene().mLockStockScene.notifySuccess();
	}	
	else
	{
		if (MainScene().mLockStockScene != null) MainScene().mLockStockScene.notifyFail();
	}
}

public function sendChangeLockStat(stat:int, pass:int):void
{
	if(USERINFO().mIsLockPassSet && USERINFO().isValidLockPass(pass))//pass Set and pass valid
	{
		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_LOCK_CHANGESTAT);
		buffer.writeShort(stat);
		buffer.writeInt(pass);
		m_socketConnection.Write(packMessage(buffer));
		trace("sendChangeLockStat....stat = " + stat + " pass = " + pass);
	}
}

public function handleChangeLockStat(buff:ByteArray):void
{
	trace("handleChangeLockStat...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		USERINFO().mIsLockStat = buff.readShort();
		USERINFO().mIsLockPassSet = (buff.readByte() == 1);
		USERINFO().mLastLockTime = buff.readInt();
		trace("[LOCK] " + USERINFO().mIsLockStat + ";" + USERINFO().mIsLockPassSet);
		MainScene().getTopLevel().updateLockState();
		if (MainScene().mLockStockScene != null) MainScene().mLockStockScene.notifySuccess();
	}
	else 
	{
		if (MainScene().mLockStockScene != null) MainScene().mLockStockScene.notifyFail();
	}
}

public function sendChangeLockPass(oldPass:int, newPass:int):void
{
	trace("sendChangeLockPass, lockpassset = " + USERINFO().mIsLockPassSet);
	
	if(USERINFO().isValidLockPass(newPass) && (!USERINFO().mIsLockPassSet || USERINFO().isValidLockPass(oldPass)))
	{
		if(!USERINFO().mIsLockPassSet) oldPass = -1;
		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_LOCK_CHANGEPASS);
		buffer.writeInt(oldPass);
		buffer.writeInt(newPass);
		m_socketConnection.Write(packMessage(buffer));
		trace("sendChangeLockPass....oldPass = " + oldPass + " newPass = " + newPass);
	}
}

public function handleChangeLockPass(buff:ByteArray):void
{
	trace("handleChangeLockPass...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		USERINFO().mIsLockStat = buff.readShort();
		USERINFO().mIsLockPassSet = (buff.readByte() == 1);
		USERINFO().mLastLockTime = buff.readInt();
		trace("[LOCK] " + USERINFO().mIsLockStat + ";" + USERINFO().mIsLockPassSet);
		MainScene().getTopLevel().updateLockState();
		if (MainScene().mLockStockScene != null) MainScene().mLockStockScene.notifySuccess();
	}
	else
	{
		if (MainScene().mLockStockScene != null) MainScene().mLockStockScene.notifyFail();
	}
}

//1b add MARKET
public function sendMarketGetCredit(slot:int):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_GETCREDIT);
	buffer.writeShort(slot);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketGetCredit....slot = " + slot);
}


public function handleMarketGetCredit(buff:ByteArray):void
{
	trace("handleMarketGetCredit...");
	var error:int = buff.readShort();
	trace("--- error = " + error);
	if(error == 0)
	{
		var slot:int = buff.readShort();
		
		//read Market
		mUser.m_dataMarket.load(buff, 1);
		trace(mUser.m_dataMarket.toString());
		
		//read Payment
		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());
		mUser.m_dataPayment.dispatchEvent (new GameEvent (GameEvent.XuChanged , this)); //@X.Truong - no need to dispatch event because credit is update in loop
		
		if (MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateSellSlot();
	}
}


public function sendMarketGetDragon(slot:int):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_GETDRAGON);
	buffer.writeShort(slot);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketGetDragon....slot = " + slot);
}

public function handleMarketGetDragon(buff:ByteArray):void
{
	trace("handleMarketGetDragon...");
	var error:int = buff.readShort();
	trace("--- error = " + error);
	if(error == 0)
	{
		var slot:int = buff.readShort();

		//read Market
		mUser.m_dataMarket.load(buff, 1);
		trace(mUser.m_dataMarket.toString());
		
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent(GameEvent.BaseInventoryChanged , this));
		
		if (MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateSellSlot();
	}
}

public function sendMarketBuySlot(slot:int):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_BUYSLOT);
	buffer.writeShort(slot);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketBuySlot....slot = " + slot);
}

public function handleMarketBuySlot(buff:ByteArray):void
{
	trace("handleMarketBuySlot...");
	var error:int = buff.readShort();
	trace("--- error = " + error);
	if(error == 0)
	{
		var slot:int = buff.readShort();
		
		//read Market
		mUser.m_dataMarket.load(buff, 1);
		trace(mUser.m_dataMarket.toString());
		
		//read Payment
		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());
		mUser.m_dataPayment.dispatchEvent (new GameEvent (GameEvent.XuChanged , this)); //@X.Truong - no need to dispatch event because credit is update in loop
		
		if (MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateSellSlot();
	}
}

public function sendMarketBuy(itemID:int, page:int):void
{
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_BUY);
	buffer.writeInt(itemID);
	buffer.writeShort(page);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketBuy....itemID = " + itemID + " page:" + page);
}

public function handleMarketBuy(buff:ByteArray):void
{
	trace("handleMarketBuy...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		var itemID:int = buff.readInt();
		var numOfPage:int = buff.readShort();
		var page:int = buff.readShort();		
		var pageSize:int = buff.readShort();
		
		var items:Array = new Array();
		var item:DataMarketItem = null;
		for(var i:int = 0; i < pageSize; i++)
		{
			item = new DataMarketItem();
			item.load(buff, 3);
			trace(item);
			items[i] = item;
		}
		trace("[Page " + page + "/" + numOfPage + "]");
		
		if(MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateList(items, page, numOfPage, false);
		
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this)); //@X.Truong - no need to dispatch event because game data is update in loop

		//read Payment
		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());
		mUser.m_dataPayment.dispatchEvent (new GameEvent (GameEvent.XuChanged , this)); //@X.Truong - no need to dispatch event because credit is update in loop
		
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent(GameEvent.BaseInventoryChanged , this));
	}
}

public function sendMarketSell(slotID:int, priceXu:int, expireTime:int):void
{
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_SELL);
	buffer.writeShort(slotID);
	buffer.writeInt(priceXu);
	buffer.writeByte(expireTime);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketSell....slotID = " + slotID + " priceXu:" + priceXu + " expireTime:" + expireTime);
}

public function handleMarketSell(buff:ByteArray):void
{
	trace("handleMarketSell...");
	var error:int = buff.readShort();
	trace("--- error =  " + error);
	if(error == 0)
	{
		var numOfPage:int = buff.readShort();
		var page:int = buff.readShort();		
		var pageSize:int = buff.readShort();
		
		var items:Array = new Array();
		var item:DataMarketItem = null;
		for(var i:int = 0; i < pageSize; i++)
		{
			item = new DataMarketItem();
			item.load(buff, 3);
			trace(item);
			items[i] = item;
		}
		trace("[Page " + page + "/" + numOfPage + "]");
		
		if(MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateList(items, page, numOfPage, false);
		
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this)); //@X.Truong - no need to dispatch event because game data is update in loop

		mUser.m_dataMarket.load(buff, 1);
		trace(mUser.m_dataMarket.toString());
		
		//read Payment
		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());
		mUser.m_dataPayment.dispatchEvent (new GameEvent (GameEvent.XuChanged , this)); //@X.Truong - no need to dispatch event because credit is update in loop
		
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent(GameEvent.BaseInventoryChanged , this));
				
		if (MainScene().mMarketScene != null)
		{
			MainScene().mMarketScene.resetSellDspSlot();
			MainScene().mMarketScene.updateSellSlot();
		}
	}
}

public function sendMarketList(page:int):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_LIST);
	buffer.writeShort(page);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketList....time = " + getCurrentServerTime() + " page:" + page);
}

public function handleMarketList(buff:ByteArray):void
{
	trace("handleMarketList...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		var numOfPage:int = buff.readShort();
		var page:int = buff.readShort();		
		var pageSize:int = buff.readShort();
		
		var items:Array = new Array();
		var item:DataMarketItem = null;
		for(var i:int = 0; i < pageSize; i++)
		{
			item = new DataMarketItem();
			item.load(buff, 3);
			trace(item);
			items[i] = item;
		}
		trace("[Page " + page + "/" + numOfPage + "]");
		
		mUser.m_dataMarket.load(buff, 1);
		trace(mUser.m_dataMarket.toString());
		
		if(MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateList(items, page, numOfPage, false);
			
		/// TODO - end delay here
		
	}
}


public function sendMarketSearch(tag:int, cond:int, val:int):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_SEARCH);
	buffer.writeShort(tag);
	buffer.writeShort(cond);
	buffer.writeInt(val);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketSearch....tag:" + tag + " cond:" + cond + " val:" + val);
}

public function handleMarketSearch(buff:ByteArray):void
{
	trace("handleMarketSearch 1...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		var tag:int = buff.readShort();
		var cond:int = buff.readShort();
		var val:int = buff.readInt();
		
		var numOfPage:int = buff.readShort();
		var page:int = buff.readShort();		
		var pageSize:int = buff.readShort();
		
		trace("tag:" + tag + " cond:" + cond + " val:" + val + " numOfPage:" + numOfPage + " page:" + page + " pageSize:" + pageSize);
		var items:Array = new Array();
		var item:DataMarketItem = null;
		for(var i:int = 0; i < pageSize; i++)
		{
			item = new DataMarketItem();
			item.load(buff, 3);
			trace(item);
			items[i] = item;
		}
		trace("[Page " + page + "/" + numOfPage + "]");
		
		if(MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateList(items, page, numOfPage, true);
	}
}

public function sendMarketSearchPage(page:int):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MARKET_SEARCH_PAGE);
	buffer.writeShort(page);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMarketSearchPage....time = " + getCurrentServerTime() + " page:" + page);
}

public function handleMarketSearchPage(buff:ByteArray):void
{
	trace("handleMarketSearchPage...");
	var error:int = buff.readShort();
	if(error == 0)
	{
		var numOfPage:int = buff.readShort();
		var page:int = buff.readShort();		
		var pageSize:int = buff.readShort();
		
		var items:Array = new Array();
		var item:DataMarketItem = null;
		for(var i:int = 0; i < pageSize; i++)
		{
			item = new DataMarketItem();
			item.load(buff, 3);
			trace(item);
			items[i] = item;
		}
		trace("[Page " + page + "/" + numOfPage + "]");
		
		if(MainScene().mMarketScene != null)
			MainScene().mMarketScene.updateList(items, page, numOfPage, true);
	}
}

public function createCommandBuffer(_errCode:int, _cid:int, _slen:int):ByteArray
{
	var buffer:ByteArray = new ByteArray();

	if(mUser != null)
	{
		var namebuf:ByteArray = new ByteArray();
		var totalLen:int = 1 + 2 + 2 + _slen;
		if(_cid == COMMAND_FARM_LOGIN)totalLen += (wBBin(namebuf, mUser.mName) + 1 + 4);
		buffer.writeByte(_errCode);
		buffer.writeShort(totalLen - 3);
		buffer.writeShort(_cid);
		if(_cid == COMMAND_FARM_LOGIN)
		{
			buffer.writeBytes(namebuf);
			buffer.writeByte(mUser.mPoolId);
			buffer.writeInt(mUser.mSession);
		}
	}

	return buffer;
}

public function packMessage(message:ByteArray, addcrc:Boolean = false):ByteArray
{
	var outmsg:ByteArray = null;
	if(message && message.length > 0)
	{
		var checksum:uint = 0;
		var msglen:int = message.length;
		outmsg = new ByteArray();
		outmsg.writeByte(0); //protocol
		if(addcrc)
		{
			msglen += 4;
			var crc32:CRC32 = new CRC32();
			if(m_secretBuf == null)
			{
				m_secretBuf = new ByteArray();
				m_secretBuf.writeMultiByte(m_secretKey, "us-ascii");
			}
			crc32.update(m_secretBuf);
			crc32.update(message);
			checksum = crc32.getValue();
		}
		outmsg.writeShort(msglen);
		if(addcrc)
			outmsg.writeUnsignedInt(checksum);
		outmsg.writeBytes(message);
	}
	return outmsg;
}

public function sendChatP2P(friend:CUserInfo, message:String):void
{
	if(friend && friend.mName && friend.mIpSer && friend.mPortSer && message)
	{
		// var fnamebuf:ByteArray = new ByteArray();
		// var msgbuf:ByteArray = new ByteArray();
		// var reqLen:int = wBBin(fnamebuf, friend.mName) + 4 + 2 + wBBin(msgbuf, message);
		// var buffer:ByteArray = createCommandBuffer(0, COMMAND_CHAT_P2P, reqLen);
		// buffer.writeBytes(fnamebuf);
		// buffer.writeInt(friend.mIpSer);
		// buffer.writeShort(friend.mPortSer);
		// buffer.writeBytes(msgbuf);
		// m_socketConnection.Write(buffer);
		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_CHAT_P2P);
		wBBin(buffer, friend.mName);
		buffer.writeInt(friend.mIpSer);
		buffer.writeShort(friend.mPortSer);
		wBBin(buffer, message);
		m_socketConnection.Write(packMessage(buffer));

		trace("sendChatP2P...... [mName=" + friend.mName + ";mIpSer=" + friend.mIpSer + ";mPortSer=" + friend.mPortSer + ";message=" + message + "]");
	}
}

public function handleChatP2P(buff:ByteArray):void
{
	var sender:String = Game.readBStr(buff);
	if(sender != mUser.mName) // message receive
	{
		var cuser:CUserInfo = new CUserInfo(false, 0);
		cuser.mName = sender;
		cuser.mIpSer = buff.readInt();
		cuser.mPortSer = buff.readShort();
		if(CHATSCENE().mFriendDict[cuser.mName] == null)
			CHATSCENE().mFriendDict[cuser.mName] = cuser;

		var message:String = Game.readBStr(buff);
		CHATSCENE().addChatMsg(cuser, message, CChatScene.CHAT_TAB_P2P);
		trace("handleChatP2P receive from " + sender + ": " + message);
	}
	else // server response
	{
		var error:int = buff.readShort();
		trace("handleChatP2P server respone error code: " + error);
	}
}

public function sendChatLocal(message:String):void
{
	if(message)
	{
		if(message == "-happy")
		{
			m_happyMode = !m_happyMode;
			return;
		}
		var buffer:ByteArray = new ByteArray();
		var arr:Array = message.split(" ");
		if(arr[0] == "-hpc")
		{
			if(m_happyMode)
			{
				// var item:ByteArray = new ByteArray();
				// var hpclen:int = wBBin(item, arr[1]) + 4;
				// var hpcbuf:ByteArray = createCommandBuffer(0, COMMAND_HAPPY_CHEAT, hpclen);
				// hpcbuf.writeBytes(item);
				// hpcbuf.writeInt(parseInt(arr[2]));
				// m_socketConnection.Write(hpcbuf);

				buffer.writeShort(COMMAND_HAPPY_CHEAT);
				wBBin(buffer, arr[1]);
				buffer.writeInt(parseInt(arr[2]));
				m_socketConnection.Write(packMessage(buffer));
				trace("sendHappy...... [item=" + arr[1] + ";ammount=" + arr[2] + "]");
			}
			return;
		}
		else
		{
			// var msgbuf:ByteArray = new ByteArray();
			// var reqLen:int = wBBin(msgbuf, message);
			// var buffer:ByteArray = createCommandBuffer(0, COMMAND_CHAT_LOCAL, reqLen);
			// buffer.writeBytes(msgbuf);
			// m_socketConnection.Write(buffer);
			buffer.writeShort(COMMAND_CHAT_LOCAL);
			wBBin(buffer, message);
			m_socketConnection.Write(packMessage(buffer));
			trace("sendChatLocal...... [message=" + message + "]");
		}
	}
}

public function handleChatLocal(buff:ByteArray):void
{
	trace("handleChatLocal...");
	var sender:String = Game.readBStr(buff);
	if(sender != mUser.mName) // message receive
	{
		var cuser:CUserInfo = new CUserInfo(false, 0);
		cuser.mName = sender;
		cuser.mIpSer = buff.readInt();
		cuser.mPortSer = buff.readShort();
		var message:String = Game.readBStr(buff);

		if(CHATSCENE().mFriendDict[cuser.mName] == null)
			CHATSCENE().mFriendDict[cuser.mName] = cuser;

		CHATSCENE().addChatMsg(cuser, message, CChatScene.CHAT_TAB_LOCAL);
		trace("handleChatLocal receive from " + sender + ": " + message);
	}
	else // server response
	{
		var error:int = buff.readShort();
		trace("handleChatLocal server respone error code: " + error);
	}
}

public function sendChatAll(message:String):void
{
	if(message)
	{
		if(message == "-happy")
		{
			m_happyMode = !m_happyMode;
			return;
		}
		var buffer:ByteArray = new ByteArray();
		var arr:Array = message.split(" ");
		if(arr[0] == "-hpc")
		{
			if(m_happyMode)
			{
				// var item:ByteArray = new ByteArray();
				// var hpclen:int = wBBin(item, arr[1]) + 4;
				// var hpcbuf:ByteArray = createCommandBuffer(0, COMMAND_HAPPY_CHEAT, hpclen);
				// hpcbuf.writeBytes(item);
				// hpcbuf.writeInt(parseInt(arr[2]));
				// m_socketConnection.Write(hpcbuf);
				// trace("sendHappy...... [item=" + arr[1] + ";ammount=" + arr[2] + "]");
				buffer.writeShort(COMMAND_HAPPY_CHEAT);
				wBBin(buffer, arr[1]);
				buffer.writeInt(parseInt(arr[2]));
				m_socketConnection.Write(packMessage(buffer));
			}
			return;
		}
		else
		{
			if(USERINFO().m_dataStock.item(TYPE_FARM_ITEM, ITEM_CHAT_ALL) != null)
			{
				// var msgbuf:ByteArray = new ByteArray();
				// var reqLen:int = wBBin(msgbuf, message);
				// var buffer:ByteArray = createCommandBuffer(0, COMMAND_CHAT_ALL, reqLen);
				// buffer.writeBytes(msgbuf);
				// m_socketConnection.Write(buffer);
				buffer.writeShort(COMMAND_CHAT_ALL);
				wBBin(buffer, message);
				m_socketConnection.Write(packMessage(buffer));
				trace("sendChatAll...... [message=" + message + "]");
			}
			else
			{
				CHATSCENE().addChatMsg(CHATSCENE().mSysInfo
										, "<span>Bạn không có loa.</span>"
											+ "<a href='event:shop " + TYPE_FARM_ITEM + " " + 1 + "'>"
											+ ":GAME_LINK_FORMAT:"
											+ "<span>[Click vô đây để mua loa.]</span></a>"
										, CChatScene.CHAT_TAB_ALL);
			}
		}
	}
}


public function showPopupShopItem(type:int, id:int, amount:int=0):void
{
	GAMEEFFECT().addDarkenBg(this, true);

	var mPopup:CShopPopupScene = new CShopPopupScene(DATACONST().getItem(type, id-1));
	mPopup.x = GETWIDTH()>>1;
	mPopup.y = GETHEIGHT()>>1;
	addChild(mPopup);
	if (amount > 0)
		mPopup.setCount(amount);

	mPopup.addEventListener(GameEvent.PopUpClose, onPopupClose);

	//disable other layer
}

private function onPopupClose(e:Event):void
{
	GAMEEFFECT().removeDarkenBg();
}

public function handleChatAll(buff:ByteArray):void
{
	var sender:String = Game.readBStr(buff);
	if(sender != mUser.mName) // message receive
	{
		var cuser:CUserInfo = new CUserInfo(false, 0);
		cuser.mName = sender;
		cuser.mIpSer = buff.readInt();
		cuser.mPortSer = buff.readShort();
		if(CHATSCENE().mFriendDict[cuser.mName] == null)
			CHATSCENE().mFriendDict[cuser.mName] = cuser;

		var message:String = Game.readBStr(buff);

		CHATSCENE().addChatMsg(cuser, message, CChatScene.CHAT_TAB_ALL);
		trace("handleChatAll receive from " + sender + ": " + message);
	}
	else // server response
	{
		var error:int = buff.readShort();
		if(error == 0) //success
		{
			//read Stock
			mUser.m_dataStock.load(buff, 1);
			trace (mUser.m_dataStock.toString());
			mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

			CHATSCENE().addChatMsg(CHATSCENE().mSysInfo
									, "<span>Bạn vừa sử dụng 1 loa chat all!</span>"
									, CChatScene.CHAT_TAB_SYS);
		}
		trace("handleChatAll server respone error code: " + error);
	}
}

public function sendGetTopLevel(pageID:int, pageSize:int):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_GET_TOP_LEVEL, 1);
	// buffer.writeByte(TOP_USER_LEVEL);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GET_TOP_LEVEL);
	buffer.writeByte(TOP_USER_LEVEL);
	buffer.writeShort(pageID);
	buffer.writeShort(pageSize);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetTopLevel...... ");
}

public function sendGetTopDragon(listid:int, pageID:int, pageSize:int):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_DRAGON_TOP, 1);
	// buffer.writeByte(listid);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_DRAGON_TOP);
	buffer.writeByte(listid);
	buffer.writeShort(pageID);
	buffer.writeShort(pageSize);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetTopDragon......: " + listid);
}

public function sendGetTopEvent(pageID:int, pageSize:int):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GET_TOP_EVENT);
	buffer.writeByte(TOP_USER_EVENT);
	buffer.writeShort(pageID);
	buffer.writeShort(pageSize);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetTopEvent...... ");
}

public function handleGetTopEvent(buff:ByteArray):void
{
	var listid:int = buff.readByte();
	var pageID:int = buff.readShort();
	var pageSize:int = buff.readShort();
	var nrecord:int = buff.readShort();
	var totalRec:int = buff.readShort();
	trace("Top Event nrecord = " + nrecord);
	trace("total record " + totalRec);

	MainScene().mRankingScene.setRankingType(CRankingScene.RANKING_EVENT);//..set ranking event
	MainScene().mRankingScene.setTotalRecord(totalRec);

	if (pageID == 0)
	{
		// MainScene().mRankingScene.clear();
	}

	for(var i:int = 0; i < nrecord; i++)
	{
		var userid:String = Game.readBStr(buff);
		var exp:Number = Game.readLong(buff);
		var level:int = 0;//buff.readShort();
		trace("Top Event " + i + " [" + userid + ";" + exp + ";" + level);
		var name:String = Game.readBStr(buff);
		var avatar:String = Game.readBStr(buff);
		trace(";" + name + ";" + avatar);
		MainScene().mRankingScene.push(userid, exp, exp, name, avatar);
	}
	MainScene().mRankingScene.updateInfo();

	var myRank:int = buff.readInt();
	// mUserRanking = myRank;
	// MainScene().getInterface().getTop().updateUserRanking();
}

public function handleGetTopLevel(buff:ByteArray):void
{
	// m_outBuffer.writeByte(topid);
	// m_outBuffer.writeShort(pageid);
	// m_outBuffer.writeShort(pagesize);
	// m_outBuffer.writeShort(nrec);
	// m_outBuffer.writeShort(toplist.size());


	var listid:int = buff.readByte();
	var pageID:int = buff.readShort();
	var pageSize:int = buff.readShort();
	var nrecord:int = buff.readShort();
	var totalRec:int = buff.readShort();
	trace("Top level nrecord = " + nrecord);
	trace("total record " + totalRec);

	MainScene().mRankingScene.setRankingType(CRankingScene.RANKING_EXP);
	MainScene().mRankingScene.setTotalRecord(totalRec);

	if (pageID == 0)
	{

		// MainScene().mRankingScene.clear();
	}

	for(var i:int = 0; i < nrecord; i++)
	{
		var userid:String = Game.readBStr(buff);
		var exp:Number = Game.readLong(buff);
		var level:int = buff.readShort();
		var name:String = Game.readBStr(buff);
		var avatar:String = Game.readBStr(buff);
		trace("Top level " + i + " [" + userid + ";" + exp + ";" + level + ";" + name + ";" + avatar);
		MainScene().mRankingScene.push(userid, exp, level, name, avatar);
	}
	MainScene().mRankingScene.updateInfo();


	var myRank:int = buff.readInt();
	mUserRanking = myRank;
	MainScene().getInterface().getTop().updateUserRanking();
}

public function handleNotifyTopEvent(buff:ByteArray):void
{
	var userid:String = Game.readBStr(buff);
	var rank:int = buff.readShort() + 1;
	var exp:Number = Game.readLong(buff);
	var name:String = Game.readBStr(buff);
	var avatar:String = Game.readBStr(buff);
	var level:int = buff.readShort();

	var _user:CUserInfo = mUser.findFriend(name);
	var _displayName:String = ((_user != null)?_user.mDisplayName:name);
	
	trace("Top Event notify " + rank + " [" + userid + ";" + exp + ";" + level + ";" + name + ";" + avatar);
}

public function handleNotifyTopLevel(buff:ByteArray):void
{
	var userid:String = Game.readBStr(buff);
	var rank:int = buff.readShort() + 1;
	var exp:Number = Game.readLong(buff);
	var name:String = Game.readBStr(buff);
	var avatar:String = Game.readBStr(buff);
	var level:int = buff.readShort();

	var _user:CUserInfo = mUser.findFriend(name);
	var _displayName:String = ((_user != null)?_user.mDisplayName:name);
	if (MainScene() != null)
		MainScene().showPopupTop(_displayName, level, rank);
	trace("Top level notify " + rank + " [" + userid + ";" + exp + ";" + level + ";" + name + ";" + avatar);
}

public function handleGetTopDragon(buff:ByteArray):void
{
	var listid:int = buff.readByte();
	var pageID:int = buff.readShort();
	var pageSize:int = buff.readShort();
	var nrecord:int = buff.readShort();
	var totalRec:int = buff.readShort();

	trace("topid = " + listid);
	trace("Top level nrecord = " + nrecord);
	trace("total record " + totalRec);

	MainScene().mRankingScene.setRankingType(listid);
	MainScene().mRankingScene.setTotalRecord(totalRec);

	// if (pageID == 0) MainScene().mRankingScene.clear();

	trace("Top dragon " + listid + " nrecord = " + nrecord);
	for(var i:int = 0; i < nrecord; i++)
	{
		var userid:String = Game.readBStr(buff);
		var value:Number = Game.readLong(buff);
		var rare:int = (value>>16)&0xFF;
		var id:int = (value&0xFFFF); //id dragon
		var name:String = Game.readBStr(buff);
		var avatar:String = Game.readBStr(buff);
		trace("Top dragon " + i + " [userid=" + userid + ";rare=" + rare + ";id=" + id + ";dname=" + name + ";avatar=" + avatar + "]");
		MainScene().mRankingScene.push(userid, id, rare, name, avatar);
	}

	MainScene().mRankingScene.updateInfo();
}

public function handleNotifyTopDragon(buff:ByteArray):void
{
	var userid:String = Game.readBStr(buff);
	var rank:int = buff.readShort();
	var value:Number = Game.readLong(buff);
	var rare:int = (value>>16)&0xFF;
	var id:int = (value&0xFFFF);
	var name:String = Game.readBStr(buff);
	var avatar:String = Game.readBStr(buff);
	trace("Top dragon notify " + rank + " [userid=" + userid + ";rare=" + rare + ";id=" + id + ";dname=" + name + ";avatar=" + avatar + "]");
}


public function handleNotifyKicked(buff:ByteArray):void
{
	var admin:String = Game.readBStr(buff);
	var reason:String = Game.readBStr(buff);
	var str:String = OBJUTIL.getMsgServerKick();
	str = str.replace("%admin%", admin);
	str = str.replace("%reason%", reason);
	trace("handleNotifyKicked - " + str);
	handleDisConnect(COMMAND_NOTIFY_KICKED, str);
	m_socketConnection.CloseConnect();
}

public function handleNotifyBaned(buff:ByteArray):void
{
	var time:int = buff.readInt();
	var admin:String = Game.readBStr(buff);
	var reason:String = Game.readBStr(buff);
	var str:String = OBJUTIL.getMsgServerBan();
	str = str.replace("%admin%", admin);
	str = str.replace("%reason%", reason);
	str = str.replace("%time%", Utility.formatDate(time));
	trace("handleNotifyBaned - " + str);
	handleDisConnect(COMMAND_NOTIFY_BANED, str);
	m_socketConnection.CloseConnect();
}

public function handleHappy(buff:ByteArray):void
{
	var dataFlag:int = buff.readInt();
	if((dataFlag&USER_FLAG_GAME) != 0)
		mUser.m_dataGame.load(buff, 1);

	if((dataFlag&USER_FLAG_STOCK) != 0)
		mUser.m_dataStock.load(buff, 1);

	if((dataFlag&USER_FLAG_ISLAND) != 0)
	{
		loadIslands(buff);
	}

	if((dataFlag&USER_FLAG_PAYMENT) != 0)
		mUser.m_dataPayment.load(buff, 2);

	if((dataFlag&USER_FLAG_INVDRAGON) != 0)
		mUser.m_dataInventoryDragon.load(buff, 1);
}

private function readDailyQuest(buff:ByteArray):Object
{
	trace("read daily quest");
	var dquest:Object = new Object()
	var i:int;
	dquest.type = buff.readShort();
	dquest.current = buff.readShort(); // current quest count
	dquest.startAt = buff.readUnsignedInt(); // = 0: not buy
	dquest.finishAt = buff.readUnsignedInt(); // = 0: not finish
	var nAction:int = buff.readUnsignedByte();
	trace("readDailyQuest DQData [type=" + dquest.type + "; id=" + dquest.current + "; startAt=" + dquest.startAt + "; finishAt=" + dquest.finishAt + "; nAction=" + nAction + "]");
	dquest.actions = new Array();
	for(i = 0; i<nAction; i++) // read actions
	{
		var action:Object = new Object();
		action.action = buff.readUnsignedShort();
		action.amount = buff.readUnsignedInt(); // current
		action.total = buff.readUnsignedInt(); // amount to finish
		dquest.actions.push(action);
		trace("\tAction [action=" + action.action + "; amount=" + action.amount + "; total=" + action.total + "]");
	}
	dquest.giftId = buff.readShort();
	dquest.giftGotTime = buff.readUnsignedInt();
	var nGift:int = buff.readUnsignedShort();
	trace("readDailyQuest DQGift [giftId=" + dquest.giftId + "; giftGotTime=" + dquest.giftGotTime + "; nGift=" + nGift + "]");
	dquest.dgifts = new Array();
	for(i = 0; i<nGift; i++)
	{
		var dgift:Object = new Object();
		dgift.gotTime = buff.readUnsignedInt();
		dgift.type = buff.readUnsignedShort();
		dgift.id = buff.readUnsignedShort();
		dgift.num = buff.readUnsignedInt();
		dgift.level = buff.readShort();
		dquest.dgifts.push(dgift);
		trace("\tGift [dgiftGotTime=" + dgift.gotTime + "; dgiftType=" + dgift.type + "; dgiftId=" + dgift.id + "; dgiftNum=" + dgift.num + "; dgiftLevel=" + dgift.level + "]");		
	}
	return dquest;
}

public function sendDQuestInfo():void
{
	trace("send Daily Quest Info");
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_DQUEST_INFO);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleDQuestInfo(buff:ByteArray):void
{
	var dquest:Object = readDailyQuest(buff);
	GAMEOBJ.mQuestHandler.mQuestObj = dquest;
	GAMEOBJ.mQuestHandler.initDailyQuest(dquest);
	GAMEOBJ.mQuestHandler.mCurDailyQuest = dquest.current;
	
	if((dquest.startAt == 0 || dquest.finishAt > 0) && dquest.current < DAILY_QUEST_MAX_NUM - 1) // user does not select quest -> create new quest
	{
		var nQuestId:int = buff.readShort(); // current quest count
		var nQuestPearl:int = buff.readInt(); // black pearl requirement
		var nRewardOption:int = buff.readByte();
		trace("handleDQuestInfo next dquest [nQuestId=" + nQuestId + "; nQuestPearl=" + nQuestPearl + "; nRewardOption=" + nRewardOption + "]");		
		
		GAMEOBJ.mQuestHandler.mCurDailyQuest = nQuestId;
		GAMEOBJ.mQuestHandler.mBlackPearlRequire = nQuestPearl;
		GAMEOBJ.mQuestHandler.mGiftOptions = new Array(nRewardOption);
		for(var i:int = 0; i<nRewardOption; i++)
		{
			var rewardType:int = buff.readShort();
			var rewardId:int = buff.readShort();
			var rewardAmount:uint = buff.readUnsignedInt();
			trace("\tReward option " + i + " [rewardType=" + rewardType + "; rewardId=" + rewardId + "; rewardAmount=" + rewardAmount + "]");
			
			var obj:Object = new Object();
			obj.rewardType = rewardType;
			obj.rewardId = rewardId;
			obj.rewardAmount = rewardAmount;
			GAMEOBJ.mQuestHandler.mGiftOptions[i] = obj;
		}
	}
	else // user has selected quest
	{
		if (GAMEOBJ.mQuestHandler.isAllQuestsComplete() && dquest.finishAt == 0)
		{
			trace("finish from server");
			GAMEOBJ.mQuestHandler.finishQuestFromServer();
		}
		GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestDescUpdate, null));
	}
	
	MainScene().getInterface().getRight().updateIconVisible(); // update quest icon
}

public function sendDQuestBuy(itemtype:int, itemid:int):void // reward type, reward id
{
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	trace("send Daily Quest Buy");
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_DQUEST_BUY);
	buffer.writeShort(itemtype);
	buffer.writeShort(itemid);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleDQuestBuy(buff:ByteArray):void
{
	var error:int = buff.readShort();
	trace("handle Daily Quest Buy: " + error);
	if(error == 0)
	{
		var dquest:Object = readDailyQuest(buff);
		mUser.m_dataStock.load(buff, 1);
		
		mUser.m_dataPayment.load(buff, 3);
		trace(mUser.m_dataPayment.toString());
		GAMEOBJ.mQuestHandler.resetQuest();
		GAMEOBJ.mQuestHandler.mQuestObj = dquest;
		GAMEOBJ.mQuestHandler.mVisitedFriends = new Array();
		GAMEOBJ.mQuestHandler.initDailyQuest(dquest);
		
		// open quest
		MainScene().addScene(CSceneConst.GP_DAILY_QUEST);
		Game.mInstance.mMainScene.getInterface().touchable = false;
		
		trace (mUser.m_dataStock.toString());
	}
	else
	{
		trace("handleDQuestBuy failed due to error code: " + error);
	}
}

public function sendDQuestFinish():void
{
	trace("send Daily Quest Finish");
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_DQUEST_FINISH);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleDQuestFinish(buff:ByteArray):void
{
	trace("handle Daily Quest Finish");
	var error:int = buff.readShort();
	if(error == 0)
	{
		var dquest:Object = readDailyQuest(buff);
		mUser.m_dataSystemGift.load(buff, 1);
		trace (mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
		
		// if (dquest.current < DAILY_QUEST_MAX_NUM - 1) // only get next quest when it is not last quest
			sendDQuestInfo();
	}
	else
	{
		trace("handleDQuestFinish failed due to error code: " + error);
	}
}

public function handlePaymentUpdate(buff:ByteArray):void
{
	mUser.m_dataPayment.load(buff, 2);	
	trace("handlePaymentUpdate.... " + mUser.m_dataPayment.toString());
}

public function sendGetPayment():void
{
	trace("sendGetPayment");
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GET_PAYMENT);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleGetPayment(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		mUser.m_dataPayment.load(buff, 2);
		trace("handleGetPayment.... " + mUser.m_dataPayment.toString());
	}
}

public function handleSystemNotify(buff:ByteArray):void
{
	GAMEOBJ.mNotifySystem.reset();
	
	var nummsg:int = buff.readByte()&0xFF;
	trace("handleSystemNotify.... nummsg=" + nummsg);
	var id:int, begin:int, end:int, delay:int, message:String;
	for(var i:int=0; i<nummsg; i++)
	{
		id = buff.readShort(); // msg id
		begin = buff.readInt(); // start time (in second)
		end = buff.readInt(); // end time (in second)
		delay = buff.readShort(); // delay timer (in second)
		message = Game.readBStr(buff); // string message
		trace("handleSystemNotify... " + id + ", " + begin + ", " + end + ", " + delay + ", " + message);
		GAMEOBJ.mNotifySystem.addNotify(new CNotifySystem(id, begin, end, delay, message), i);
	}
}

public function sendSelectDragon(id:int):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_SELECT_DRAGON, 1);
	// buffer.writeByte(id);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_SELECT_DRAGON);
	buffer.writeByte(id);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendSelectDragon.... id=" + id + " time = " + getCurrentServerTime());
}

public function handleSelectDragon(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read Inventory Dragon
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged, this));

		loadIslands(buff);

		MainScene().removeScene(CSceneConst.GP_SELECT_DRAGON);
	}
}

public function sendUnlockDGift(id:int):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_UNLOCKDGIFT, 1);
	// buffer.writeByte(id);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_UNLOCKDGIFT);
	buffer.writeByte(id);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendUnlockDGift.... id=" + id + " time = " + getCurrentServerTime());
}

public function handleUnlockDGift(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		if(MainScene().mDailyGiftScene!=null)
			MainScene().mDailyGiftScene.updateGiftLayer();
	}
}

public function sendGetDailyGift():void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_GETDAILYGIFT, 0);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GETDAILYGIFT);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetDailyGift.... time = " + getCurrentServerTime());
}


public function handleGetDailyGift(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read system gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace (mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));

		//read stock
		mUser.m_dataStock.load(buff, 1);
		trace (mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		MainScene().removeScene(CSceneConst.GP_DAILY_GIFT);
	}
}

public function sendGiftZPhoto():void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_GIFT_ZPHOTO, 0);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GIFT_ZPHOTO);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGiftZPhoto....time = " + getCurrentServerTime());
}

public function handleGiftZPhoto(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		var giftID:int = buff.readShort(); //Id in sysgift

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read system gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace (mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));

		MainScene().getTopLevel().updateCaptureNotify(USERINFO().m_dataGame.mZPhotoGift);
	}
}


public function sendDragonSwim():void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_DRAGON_SWIM, 0);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_DRAGON_SWIM);	
	m_socketConnection.Write(packMessage(buffer));
	trace("sendDragonSwim.... time = " + getCurrentServerTime());
}

public function handleDragonSwim(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		var _giftID:int = buff.readShort();
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read system gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace (mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
	}
}

public function sendItemExchange(id:int):void
{
	trace("sendItemExchange");
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_ITEM_EXCHANGE, 2);
	// buffer.writeShort(id);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_ITEM_EXCHANGE);
	buffer.writeShort(id);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendItemExchange.... id = " + id + " time = " + getCurrentServerTime());
}

public function handleItemExchange(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));
		
		//read stock
		mUser.m_dataStock.load(buff, 1);
		trace (mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
		
		//read Inventory Dragon
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged, this));
		
		if (MainScene().mEventHalloweenScene != null)
			MainScene().mEventHalloweenScene.updateAll();
	}
}

public function sendEventSpin(id:int):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_EVENT_SPIN, 2);
	// buffer.writeShort(id);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_EVENT_SPIN);
	buffer.writeShort(id);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendEventSpin.... id = " + id + " time = " + getCurrentServerTime());
}

public function handleEventSpin(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		var rank:int = buff.readShort(); //Id in sysgift
		var giftID:int = buff.readShort(); //Id in sysgift
		var giftOrder:int = buff.readShort(); //Order in reels

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));		
		
		//read system gift
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
		mUser.m_dataSystemGift.load(buff, 1);
		trace(mUser.m_dataSystemGift.toString());

		//read stock
		mUser.m_dataStock.load(buff, 1);
		trace (mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		// if(MainScene().mEvtCollectScene != null)MainScene().mEvtCollectScene.startSpin(giftOrder);
		// if(MainScene().mEventHalloweenScene != null)MainScene().mEventHalloweenScene.startSpin(giftOrder);
		if(MainScene().mEventLuckyWheelScene != null) MainScene().mEventLuckyWheelScene.startSpin(giftOrder);
	}
}

public function sendGetSysGift(id:int, got:Boolean = true):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_GETSYSGIFT, 2);
	// buffer.writeShort(id);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF && !got) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GETSYSGIFT);
	buffer.writeShort(id);
	buffer.writeByte(got?1:0);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendGetSysGift.... id = " + id + " got= " + got+ " time = " + getCurrentServerTime());
}


public function handleGetSysGift(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		var got:Boolean = (buff.readByte() == 1);
		var _pack:UserData_GiftPack = new UserData_GiftPack();
		_pack.load(buff, 1);
		trace (_pack.toString());

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read system gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace (mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));

		//read stock
		mUser.m_dataStock.load(buff, 1);
		trace (mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		//read Inventory Dragon
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged, this));

		//read Inventory Equipe
		// mUser.m_dataInventoryDragon.load(buff, 1);
		// trace(mUser.m_dataInventoryDragon.toString());

		if(got)	MainScene().mSysGiftScene.effectFlyingGift();
		if(USERINFO().m_dataSystemGift.giftList.length > 0 && MainScene().mSysGiftScene != null)
		{
			MainScene().mSysGiftScene.SetGiftData(USERINFO().m_dataSystemGift.giftList[0]);
		}
		else
		{
			MainScene().removeScene(CSceneConst.GP_SYSTEM_GIFT);
		}
	}
}


public function sendChangeDragonName(isl:int, slot:int, name:String):void
{
	// var nameBuf:ByteArray = new ByteArray();
	// var slen:int = 2 + 2 + wBBin(nameBuf, name);
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_DRAGON_NAME, slen);
	// buffer.writeShort(isl);
	// buffer.writeShort(slot);
	// buffer.writeBytes(nameBuf);
	// m_socketConnection.Write(buffer);
	// if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_DRAGON_NAME);
	buffer.writeShort(isl);
	buffer.writeShort(slot);
	wBBin(buffer, name);
	m_socketConnection.Write(packMessage(buffer));

	trace("sendChangeDragonName.... isl = " + isl + " slot = " + slot + " name = " + name);
}

public function handleChangeDragonName(buff:ByteArray):void
{
	var error:int = buff.readShort();
	trace("handleChangeDragonName");
	trace("error = " + error);
	if(error == 0)
	{
		var isl:int = buff.readByte();
		var slot:int = buff.readByte();
		if(isl >= 0)
		{
			loadIslands(buff);
		}
		else
		{
			//read Inventory Dragon
			mUser.m_dataInventoryDragon.load(buff, 1);
			trace(mUser.m_dataInventoryDragon.toString());
			mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged, this));
		}

	}
}

public function sendMNGKillPirate(count:int = 1):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_MNG_KILLPIRATE, 2);
	// buffer.writeShort(count);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_MNG_KILLPIRATE);
	buffer.writeShort(count);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendMNGKillPirate.... count = " + count + " time = " + getCurrentServerTime());
}

public function handleMNGKillPirate(buff:ByteArray):void
{
	var error:int = buff.readShort();
	if(error == 0)
	{
		var isKilled:Boolean = (buff.readByte()==1);
		trace("handleMNGKillPirate...." + isKilled);

		//Data MiniGame
		mUser.m_dataMiniGame.load(buff, 1);
		trace(mUser.m_dataMiniGame.toString());
		//Dispatch Event MiniGame change...

		if(isKilled)
		{
			var gold:int = buff.readInt();
			var exp:int = buff.readInt();
			var giftID:int = buff.readShort();

			GAMEOBJ.dispatchEvent(new GameEvent(GameEvent.AddFlyingObject, -1 , -1 , TYPE_GOLD , gold , TYPE_MNG_PIRATE));
			GAMEOBJ.dispatchEvent(new GameEvent(GameEvent.AddFlyingObject, -1 , -1 , TYPE_EXP , exp , TYPE_MNG_PIRATE));

			//read Game
			mUser.m_dataGame.load(buff, 1);
			trace (mUser.m_dataGame.toString());
			mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

			//read stock
			mUser.m_dataStock.load(buff, 1);
			trace (mUser.m_dataStock.toString());
			mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

			//read system gift
			mUser.m_dataSystemGift.load(buff, 1);
			trace(mUser.m_dataSystemGift.toString());
			MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
		}
		
		
		var game:UserData_MNGPirate = mUser.m_dataMiniGame.getGame(TYPE_MNG_PIRATE) as UserData_MNGPirate;
		if (game.hasNewPirate()) {
			mUser.dispatchEvent (new GameEvent (GameEvent.PirateChanged , this));
			
			GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_FIGHT_PIRATE, 1));
		}
	}
	else
	{
		trace("handleMNGKillPirate....Failed");
	}
}
public function sendFriendFighting(friend:CUserInfo):void
{
	// if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	if(friend && friend.mName && friend.mPoolId && friend.m_visitKey)
	{
		// var fnamebuf:ByteArray = new ByteArray();
		// var reqLen:int = wBBin(fnamebuf, friend.mName) + 1 + 4 + 4 + 4 + 2 + 4;
		// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FRIEND_FIGHTING, reqLen);
		// buffer.writeBytes(fnamebuf);
		// buffer.writeByte(friend.mPoolId);
		// buffer.writeInt(friend.m_visitKey);
		// buffer.writeInt(friend.mOnlineAt);
		// buffer.writeInt(friend.mIpSer);
		// buffer.writeShort(friend.mPortSer);
		// buffer.writeInt(friend.mSnsId);
		// m_socketConnection.Write(buffer);

		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_FRIEND_FIGHTING);
		wBBin(buffer, friend.mName)
		buffer.writeByte(friend.mPoolId);
		buffer.writeInt(friend.m_visitKey);
		buffer.writeInt(friend.mOnlineAt);
		buffer.writeInt(friend.mIpSer);
		buffer.writeShort(friend.mPortSer);
		buffer.writeInt(friend.mSnsId);
		m_socketConnection.Write(packMessage(buffer));
		trace("sendFriendFighting...... [mName=" + friend.mName + ";mPoolId=" + friend.mPoolId + ";m_visitKey=" + friend.m_visitKey + "]");
	}
}

public function handleFriendFighting(buff:ByteArray):void
{
	var attacker:String = Game.readBStr(buff);
	var error:int = buff.readShort();
	var defender:String = Game.readBStr(buff);

	if(error == 0)
	{
		var isWin:Boolean = (buff.readByte() == 1);
		trace("handleFriendFighting from " + attacker + " to " + defender + (isWin?" win!!!":" lose!!!"));
		if(attacker == mUser.mName)
		{
			//read Game
			mUser.m_dataGame.load(buff, 1);
			trace (mUser.m_dataGame.toString());
			mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

			//Data Diary
			// mUser.m_dataDiary.load(buff, 1);
			// trace(mUser.m_dataDiary.toString());

			var friend:CUserInfo = null;
			if((friend = mUser.findFriend(defender)) != null)
			{
				if(friend.m_dataGame == null)
					friend.m_dataGame = new UserData_Game(friend);
				friend.m_dataGame.load(buff, 1);
				//TODO:Add Dispatch Event for Friend Data_Game
				//....
				var giftID:int = 0;
				if(isWin)
				{
					//NEWWWWWWWWWWWW
					giftID = buff.readShort();

					mUser.m_dataSystemGift.load(buff, 1);
					trace (mUser.m_dataSystemGift.toString());
				}
				BattleCine.startBattleCine(isWin , giftID);
			}
			// check quest
			GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_FIGHT_FRIEND, 1));
		}
		else
		{
			var _user:CUserInfo = mUser.findFriend(attacker);
			var _displayName:String = ((_user != null)?_user.mDisplayName:name);
			MainScene().showFriendFightPopup(_displayName, isWin);
		}
	}
	else
	{
		trace("handleFriendFighting from " + attacker + " to " + defender + " error = " + error);
	}
}

public function sendSetFightDragon(isl:int, slot:int):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_SET_FIGHTDRAGON, 2 + 2);
	// buffer.writeShort(isl);
	// buffer.writeShort(slot);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_SET_FIGHTDRAGON);
	buffer.writeShort(isl);
	buffer.writeShort(slot);
	m_socketConnection.Write(packMessage(buffer));
	trace("sendSetFightDragon " + isl + ":" + slot);
}

public function handleSetFightDragon(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));
	}
	else
	{
	}
}


public function sendFriendGiftSend(friend:CUserInfo, giftType:int, giftID:int, giftNum:int):void
{
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	if(friend && friend.mName && friend.mPoolId && friend.m_visitKey)
	{
		// var fnamebuf:ByteArray = new ByteArray();
		// var reqLen:int = wBBin(fnamebuf, friend.mName) + 1 + 4 + 4 + 4 + 2 + 2 + 2 + 4;
		// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FRIEND_SENDGIFT, reqLen);
		// buffer.writeBytes(fnamebuf);
		// buffer.writeByte(friend.mPoolId);
		// buffer.writeInt(friend.m_visitKey);
		// buffer.writeInt(friend.mOnlineAt);
		// buffer.writeInt(friend.mIpSer);
		// buffer.writeShort(friend.mPortSer);
		// buffer.writeShort(giftType);
		// buffer.writeShort(giftID);
		// buffer.writeInt(giftNum);
		// m_socketConnection.Write(buffer);
		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_FRIEND_SENDGIFT);
		wBBin(buffer, friend.mName)
		buffer.writeByte(friend.mPoolId);
		buffer.writeInt(friend.m_visitKey);
		buffer.writeInt(friend.mOnlineAt);
		buffer.writeInt(friend.mIpSer);
		buffer.writeShort(friend.mPortSer);
		buffer.writeShort(giftType);
		buffer.writeShort(giftID);
		buffer.writeInt(giftNum);
		m_socketConnection.Write(packMessage(buffer));
		trace("FriendGiftSend->Send...... [mName=" + friend.mName + ";mPoolId=" + friend.mPoolId + ";m_visitKey=" + friend.m_visitKey + "]");
	}
}

public function handleFriendGiftSend(buff:ByteArray):void
{
	var sender:String = Game.readBStr(buff);
	var receiver:String = Game.readBStr(buff);
	trace("handleFriendGiftSend from " + sender + " to " + receiver);
	//read Data_FGift
	mUser.m_dataFriendGift.load(buff, 1);
	trace (mUser.m_dataFriendGift.toString());
	//TODO:Add Dispatch Event for FriendGift
	//mUser.m_dataFriendGift.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));
	if(sender == mUser.mName)
	{
		var friend:CUserInfo = null;
		if(receiver != null && (friend = mUser.findFriend(receiver)) != null)
		{
			//read Friend Data_FGift
			if(friend.m_dataFriendGift == null)
				friend.m_dataFriendGift = new UserData_FriendGift();
			friend.m_dataFriendGift.load(buff, 1);
			//TODO:Add Dispatch Event for Friend FriendGift
			//....

			var giftType:int = buff.readShort();
			if(giftType == TYPE_DRAGON)
			{
				//read Inventory Dragon
				mUser.m_dataInventoryDragon.load(buff, 1);
				trace(mUser.m_dataInventoryDragon.toString());
				mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged , this));
			}
			else if(giftType == TYPE_DRAGON)
			{
				//read Equipe Dragon
			}
			else
			{
				//read stock
				mUser.m_dataStock.load(buff, 1);
				trace (mUser.m_dataStock.toString());
				mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
			}
			
			GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_GIVE_FRIEND, 1));
		}
		else
		{
			trace("Failed to send friend gift T_T");
		}
	}
	else
	{
		var _slot:int = buff.readShort();
		var _user:CUserInfo = mUser.findFriend(sender);
		var _displayName:String = ((_user != null)?_user.mDisplayName:sender);
		if(_slot < mUser.m_dataFriendGift.giftList.length)
			MainScene().showFriendGiftPopup(_displayName, mUser.m_dataFriendGift.giftList[_slot]);
		else
			MainScene().showFriendGiftPopup(_displayName, null);
	}

	mMainScene.updateFGift();
	MainScene().getInterface().getRight().getGiftNotify().dispatchEvent(new GameEvent(GameEvent.NotificationUpdate, this));
}

public function sendFriendGiftGet(giftSlot:int, gotOrNot:Boolean = true):void
{
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	trace("sendFriendGiftGet->Get...... [giftSlot=" + giftSlot + "]");
	// var slen:int = 1 + 1;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FRIEND_GETGIFT, slen);
	// buffer.writeByte(giftSlot);
	// buffer.writeByte(gotOrNot?1:0);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FRIEND_GETGIFT);
	buffer.writeByte(giftSlot);
	buffer.writeByte(gotOrNot?1:0);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleFriendGiftGet(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var giftSlot:int = buff.readByte();

		//Friend Gift
		mUser.m_dataFriendGift.load(buff, 1);
		trace(mUser.m_dataFriendGift.toString());
		//TODO:Add Dispatch Event for FriendGift

		var giftType:int = buff.readShort();

		if(giftType == TYPE_DRAGON)
		{
			//read Inventory Dragon
			mUser.m_dataInventoryDragon.load(buff, 1);
			trace(mUser.m_dataInventoryDragon.toString());
			mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged , this));
		}
		else if(giftType == TYPE_BATTLE_EQUIPE)
		{
			// obuff.writeBytes(m_dataInventoryEquipe.toByteArray());
		}
		else
		{	//read Stock
			mUser.m_dataStock.load(buff, 1);
			trace(mUser.m_dataStock.toString());
			mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
		}

		mMainScene.updateFGift();
	}
	else
	{
		//Error
	}
}

public function sendVisitFriend(friend:CUserInfo):void
{
	if(friend && friend.mName && friend.mPoolId && friend.m_visitKey)
	{
		// var fidbuf:ByteArray = new ByteArray();
		// var fnamebuf:ByteArray = new ByteArray();
		// var favatarbuf:ByteArray = new ByteArray();
		// var reqLen:int = wBBin(fidbuf, friend.mName) + 1 + 4 + 4 + 4 + 2 + wBBin(fnamebuf, friend.mDisplayName) + wBBin(favatarbuf, friend.mAvatarUrl);
		// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_VISIT_FRIEND, reqLen);
		// buffer.writeBytes(fidbuf);
		// buffer.writeByte(friend.mPoolId);
		// buffer.writeInt(friend.m_visitKey);
		// buffer.writeInt(friend.mOnlineAt);
		// buffer.writeInt(friend.mIpSer);
		// buffer.writeShort(friend.mPortSer);
		// buffer.writeBytes(fnamebuf);
		// buffer.writeBytes(favatarbuf);
		// m_socketConnection.Write(buffer);
		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_FARM_VISIT_FRIEND);
		wBBin(buffer, friend.mName)
		buffer.writeByte(friend.mPoolId);
		buffer.writeInt(friend.m_visitKey);
		buffer.writeInt(friend.mOnlineAt);
		buffer.writeInt(friend.mIpSer);
		buffer.writeShort(friend.mPortSer);
		wBBin(buffer, friend.mDisplayName);
		wBBin(buffer, friend.mAvatarUrl);
		m_socketConnection.Write(packMessage(buffer));
		trace("sendVisitFriend...... [mName=" + friend.mName + ";mPoolId=" + friend.mPoolId + ";m_visitKey=" + friend.m_visitKey + ";snsID=" + friend.mSnsId+ "]");
	}
}

public function handleVisitFriend(buff:ByteArray):void
{
	var visitor:String = Game.readBStr(buff);
	var friend:CUserInfo = null;
	if(visitor == mUser.mName)
	{
		var fname:String = Game.readBStr(buff);
		if((friend = mUser.findFriend(fname)) != null)
		{
			friend.mOnlineAt = buff.readInt();
			friend.mIpSer = buff.readInt();
			friend.mPortSer = buff.readShort();
			var friendRank:int = buff.readInt();
			var myRank:int = buff.readInt();

			// if (myRank != mUserRanking)
				// mUserRanking = myRank;

			mFriendRanking = friendRank;

			trace("handleVisitFriend to " + fname + "[" + friend.mOnlineAt + ";" + int2ip(friend.mIpSer) + ":" + friend.mPortSer + ";" + friendRank + ";" + myRank);
			if(friend.m_dataGame == null)
				friend.m_dataGame = new UserData_Game(friend);
			friend.m_dataGame.load(buff, 1);

			trace("Friend Game:" + friend.m_dataGame.toString())

			//read Friend Data_FGift
			if(friend.m_dataFriendGift == null)
				friend.m_dataFriendGift = new UserData_FriendGift();
			friend.m_dataFriendGift.load(buff, 1);
			//Dispatch Event for Friend FriendGift
			trace("Friend m_dataFriendGift:" + friend.m_dataFriendGift.toString())

			//read Friend Data_FGift
			if(friend.m_dataMiniGame == null)
				friend.m_dataMiniGame = new UserData_MiniGame(friend);
			friend.m_dataMiniGame.load(buff, 1);
			//Dispatch Event for Friend m_dataMiniGame
			trace("Friend m_dataMiniGame:" + friend.m_dataMiniGame.toString())

			if(friend.m_dataIslands == null)
				friend.m_dataIslands = new Vector.<UserData_Island>();
			else
			{
				while (friend.m_dataIslands.length > 0) friend.m_dataIslands.pop();
			}

			var islandNum:int = buff.readByte();
			for (var i:int = 0 ; i < islandNum ; i++)
			{
				var islandId:int = buff.readByte();
				var island:UserData_Island = new UserData_Island (islandId , friend);
				friend.m_dataIslands.push (island);
				island.load(buff, 1);
				trace(island.toString());
			}

			mMainScene.viewUserIsland(friend, true);
			
			if (GAMEOBJ.mQuestHandler.isVisitedThatFriend(friend.mName) == false)
			{
				GAMEOBJ.mQuestHandler.mVisitedFriends.push(friend.mName);
				GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_VISIT_FRIEND, 1));
			}
		}
		mMainScene.removeWaitVisitFriend();
	}
	else
	{
		if((friend = mUser.findFriend(visitor)) != null)
		{
			friend.mOnlineAt = getCurrentServerTime();
			friend.mIpSer = buff.readInt();
			friend.mPortSer = buff.readShort();

			trace("handleVisitFriend by " + visitor + "[" + friend.mOnlineAt + ";" + int2ip(friend.mIpSer) + ":" + friend.mPortSer);
			MainScene().showFriendVisitPopup(friend);
		}
	}
}

public function sendSaveSetting(setting:int, guide:int):void
{
	trace("sendSaveSetting......");
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_SAVE_SETTING, 8);
	// buffer.writeInt(setting);
	// buffer.writeInt(guide);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_SAVE_SETTING);
	buffer.writeInt(setting);
	buffer.writeInt(guide);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleSaveSetting(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));
	}
}

public function sendGetFriend():void
{
	trace("sendGetFriend......");
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_GETFRIEND, 0);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_GETFRIEND);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleGetFriend(buff:ByteArray):void
{
	var nFriend:int = buff.readShort();
	trace("handleGetFriend.... " + nFriend);
	USERINFO().initFriends();
	if(nFriend > 0)
	{
		var fbuf:ByteArray = new ByteArray();
		fbuf.writeBytes(buff, buff.position);
		trace("handleGetFriend compress szie = " + fbuf.length);
		fbuf.uncompress();
		trace("handleGetFriend full szie = " + fbuf.length);
		for(var i:int = 0; i<nFriend; i++)
		{
			var friend:CUserInfo = new CUserInfo(false, i);
			friend.mName = Game.readBStr(fbuf);
			friend.mPoolId = fbuf.readByte();
			friend.m_visitKey = fbuf.readInt();
			friend.mRegisterAt = fbuf.readInt();
			friend.mOnlineAt = fbuf.readInt();
			friend.mIpSer = fbuf.readInt();
			friend.mPortSer = fbuf.readShort();
			friend.mExp = Game.readLong(fbuf);
			friend.mLevel = fbuf.readShort();
			friend.mSnsId = fbuf.readInt();
			friend.mDisplayName = Game.readBStr(fbuf);
			if (friend.mDisplayName == null || friend.mDisplayName == "")
				friend.mDisplayName = friend.mName;
			friend.mAvatarUrl = Game.readBStr(fbuf);
			friend.mDoB = fbuf.readInt();
			friend.setDefaultAvatar();
			USERINFO().addFriend(friend);
			// trace(friend);
		}
	}
	USERINFO().setDefaultAvatar();
	USERINFO().addUserToFriendList(); // add current user to friend list
	USERINFO().sortFriends();
	dispatchEvent(new GameEvent(GameEvent.FriendLoaded, this));
}
//LOGIN
public function sendLogin():void
{
	// var dnamebuf:ByteArray = new ByteArray();
	// var slen:int = 4 + 4 + 2 + 1 + wBBin(dnamebuf, mUser.mDisplayName);
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_LOGIN, slen);
	trace("sendLogin....poolId:" + mUser.mPoolId);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_LOGIN);
	wBBin(buffer, mUser.mName);
	buffer.writeByte(mUser.mPoolId);
	buffer.writeInt(mUser.mSession);
	buffer.writeInt(mUser.mSnsId);
	wBBin(buffer, mUser.mDisplayName);
	buffer.writeInt(mUser.mIpSer);
	buffer.writeShort(mUser.mPortSer);
	buffer.writeByte(mUser.mNewBie?1:0); // 1: newbie - 0: oldbie
	m_socketConnection.Write(packMessage(buffer, true));
}

public function handleLogin(buff:ByteArray):void
{
	trace("handleLogin ...");
	if(buff.readShort() == 0)
	{	
		var i:int;

		mUser.mPoolId = buff.readByte();
		mStartServerTime = buff.readInt();//Server Time
		mStartClientTime = getTimer()/1000;
		trace("------------------- sever time and client time " + mStartServerTime + " " + mStartClientTime);

		mUser.mIpSer = buff.readInt();
		mUser.mPortSer = buff.readShort();
		trace("------------------- lan udp = " + int2ip(mUser.mIpSer) + ":" + mUser.mPortSer);

		var levelRank:int = buff.readInt();
		mUserRanking = levelRank;
		trace("------------------- my level rank = " + levelRank);

		//read Constant
		var constBuf:ByteArray = readSArray(buff);
		trace("------------------- constBuf compress size = " + constBuf.length);
		constBuf.uncompress();
		trace("------------------- constBuf uncompress size = " + constBuf.length);

		mConst.loadConstDragons(constBuf);
		mConst.loadConstFoods(constBuf);
		mConst.loadConstDragonNites(constBuf);
		mConst.loadConstBuildings(constBuf);
		// mConst.loadConstStatues(constBuf);
		mConst.loadConstDecors(constBuf);
		mConst.loadConstFarmItems(constBuf);
		mConst.loadConstExchanges(constBuf);
		mConst.loadConstBattleItems(constBuf);
		// mConst.loadConstEquipes(constBuf);
		// mConst.loadConstBots(constBuf);
		mConst.loadConstIslands(constBuf);
		mConst.loadConstDragonElements(constBuf);
		mConst.loadConstDragonColors(constBuf);
		mConst.loadConstDragonRares(constBuf);
		mConst.loadConstLevelUps(constBuf);
		mConst.loadConstMNGPirates(constBuf);
		mConst.loadConstEvents(constBuf);
		mConst.loadConstEventMixs(constBuf);

		var n:int = buff.readByte();
		mUser.mRegSelDragons = new Array(n);
		for (i = 0 ; i < n ; i++)
		{
			mUser.mRegSelDragons[i] = buff.readShort();
		}

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());

		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());

		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());

		//System Gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace(mUser.m_dataSystemGift.toString());

		//Friend Gift
		mUser.m_dataFriendGift.load(buff, 1);
		trace(mUser.m_dataFriendGift.toString());

		//Data MiniGame
		mUser.m_dataMiniGame.load(buff, 1);
		trace(mUser.m_dataMiniGame.toString());
		
		//Data m_dataEvent
		mUser.m_dataEvent.load(buff, 2);
		trace(mUser.m_dataEvent.toString());

		// mUser.m_arena.load(buff, 3);
		// trace(mUser.m_arena.toString());
		
		USERINFO().mIsLockStat = buff.readShort();
		USERINFO().mIsLockPassSet = (buff.readByte() == 1);
		USERINFO().mLastLockTime = buff.readInt();
		if(MainScene() != null && MainScene().getInterface() != null
		&& MainScene().getInterface().getTop() != null)
			MainScene().getTopLevel().updateLockState();
		trace("[LOCK] " + USERINFO().mIsLockStat + ";" + USERINFO().mIsLockPassSet);

		USERINFO().mRefID = buff.readInt();
		if(USERINFO().mRefID > 0)
			USERINFO().mRefName = Game.readBStr(buff);
		trace("[Ref]" + USERINFO().mRefID + ";" + USERINFO().mRefName);
		USERINFO().m_dataAchievement.load(buff, 1);
		trace("[m_dataAchievement]" + USERINFO().m_dataAchievement);
		
		var islandNum:int = buff.readByte();
		trace ("island Num = " + islandNum);
		while (mUser.m_dataIslands.length > 0)
			mUser.m_dataIslands.pop();

		for (i = 0 ; i < islandNum ; i++) {
			var islandId:int = buff.readByte();
			var island:UserData_Island = new UserData_Island (islandId , mUser);
			mUser.m_dataIslands.push (island);
			island.load(buff, 1);
			trace(island.toString());
		}
		
		if (isCloseMarket) 
		{
			var currentIslandIndex:int = mMainScene.getCurrentIslandIndex();
			mMainScene.viewUserIsland(mUser);
			mMainScene.gotoIsland(currentIslandIndex);
		}
		isCloseMarket = false;
		
		
		USERINFO().mMarketListExp = new Array();
		var lenExp:int = buff.readShort();
		for(i = 0; i < lenExp; i++)
		{
			USERINFO().mMarketListExp[i] = buff.readInt(); 
		}
		trace("USERINFO().mMarketListExp="+ USERINFO().mMarketListExp);		
		
		USERINFO().mMarketSlotPriceList = new Array();
		lenExp = buff.readShort();
		for(i = 0; i < lenExp; i++)
		{
			USERINFO().mMarketSlotPriceList[i] = buff.readInt(); 
		}
		trace("USERINFO().mMarketSlotPriceList="+ USERINFO().mMarketSlotPriceList);
			
		USERINFO().mMarketSlotExpiredList = new Array();
		lenExp = buff.readShort();
		for(i = 0; i < lenExp; i++)
		{
			USERINFO().mMarketSlotExpiredList[i] = buff.readInt(); 
		}
		trace("USERINFO().mMarketSlotExpiredList="+ USERINFO().mMarketSlotExpiredList);
		
		dispatchEvent(new GameEvent(GameEvent.LoginSuccess, this));
		if(isMarket)MainScene().addScene(CSceneConst.GP_MARKET_SCENE);		
		
		if(MainScene()!= null && CHATSCENE() != null)
			GAMEOBJ.sendChatVisible(CHATSCENE().mChatContainer.visible && CHATSCENE().mChatGUIContainer.visible);
		if(mUser.m_dataGame.feedInvite == 0)
		{
			sendFeedInvite();
			FEED().feedInvite();
		}
	}
	else
	{
	}
}

public function sendFeedInvite():void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FED_INVITE);	
	m_socketConnection.Write(packMessage(buffer));
}

public function sendGetArenaStat():void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_ARENA_STAT);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleGetArenaStat(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var arenaBuf:ByteArray = readSArray(buff);
		if(arenaBuf != null)
		{
			trace("------------------- arenaBuf compress size = " + arenaBuf.length);
			arenaBuf.uncompress();
			mUser.m_arena.load(arenaBuf, 3);
			trace(mUser.m_arena.toString());
		}
		// MainScene().mArenaScene._pageList = USERINFO().m_arena.getResultList();
		if(MainScene().mArenaScene != null) MainScene().mArenaScene.updateScene(true);
	}
}

public function sendArenaResult():void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_ARENA_RESULT);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleArenaResult(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		var n:int = buff.readShort();
		MainScene().mArenaScene._pageList = new Array();
		for(var i:int = 0; i<n; i++)
		{
			MainScene().mArenaScene._pageList[i] = Game.readBStr(buff);

			trace(MainScene().mArenaScene._pageList[i]);
		}

		if(MainScene().mArenaScene != null)
		{
			MainScene().mArenaScene.updateScene(true);
			MainScene().mArenaScene.openResult();
		}
	}
}

public function sendRegArena():void
{
	// if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_ARENA_REGISTER);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleRegArena(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
		buff.readShort();

		var arenaBuf:ByteArray = readSArray(buff);
		if(arenaBuf != null)
		{
			trace("------------------- arenaBuf compress size = " + arenaBuf.length);
			arenaBuf.uncompress();
			mUser.m_arena.load(arenaBuf, 3);
			trace(mUser.m_arena.toString());
		}

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		if(MainScene().mArenaScene != null) MainScene().mArenaScene.updateScene(true);
	}
}

public function handleNotifyArena(buff:ByteArray):void
{
	//read Game
	mUser.m_dataGame.load(buff, 1);
	trace (mUser.m_dataGame.toString());
	mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

	//read system gift
	mUser.m_dataSystemGift.load(buff, 1);
	trace (mUser.m_dataSystemGift.toString());
	MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));

	if(MainScene().mArenaScene != null) MainScene().mArenaScene.updateScene(true);
}


public function handleUnlockIsland(buff:ByteArray):void
{
	trace("handleUnlockIsland ...");
	if(buff.readShort() == 0)
	{
		loadIslands(buff);
	}
	else
	{

	}
}

private function loadIslands(buff:ByteArray):void {
	var islandNum:int = buff.readByte();
	trace ("island Num = " + islandNum);
	for (var i:int = 0 ; i < islandNum ; i++) {
		var islandId:int = buff.readByte();
		var island:UserData_Island;
		if (islandId >= mUser.m_dataIslands.length)
		{
			trace("New Island ..." +islandId);
			island = new UserData_Island (islandId , mUser);
			mUser.m_dataIslands.push (island);
			island.load(buff, 1);
			mUser.dispatchEvent (new GameEvent(GameEvent.IslandAdded , island));
		}
		else
		{
			trace("Update Island ..." +islandId);
			island = mUser.m_dataIslands[islandId];
			island.load(buff, 1);
			trace("island.dispatchEvent (new GameEvent(GameEvent.IslandChanged , this));");
			island.dispatchEvent (new GameEvent(GameEvent.IslandChanged , this));
		}

		trace(island.toString());
	}
}

public function handleLevelUp(buff:ByteArray):void
{
	trace("handleLevelUp ...");
	if(buff.readShort() == 0)
	{
		//server rank
		var rank:int = buff.readInt();
		trace("handleLevelUp my rank: " + rank);
		mUserRanking = rank;

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read System Gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace(mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
		GAMEOBJ.dispatchEvent (new GameEvent (GameEvent.LevelUp, this));

		//Data MiniGame
		mUser.m_dataMiniGame.load(buff, 1);
		trace(mUser.m_dataMiniGame.toString());
		mUser.dispatchEvent (new GameEvent (GameEvent.PirateChanged , this));

		loadIslands(buff);


		// MainScene().addScene(CSceneConst.GP_LEVEL_UP);
		MainScene().addLevelUpEffect();
		
		MainScene().getInterface().updateIconVisible(); // update icon visible when level up
	}
	else
	{

	}
}


//DRAGON INTERACTIVE
public function sendMoveDragon(_moveType:int, _islSrc:int, _islDst:int, _srcID:int, _dstID:int):void
{
	// var slen:int = 1 + 1 + 1 + 2 + 2;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_MOVEDRAGON, slen);
	// buffer.writeByte(_moveType);//MOVE_INV_TO_ISL || MOVE_ISL_TO_INV || MOVE_ISL_TO_ISL
	// buffer.writeByte(_islSrc);
	// buffer.writeByte(_islDst);
	// buffer.writeShort(_srcID);
	// buffer.writeShort(_dstID);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	trace(" - send move dragon - type: " + _moveType + ", src island: " + _islSrc + ", dst island: " + _islDst + ", src id: " + _srcID + ", dst id: " + _dstID);
	if(_islSrc >= 0 && USERINFO().m_dataIslands[_islSrc].isLocked) return;
	if(_islDst >= 0 && USERINFO().m_dataIslands[_islDst].isLocked) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_MOVEDRAGON);
	buffer.writeByte(_moveType);//MOVE_INV_TO_ISL || MOVE_ISL_TO_INV || MOVE_ISL_TO_ISL
	buffer.writeByte(_islSrc);
	buffer.writeByte(_islDst);
	buffer.writeShort(_srcID);
	buffer.writeShort(_dstID);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleMoveDragon(buff:ByteArray):void
{
	trace("handleMoveDragon ...");
	if(buff.readShort() == 0)
	{
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent(GameEvent.BaseInventoryChanged , this));

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		loadIslands(buff);

		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));
	}
}

public function sendEnhanceDragon(_usePearl:Boolean = false):void
{
	trace("--- sendEnhanceDragon ---" + _usePearl);
	// var slen:int = 1;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_DRAGON_ENCHANT, slen);
	// buffer.writeByte(_usePearl?1:0); //instock = -1
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_DRAGON_ENCHANT);
	buffer.writeByte(_usePearl?1:0); //instock = -1
	m_socketConnection.Write(packMessage(buffer));
}

public function handleEnhanceDragon(buff:ByteArray):void
{
	trace("handleEnhanceDragon ...");
	if (buff.readShort() == 0)
	{
		var enhance:Boolean = (buff.readByte() == 1);
		trace("--- use enhance? " + enhance);

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace(mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		var _newSlot:int = mUser.m_dataGame.m_breedSlot;
		trace(" new slot: " + _newSlot);

		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));

		//read Inventory Dragon
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		if (enhance)
			mUser.m_dataInventoryDragon.dispatchEvent(new GameEvent(GameEvent.EnhanceDragon));
		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged, this));
	}
}

public function sendBreedDragon(_leftIsland:int, _leftId:int, _rightIsland:int, _rightId:int):void
{
	trace("--- send breed dragon: LEFT - island: " + _leftIsland + ", id: " + _leftId + ", RIGHT - island: " + _rightIsland + ", id: " + _rightId);
	// var slen:int = 2 + 2 + 2 + 2;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_BREED, slen);
	// buffer.writeShort(_leftIsland); //instock = -1
	// buffer.writeShort(_leftId);
	// buffer.writeShort(_rightIsland); //in stock = -1
	// buffer.writeShort(_rightId);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_BREED);
	buffer.writeShort(_leftIsland); //instock = -1
	buffer.writeShort(_leftId);
	buffer.writeShort(_rightIsland); //in stock = -1
	buffer.writeShort(_rightId);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleBreedDragon(buff:ByteArray):void
{
	trace("handleBreedDragon ...");
	if(buff.readShort() == 0)
	{
		var giftID:int = buff.readShort();
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace(mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));

		//read Inventory Dragon
		mUser.m_dataInventoryDragon.load(buff, 1);
		trace(mUser.m_dataInventoryDragon.toString());
		mUser.m_dataInventoryDragon.dispatchEvent(new GameEvent(GameEvent.MixDragonBirth, mUser.m_dataGame.m_breedSlot));

		//read system gift
		mUser.m_dataSystemGift.load(buff, 1);
		trace(mUser.m_dataSystemGift.toString());
		MainScene().dispatchEvent (new GameEvent (GameEvent.SystemGiftChanged , this));
		
		//read Islands
		loadIslands(buff);

		mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged, this));
	}
}

#define MAX_FEED_COMMAND	5
#define TIMEOUT_FEED_COMMAND	3000
public var m_feedIsldIDs:Array;
public var m_feedSlotIDs:Array;
public var m_feedFoodIDs:Array;
public var m_feedBuys:Array;

public function sendFeedDragon(_islID:int, _slotID:int, _foodID:int, _buy:Boolean = false):void
{
	if(_islID >= 0 && USERINFO().m_dataIslands[_islID].isLocked) return;
	if(m_feedIsldIDs == null) m_feedIsldIDs = new Array();
	if(m_feedSlotIDs == null) m_feedSlotIDs = new Array();
	if(m_feedFoodIDs == null) m_feedFoodIDs = new Array();
	if(m_feedBuys == null) m_feedBuys = new Array();
	m_feedIsldIDs.push(_islID);
	m_feedSlotIDs.push(_slotID);
	m_feedFoodIDs.push(_foodID);
	m_feedBuys.push(_buy?1:0);
	comboFeedDragonUpdate(null);
}

public function comboFeedDragonUpdate(event:TimerEvent):void
{
	if(m_feedIsldIDs != null && m_feedSlotIDs != null
		&& m_feedFoodIDs != null && m_feedBuys != null
	)
	{
		trace("m_feedIsldIDs.length = " + m_feedIsldIDs.length + " event = " + (event!=null));
		if(event != null || m_feedIsldIDs.length == MAX_FEED_COMMAND)
		{
			// var slen:int = 2 + m_feedIsldIDs.length*(1 + 1 + 2 + 1);
			// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_FEEDDRAGON, slen);
			// buffer.writeShort(m_feedIsldIDs.length);
			// for(var i:int = 0; i < m_feedIsldIDs.length ;i++)
			// {
				// buffer.writeByte(m_feedIsldIDs[i]);
				// buffer.writeByte(m_feedSlotIDs[i]);
				// buffer.writeShort(m_feedFoodIDs[i]);
				// buffer.writeByte(m_feedBuys[i]);
			// }
			// m_socketConnection.Write(buffer);
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(COMMAND_FARM_FEEDDRAGON);
			buffer.writeShort(m_feedIsldIDs.length);
			for(var i:int = 0; i < m_feedIsldIDs.length ;i++)
			{
				buffer.writeByte(m_feedIsldIDs[i]);
				buffer.writeByte(m_feedSlotIDs[i]);
				buffer.writeShort(m_feedFoodIDs[i]);
				buffer.writeByte(m_feedBuys[i]);
			}
			m_socketConnection.Write(packMessage(buffer));

			if(event != null)
			{
				//Stop timer
				var _timer:Timer = Timer(event.target);
				_timer.stop();
			}

			//Reset Arrays
			m_feedIsldIDs = null;
			m_feedSlotIDs = null;
			m_feedFoodIDs = null;
			m_feedBuys = null;
		}
		else if(m_feedIsldIDs.length == 1)
		{
			//New Timer Tick
			var myTimer:Timer = new Timer(TIMEOUT_FEED_COMMAND, 1);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, comboFeedDragonUpdate);
			myTimer.start();
		}
	}
}

public function handleFeedDragon(buff:ByteArray):void
{
	trace("handleFeedDragon ...");
	if(buff.readShort() == 0)
	{
		var i:int;

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		loadIslands(buff);

		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));

		var _num:int = buff.readShort();
		var _islID:Array = new Array(_num);
		var _slotID:Array = new Array(_num);
		var _goldGot:Array = new Array(_num);
		var _expGot:Array = new Array(_num);

		for (i = 0 ; i < _num ; i++)
		{
			_islID[i] = buff.readByte();
			_slotID[i] = buff.readByte();
			_goldGot[i] = buff.readInt();
			_expGot[i] = buff.readInt();
			trace("#################################### i =" + i + " _islID = " + _islID[i] + " Slot id = " + _slotID[i] +"_gold Got = " + _goldGot[i] + " _expGot" + _expGot[i]);
			GAMEOBJ.dispatchEvent(new GameEvent(GameEvent.AddFlyingObject, _islID[i], _slotID[i], TYPE_GOLD, _goldGot[i] , TYPE_DRAGON));
			GAMEOBJ.dispatchEvent(new GameEvent(GameEvent.AddFlyingObject, _islID[i], _slotID[i], TYPE_EXP, _expGot[i], TYPE_DRAGON));
		}
		
		GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_EAT_FOOD, _num));

	}
}


//Pick Gold Drop From Dragon
#define MAX_PICK_COMMAND		10
#define TIMEOUT_PICK_COMMAND	3000
public var m_pickIsldIDs:Array;
public var m_pickSlotIDs:Array;
public var m_pickGolds:Array;
public var m_pickNites:Array;
public var m_pickEvents:Array;

public function sendPickGold(_islID:int, _slotID:int, _gold:int, _nite:int = 0, _event:int = 0):void
{
	if(m_pickIsldIDs == null) m_pickIsldIDs = new Array();
	if(m_pickSlotIDs == null) m_pickSlotIDs = new Array();
	if(m_pickGolds == null) m_pickGolds = new Array();
	if(m_pickNites == null) m_pickNites = new Array();
	if(m_pickEvents == null) m_pickEvents = new Array();
	m_pickIsldIDs.push(_islID);
	m_pickSlotIDs.push(_slotID);
	m_pickGolds.push(_gold);
	m_pickNites.push(_nite);
	m_pickEvents.push(_event);
	comboPickGoldUpdate(null);
}

public function comboPickGoldUpdate(event:TimerEvent):void
{
	if(m_pickIsldIDs != null && m_pickSlotIDs != null && m_pickGolds != null && m_pickNites != null)
	{
		trace("m_pickIsldIDs.length = " + m_pickIsldIDs.length + " event = " + (event!=null));
		if(event != null || m_pickIsldIDs.length == MAX_PICK_COMMAND)
		{
			// var slen:int = 2 + m_pickIsldIDs.length*(1 + 1 + 4 + 2 + 1);
			// trace("			slen=" + slen);
			// trace("			pickLen=" + m_pickIsldIDs.length);
			// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_PICKGOLD, slen);
			// buffer.writeShort(m_pickIsldIDs.length);
			// for(var i:int = 0; i < m_pickIsldIDs.length ;i++)
			// {
				// buffer.writeByte(m_pickIsldIDs[i]);
				// buffer.writeByte(m_pickSlotIDs[i]);
				// buffer.writeInt(m_pickGolds[i]);
				// buffer.writeShort(m_pickNites[i]);
				// buffer.writeByte(m_pickEvents[i]);
			// }
			// m_socketConnection.Write(buffer);
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(COMMAND_FARM_PICKGOLD);
			buffer.writeShort(m_pickIsldIDs.length);
			for(var i:int = 0; i < m_pickIsldIDs.length ;i++)
			{
				buffer.writeByte(m_pickIsldIDs[i]);
				buffer.writeByte(m_pickSlotIDs[i]);
				buffer.writeInt(m_pickGolds[i]);
				buffer.writeShort(m_pickNites[i]);
				buffer.writeByte(m_pickEvents[i]);
			}
			m_socketConnection.Write(packMessage(buffer));

			//Stop timer
			if (event!=null) {
				var _timer:Timer = Timer(event.target);
				_timer.stop();
			}

			//Reset Arrays
			m_pickIsldIDs = null;
			m_pickSlotIDs = null;
			m_pickGolds = null;
			m_pickNites = null;
			m_pickEvents = null;
		}
		else if(m_pickIsldIDs.length == 1)
		{
			//New Timer Tick
			var myTimer:Timer = new Timer(TIMEOUT_PICK_COMMAND, 1);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, comboPickGoldUpdate);
			myTimer.start();
		}
	}
}

public function handlePickGold(buff:ByteArray):void
{
	trace("handlePickGold ...");
	if(buff.readShort() == 0)
	{
		var i:int;

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		loadIslands(buff);

		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));

		var _num:int = buff.readShort();
		var _islID:Array = new Array(_num);
		var _slotID:Array = new Array(_num);
		var _goldGot:Array = new Array(_num);
		var _niteGot:Array = new Array(_num);

		for (i = 0 ; i < _num ; i++)
		{
			_islID[i] = buff.readByte();
			_slotID[i] = buff.readByte();
			_goldGot[i] = buff.readInt();
			_niteGot[i] = buff.readShort();
			trace("i =" + i + " _islID = " + _islID[i] + " Slot id = " + _slotID[i] +"_niteGot = " + _niteGot[i] +"_gold Got = " + _goldGot[i]);
		}
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GoldPicked , _islID , _slotID , _goldGot, _niteGot));
	}
}

public function sendGetDiary():void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_GET_DIARY, 0);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_GET_DIARY);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleGetDiary(buff:ByteArray):void
{
	trace("handleGetDiary ...");
	if(buff.readShort() == 0)
	{
		//Data Diary
		mUser.m_dataDiary.load(buff, 1);
		trace(mUser.m_dataDiary.toString());
		if(MainScene().mDiaryScene != null) MainScene().mDiaryScene.updateRecords();
	}
}

#define MAX_BHAVERST_COMMAND		3
#define TIMEOUT_BHAVERST_COMMAND	1500
public var m_bHaverstIsldIDs:Array;
public var m_bHaverstSlotIDs:Array;


public function sendBHaverst(_islID:int, _slotID:int):void
{
	// if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	if(m_bHaverstIsldIDs == null) m_bHaverstIsldIDs = new Array();
	if(m_bHaverstSlotIDs == null) m_bHaverstSlotIDs = new Array();
	m_bHaverstIsldIDs.push(_islID);
	m_bHaverstSlotIDs.push(_slotID);

	comboBHaverstUpdate(null);
}

public function comboBHaverstUpdate(event:TimerEvent):void
{
	if(m_bHaverstIsldIDs != null && m_bHaverstSlotIDs != null)
	{
		trace("m_bHaverstIsldIDs.length = " + m_bHaverstIsldIDs.length + " event = " + (event!=null));
		if(event != null || m_bHaverstIsldIDs.length == MAX_BHAVERST_COMMAND)
		{
			// var slen:int = 2 + m_bHaverstIsldIDs.length*(1 + 1);
			// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_BHAVERST, slen);
			// buffer.writeShort(m_bHaverstIsldIDs.length);
			// for(var i:int = 0; i < m_bHaverstIsldIDs.length ;i++)
			// {
				// buffer.writeByte(m_bHaverstIsldIDs[i]);
				// buffer.writeByte(m_bHaverstSlotIDs[i]);
			// }
			// m_socketConnection.Write(buffer);

			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(COMMAND_FARM_BHAVERST);
			buffer.writeShort(m_bHaverstIsldIDs.length);
			for(var i:int = 0; i < m_bHaverstIsldIDs.length ;i++)
			{
				buffer.writeByte(m_bHaverstIsldIDs[i]);
				buffer.writeByte(m_bHaverstSlotIDs[i]);
			}
			m_socketConnection.Write(packMessage(buffer));

			if(event != null)
			{
				//Stop timer
				var _timer:Timer = Timer(event.target);
				_timer.stop();
			}

			//Reset Arrays
			m_bHaverstIsldIDs = null;
			m_bHaverstSlotIDs = null;
		}
		else if(m_bHaverstIsldIDs.length == 1)
		{
			//New Timer Tick
			var myTimer:Timer = new Timer(TIMEOUT_BHAVERST_COMMAND, 1);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, comboBHaverstUpdate);
			myTimer.start();
		}
	}
}

public function handleBHaverst(buff:ByteArray):void
{
	trace("handleBHaverst ...");
	if(buff.readShort() == 0)
	{
		var i:int;

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		//read Stock
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		loadIslands(buff);

		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));

		var _num:int = buff.readShort();
		var _islID:Array = new Array(_num);
		var _slotID:Array = new Array(_num);
		var _giftPack:Array = new Array(_num);

		for (i = 0 ; i < _num ; i++)
		{
			_islID[i] = buff.readByte();
			_slotID[i] = buff.readByte();
			if (buff.readByte() == 1) {
				_giftPack[i] = new UserData_GiftPack();
				_giftPack[i].load(buff, 1);
				trace("i =" + i + " _islID = " + _islID[i] + " Slot id = " + _slotID[i] +" _giftPack = " + _giftPack[i].toString());
			}
		}

		// add flying effect
		var gift:UserData_Gift;
		for (i=0; i<_num; i++)
		{
			if (_giftPack && _giftPack[i])
			{
				for (var j:int=0; j < _giftPack[i].mGifts.length; j++)
				{
					gift = _giftPack[i].mGifts[j];
					if (gift.giftType == TYPE_GOLD || gift.giftType == TYPE_EXP)
					{
						GAMEOBJ.dispatchEvent(new GameEvent(GameEvent.AddFlyingObject, _islID[i], _slotID[i], gift.giftType, gift.giftNum , TYPE_BUILDING));
					}
					else if (gift.giftType == TYPE_DRAGON_NITE)
					{
						trace("--- type: " + gift.giftType + " island id: " + _islID[i] + ", slot id: " + _slotID[i] + ", num: " + gift.giftNum);
						if (_islID[i] >= 0 && _islID[i] < USERINFO().m_dataIslands.length)
						{
							var island:UserData_Island = USERINFO().m_dataIslands[_islID[i]];
							var building:UserData_Building = island.m_buildings[_slotID[i]];
							if (building != null && building.isEmpty() == false)
							{
								var buildingConst:ConstData_Building = DATACONST().getItem(TYPE_BUILDING , building.getItemId()) as ConstData_Building;
								GAMEOBJ.dispatchEvent(new GameEvent(GameEvent.AddFlyingObject, _islID[i], _slotID[i], gift.giftType, gift.giftNum , TYPE_BUILDING, buildingConst.abilitySID[0]));
							}
						}
					}

					if (gift.giftType == TYPE_GOLD)
						GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_COLLECT_GOLD_BUILDING, gift.giftNum));
					else if (gift.giftType == TYPE_EXP)
						GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_COLLECT_EXP_BUILDING, gift.giftNum));
					else if (gift.giftType == TYPE_DRAGON_NITE)
						GAMEOBJ.mQuestHandler.dispatchEvent(new GameEvent(GameEvent.QuestUpdate, CQuestConst.ACTION_COLLECT_NITE_BUILDING, gift.giftNum));

				}
			}
		}
	}
}

public function sendChatVisible(visible:Boolean):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_CHAT_VISIBLE, 1);
	// buffer.writeByte(visible?1:0);
	// m_socketConnection.Write(buffer);
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_CHAT_VISIBLE);
	buffer.writeByte(visible?1:0);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleChatVisible(buff:ByteArray):void
{
	if(buff.readShort() == 0)
	{
	}
}

//ZME ENCODE CREDIT
public function sendZMECreditEncode(visible:Boolean):void
{
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_ZME_CREDIT_ENCODE);
	//wParams to server here
	m_socketConnection.Write(packMessage(buffer));
}

public function handleZMECreditEncode(buff:ByteArray):void
{
	if(buff.readShort() == 0) //If error code success
	{
		//read Data Response to client
	}
	else//Error code fail
	{
	}
}


public function sendClientActive(active:Boolean):void
{
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_CHAT_VISIBLE, 1);
	// buffer.writeByte(visible?1:0);
	// m_socketConnection.Write(buffer);
	if(m_socketConnection != null)
	{
		var buffer:ByteArray = new ByteArray();
		buffer.writeShort(COMMAND_CLIENT_ACTIVE);
		buffer.writeByte(active?1:0);
		m_socketConnection.Write(packMessage(buffer));
	}
}

//BUILDING MOVING
public function sendMoveBuilding(_moveType:int, _islID:int, _slotID:int, _buildingID:int):void
{
	// var slen:int = 1 + 1 + 1 + 2;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_MOVEBUILDING, slen);
	// buffer.writeByte(_moveType);//MOVE_INV_TO_ISL || MOVE_ISL_TO_INV || MOVE_ISL_TO_ISL
	// buffer.writeByte(_islID);
	// buffer.writeByte(_slotID);
	// buffer.writeShort(_buildingID);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	if(_islID >= 0 && USERINFO().m_dataIslands[_islID].isLocked) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_MOVEBUILDING);
	buffer.writeByte(_moveType);//MOVE_INV_TO_ISL || MOVE_ISL_TO_INV || MOVE_ISL_TO_ISL
	buffer.writeByte(_islID);
	buffer.writeByte(_slotID);
	buffer.writeShort(_buildingID);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleMoveBuilding(buff:ByteArray):void
{
	trace("handleMoveBuilding ...");
	if(buff.readShort() == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		// mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this)); //@X.Truong - no need to dispatch event because game data is update in loop

		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		loadIslands(buff);
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));
	}
}


//Upgrade Building
public function sendUpgBuilding(_islID:int, _slotID:int, _unit:int):void
{
	// var slen:int = 1 + 1 + 1;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_UPGBUILDING, slen);
	// buffer.writeByte(_islID);
	// buffer.writeByte(_slotID);
	// buffer.writeByte(_unit);//UNIT_GOLD || UNIT_XU
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_UPGBUILDING);
	buffer.writeByte(_islID);
	buffer.writeByte(_slotID);
	buffer.writeByte(_unit);//UNIT_GOLD || UNIT_XU
	m_socketConnection.Write(packMessage(buffer));
}

public function handleUpgBuilding(buff:ByteArray):void
{
	trace("handleUpgBuilding ...");
	if(buff.readShort() == 0)
	{
		var islID:int = buff.readByte();
		var slotID:int = buff.readByte();
		var success:Boolean = (buff.readByte()==1);

		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this)); //@X.Truong - no need to dispatch event because game data is update in loop

		//read Payment
		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());
		mUser.m_dataPayment.dispatchEvent (new GameEvent (GameEvent.XuChanged , this)); //@X.Truong - no need to dispatch event because credit is update in loop

		//read Stock
		if (success) {
			loadIslands(buff);
		}
		else
		{
			var buildingData:UserData_Building = USERINFO().buildingAt(islID, slotID);
			var building:CBuilding = MainScene().getListIslands()[islID].buildingAt(slotID);
			building.updateFail();
		}
	}
}



public function sendMoveStatue(_moveType:int, _islID:int, _slotID:int, _statueID:int):void
{
	// var slen:int = 1 + 1 + 1 + 2;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_MOVESTATUE , slen);
	// buffer.writeByte(_moveType);//MOVE_INV_TO_ISL || MOVE_ISL_TO_INV || MOVE_ISL_TO_ISL
	// buffer.writeByte(_islID);
	// buffer.writeByte(_slotID);
	// buffer.writeShort(_statueID);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_MOVESTATUE);
	buffer.writeByte(_islID);
	buffer.writeByte(_slotID);
	buffer.writeShort(_statueID);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleMoveStatue(buff:ByteArray):void
{
	trace("handleMoveStatue ...");
	if(buff.readShort() == 0)
	{
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		loadIslands(buff);
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));
	}
}


public function sendMoveDecor(_moveType:int, _islSrc:int, _islDst:int, _srcID:int, _dstID:int , x:int , y:int):void
{
	// var slen:int = 1 + 1 + 1 + 2 + 2 + 2 + 2;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_MOVEDECOR, slen);
	// buffer.writeByte(_moveType);//MOVE_INV_TO_ISL || MOVE_ISL_TO_INV || MOVE_ISL_TO_ISL
	// buffer.writeByte(_islSrc);
	// buffer.writeByte(_islDst);
	// buffer.writeShort(_srcID);
	// buffer.writeShort(_dstID);
	// trace("=================> Move to " + x + " ,  " + y);
	// buffer.writeShort(x);
	// buffer.writeShort(y);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	if(_islSrc >= 0 && USERINFO().m_dataIslands[_islSrc].isLocked) return;
	if(_islDst >= 0 && USERINFO().m_dataIslands[_islDst].isLocked) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_MOVEDECOR);
	buffer.writeByte(_moveType);//MOVE_INV_TO_ISL || MOVE_ISL_TO_INV || MOVE_ISL_TO_ISL
	buffer.writeByte(_islSrc);
	buffer.writeByte(_islDst);
	buffer.writeShort(_srcID);
	buffer.writeShort(_dstID);
	trace("=================> Move to " + x + " ,  " + y);
	buffer.writeShort(x);
	buffer.writeShort(y);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleMoveDecor(buff:ByteArray):void
{
	trace("handleMoveDecor ...");
	if(buff.readShort() == 0)
	{
		mUser.m_dataStock.load(buff, 1);
		trace(mUser.m_dataStock.toString());
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));

		loadIslands(buff);
		mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));
	}
}


//SHOPPING
public function sendBuyItem(_itemType:int, _itemID:int, _num:int, _unit:int):void
{
	// var slen:int = 2 + 2 + 4 + 2;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_BUYITEM, slen);
	// buffer.writeShort(_itemType);
	// buffer.writeShort(_itemID);
	// buffer.writeInt(_num);
	// buffer.writeShort(_unit);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_BUYITEM);
	buffer.writeShort(_itemType);
	buffer.writeShort(_itemID);
	buffer.writeInt(_num);
	buffer.writeShort(_unit);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleBuyItem(buff:ByteArray):void
{
	trace("handleBuyItem ...");
	if(buff.readShort() == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this)); //@X.Truong - no need to dispatch event because game data is update in loop

		//read Payment
		mUser.m_dataPayment.load(buff, 2);
		trace(mUser.m_dataPayment.toString());
		mUser.m_dataPayment.dispatchEvent (new GameEvent (GameEvent.XuChanged , this)); //@X.Truong - no need to dispatch event because credit is update in loop

		var type:int = buff.readShort();
		var id:int = buff.readShort();
		var num:int = buff.readInt();

		//read Stock
		if (type == TYPE_DRAGON) {
			mUser.m_dataInventoryDragon.load(buff, 1);
			trace(mUser.m_dataInventoryDragon.toString());
			mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged , this));
		} else if (type == TYPE_BATTLE_EQUIPE) {
		} else {
			mUser.m_dataStock.load(buff, 1);
			trace(mUser.m_dataStock.toString());
			mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
			mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));
		}
		if (type >= 0 && id > 0 && num > 0) {
			mUser.m_dataGame.dispatchEvent(new GameEvent(GameEvent.ItemBought , type , id , num));
		}
	}
	else
	{

	}
}

public function sendSellItem(_itemType:int, _itemID:int, _num:int):void
{
	// var slen:int = 2 + 2 + 4;
	// var buffer:ByteArray = createCommandBuffer(0, COMMAND_FARM_SELLITEM, slen);
	// buffer.writeShort(_itemType);
	// buffer.writeShort(_itemID); //TYPE_DRAGON:SlotID, TYPE_EQUIPE:SlotID, Other:ItemID
	// buffer.writeInt(_num);
	// m_socketConnection.Write(buffer);
	if(USERINFO().mIsLockStat != LOCK_STATUS_OFF) return;
	var buffer:ByteArray = new ByteArray();
	buffer.writeShort(COMMAND_FARM_SELLITEM);
	buffer.writeShort(_itemType);
	buffer.writeShort(_itemID); //TYPE_DRAGON:SlotID, TYPE_EQUIPE:SlotID, Other:ItemID
	buffer.writeInt(_num);
	m_socketConnection.Write(packMessage(buffer));
}

public function handleSellItem(buff:ByteArray):void
{
	trace("handleSellItem ...");
	if(buff.readShort() == 0)
	{
		//read Game
		mUser.m_dataGame.load(buff, 1);
		trace (mUser.m_dataGame.toString());
		mUser.m_dataGame.dispatchEvent (new GameEvent (GameEvent.GameDataChanged , this));

		var type:int = buff.readShort();
		//read Stock
		if (type == TYPE_DRAGON) {
			mUser.m_dataInventoryDragon.load(buff, 1);
			trace(mUser.m_dataInventoryDragon.toString());
			mUser.m_dataInventoryDragon.dispatchEvent (new GameEvent (GameEvent.BaseInventoryChanged , this));
		} else if (type == TYPE_BATTLE_EQUIPE) {
		} else {
			mUser.m_dataStock.load(buff, 1);
			trace(mUser.m_dataStock.toString());
			mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockChanged , this));
			mUser.m_dataStock.dispatchEvent (new GameEvent (GameEvent.StockFake , this));
		}
	}
	else
	{

	}
}



//UTILITIES
public static function readBStr(buf:ByteArray, encode:String = "utf-8"):String
{
	var len:int = buf.readUnsignedByte();
	if(len)
		return buf.readMultiByte(len, encode);
	return "";
}

public static function readLong(buffer:ByteArray):Number
{
	var msb:int = buffer.readUnsignedInt();
	var lsb:int = buffer.readUnsignedInt();
	var result:Number;

	if (msb & 0x80000000)
	{
		msb ^= 0xFFFFFFFF;
		lsb ^= 0xFFFFFFFF;
		result = -(Number(msb)*4294967296 + Number(lsb) + 1);
	}
	else
	{
		result = Number(msb)*4294967296 + Number(lsb);
	}

	return result;
}

public static function readBArray(buf:ByteArray):ByteArray
{
	var array:ByteArray = new ByteArray();
	var len:int = buf.readUnsignedByte();
	if(len)
		buf.readBytes(array, 0, len);
	return array;

}

public static function readSArray(buf:ByteArray):ByteArray
{
	var array:ByteArray = new ByteArray();
	var len:int = buf.readUnsignedShort();
	if(len)
		buf.readBytes(array, 0, len);
	return array;

}

public static function rIntArray(bin:ByteArray):Vector.<int>
{
	var len:int = bin.readShort();
	var resultArr:Vector.<int> = new Vector.<int> ();

	for(var i:int = 0; i<len ;i++)
	{
		resultArr.push (bin.readInt ());
	}

	return resultArr;
}

public static function rLongArray(bin:ByteArray):Vector.<Number>
{
	var len:int = bin.readShort();
	var resultArr:Vector.<Number> = new Vector.<Number> ();

	for(var i:int = 0; i<len ;i++)
	{
		resultArr.push (readLong(bin));
	}

	trace("========rLongArray=======" +  resultArr);
	return resultArr;
}


public static function wBBin(buf:ByteArray, str:String, encode:String = "utf-8"):int
{
	var strByteArr:ByteArray = new ByteArray();
	strByteArr.writeMultiByte(str,encode);

	if(strByteArr != null)
	{
		buf.writeByte(strByteArr.length);
		buf.writeBytes(strByteArr);
	}
	else
	{
		buf.writeByte(0);
	}
	return strByteArr.length + 1;
}

public static function ip2int(ip:String):int
{
		var arr:Array = ip.split(".");
		if(arr.length == 4)
			return (parseInt(arr[0])<<24) | (parseInt(arr[1])<<16) |
					(parseInt(arr[2])<<8) | (parseInt(arr[3]));
		return 0;
}

public static function int2ip(i:int):String
{
	return ((i >> 24 ) & 0xFF) + "." + ((i >> 16 ) & 0xFF) + "." +
			((i >>  8 ) & 0xFF) + "." +	( i        & 0xFF);
}
