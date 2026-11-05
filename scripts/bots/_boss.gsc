/**
* file: scripts\bots\_boss.gsc
*
* Boss stages loaded from cfgs/boss.cfg.
* One cyclops and the upper body from spawnHitboxBot() share one damage pool.
*/

registerDvars()
{
	scripts\server\_settings::dvarString("surv", "boss_stages", "1;2;3;4");
	level.bossStageDefined = [];

	for(n = 1; n <= 4; n++)
	{
		level.bossStageDefined[n] = true;
		registerStage(n);
	}

	level.bossStageDefined[5] = (getDvar("surv_boss_health_stage5") != "" || getDvar("surv_boss_hud_title_stage5") != "" || getDvar("surv_boss_difficulty_stage5") != "");
	if(level.bossStageDefined[5])
		registerStage(5);
}

registerStage(n)
{
	scripts\server\_settings::dvarFloat("surv", "boss_difficulty_stage" + n, 1, 0.25, 5);

	scripts\server\_settings::dvarInt("surv", "boss_rifle_percent_stage" + n, numDef(n, "rifle_percent"), 0, 100);
	scripts\server\_settings::dvarInt("surv", "boss_rifle_mode_stage" + n, numDef(n, "rifle_mode"), 0, 5);
	scripts\server\_settings::dvarInt("surv", "boss_melee_percent_stage" + n, numDef(n, "melee_percent"), 0, 100);
	scripts\server\_settings::dvarInt("surv", "boss_melee_mode_stage" + n, numDef(n, "melee_mode"), 0, 5);
	scripts\server\_settings::dvarInt("surv", "boss_explosive_percent_stage" + n, numDef(n, "explosive_percent"), 0, 100);
	scripts\server\_settings::dvarInt("surv", "boss_explosive_mode_stage" + n, numDef(n, "explosive_mode"), 0, 5);
	scripts\server\_settings::dvarInt("surv", "boss_raygun_percent_stage" + n, numDef(n, "raygun_percent"), 0, 100);
	scripts\server\_settings::dvarInt("surv", "boss_raygun_mode_stage" + n, numDef(n, "raygun_mode"), 0, 5);
	scripts\server\_settings::dvarInt("surv", "boss_mg_turret_percent_stage" + n, numDef(n, "mg_percent"), 0, 100);
	scripts\server\_settings::dvarInt("surv", "boss_mg_turret_mode_stage" + n, numDef(n, "mg_mode"), 0, 5);
	scripts\server\_settings::dvarInt("surv", "boss_gl_turret_percent_stage" + n, numDef(n, "gl_percent"), 0, 100);
	scripts\server\_settings::dvarInt("surv", "boss_gl_turret_mode_stage" + n, numDef(n, "gl_mode"), 0, 5);

	scripts\server\_settings::dvarInt("surv", "boss_infection_stage" + n, numDef(n, "infection"), 0, 100);
	scripts\server\_settings::dvarFloat("surv", "boss_push_stage" + n, numDef(n, "push"), 0, 10);
	scripts\server\_settings::dvarFloat("surv", "boss_speed_stage" + n, numDef(n, "speed"), 0.25, 3);
	scripts\server\_settings::dvarInt("surv", "boss_health_stage" + n, numDef(n, "health"), 100, 100000);
	scripts\server\_settings::dvarFloat("surv", "boss_damage_stage" + n, 1, 0, 5);
	scripts\server\_settings::dvarInt("surv", "boss_stun_limit_stage" + n, 2000, 1, 100000);
	scripts\server\_settings::dvarFloat("surv", "boss_stun_gain_stage" + n, 1, 0, 10);
	scripts\server\_settings::dvarFloat("surv", "boss_stun_time_stage" + n, 3, 0, 30);
	scripts\server\_settings::dvarFloat("surv", "boss_stun_recovery_stage" + n, 2, 0, 30);

	scripts\server\_settings::dvarString("surv", "boss_fx_stage" + n, strDef(n, "fx"));
	scripts\server\_settings::dvarString("surv", "boss_targets_stage" + n, strDef(n, "targets"));
	scripts\server\_settings::dvarString("surv", "boss_attacks_stage" + n, strDef(n, "attacks"));

	scripts\server\_settings::dvarInt("surv", "boss_attack_melee_usage_stage" + n, numDef(n, "melee_usage"), 0, 2);
	scripts\server\_settings::dvarInt("surv", "boss_attack_melee_ignore_stun_stage" + n, 0, 0, 1);
	scripts\server\_settings::dvarInt("surv", "boss_attack_jump_usage_stage" + n, numDef(n, "jump_usage"), 0, 2);
	scripts\server\_settings::dvarInt("surv", "boss_attack_jump_ignore_stun_stage" + n, 0, 0, 1);
	scripts\server\_settings::dvarInt("surv", "boss_attack_soul_usage_stage" + n, numDef(n, "soul_usage"), 0, 2);
	scripts\server\_settings::dvarInt("surv", "boss_attack_soul_ignore_stun_stage" + n, numDef(n, "soul_ignore"), 0, 1);
	scripts\server\_settings::dvarInt("surv", "boss_attack_fire_usage_stage" + n, 0, 0, 2);
	scripts\server\_settings::dvarInt("surv", "boss_attack_fire_ignore_stun_stage" + n, 0, 0, 1);

	scripts\server\_settings::dvarString("surv", "boss_visual_stage" + n, strDef(n, "visual"));
	scripts\server\_settings::dvarString("surv", "boss_music_stage" + n, strDef(n, "music"));
	scripts\server\_settings::dvarFloat("surv", "boss_quake_stage" + n, numDef(n, "quake"), 0, 5);
	scripts\server\_settings::dvarString("surv", "boss_hud_color_stage" + n, strDef(n, "color"));
	scripts\server\_settings::dvarInt("surv", "boss_hud_lock_stage" + n, numDef(n, "lock"), 0, 1);
	scripts\server\_settings::dvarString("surv", "boss_hud_title_stage" + n, strDef(n, "title"));
	scripts\server\_settings::dvarString("surv", "boss_hud_desc_stage" + n, strDef(n, "desc"));
}

