# Class abilities

Audit of player class abilities in `scripts/players/_abilities.gsc`, checked against the strings in `english/localizedstrings/abilities.str` and the gameplay code that reads those flags.

Class abilities are rank unlocks that stack. They are not a pick-one loadout. With `game_class_ranks 1`, the stored stat is turned into `stat + 1` before the unlock check. Rank 30 is reachable (the stat caps at 29). If class ranks are turned off, everyone is treated as rank 30 and every slot opens.

| Slot | Opens at rank |
|---|---|
| Passive 1 | 1 (always) |
| Primary 1 | 5 |
| Passive 2 | 10 |
| Primary 2 | 15 |
| Passive 3 | 20 |
| Primary 3 | 25 |
| Passive 4 | 30 |

The F-special is hold Use for about 1 second. Only three names are wired: Soldier Rampage, Armored Invincibility, Engineer Augmented Turrets. The `recharge_time` values on those three are never read. The bar fills from kills, sprees, medic heals, engineer ammo, and armored knife hits. It is ready on spawn.

Throwable kits (medkit, ammo box, forcefield) do use their recharge timers. They are the killstreak weapons `radar_mp`, `airstrike_mp`, and `helicopter_mp` under the script names `medic_mp`, `supply_mp`, and `forcefield_mp`.

Weapon-type damage bonuses (rifles, LMGs, SMGs, knives, explosives) are not applied anywhere. `getDamageModifier()` only adds weapon-upgrade multipliers.

Status values used below:

| Status | Meaning |
|---|---|
| Works | Behavior matches the description, with notes only for extra detail. |
| Partial | Some of the described effect runs. The rest is missing or different. |
| Broken | Code exists and starts, then fails or causes a bad side effect. |
| Missing | The case is empty, or a flag is set and never read. |

Of the 35 named class slots, 12 work as described, 5 are only partial or broken, and 18 do nothing.

## Soldier

Base: 115 health. Works.

| Slot | Rank | Name | Status | What the script does |
|---|---|---|---|---|
| Primary 1 | 5 | Strong Bullet | Works | Sets `specialty_bulletpenetration` (Deep Impact) and `specialty_bulletdamage` (Stopping Power). Penetration matches the text. Stopping Power is extra damage the text does not mention. Both are real CoD4 perks. |
| Primary 2 | 15 | Rampage | Partial | 15 seconds. Faster reload (`specialty_fastreload`), red screen tint, and 2 health about 40 times over the duration (about 80 health). `specialty_rof` is also set for faster fire. That perk is not in the stock CoD4 perk table, so faster fire only happens if this build's engine honors it. The stored 50-second recharge is ignored. |
| Primary 3 | 25 | Rocket Control | Missing | The case is empty. Rockets are unchanged. |
| Passive 1 | 1 | Rifle Expertise | Missing | The case is empty. No +10% assault-rifle damage. |
| Passive 2 | 10 | Gun Master | Works | `specialty_fastreload`. Rampage will not remove it afterward. |
| Passive 3 | 20 | Regeneration | Works | +1 health every 1 second, up to max health. Stops while downed. |
| Passive 4 | 30 | Immunity | Works | +5 max health (120 total) and `infectionMP = 0`, so zombie melee infection chance becomes 0. |

The class blurb matches Rampage.

## Specialist

Base: 100 health, move speed 1.02, and `specialty_quieter` (Dead Silence). The speed change works. Dead Silence only quiets footsteps for other players. Zombie detection does not use it.

