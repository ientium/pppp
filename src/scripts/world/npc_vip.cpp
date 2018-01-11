/* Copyright (C) 2006 - 2009 ScriptDev2 <https://scriptdev2.svn.sourceforge.net/>
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

/* ScriptData
SDName: Npc_Professions
SD%Complete: 80
SDComment: Provides learn/unlearn/relearn-options for professions. Not supported: Unlearn engineering, re-learn engineering, re-learn leatherworking.
SDCategory: NPCs
EndScriptData */

#include "scriptPCH.h"

/*
A few notes for future developement:
- A full implementation of gossip for GO's is required. They must have the same scripting capabilities as creatures. Basically,
there is no difference here (except that default text is chosen with `gameobject_template`.`data3` (for GO type2, different dataN for a few others)
- It's possible blacksmithing still require some tweaks and adjustments due to the way we _have_ to use reputation.
*/

/*
-- UPDATE `gameobject_template` SET `ScriptName` = 'go_soothsaying_for_dummies' WHERE `entry` = 177226;
*/



/*############################################################################################################
# VIP商人点数消费
############################################################################################################*/

/*###
# VIP价格定义
###*/

#define GOSSIP_SENDER_INQUIRECOIN                      60   //查询积分
#define GOSSIP_SENDER_INSTANTFLIGHT                    61   //瞬飞操作
#define GOSSIP_SENDER_INSTANTFLIGHT_START              611  //瞬飞开通
#define GOSSIP_SENDER_CHANGENAME                       62   //改名
#define GOSSIP_SENDER_LEVELUP                          63   //等级提升
#define GOSSIP_SENDER_CHANGERACE                       64   //修改种族
#define GOSSIP_SENDER_INQUIRECOIN_CHANGE              601   //修改积分
#define GOSSIP_SENDER_BACK						       59    //返回

#define C_FLYINGMON_COIN          50           //需要50积分开瞬飞一个月
#define C_TIMETOCOIN              7200          //每2小时变化1点积分
#define C_FLYINGMONSECOND         2592000       //瞬飞30天的秒数
#define C_CHANGENAME_COIN         300           //改名需要300点
#define C_LEVELUP_COIN            10          //提升一级需要的点数
#define C_MAXLEVEL_COIN           500          //直接满级需要点数


#define GOSSIP_VIP_TEXT_INQUIRECOIN					"我想查询我的积分"
#define GOSSIP_VIP_TEXT_INSTANTFLIGHT				"我想了解瞬飞的事"
#define GOSSIP_VIP_TEXT_CHANGENAME					"我想修改名字"
#define GOSSIP_VIP_TEXT_LEVELUP						"我想提升等级"
#define GOSSIP_VIP_TEXT_CHANGERACE					"我想改变种族"
#define GOSSIP_VIP_TEXT_BACK						"返回"
#define GOSSIP_VIP_TEXT_VENDOR                      "查看出售物品"
#define GOSSIP_VIP_TEXT_INQUIRECOIN_CHANGE          "现在转换积分"