numDef(n, key)
{
	if(key == "rifle_percent")
	{
		if(n == 2 || n == 3)
			return 100;
		return 0;
	}
	if(key == "rifle_mode")
	{
		if(n == 2 || n == 3)
			return 5;
		return 0;
	}
	if(key == "melee_percent")
	{
		if(n == 3 || n == 4)
			return 100;
		return 0;
	}
	if(key == "melee_mode")
	{
		if(n == 3)
			return 5;
		if(n == 4)
			return 2;
		return 0;
	}
	if(key == "explosive_percent")
	{
		if(n == 1)
			return 100;
		if(n == 2)
			return 5;
		return 0;
	}
	if(key == "explosive_mode")
	{
		if(n == 1 || n == 2)
			return 5;
		if(n == 4)
			return 3;
		return 0;
	}
	if(key == "raygun_percent")
	{
		if(n == 1)
			return 5;
		if(n == 3)
			return 100;
		return 0;
	}
	if(key == "raygun_mode")
	{
		if(n == 1 || n == 3)
			return 5;
		if(n == 4)
			return 3;
		return 0;
	}
	if(key == "mg_percent")
	{
		if(n == 3)
			return 100;
		return 0;
	}
	if(key == "mg_mode")
	{
		if(n == 3)
			return 5;
		return 0;
	}
	if(key == "gl_percent")
	{
		if(n == 2)
			return 5;
		return 0;
	}
	if(key == "gl_mode")
	{
		if(n == 2)
			return 5;
		return 0;
	}
	if(key == "infection")
	{
		if(n == 2)
			return 20;
		return 0;
	}
	if(key == "push")
	{
		if(n == 2)
			return 2;
		if(n == 3)
			return 3;
		if(n == 4)
			return 1;
		return 0;
	}
	if(key == "speed")
	{
		if(n == 2)
			return 1.25;
		return 1;
	}
	if(key == "health")
	{
		if(n == 2 || n == 3)
			return 3100;
		return 1800;
	}
	if(key == "quake")
	{
		if(n == 3)
			return 1.4;
		return 0.8;
	}
	if(key == "melee_usage")
	{
		if(n == 4)
			return 2;
		return 0;
	}
	if(key == "jump_usage" || key == "soul_usage" || key == "soul_ignore" || key == "lock")
	{
		if(n == 4)
			return 1;
		return 0;
	}
	return 0;
}

strDef(n, key)
{
	if(key == "fx")
	{
		if(n == 3)
			return "fire";
		if(n == 4)
			return "aura";
		return "none";
	}
	if(key == "targets")
	{
		if(n == 4)
			return "gl_turrets;go_away";
		return "players";
	}
	if(key == "attacks")
	{
		if(n == 2)
			return "melee;jump";
		if(n == 3)
			return "melee;jump;fire";
		if(n == 4)
			return "soul;jump;melee";
		return "melee";
	}
	if(key == "visual")
	{
		if(n == 3)
			return "red_fog";
		if(n == 4)
			return "finale";
		return "dark_fog";
	}
	if(key == "music")
	{
		if(n == 3)
			return "ambient_inferno";
		if(n == 4)
			return "ambient_finale";
		return "ambient_boss";
	}
	if(key == "color")
	{
		if(n == 1)
			return "blue";
		if(n == 2)
			return "green";
		return "red";
	}
	if(key == "title")
	{
		if(n == 1)
			return "Armor";
		if(n == 2)
			return "Health";
		if(n == 3)
			return "Agony";
		if(n == 4)
			return "Demon spirit";
		return "Boss";
	}
	if(key == "desc")
	{
		if(n == 1)
			return "Break the armor with something explosive";
		if(n == 2)
			return "Feed the beast lead";
		if(n == 3)
			return "Fire from every gun";
		if(n == 4)
			return "Stun the beast and cut it apart";
		return "";
	}
	return "";
}

