/**
* vim: set ft=cpp:
* file: scripts\players\_spree.gsc
*
* authors: Luk, 3aGl3, Bipo, Etheross
* team: SOG Modding
*
* project: RotU - Revolution
* website: http://survival-and-obliteration.com/
*
* Reign of the Undead - Revolution by Luk and 3aGl3
* You may modify this code to your liking or reuse it, as long as you give credit to those who wrote it
* Based on Reign of the Undead 2.1 created by Bipo and Etheross
*/

/***
*
*	TODO: Add file description
*
*/

#include scripts\include\hud; //Required for spree hud

/**
 * Initialzing per player that spawns.
 */

onPlayerSpawn()
{
	self.spree = 0;
	if (!isdefined(self.hud_streak)) //Check if hud is already loaded for the spree's
		streakHud();
}

/**
 * Main function
 * We check how big the spree already is and play the sound required for that spree.
 * After that we start the reset spree timer function
 * @see spreetimer
 */

checkSpree() 
{
	self endon("disconnect");
	self endon("death");
	self notify("end_spree");
	
	self.spree++;
	if (self.spree > 1) 
	{
		if (self.hud_streak.alpha == 0) 
		{
			self.hud_streak.alpha = 1;
		}
		self.hud_streak setvalue(self.spree);
		self.hud_streak fontPulse(self);
		switch (self.spree) 
		{
			case 0:
			case 1:
				break; 
			// The above is just in case somthing goes wrong with the if
			case 2:
				self playlocalsound("double_kill");
			break;
			case 3:
				self.laststreak = "triple";
				self stoplocalsound("double_kill");
				self playlocalsound("triple_kill");
				break;
			case 4:
			case 5:
			case 6:
				if(self.laststreak != "multi")
				{
					self.laststreak = "multi";
					self stoplocalsound("triple_kill");
					self playlocalsound("multikill");
				}
				break;
			case 7:
			case 8:
				if(self.laststreak != "killing")
				{
					self.laststreak = "killing";
					self stoplocalsound("multikill");
					self playlocalsound("killing_spree");
				}
				break;
			case 9:
			case 10:
				if(self.laststreak != "ultra")
				{
					self.laststreak = "ultra";
					self stoplocalsound("killing_spree");
					self playlocalsound("ultrakill");

				}
				break;
			case 11:
			case 12:
				if(self.laststreak != "mega")
				{
					self.laststreak = "mega";
					self stoplocalsound("ultrakill");
					self playlocalsound("megakill");
				}
				break;
			case 13:
			case 14:
				if(self.laststreak != "ludicrous")
				{
					self.laststreak = "ludicrous";
					self stoplocalsound("megakill");
					self playlocalsound("ludicrouskill");
				}
				break;
			case 15:
			case 16:
			case 17:
			case 18:
			case 19:
				if(self.laststreak != "holy")
				{
					self.laststreak = "holy";
					self stoplocalsound("ludicrouskill");
					self playlocalsound("holyshit");
				}
				break;
			default:
				if(self.laststreak != "wicked")
				{
					self.laststreak = "wicked";
					self stoplocalsound("holyshit");
					self playlocalsound("wickedsick");
				}
				break;
		}
	} 
	else 
	{
		self.laststreak = "";
	}
	self thread spreetimer();
}

/**
 * This function will wait 1,25 seconds or reset if called again before processing the spree
 * @see processspree
 */

spreetimer()
{
	self endon("disconnect");
	self endon("death");
	self notify("end_spree");
	self endon("end_spree");
	
	wait 1.25;
	self thread processspree(self.laststreak, self.spree);
}

/**
 * This function will process the end spree and grant the required xp
 * @param streak We send in the current streakname so its data won't get lost when it gets reset during the procesing
 * @param spree We send in the current intger amount of the spree so it's data won't get lost when it gets reset during the procesing
 */

processspree(streak, spree)
{
	self endon("disconnect");
	self endon("death");
	
	if(!isdefined(streak) || !isdefined(spree))
		return;
	
	self.spree = 0;
	self.laststreak = "";
	self.hud_streak fadeovertime(.5);
	self.hud_streak.alpha = 0;
	if (streak != "" && spree != 0) 
		iprintln(&"ZOMBIEUI_SPREE_ANNOUNCE", spreeTitle(streak), self, spree);
	
	if(spree == 2)
	{
		self scripts\players\_rank::giveRankXP("spree", 5);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(5);
	}
	else if(streak == "triple")
	{
		self scripts\players\_rank::giveRankXP("spree", 15);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(15);
	}
	else if(streak == "multi")
	{
		self scripts\players\_rank::giveRankXP("spree", 40);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(30);
	}
	else if(streak == "killing")
	{
		self scripts\players\_rank::giveRankXP("spree", 90);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(70);
	}
	else if(streak == "ultra")
	{
		self scripts\players\_rank::giveRankXP("spree", 190);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(95);
	}
	else if(streak == "mega")
	{
		self scripts\players\_rank::giveRankXP("spree", 440);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(125);
	}
	else if(streak == "ludicrous")
	{
		self scripts\players\_rank::giveRankXP("spree", 940);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(160);
	}
	else if(streak == "holy")
	{
		self scripts\players\_rank::giveRankXP("spree", 1940);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(200);
	}
	else if(streak == "wicked")
	{
		self scripts\players\_rank::giveRankXP("spree", 3940);
		if (self.curClass == "soldier")
			self scripts\players\_abilities::rechargeSpecial(300);
	}
}

spreeTitle(token)
{
	switch(token)
	{
		case "triple": return &"ZOMBIEUI_SPREE_TRIPLE";
		case "multi": return &"ZOMBIEUI_SPREE_MULTI";
		case "killing": return &"ZOMBIEUI_SPREE_KILLING";
		case "ultra": return &"ZOMBIEUI_SPREE_ULTRA";
		case "mega": return &"ZOMBIEUI_SPREE_MEGA";
		case "ludicrous": return &"ZOMBIEUI_SPREE_LUDICROUS";
		case "holy": return &"ZOMBIEUI_SPREE_HOLY";
		case "wicked": return &"ZOMBIEUI_SPREE_WICKED";
		default: return &"ZOMBIEUI_SPREE_TRIPLE";
	}
}
