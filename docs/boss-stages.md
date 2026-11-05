# Boss stages

Wave token `7` in `surv_waves` is the boss. Token `9` is the finale and is a different fight. The default wave list is `0;?;0;?;?;?;7;20;?;?;?;?;0;7;9`.

The fight is one cyclops plus the upper body from `spawnHitboxBot()`. Both bodies share one scripted health pool. Hits do not reduce the entity's own health. `onDamage` always returns 0, so the engine never kills the boss from a shot. When the last stage is emptied, the script kills the boss. The child body dies first, and that death ends the wave.

Settings live in `cfgs/boss.cfg`, loaded from `cfgs/general.cfg`. The file is Windows-1251 because the HUD strings are Russian. The script reads them in `scripts/bots/_boss.gsc` when settings load. A cfg edit applies on the next server start. Stages 1–4 are always registered. Stage 5 is registered only when `surv_boss_health_stage5`, `surv_boss_hud_title_stage5`, or `surv_boss_difficulty_stage5` is already set. This cfg does not define stage 5.

## Stage order

`surv_boss_stages` is a `;` list of indexes. The shipped value is `1;2;3;4`. Repeats are allowed (`1;1;2` runs stage 1 twice). An index outside 1–5 is skipped. An index whose settings were never registered is skipped. If nothing valid remains, the fight uses `1;2;3;4`.

Each stage starts with a fresh pool, a fresh stun meter, and no leftover damage from the previous stage.

## Health pool

The bar is remaining health. It starts full and shrinks to empty.

```
pool = stage health × active players × stage difficulty × game-difficulty factor
```

`active players` is everyone still in the round, including downed players, and not spectators. The count is taken once, when that stage starts. Joins and leaves during the stage do not resize the pool. A missing count is treated as 1. The pool is at least 1.

`surv_boss_difficulty_stageN` is a float from 0.25 to 5. Every shipped stage uses 1.

The game-difficulty factor is the menu difficulty, separate from the stage multiplier:

| Game difficulty | Factor |
|---|---|
| 1 Easy | 0.5 |
| 2 Medium | 0.8 |
| 3 Normal | 1 |
| 4 and above | 1.5 |

On Normal with one player, stage 1 and stage 4 have 1800 health, stage 2 has 2800, and stage 3 has 3600. Four players on stage 2 is `2800 × 4 = 11200`.

## Damage he deals

Melee, jump, and barricade hits use `int(80 × stage damage) × dif_zomDamMod`. Every shipped stage has damage 1, so the base hit is 80 before the player-count modifier. The soul orb is `int(50 × dif_zomDamMod × stage damage)`. Fire ticks use the melee value times a small random fraction of the game difficulty.

`dif_zomDamMod` is the same modifier normal zombies use. It refreshes every 5 seconds, so it follows the live player count during the fight:

| Players | Modifier | Melee hit at damage 1 |
|---|---|---|
| 1–5 | 0.5 | 40 |
| 6–10 | 0.75 | 60 |
| 11–15 | 1 | 80 |
| 16–20 | 1.25 | 100 |
| 21–25 | 1.5 | 120 |
| 26–30 | 1.75 | 140 |
| 31+ | 2 | 160 |

A landed melee can infect. The stage chance is `surv_boss_infection_stageN` percent, then the target's own infection multiplier applies. Push is `surv_boss_push_stageN` (0–10). Zero means no knockback. Above zero, the existing bounce runs that many times. The `boss` shellshock still lasts 2 seconds when push is 0.

Speed (`surv_boss_speed_stageN`, 0.25–3) multiplies run speed and melee speed. Walk speed stays 20. Base run is 58, base melee speed is 30, melee range is 160.

## Damage he takes

Each weapon channel has a percent (0–100) and a mode (0–5). The bar uses the raw hit, before Stopping Power and other player damage modifiers. A positive result that would round down to 0 still removes 1. Upgrade points are `int(game_rewardscale / 20 × bar damage)` and are awarded only when the bar moves.

| Mode | Bar | Stun meter |
|---|---|---|
| 0 | No | No |
| 1 | Only while he is not stunned | No |
| 2 | Only while he is stunned | No |
| 3 | No | Raw hit × stun gain |
| 4 | At the percent, in either state | Raw hit × stun gain |
| 5 | At the percent, in either state | No |

Mode 3 ignores the percent. The meter uses the raw hit.

Channels, checked in this order:

| Channel | What counts |
|---|---|
| MG turret | Inflictor is a minigun turret. Bullets use the weapon name `turret_mp`, so the turret check comes before the rifle check. |
| GL turret | Inflictor is a GL turret. |
| Melee | `MOD_MELEE`, including a raygun bash. |
| Raygun | A direct `raygun_mp` or `raygunmk2_mp` hit. |
| Explosive | Frags, C4, claymores, underbarrel grenades, RPGs, barrels, and raygun splash. |
| Rifle | Pistol, SMG, assault, LMG, shotgun, sniper. |