dvar(name, n)
{
	return level.dvar["surv_boss_" + name + "_stage" + n];
}

buildStage(n)
{
	stage = spawnstruct();
	stage.difficulty = dvar("difficulty", n);
	stage.rifle_percent = dvar("rifle_percent", n);
	stage.rifle_mode = dvar("rifle_mode", n);
	stage.melee_percent = dvar("melee_percent", n);
	stage.melee_mode = dvar("melee_mode", n);
	stage.explosive_percent = dvar("explosive_percent", n);
	stage.explosive_mode = dvar("explosive_mode", n);
	stage.raygun_percent = dvar("raygun_percent", n);
	stage.raygun_mode = dvar("raygun_mode", n);
	stage.mg_percent = dvar("mg_turret_percent", n);
	stage.mg_mode = dvar("mg_turret_mode", n);
	stage.gl_percent = dvar("gl_turret_percent", n);
	stage.gl_mode = dvar("gl_turret_mode", n);
	stage.infection = dvar("infection", n);
	stage.push = dvar("push", n);
	stage.speed = dvar("speed", n);
	stage.health = dvar("health", n);
	stage.damage = dvar("damage", n);
	stage.stunLimit = dvar("stun_limit", n);
	stage.stunGain = dvar("stun_gain", n);
	stage.stunTime = dvar("stun_time", n);
	stage.stunRecovery = dvar("stun_recovery", n);
	stage.fx = dvar("fx", n);
	stage.targets = strTok(dvar("targets", n), ";");
	stage.attacks = strTok(dvar("attacks", n), ";");
	stage.melee_usage = dvar("attack_melee_usage", n);
	stage.melee_ignore = dvar("attack_melee_ignore_stun", n);
	stage.jump_usage = dvar("attack_jump_usage", n);
	stage.jump_ignore = dvar("attack_jump_ignore_stun", n);
	stage.soul_usage = dvar("attack_soul_usage", n);
	stage.soul_ignore = dvar("attack_soul_ignore_stun", n);
	stage.fire_usage = dvar("attack_fire_usage", n);
	stage.fire_ignore = dvar("attack_fire_ignore_stun", n);
	stage.visual = dvar("visual", n);
	stage.music = dvar("music", n);
	stage.quake = dvar("quake", n);
	stage.hudColor = dvar("hud_color", n);
	stage.hudLock = dvar("hud_lock", n);
	stage.title = dvar("hud_title", n);
	stage.desc = dvar("hud_desc", n);
	stage.color = colorFor(stage.hudColor);

	if(stage.fx != "none" && stage.fx != "fire" && stage.fx != "aura")
		stage.fx = "none";
	if(!musicOk(stage.music))
		stage.music = "ambient_boss";
	if(stage.visual != "myst" && stage.visual != "dark_fog" && stage.visual != "green_fog" && stage.visual != "red_fog" && stage.visual != "finale" && stage.visual != "scary")
		stage.visual = "dark_fog";

	return stage;
}

musicOk(name)
{
	if(name == "zom_ambient" || name == "ambient_inferno" || name == "ambient_toxic" || name == "ambient_scary")
		return true;
	if(name == "ambient_tank" || name == "ambient_grouped" || name == "ambient_boss" || name == "ambient_finale")
		return true;
	return false;
}

colorFor(name)
{
	if(name == "red")
		return (1, 0.15, 0.05);
	if(name == "blue")
		return (0.2, 0.45, 1);
	if(name == "green")
		return (0.1, 0.85, 0.2);
	if(name == "cyan")
		return (0.2, 0.9, 0.95);
	if(name == "yellow")
		return (1, 0.9, 0.2);
	return (1, 1, 1);
}

loadStages()
{
	level.bossStages = [];
	level.bossOrder = [];

	raw = level.dvar["surv_boss_stages"];
	if(!isDefined(raw) || raw == "")
		raw = "1;2;3;4";

	tokens = strTok(raw, ";");
	for(i = 0; i < tokens.size; i++)
	{
		n = int(tokens[i]);
		if(n < 1 || n > 5)
		{
			bossError("Boss stage '" + tokens[i] + "' is outside 1-5 and was skipped");
			continue;
		}
		if(!isDefined(level.bossStageDefined) || !isDefined(level.bossStageDefined[n]) || !level.bossStageDefined[n])
		{
			bossError("Boss stage " + n + " has no settings and was skipped");
			continue;
		}
		level.bossOrder[level.bossOrder.size] = n;
		if(!isDefined(level.bossStages[n]))
			level.bossStages[n] = buildStage(n);
	}

	if(level.bossOrder.size == 0)
	{
		bossError("Boss stage list was empty. Using 1;2;3;4");
		level.bossOrder[0] = 1;
		level.bossOrder[1] = 2;
		level.bossOrder[2] = 3;
		level.bossOrder[3] = 4;
		for(i = 1; i <= 4; i++)
			level.bossStages[i] = buildStage(i);
	}

	level.bossOrderPos = 0;
}