/*###
# start menues for VIPNPC (engineering and leatherworking)
###*/
//返回操作
void SendChildMenu_Main(Player* pPlayer, Creature* pCreature) {

	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INQUIRECOIN, GOSSIP_SENDER_INQUIRECOIN, 1);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INSTANTFLIGHT, GOSSIP_SENDER_INSTANTFLIGHT, 2);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_CHANGENAME, GOSSIP_SENDER_CHANGENAME, 3);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_CHANGERACE, GOSSIP_SENDER_CHANGERACE, 4);
	if (pPlayer->getLevel() <= DEFAULT_MAX_LEVEL)
	{
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_LEVELUP, GOSSIP_SENDER_LEVELUP, 5);
	}
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, GOSSIP_VIP_TEXT_VENDOR, GOSSIP_ACTION_TRADE, 6);
	char sMessage[100];
	sprintf(sMessage, "欢迎您,%s!", pPlayer->GetName());
	pPlayer->SEND_GOSSIP_TEXT(sMessage);
	pPlayer->SEND_GOSSIP_MENU(0x7FFFFFFF, pCreature->GetGUID()); //80001为VIP商人菜单

}
void SendChildMenu_INQUIRECOIN(Player* pPlayer, Creature* pCreature, uint32 uiAction) {
	int t_coin = (pPlayer->getVipInfoTimeToCoin() / C_TIMETOCOIN);
	switch (uiAction)
	{
		case 1:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INQUIRECOIN_CHANGE, GOSSIP_SENDER_INQUIRECOIN, GOSSIP_SENDER_INQUIRECOIN_CHANGE);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_BACK, GOSSIP_SENDER_BACK,2);
			char sMessage[200];
			sprintf(sMessage, "尊敬的 %s,您的剩余积分为 %d,未转化积分为 %d.", pPlayer->GetName(), pPlayer->getVipInfo(-1), t_coin);
			pPlayer->SEND_GOSSIP_TEXT(sMessage);
			pPlayer->SEND_GOSSIP_MENU(0x7FFFFFFF, pCreature->GetGUID()); //80001为VIP商人菜单
		break;
		case GOSSIP_SENDER_INQUIRECOIN_CHANGE:
			int flag = pPlayer->setVipMemberCoin(C_TIMETOCOIN);  //每7200秒转换1分
			if (flag < 0) {
			}else if(flag == 0) {
				char sMessage[100];
				sprintf(sMessage, "您的等级未达到 %d 级.", DEFAULT_MAX_LEVEL);
				pCreature->MonsterSay(sMessage, LANG_UNIVERSAL);
			}
			else if (flag == 1) {
				char sMessage[100];
				sprintf(sMessage, "转换了 %d 积分.", t_coin);
				pCreature->MonsterSay(sMessage, LANG_UNIVERSAL);
				pPlayer->CLOSE_GOSSIP_MENU();
			}
		break;
	}
	

}
void SendChildMenu_INSTANTFLIGHT(Player* pPlayer, Creature* pCreature, uint32 uiAction) {
	uint32 timetemp = pPlayer->getVipInfo(2) - time(NULL);   //获取瞬飞到期时间和当前时间的差值
	switch (uiAction)
	{
		case 1:
			if (pPlayer->getVipInfo(2) > 0)
			{
				if (timetemp > 0) {
					char sMessage[100];

					std::stringstream strtime;
					time_t currenttime = pPlayer->getVipInfo(2);
					char tAll[100];
					strftime(tAll, sizeof(tAll), "%Y年%m月%d日%H时.", localtime(&currenttime));
					strtime << tAll;
					sprintf(sMessage, "尊敬的 %s,您的瞬飞时间到期时间为 %s", pPlayer->GetName(), strtime.str());
					pPlayer->SEND_GOSSIP_TEXT(sMessage);
				}
				char sMessage[200];
				if (pPlayer->getVipInfo(2) > 0) {

					sprintf(sMessage, "花费%d积分,续费1个月瞬飞服务. ", C_FLYINGMON_COIN);

				}
				else {
					sprintf(sMessage, "1个月瞬飞服务需要花费%d积分,现在开通? ", C_FLYINGMON_COIN);
				}
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, sMessage, GOSSIP_SENDER_INSTANTFLIGHT, GOSSIP_SENDER_INSTANTFLIGHT_START); //611
			}
			else {
				pPlayer->SEND_GOSSIP_TEXT("您还未开通瞬飞服务. ");
			}
			pPlayer->SEND_GOSSIP_MENU(0x7FFFFFFF, pCreature->GetGUID()); //80001为VIP商人菜单
		break;
		case GOSSIP_SENDER_INSTANTFLIGHT_START: //点击瞬飞操作
			char sMessage[100];
			if (pPlayer->getVipInfo(-1) > C_FLYINGMON_COIN) {
				pPlayer->setUpdateVIPFlyingTime(C_FLYINGMONSECOND, C_FLYINGMON_COIN);
				
				std::stringstream strtime;
				time_t currenttime = pPlayer->getVipInfo(2);
				char tAll[100];
				strftime(tAll, sizeof(tAll), "%Y年%m月%d日%H时.", localtime(&currenttime));
				strtime << tAll;
				sprintf(sMessage, "瞬飞已开通,您的瞬飞时间到期时间为 %s.", strtime.str());
				pCreature->MonsterSay(sMessage, LANG_UNIVERSAL);
				SendChildMenu_Main(pPlayer, pCreature);
			}else {
				sprintf(sMessage, "积分不足,开通瞬飞服务需要 %d积分.", C_FLYINGMON_COIN);
				pCreature->MonsterSay(sMessage, LANG_UNIVERSAL);
			}
		break;
	}
}