| Slot | Rank | Name | Status | What the script does |
|---|---|---|---|---|
| Primary 1 | 5 | Crossbow | Missing | The case is empty. No crossbow is given. |
| Primary 2 | 15 | Fake Death | Missing | The case is empty. No F-special is assigned, so the class has no Use-button special. |
| Primary 3 | 25 | Quick Escape | Broken | Below 25% health it sets `visible = false` (zombies skip that player in `zomSpot`), adds 0.2 move speed, and applies a green tint. It then waits on `level.special_quickescape_duration` and `level.special_quickescape_intermission`. Those variables are never set. The wait fails, `end_trance` never fires, and the player stays hidden and sped up until downed. Downed state does clear it. |
| Passive 1 | 1 | Way of the Assassin | Missing | The case is empty. No damage bonus or penalty by weapon type. |
| Passive 2 | 10 | Agile Blade | Missing | The case is empty. `knifeDamageMP` is never read by damage code. |
| Passive 3 | 20 | Silent Boots | Missing | The case is empty. Walking does not stop zombies from spotting you. |
| Passive 4 | 30 | Explosive Crossbow | Missing | The text describes an explosive crossbow. The script only sets `hasRadar = true`, and nothing reads `hasRadar`. |

The class blurb says the special is Fake Death. That ability is not in the script.

## Armored

Base health 140 and speed 0.95 do not apply. `loadGeneralAbilities()` checks the class name `"amored"` (missing `r`). Armored players stay at 100 health and speed 1.

| Slot | Rank | Name | Status | What the script does |
|---|---|---|---|---|
| Primary 1 | 5 | Menu: Melee Warrior. Code: throwable forcefield | Partial | Melee damage is unchanged. The script gives `forcefield_mp`, clip 0, two recharge threads of 180 seconds, so the first ready moment grants 2 charges. Thrown shield lasts 30 seconds, radius 128, damage taken inside is multiplied by 0.4 (60% reduction). Any player in range gets it. A chat line prints the reduced damage on every hit. Any armored knife hit also fills the F-special bar. That knife recharge is not tied to this slot. |
| Primary 2 | 15 | Invincibility | Works | 20 seconds of god mode, infection chance 0, and a pulsing blue overlay. Hold Use to start it. When it ends it forces `infectionMP = 1`, which wipes Resistant Skin's infection reduction until the class is loaded again. |
| Primary 3 | 25 | Heavily Armored | Missing | `heavyArmor` and the armor HUD are commented out. Damage is not halved above 65% health. |
| Passive 1 | 1 | Heavy Gunner | Missing | The case is empty. No LMG bonus or SMG/sniper/pistol penalty. |
| Passive 2 | 10 | Extreme Strength | Partial | Sets `specialty_bulletaccuracy` (Steady Aim, hipfire). The +35% melee damage in the text is not applied. |
| Passive 3 | 20 | Machine Gunner | Missing | The case is empty. No faster LMG reload and no extra LMG damage. |
| Passive 4 | 30 | Resistant Skin | Works | Incoming damage times 0.9. Infection chance times 0.65. Invincibility's cleanup sets infection chance back to 1. |

The class blurb describes a health shield and invincibility. Invincibility works. The shield (Heavily Armored) and the 140 health do not.

## Engineer

Base: 100 health, speed 1. No class base bonus.

| Slot | Rank | Name | Status | What the script does |
|---|---|---|---|---|
| Primary 1 | 5 | Ammo Box | Works | Gives `supply_mp`, one charge after 75 seconds, box lasts 15 seconds, radius 120. Each second, a living player inside gets 10% of that weapon's max stock (special weapons are skipped). `ammoboxRestoration = 25` is never used. The engineer gains upgrade points and F-special charge from this. |
| Primary 2 | 15 | Augmented Turrets | Works | Hold Use. Fails with a message if turrets are disabled or this player has no unoccupied owned turret. GL turret: fire delay halved, +2 bullets, +200 range, cooldown times 0.8. Sentry: bullets times 2, damage bonus times 2, +300 range, cooldown times 0.5. The stored 1-second recharge is ignored. The bar refills from kills like the other F-specials. Picking the turret back up keeps the boost. |
| Primary 3 | 25 | Turret Engineering | Works | Owned turrets stay out for `game_turret_time * 1.4` (120 seconds in `rotu.cfg`, so 168 seconds). |
| Passive 1 | 1 | Rifle Engineering | Missing | The case is empty. No rifle, LMG, shotgun, or explosive damage bonus. Barricade repair time is a fixed 1 second for everyone. |
| Passive 2 | 10 | Gas Mask | Works | `toxicImmunity` makes crawler toxic clouds skip this player. |
| Passive 3 | 20 | Repair Tools | Missing | The case is empty. The string already says unimplemented. |
| Passive 4 | 30 | Incendiary Ammo | Missing | The case is empty. `igniteBot()` exists and is never called. |