bossError(text)
{
	iprintln("^1" + text);
	logPrint("BOSS; " + text + "\n");
}

begin()
{
	level.bossParent = self;
	level.bossDying = false;
	level.bossFight = true;
	level.bossSoulBusy = false;
	level.bossStunned = false;
	level.bossStunRecovering = false;
	level.bossStunPoints = 0;
	level.bossPhase = -1;
	level.bossDamageDone = 0;
	level.bossBarLocked = 0;

	self loadStages();
	self ghostBarrels();
	self applyStage();

	if(!isDefined(level.bossWatching) || !level.bossWatching)
	{
		level.bossWatching = true;
		level thread stunWatcher();
		level thread watchFightEnd();
	}
}

applyStage()
{
	n = level.bossOrder[level.bossOrderPos];
	level.bossStage = level.bossStages[n];
	stage = level.bossStage;

	level.bossStunned = false;
	level.bossStunRecovering = false;
	level.bossStunPoints = 0;
	level.bossDamageDone = 0;
	level.bossBarLocked = 0;
	level.bossPhase = -1;

	base = level.zom_types["boss"];
	self.runSpeed = base.runSpeed * stage.speed;
	self.meleeSpeed = base.meleeSpeed * stage.speed;
	self.damage = int(base.damage * stage.damage);
	self.infectionChance = stage.infection / 100;

	factor = 1;
	if(level.dvar["game_difficulty"] == 1)
		factor = 0.5;
	else if(level.dvar["game_difficulty"] == 2)
		factor = 0.8;
	else if(level.dvar["game_difficulty"] >= 4)
		factor = 1.5;

	players = level.activePlayers;
	if(!isDefined(players) || players < 1)
		players = 1;

	level.bossPool = int(stage.health * players * stage.difficulty * factor);
	if(level.bossPool < 1)
		level.bossPool = 1;

	self applyVisual(stage.visual);
	scripts\server\_environment::setAmbient(stage.music, 2, 1);
	self applyBodyFx();
	scripts\gamemodes\_hud::createBossHud(stage.title, stage.desc, stage.color);
	scripts\gamemodes\_hud::updateBossBar();
}

applyVisual(token)
{
	level notify("global_fx_end");

	if(token == "myst")
	{
		setExpFog(400, 1200, 0.65, 0.65, 0.65, 5);
		scripts\server\_environment::resetVision(5);
	}
	else if(token == "dark_fog")
	{
		scripts\server\_environment::setFog("boss", 5);
		scripts\server\_environment::setVision("boss", 5);
	}
	else if(token == "green_fog")
	{
		scripts\server\_environment::setFog("toxic", 5);
		scripts\server\_environment::resetVision(5);
	}
	else if(token == "red_fog")
	{
		scripts\server\_environment::setFog("grouped", 5);
		scripts\server\_environment::setVision("inferno", 5);
		scripts\server\_environment::setGlobalFX("ember");
	}
	else if(token == "finale")
	{
		scripts\server\_environment::setFog("finale", 5);
		scripts\server\_environment::setVision("finale", 5);
		scripts\server\_environment::setGlobalFX("finale");
	}
	else if(token == "scary")
	{
		scripts\server\_environment::setFog("scary", 5);
		scripts\server\_environment::setVision("night", 5);
	}
}

applyBodyFx()
{
	self notify("boss_fx_stop");
	self.bossAuraOn = false;
	if(isDefined(self.effect))
	{
		self.effect delete();
		self.effect = undefined;
	}

	if(level.bossStage.fx == "fire")
		self startFireAura();
	else if(level.bossStage.fx == "aura" && isDefined(level.soul_deathfx))
		self thread loopFx(level.soul_deathfx, "j_spinelower");
}

startFireAura()
{
	if(isDefined(self.bossAuraOn) && self.bossAuraOn)
		return;
	self.bossAuraOn = true;
	self thread loopFx(level.bossFireFX, "j_spinelower");
	self thread scripts\bots\_types::bossCatchFire();
}

loopFx(fx, tag)
{
	self endon("death");
	self endon("boss_fx_stop");
	level endon("wave_finished");

	org = spawn("script_model", self getTagOrigin(tag));
	org setModel("tag_origin");
	self.effect = org;
	wait 0.05;
	if(!isDefined(org))
		return;
	PlayFXOnTag(fx, org, "tag_origin");
	org linkTo(self);
}