bool GossipHello_npc_prof_vipnpc(Player* pPlayer, Creature* pCreature)
{
	SendChildMenu_Main(pPlayer, pCreature);
	
	/*pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INQUIRECOIN, GOSSIP_SENDER_INQUIRECOIN,1);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INSTANTFLIGHT, GOSSIP_SENDER_INSTANTFLIGHT,2);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_CHANGENAME,  GOSSIP_SENDER_CHANGENAME,3);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_CHANGERACE, GOSSIP_SENDER_CHANGERACE,4);
	if (pPlayer->getLevel() <= DEFAULT_MAX_LEVEL)
	{
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_LEVELUP,GOSSIP_SENDER_LEVELUP,5);
	}
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, GOSSIP_VIP_TEXT_VENDOR, GOSSIP_ACTION_TRADE,6);
	char sMessage[200];
	sprintf(sMessage, "欢迎您， %s !", pPlayer->GetName());
	pPlayer->SEND_GOSSIP_TEXT(sMessage);
	pPlayer->SEND_GOSSIP_MENU(0x7FFFFFFF, pCreature->GetGUID()); //80001为VIP商人菜单*/
	return true;

}
bool GossipSelect_npc_prof_vipnpc(Player* pPlayer, Creature* pCreature, uint32 uiSender, uint32 uiAction)
{
	switch (uiSender)
	{
	case GOSSIP_SENDER_INQUIRECOIN:   //查询积分
		SendChildMenu_INQUIRECOIN(pPlayer, pCreature,uiAction);
		break;
	case GOSSIP_SENDER_INSTANTFLIGHT:  //瞬飞
		SendChildMenu_INSTANTFLIGHT(pPlayer,pCreature,uiAction);
		break;
	case GOSSIP_SENDER_CHANGENAME:     //改名
		//SendActionMenu_npc_prof_leather(pPlayer, pCreature, uiAction);
		break;
	case GOSSIP_SENDER_CHANGERACE:     //修改种族
		//SendActionMenu_npc_prof_leather(pPlayer, pCreature, uiAction);
		break;
	case GOSSIP_SENDER_LEVELUP:        //升级
		//SendActionMenu_npc_prof_leather(pPlayer, pCreature, uiAction);
		break;
	case GOSSIP_ACTION_TRADE:        //交易商店
		pPlayer->SEND_VENDORLIST(pCreature->GetGUID());
		break;
	case  GOSSIP_SENDER_BACK:        //返回
		SendChildMenu_Main(pPlayer,pCreature);

		break;
	}
	return true;
}


/*###
# start menues for GO (engineering and leatherworking)
###*/

/*bool GOHello_go_soothsaying_for_dummies(Player* pPlayer, GameObject* pGo)
{
pPlayer->ADD_GOSSIP_ITEM(0,GOSSIP_LEARN_DRAGON, GOSSIP_SENDER_INFO, GOSSIP_ACTION_INFO_DEF);
pPlayer->SEND_GOSSIP_MENU(5584, pGo->GetGUID());

return true;
}*/

/*###
#
###*/

void AddSC_npc_vip()
{
	Script *newscript;

	newscript = new Script;
	newscript->Name = "npc_prof_vipnpc";
	newscript->pGossipHello = &GossipHello_npc_prof_vipnpc; //主菜单
	newscript->pGossipSelect = &GossipSelect_npc_prof_vipnpc;
	newscript->RegisterSelf();
	/*newscript = new Script;
	newscript->Name = "go_soothsaying_for_dummies";
	newscript->pGOHello =  &GOHello_go_soothsaying_for_dummies;
	//newscript->pGossipSelect = &GossipSelect_go_soothsaying_for_dummies;
	newscript->RegisterSelf();*/
}