The class blurb matches the ammo box and the turret boost.

## Medic

Base: 110 health. Works.

| Slot | Rank | Name | Status | What the script does |
|---|---|---|---|---|
| Primary 1 | 5 | Medkit | Works | Gives `medic_mp`, clip 0, two recharge threads of 60 seconds, so the first ready moment grants 2 charges. Kit lasts 12 seconds, heals 25 health per second, radius 120, living players only. Healing another player gives upgrade points and a little F-special charge. |
| Primary 2 | 15 | Healing Aura | Missing | The case is empty. Aura stats exist (60 second recharge, 20 second duration, 35 heal) and a heal-glow effect is loaded, but nothing starts an aura and the F-special switch has no `"aura"` case. Medic has no Use-button special. |
| Primary 3 | 25 | Health Transfusion | Broken | On a direct hit, 20% chance, at most once a second, heals 3% of max health. The text says 3% of missing health, and the zombie does not lose extra health. `lastTransfusion` starts as boolean `false`, and the check does `false + 1000`. That is an invalid script operation and can abort the zombie damage function before the hit is applied. |
| Passive 1 | 1 | Paramedic | Works | Revive time is `surv_revivetime` (3 seconds) minus 1.5, so 1.5 seconds. That is twice as fast. |
| Passive 2 | 10 | Mobile Vaccine | Works | This player can use an infected teammate and cure them. Move speed times 1.10. |
| Passive 3 | 20 | Oath of Help | Partial | While the revive bar is running, damage taken is halved. `ui_damagereduced` is set for the HUD. No shield entity is spawned. |
| Passive 4 | 30 | Poisonous Bullets | Missing | The case is empty. `poisonBot()` exists and is never called. |

The class blurb says the special is a healing aura. The working active tool is the medkit. Reviving a player also gives a medic 8 special charge, but there is no special to spend it on.

## Summary

| Class | Works | Partial or broken | Missing |
|---|---|---|---|
| Soldier | Strong Bullet, Gun Master, Regeneration, Immunity | Rampage | Rocket Control, Rifle Expertise |
| Specialist | — | Quick Escape | Crossbow, Fake Death, Way of the Assassin, Agile Blade, Silent Boots, Explosive Crossbow |
| Armored | Invincibility, Resistant Skin | Melee Warrior / forcefield, Extreme Strength | Heavily Armored, Heavy Gunner, Machine Gunner. Base 140 health and 0.95 speed also fail (class name typo `"amored"`). |
| Engineer | Ammo Box, Augmented Turrets, Turret Engineering, Gas Mask | — | Rifle Engineering, Repair Tools, Incendiary Ammo |
| Medic | Medkit, Paramedic, Mobile Vaccine | Health Transfusion, Oath of Help | Healing Aura, Poisonous Bullets |

## Selectable and common abilities

The secondary slot (`SC_AB1` through `SC_AB5`) and the four common abilities are not in the game.

| Piece | State |
|---|---|
| Class menu secondary button and common-ability block | Commented out |
| `SOLDIER_SC_*` and the other class secondary strings | Do not exist. Common entries are placeholder titles. |
| `getAbilityAllowed()` for secondary slots 4 and 5 | Commented out, so those two can never pass |
| Class loaders | Only handle `"PR"` and `"PS"`. A `"SC"` call does nothing |

## Dead helpers

These functions are never started by a class ability: `dynamicAccuracy()`, `glow_heal_ball_out()`, `restoreSmokeGrenade()`, `restoreInvisibility()`. `restoreMonkey()` belongs to the monkey bomb, not a class.

Every class also gets `specialty_pistoldeath` (Last Stand) from `loadGeneralAbilities()`. That is separate from the mod's own downed state.