advanceStage()
{
	boss = self;
	if(isDefined(level.bossParent))
		boss = level.bossParent;

	if(level.bossOrderPos + 1 < level.bossOrder.size)
	{
		level.bossOrderPos++;
		boss applyStage();
		return;
	}

	if(isDefined(level.bossDying) && level.bossDying)
		return;

	level.bossDying = true;
	scripts\gamemodes\_hud::destroyBossHud();
	if(isDefined(level.bossParent))
		level.bossParent thread scripts\bots\_types::dieDelay();
	else
		self thread scripts\bots\_types::dieDelay();
}

stunWatcher()
{
	level endon("game_ended");
	level endon("wave_finished");

	while(1)
	{
		wait 0.1;
		if(!isDefined(level.bossStage))
			continue;

		if(level.bossStunned && getTime() >= level.bossStunEnd)
		{
			level.bossStunned = false;
			level.bossStunPoints = 0;
			if(level.bossStage.stunRecovery > 0)
			{
				level.bossStunRecovering = true;
				level.bossRecoverEnd = getTime() + int(level.bossStage.stunRecovery * 1000);
			}
			else
				level.bossStunRecovering = false;
			scripts\gamemodes\_hud::updateBossBar();
		}
		else if(level.bossStunRecovering && getTime() >= level.bossRecoverEnd)
			level.bossStunRecovering = false;
	}
}

startStun()
{
	if(level.bossStunned)
		return;

	level.bossStunned = true;
	level.bossStunRecovering = false;
	level.bossStunPoints = level.bossStage.stunLimit;
	level.bossStunEnd = getTime() + int(level.bossStage.stunTime * 1000);
	scripts\gamemodes\_hud::updateBossBar();
}

watchFightEnd()
{
	level endon("game_ended");
	level waittill("wave_finished");

	level.bossFight = false;
	level.bossWatching = false;
	level.bossStunned = false;
	level.bossStage = undefined;

	if(isDefined(level.bossParent))
		level.bossParent notify("boss_fx_stop");

	scripts\gamemodes\_hud::destroyBossHud();
	restoreBarrels();
}

/* ---------- damage ---------- */

onDamage(sMeansOfDeath, sWeapon, iDamage, eAttacker, eInflictor)
{
	stage = level.bossStage;
	if(!isDefined(stage))
		return 0;

	channel = damageChannel(eInflictor, sMeansOfDeath, sWeapon);
	if(channel == "")
		return 0;

	if(isDefined(self.number) && self.number == 1 && channel == "explosive")
		return 0;

	percent = channelPercent(stage, channel);
	mode = channelMode(stage, channel);
	if(mode == 0)
		return 0;

	bar = false;
	stun = false;

	if(mode == 1 && !level.bossStunned)
		bar = true;
	else if(mode == 2 && level.bossStunned)
		bar = true;
	else if(mode == 3)
		stun = true;
	else if(mode == 4)
	{
		bar = true;
		stun = true;
	}
	else if(mode == 5)
		bar = true;

	if(level.bossStunned || level.bossStunRecovering)
		stun = false;

	filled = false;
	if(stun)
	{
		level.bossStunPoints += iDamage * stage.stunGain;
		if(level.bossStunPoints >= stage.stunLimit)
		{
			filled = true;
			self startStun();
		}
	}

	amount = 0;
	if(bar)
	{
		scaled = iDamage * percent / 100;
		amount = int(scaled);
		if(amount < 1 && scaled > 0)
			amount = 1;
	}

	if(amount > 0)
		showHit(eAttacker, (1, 0.15, 0.05), percent < 10);
	else if(filled)
		showHit(eAttacker, (0.2, 0.45, 1), percent < 10);

	if(amount > 0)
	{
		level.bossDamageDone += amount;
		if(isDefined(eAttacker) && isPlayer(eAttacker))
		{
			if(isDefined(eAttacker.stats) && isDefined(eAttacker.stats["damageDealtToBoss"]))
				eAttacker.stats["damageDealtToBoss"] += amount;
			eAttacker scripts\players\_players::incUpgradePoints(int(level.dvar["game_rewardscale"] / 20 * amount));
		}
		scripts\gamemodes\_hud::updateBossBar();
		if(level.bossDamageDone >= level.bossPool)
			self advanceStage();
	}

	return 0;
}

damageChannel(eInflictor, sMeansOfDeath, sWeapon)
{
	if(isDefined(eInflictor) && isDefined(eInflictor.isTurret) && eInflictor.isTurret)
	{
		if(isDefined(eInflictor.turret_type) && eInflictor.turret_type == "gl")
			return "gl";
		return "mg";
	}

	if(sMeansOfDeath == "MOD_MELEE")
		return "melee";

	if(sWeapon == "raygun_mp" || sWeapon == "raygunmk2_mp")
	{
		if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE")
			return "explosive";
		return "raygun";
	}

	if(explosiveMod(sMeansOfDeath) || explosiveWeapon(sWeapon))
		return "explosive";

	if(rifleWeapon(sWeapon))
		return "rifle";

	return "";
}

