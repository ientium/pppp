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
#define GOSSIP_SENDER_CHANGENAME                       62   //改名
#define GOSSIP_SENDER_LEVELUP                          63   //等级提升
#define GOSSIP_SENDER_CHANGERACE                       64   //修改种族
#define GOSSIP_SENDER_INQUIRECOIN_CHANGE              601   //修改种族
#define GOSSIP_SENDER_BACK						       59    //返回

#define C_FLYINGMON_COIN          50           //需要50积分开瞬飞一个月
#define C_TIMETOCOIN              7200          //每2小时变化1点积分
#define C_FLYINGMONSECOND         2592000       //瞬飞30天的秒数
#define C_CHANGENAME_COIN         300           //改名需要300点
#define C_LEVELUP_COIN            10          //提升一级需要的点数
#define C_MAXLEVEL_COIN           500          //直接满级需要点数
	
#define GOSSIP_VIP_TEXT_INQUIRECOIN					"我想要查询我的积分"
#define GOSSIP_VIP_TEXT_INSTANTFLIGHT				"我想要了解瞬飞的事"
#define GOSSIP_VIP_TEXT_CHANGENAME					"我想要修改名字"
#define GOSSIP_VIP_TEXT_LEVELUP						"我想要提升等级"
#define GOSSIP_VIP_TEXT_CHANGERACE					"我想要改变种族"
#define GOSSIP_VIP_TEXT_BACK						"返回"
#define GOSSIP_VIP_TEXT_VENDOR                      "查看出售物品"
#define GOSSIP_VIP_TEXT_INQUIRECOIN_CHANGE          "现在转换积分"

/*###
# start menues for VIPNPC (engineering and leatherworking)
###*/
void SendChildMenu_INQUIRECOIN(Player* pPlayer, Creature* pCreature) {
	
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INQUIRECOIN_CHANGE, GOSSIP_SENDER_INQUIRECOIN_CHANGE, GOSSIP_ACTION_INFO_DEF + 1);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_BACK, GOSSIP_SENDER_BACK, GOSSIP_ACTION_INFO_DEF + 2);
	char sMessage[200];
	sprintf(sMessage, "尊敬的%s勇士，您的剩余积分为%d,未转化积分为%d", pPlayer->GetName(), pPlayer->getVipInfo(4), pPlayer->getVipInfoTimeToCoin() / C_TIMETOCOIN);
	pPlayer->SEND_GOSSIP_TEXT(sMessage);
	pPlayer->SEND_GOSSIP_MENU(0x7FFFFFFF, pCreature->GetGUID()); //80001为VIP商人菜单

}
bool GossipHello_npc_prof_vipnpc(Player* pPlayer, Creature* pCreature)
{
	sLog.outDebug("==========================================================打开菜单选项.");
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INQUIRECOIN, GOSSIP_SENDER_MAIN, GOSSIP_SENDER_INQUIRECOIN);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_INSTANTFLIGHT, GOSSIP_SENDER_MAIN, GOSSIP_SENDER_INSTANTFLIGHT);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_CHANGENAME, GOSSIP_SENDER_MAIN, GOSSIP_SENDER_CHANGENAME);
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_CHANGERACE, GOSSIP_SENDER_MAIN, GOSSIP_SENDER_CHANGERACE);
	if (pPlayer->getLevel() < 60) {
	{
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_VIP_TEXT_LEVELUP, GOSSIP_SENDER_MAIN, GOSSIP_SENDER_LEVELUP);
	}
	pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, GOSSIP_VIP_TEXT_VENDOR, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_TRADE);
		//char sMessage[200];
		//sprintf(sMessage, "欢迎您， %s !", pPlayer->GetName());
		//pPlayer->SEND_GOSSIP_TEXT(sMessage);
		pPlayer->SEND_GOSSIP_MENU(0x7FFFFFFF, pCreature->GetGUID()); //80001为VIP商人菜单
		return true;
	}
}
bool GossipSelect_npc_prof_vipnpc(Player* pPlayer, Creature* pCreature, uint32 uiSender, uint32 uiAction)
{
	switch (uiSender)
	{
	case GOSSIP_SENDER_INQUIRECOIN:   //查询积分
		SendChildMenu_INQUIRECOIN(pPlayer, pCreature);
		break;
	case GOSSIP_SENDER_INSTANTFLIGHT:  //瞬飞
		//SendActionMenu_npc_prof_leather(pPlayer, pCreature, uiAction);
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