Anything that matches none of those is ignored and shows no marker.

One explosion can touch both bodies. The same attacker and weapon in the same millisecond is counted once. A blast that reaches only the upper body still counts. A rifle, melee, or direct raygun shot that hits both bodies in that same millisecond is also counted once. Pellets that only strike one body still each count. The upper body is untargetable, so turrets do not acquire it. A turret whose mode is 0 does not acquire the boss. Mode 3 or 4 still acquires him when the percent is 0.

## Hit markers

One marker per hit. Zombie hits stay white. Boss hits replace that marker.

| Result | Marker |
|---|---|
| Bar damage above 10%, and this hit did not add stun | Red cross |
| This hit added stun, and the bar damage is not above 10% | Light-blue cross |
| This hit added stun and the bar damage is above 10% | Violet cross |
| No stun added and no bar damage, including a fully ignored hit | Shield icon, centered, 24×24 |

"Added stun" means this hit put points into the meter. A partial fill flashes too, not only the hit that starts the stun. Exactly 10% bar damage with no stun shows neither the cross nor the shield. A stun hit does not also show the shield.

## Stun

The meter is not drawn. Modes 3 and 4 add `raw damage × surv_boss_stun_gain_stageN`. The percent is not used. At `surv_boss_stun_limit_stageN` he is stunned for `surv_boss_stun_time_stageN` seconds.

While he is stunned, more stun hits add nothing and do not refresh the timer. He does not walk. An attack runs only when its ignore-stun flag is 1.

When the timer ends, the meter drops to 0 and `surv_boss_stun_recovery_stageN` seconds begin. He can attack again. Stun hits still add nothing. After recovery, the meter can fill again.

The limit does not grow with the player count, so more players fill it faster.

## HUD

Title, bar, then description, centered at the top. Title and description are the literal cfg strings, not localized `.str` entries. Title size is 2.0. Description size is 1.4 and sits under the bar.

Colors: `red`, `blue`, `green`, `cyan`, `yellow`, and anything else as white.

`surv_boss_hud_lock_stageN` set to 1 freezes the drawn fill while he is not stunned and draws that fill in pulsing gray. Damage still counts. The bar catches up when the stun starts. Stage 4 is the only shipped stage with the lock on.

During last chance the HUD fades out and comes back if the round continues. It is destroyed when the map ends.

## Targets

`surv_boss_targets_stageN` is a `;` list. The first token that finds something inside its radius wins.

A token can set that radius itself: `gl_turrets:800`. A token with no radius uses `surv_boss_target_range_stageN` (default 1000). `players` with no radius has no cap, so it remains the fallback. `go_away`, `map_center`, and `none` ignore the radius. `go_away` still triggers at 280.

| Token | He moves toward |
|---|---|
| `players` | Nearest living player inside the radius |
| `best_player` | Highest score among living players inside the radius |
| `far_player` | Living player inside the radius who is farthest from that group's center |
| `raygun_player` | Nearest living player inside the radius who is holding a raygun |
| `go_away` | A point 400 units away, only if a player is inside 280 |
| `gl_turrets` | Nearest GL turret inside the radius. Inside melee range he smashes it. |
| `mg_turrets` | Nearest minigun turret inside the radius. Inside melee range he smashes it. |
| `map_center` | Average of the map waypoints |
| `none` | Nothing |

`surv_boss_turret_hits` (default 3) is how many smashes a turret takes, MG and GL alike. The killing smash plays `explosions/grenadeExp_blacktop` on the gun, then the turret is removed.

Living means in the round, not down, and not a zombie.

## Attacks

`surv_boss_attacks_stageN` is a `;` list. The first attack that is allowed right now wins.

| Attack | When it can start |
|---|---|
| `melee` | A living player is inside melee range, and the 2 second melee cooldown has finished. After the swing he stands for 2 seconds so the player can leave. Barricade swings and turret smashes are not on this cooldown. |
| `jump` | A living player is inside 360, and 10–20 seconds have passed since the last jump. The quake strength is `surv_boss_quake_stageN`, radius 600, duration 1 second. |
| `soul` | A living player exists and no volley is already out. One orb per living player, then he waits until that volley ends. He can still walk during the orbs. |
| `fire` | Turns on the fire aura. Ticks pause while he is stunned unless fire ignore-stun is 1. |
| `none` | Skip |

Usage, per attack: `0` anyone, `1` anyone except the last living player, `2` only the last living player. Ignore-stun `1` lets that attack run during the stun. Usage 1 never aims a soul at the last player, because the attack is not allowed then.