explosiveMod(mod)
{
	if(mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE")
		return true;
	return false;
}

explosiveWeapon(sWeapon)
{
	if(!isDefined(sWeapon) || !isDefined(level.weaponList[sWeapon]))
		return false;
	wepClass = level.weaponList[sWeapon]["class"];
	return wepClass == "weapon_explosive" || wepClass == "weapon_projectile";
}

rifleWeapon(sWeapon)
{
	if(!isDefined(sWeapon) || !isDefined(level.weaponList[sWeapon]))
		return false;

	wepClass = level.weaponList[sWeapon]["class"];
	if(wepClass == "weapon_pistol" || wepClass == "weapon_smg" || wepClass == "weapon_assault")
		return true;
	if(wepClass == "weapon_lmg" || wepClass == "weapon_shotgun" || wepClass == "weapon_sniper")
		return true;
	return false;
}

channelPercent(stage, channel)
{
	if(channel == "rifle")
		return stage.rifle_percent;
	if(channel == "melee")
		return stage.melee_percent;
	if(channel == "explosive")
		return stage.explosive_percent;
	if(channel == "raygun")
		return stage.raygun_percent;
	if(channel == "mg")
		return stage.mg_percent;
	if(channel == "gl")
		return stage.gl_percent;
	return 0;
}

channelMode(stage, channel)
{
	if(channel == "rifle")
		return stage.rifle_mode;
	if(channel == "melee")
		return stage.melee_mode;
	if(channel == "explosive")
		return stage.explosive_mode;
	if(channel == "raygun")
		return stage.raygun_mode;
	if(channel == "mg")
		return stage.mg_mode;
	if(channel == "gl")
		return stage.gl_mode;
	return 0;
}

showHit(attacker, color, shield)
{
	if(!isDefined(attacker) || !isPlayer(attacker))
		return;
	attacker scripts\players\_damagefeedback::bossDamageFeedback(color, shield);
}

turretAllows(turret, bot)
{
	if(!isDefined(bot) || !isDefined(bot.type) || bot.type != "boss")
		return true;
	if(isDefined(bot.untargetable) && bot.untargetable)
		return false;
	if(!isDefined(level.bossStage))
		return false;
	if(isDefined(turret.turret_type) && turret.turret_type == "gl")
		return level.bossStage.gl_mode != 0;
	return level.bossStage.mg_mode != 0;
}

/* ---------- movement and attacks ---------- */

think()
{
	if(!isDefined(level.bossStage))
		return;

	self breakNearbyBarrels();

	pick = self pickTarget();
	attack = self pickAttack();

	if(level.bossStunned)
	{
		self setanim("stand");
		self.cur_speed = 0;
		self runAttack(attack, pick);
		return;
	}

	if(isDefined(pick) && self scripts\bots\_bots::checkForBarricade(pick.origin))
	{
		self scripts\bots\_bots::zomMelee();
		return;
	}

	if(isDefined(pick) && pick.kind == "turret" && isDefined(pick.ent) && distance(self.origin, pick.origin) < self.meleeRange)
	{
		self smashTurret(pick.ent);
		return;
	}

	if(attack == "melee" || attack == "jump")
	{
		self runAttack(attack, pick);
		return;
	}

	if(attack == "soul")
		self launchSoul();
	else if(attack == "fire")
		self startFireAura();

	if(isDefined(pick) && distance(self.origin, pick.origin) > 48)
	{
		self scripts\bots\_bots::zomMovement();
		self scripts\bots\_bots::zomMoveTowards(pick.origin);
	}
	else
	{
		self setanim("stand");
		self.cur_speed = 0;
	}
}

runAttack(attack, pick)
{
	if(attack == "melee")
	{
		victim = self nearestPlayer(self.meleeRange);
		if(!isDefined(victim))
			return;
		self thread scripts\bots\_bots::zomMoveLockon(victim, self.meleeTime, self.meleeSpeed);
		self scripts\bots\_bots::zomMelee();
	}
	else if(attack == "jump")
		self doJump();
	else if(attack == "soul")
		self launchSoul();
	else if(attack == "fire")
		self startFireAura();
}

pickAttack()
{
	stage = level.bossStage;
	if(!isDefined(stage.attacks))
		return "";

	for(i = 0; i < stage.attacks.size; i++)
	{
		name = stage.attacks[i];
		if(name == "" || name == "none")
			continue;
		if(level.bossStunned && !attackIgnore(stage, name))
			continue;
		if(!usageAllows(stage, name))
			continue;
		if(name == "melee")
		{
			victim = self nearestPlayer(self.meleeRange);
			if(!isDefined(victim))
				continue;
		}
		if(name == "jump")
		{
			victim = self nearestPlayer(360);
			if(getTime() < level.nextBossJump || !isDefined(victim))
				continue;
		}
		if(name == "soul")
		{
			victim = self nearestPlayer(999999);
			if(level.bossSoulBusy || !isDefined(victim))
				continue;
		}
		if(name == "melee" || name == "jump" || name == "soul" || name == "fire")
			return name;
	}
	return "";
}

attackIgnore(stage, name)
{
	if(name == "melee")
		return stage.melee_ignore;
	if(name == "jump")
		return stage.jump_ignore;
	if(name == "soul")
		return stage.soul_ignore;
	if(name == "fire")
		return stage.fire_ignore;
	return 0;
}

attackUsage(stage, name)
{
	if(name == "melee")
		return stage.melee_usage;
	if(name == "jump")
		return stage.jump_usage;
	if(name == "soul")
		return stage.soul_usage;
	if(name == "fire")
		return stage.fire_usage;
	return 0;
}

usageAllows(stage, name)
{
	usage = attackUsage(stage, name);
	aliveList = livingPlayers();
	alive = aliveList.size;
	if(usage <= 0)
		return true;
	if(usage == 1)
		return alive > 1;
	return alive == 1;
}

doJump()
{
	self endon("death");
	self setanim("jump");
	playFX(level.bossShockwaveFX, self.origin);
	self playsound("boss_charge");
	wait 1.1;

	if(isDefined(level.bossStage) && level.bossStage.quake > 0)
		Earthquake(level.bossStage.quake, 1, self.origin, 600);

	if(isAlive(self))
	{
		self scripts\bots\_bots::zomAreaDamage(360);
		self playsound("detpack_explo_main");
	}

	wait 0.2;
	self setanim("stand");
	level.lastBossJump = getTime();
	level.nextBossJump = level.lastBossJump + 10000 + randomint(10000);
}

launchSoul()
{
	player = self nearestPlayer(999999);
	if(!isDefined(player) || level.bossSoulBusy)
		return;

	level.bossSoulBusy = true;
	self thread soulWatcher(player);
}

soulWatcher(player)
{
	self endon("death");
	level endon("wave_finished");
	self scripts\bots\_types::kill_ball_out(player);
	level.bossSoulBusy = false;
}

smashTurret(gun)
{
	self scripts\bots\_bots::zomMelee(false);
	if(!isDefined(gun))
		return;

	gun notify("kill_turret");
	bipod = gun.bipod;
	if(!isDefined(bipod) && isDefined(gun.owner))
		bipod = gun.owner.turret_bipod;
	if(isDefined(bipod))
		scripts\players\_turrets::deleteTurret(gun, bipod);
}

pushPlayer(dir, times)
{
	self endon("disconnect");
	self endon("death");

	if(!isDefined(times) || times < 1)
		return;

	for(i = 0; i < times; i++)
		self scripts\players\_players::bounce(dir);
}

pickTarget()
{
	stage = level.bossStage;
	if(!isDefined(stage.targets))
		return undefined;

	for(i = 0; i < stage.targets.size; i++)
	{
		token = stage.targets[i];
		pick = self targetFor(token);
		if(isDefined(pick))
			return pick;
	}
	return undefined;
}

targetFor(token)
{
	if(token == "" || token == "none")
		return undefined;

	if(token == "players" || token == "best_player" || token == "far_player" || token == "raygun_player")
	{
		player = self playerForToken(token);
		if(!isDefined(player))
			return undefined;
		return makePick(player.origin, player, "player");
	}

	if(token == "go_away")
	{
		nearest = self nearestPlayer(280);
		if(!isDefined(nearest))
			return undefined;
		return makePick(self awayFrom(nearest), undefined, "point");
	}

	if(token == "gl_turrets" || token == "mg_turrets")
	{
		kind = "minigun";
		if(token == "gl_turrets")
			kind = "gl";
		gun = self nearestTurret(kind);
		if(!isDefined(gun))
			return undefined;
		return makePick(gun.origin, gun, "turret");
	}

	if(token == "map_center")
	{
		center = mapCenter();
		if(!isDefined(center))
			return undefined;
		return makePick(center, undefined, "point");
	}

	return undefined;
}

makePick(origin, ent, kind)
{
	pick = spawnstruct();
	pick.origin = origin;
	pick.ent = ent;
	pick.kind = kind;
	return pick;
}

playerForToken(token)
{
	if(token == "players")
		return self nearestPlayer(999999);
	if(token == "raygun_player")
		return self nearestRaygun();
	if(token == "best_player")
		return bestPlayer();
	if(token == "far_player")
		return farPlayer();
	return undefined;
}

nearestPlayer(maxDist)
{
	best = undefined;
	bestDist = maxDist;
	list = livingPlayers();
	for(i = 0; i < list.size; i++)
	{
		dist = distance(self.origin, list[i].origin);
		if(dist <= bestDist)
		{
			bestDist = dist;
			best = list[i];
		}
	}
	return best;
}

nearestRaygun()
{
	best = undefined;
	bestDist = 999999;
	list = livingPlayers();
	for(i = 0; i < list.size; i++)
	{
		if(!holdingRaygun(list[i]))
			continue;
		dist = distance(self.origin, list[i].origin);
		if(dist < bestDist)
		{
			bestDist = dist;
			best = list[i];
		}
	}
	return best;
}

bestPlayer()
{
	best = undefined;
	bestScore = undefined;
	list = livingPlayers();
	for(i = 0; i < list.size; i++)
	{
		score = 0;
		if(isDefined(list[i].score))
			score = list[i].score;
		if(!isDefined(best) || score > bestScore)
		{
			best = list[i];
			bestScore = score;
		}
	}
	return best;
}

farPlayer()
{
	list = livingPlayers();
	if(list.size == 0)
		return undefined;

	center = (0, 0, 0);
	for(i = 0; i < list.size; i++)
		center = (center[0] + list[i].origin[0], center[1] + list[i].origin[1], center[2] + list[i].origin[2]);
	center = (center[0] / list.size, center[1] / list.size, center[2] / list.size);

	best = undefined;
	bestDist = -1;
	for(i = 0; i < list.size; i++)
	{
		dist = distance(center, list[i].origin);
		if(dist > bestDist)
		{
			bestDist = dist;
			best = list[i];
		}
	}
	return best;
}

awayFrom(player)
{
	dir = self.origin - player.origin;
	if(distance(self.origin, player.origin) < 1)
		dir = (1, 0, 0);
	else
		dir = vectorNormalize(dir);
	return self.origin + dir * 400;
}

mapCenter()
{
	if(!isDefined(level.waypoints) || level.waypoints.size == 0)
		return undefined;

	center = (0, 0, 0);
	for(i = 0; i < level.waypoints.size; i++)
		center = (center[0] + level.waypoints[i].origin[0], center[1] + level.waypoints[i].origin[1], center[2] + level.waypoints[i].origin[2]);
	return (center[0] / level.waypoints.size, center[1] / level.waypoints.size, center[2] / level.waypoints.size);
}

nearestTurret(kind)
{
	best = undefined;
	bestDist = 999999;
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(!isDefined(player) || !isDefined(player.turret_gun))
			continue;
		gun = player.turret_gun;
		if(!isDefined(gun.isTurret) || !gun.isTurret)
			continue;
		if(!isDefined(gun.turret_type) || gun.turret_type != kind)
			continue;
		dist = distance(self.origin, gun.origin);
		if(dist < bestDist)
		{
			bestDist = dist;
			best = gun;
		}
	}
	return best;
}