Map barricades still stop him and he melees them. Placed barrels are not walls for him. A barrel within 72 is destroyed. Fuel barrels still explode, and that blast uses the explosive rules. During the fight, barrel models are non-solid, including barrels placed mid-fight. They become solid again when the wave ends.

## Look and sound

| Visual | What plays |
|---|---|
| `myst` | Light gray fog, default vision |
| `dark_fog` | Boss fog and boss vision |
| `green_fog` | Crawler toxic fog, default vision |
| `red_fog` | Grouped red fog, inferno vision, ember FX |
| `finale` | Finale fog, finale vision, finale FX |
| `scary` | Close black fog, night vision |

Music is one of `zom_ambient`, `ambient_inferno`, `ambient_toxic`, `ambient_scary`, `ambient_tank`, `ambient_grouped`, `ambient_boss`, `ambient_finale`. An unknown name falls back to `ambient_boss`.

Body FX: `none`, `fire` on the torso, or `aura` (`misc/soul_death`) on the head. The boss wave does not apply the old lightning preset over the stage visual.

## Shipped stages

Percent / mode. A mode 0 channel deals nothing. A mode 3 channel stuns and does not move the bar, so its percent is unused.

### Stage 1 — Броня

Пробейте броню чем-то взрывным.

Explosives and the GL turret move the bar. A direct raygun tickles it. Rifles and melee do nothing. He walks slower than normal and prefers a GL turret, otherwise the nearest player. Dark fog, boss music, blue bar.

| | Rifle | Melee | Explosive | Raygun | MG | GL |
|---|---|---|---|---|---|---|
| Percent | 0 | 0 | 100 | 5 | 0 | 11 |
| Mode | 0 | 0 | 5 | 5 | 0 | 5 |

Difficulty 1, speed 0.7, health 1800, damage 1, infection 0, push 0. Stun limit 2000, gain 1, stun 3s, recovery 2s. FX none. Targets `gl_turrets:800;players`. Attacks `melee`, usage 0. Quake 0.8. HUD blue, unlocked.

### Stage 2 — Здоровье

Накормите тварь свинцом!

Bullets, a little explosive and raygun damage, and both turrets move the bar. Melee does not. He can infect and knock players back. He goes for a minigun turret inside 800, then the highest-scoring player inside 1200, then the nearest player. Crawler green fog and crawler music, green bar.

| | Rifle | Melee | Explosive | Raygun | MG | GL |
|---|---|---|---|---|---|---|
| Percent | 40 | 0 | 11 | 5 | 11 | 11 |
| Mode | 5 | 0 | 5 | 5 | 5 | 5 |

Difficulty 1, speed 1, health 2800, damage 1, infection 20, push 2. Same stun defaults as stage 1. FX none. Targets `mg_turrets:800;best_player:1200;players`. Attacks `melee;jump`, both usage 0. Quake 0.8. HUD green, unlocked.

### Stage 3 — Агония

Огонь из всех орудий!

Rifles, melee, rayguns, and the minigun move the bar. Explosives do nothing. The GL turret still does a little. He is faster, knocks harder, and burns. He prefers a minigun turret inside 800, then a player holding a raygun inside 1000, then the nearest player. Red fog, inferno music, red bar.

| | Rifle | Melee | Explosive | Raygun | MG | GL |
|---|---|---|---|---|---|---|
| Percent | 30 | 100 | 0 | 60 | 100 | 11 |
| Mode | 5 | 5 | 0 | 5 | 5 | 5 |

Difficulty 1, speed 1.25, health 3600, damage 1, infection 0, push 3. Same stun defaults. FX `fire`. Targets `mg_turrets:800;raygun_player:1000;players`. Attacks `melee;jump;fire`, all usage 0, none ignore stun. Quake 1.4. HUD red, unlocked.

### Stage 4 — Демонический дух

Оглушите тварь и устройте резню!

Rifles do nothing. Explosives, direct rayguns, and the GL turret fill the stun meter and do not move the bar. The knife and the minigun move the bar only during the stun. The drawn bar stays locked until that stun. The soul aura sits on his head, and the soul still fires while he is stunned. Finale fog and finale music, red bar.

| | Rifle | Melee | Explosive | Raygun | MG | GL |
|---|---|---|---|---|---|---|
| Percent | 0 | 100 | 100 | 100 | 11 | 50 |
| Mode | 0 | 2 | 3 | 3 | 2 | 3 |

Difficulty 1, speed 1, health 1800, damage 1, infection 0, push 1. Stun limit 2000, gain 1, stun 5s, recovery 2s. FX `aura`. Targets `gl_turrets:800;raygun_player:1000;far_player:1500;go_away`. Attacks `soul;jump;melee`. Soul usage 0 and ignore-stun 1. One orb goes out for each living player. Jump usage 0. Melee usage 2, so only the last living player, and only in melee range. Quake 0.8. HUD red, locked.