holdingRaygun(player)
{
	wep = player getCurrentWeapon();
	if(!isDefined(wep) || wep == "" || wep == "none")
		return false;
	if(isDefined(level.weaponKeyC2S) && isDefined(level.weaponKeyC2S[wep]))
		wep = level.weaponKeyC2S[wep];
	return wep == "raygun_mp" || wep == "raygunmk2_mp";
}

livingPlayers()
{
	list = [];
	for(i = 0; i < level.players.size; i++)
	{
		if(playerOk(level.players[i]))
			list[list.size] = level.players[i];
	}
	return list;
}

playerOk(player)
{
	if(!isDefined(player))
		return false;
	if(!isReallyPlaying(player))
		return false;
	if(isDefined(player.isDown) && player.isDown)
		return false;
	if(isDefined(player.isZombie) && player.isZombie)
		return false;
	return true;
}

/* ---------- barrels ---------- */

ghostBarrels()
{
	if(!isDefined(level.dynamic_barricades))
		return;
	for(i = 0; i < level.dynamic_barricades.size; i++)
	{
		if(isDefined(level.dynamic_barricades[i]))
			level.dynamic_barricades[i] setContents(0);
	}
}

restoreBarrels()
{
	if(!isDefined(level.dynamic_barricades))
		return;
	for(i = 0; i < level.dynamic_barricades.size; i++)
	{
		if(isDefined(level.dynamic_barricades[i]))
			level.dynamic_barricades[i] setContents(1);
	}
}

breakNearbyBarrels()
{
	if(!isDefined(level.dynamic_barricades))
		return;

	for(i = 0; i < level.dynamic_barricades.size; i++)
	{
		ent = level.dynamic_barricades[i];
		if(!isDefined(ent) || !isDefined(ent.hp) || ent.hp <= 0)
			continue;
		if(distance(self.origin, ent.origin) <= 72)
			ent thread scripts\players\_barricades::doBarricadeDamage(ent.hp);
	}
}
