# Features

* All features are enabled by default. If you want to play with all changes from the list below, there's no additional step beside installing the mod
* If you want to disable any of the features, you can individually disable them following the instructions on the [Installation Guide](https://github.com/kvnbias/ZerdBG3/blob/main/Installing.md#optional-configurations)
* All dependencies of enabled features will be automatically turned on to avoid inconsistencies or bugs in your game
  - _For example, if you disable [`defaultActions`](https://github.com/kvnbias/ZerdBG3/blob/main/Features.md#default-actions-%EF%B8%8F-defaultactions) on the options file, but keep any of its dependencies (like [`extraAttack`](https://github.com/kvnbias/ZerdBG3/blob/main/Features.md#extra-attack-%EF%B8%8F-extraattack) or [`familiars`](https://github.com/kvnbias/ZerdBG3/blob/main/Features.md#familiars-%EF%B8%8F-familiars)), the `defaultActions` option will be re-enabled in-game_

## Attunement ⚙️ `attunement`
_Developed in partnership with [Eric](https://www.nexusmods.com/baldursgate3/mods/2155). It's redundant to have both mods, since they do the same thing; they aren't compatible either._
* Several magical items now require attunement. [Here's the list](https://docs.google.com/spreadsheets/d/1yCJ9ITC180dqykK713iHMEsrvVOHkgOmLF882-yr_hQ/edit#gid=0&fvid=1734738953)
  - To attune to an item, you simply equip it
  - Items that require attunement can only be equipped outside of combat (except for weapons)
* You have a maximum number of items that can be attuned at once to each character (amount modifiable on the optional files, maximum is 16, default is 4)
  - After reaching your maximum amount of attuned items, you can no longer equip items that require attunement
  - To end an attunement, simply unequip an item that requires it

## Concentration Failsafe ⚙️ `concentration_failsafe`
_Quality of Life feature_
* Provides a toggleable passive for players that prevents casting spells that require Concentration while concentrating on another spell.
* Toggle it off or manually stop the concentration (clicking the `X` below the portrait) to cast another concentration spell.
* Given the implementation, spells that are concentration but don't give the caster a status might result in the concentration spells being blocked even so the caster ended concentration manually (or timeout). Basically taking any action (even moving) will remove the blockage, but if nothing works, just untoggle the passive to remove the blockage.

## Downed ⚙️ `downed`
* Healing a downed character allows them to play their turn normally

## Free Weapon Equip ⚙️ `freeWeaponEquip`
* The first weapon equipped in a turn doesn't cost an Action Point. Further equips cost one Action Point each
* Dual Wielder Feat: Allows you to equip two weapons for free per turn instead of just one

## Stabilize ⚙️ `stabilize`
* Help stabilizes the target (Medicine `DC 10`), and the stabilized character is healed once out of combat. If the character is stabilized own their own by succeeding the Death Saving Throws, they will still require a Help Action (and the Medicine Check) to regain 1 HP

## Weapon Sets ⚙️ `weaponSets`
* Removes the possibility of having a melee and a ranged weapon equipped at the same time, on the different weapon slots
  - _The reasoning for this is to avoid benefiting from bonuses (like AC from shields, or Spells from weapons) while using the other set_
* Upon equipping a melee weapon or a shield, both ranged weapon slots are unequipped. Upon equipping a ranged weapon, both melee weapon slots are unequipped
  - _Due to the change to equip cost mentioned on [Global Changes](https://github.com/kvnbias/ZerdBG3/blob/main/Features.md#global-changes), you can always equip one weapon per turn for free, allowing you to switch "sets" without necessarily spending an action_
* _One useful tip is to place your commonly used weapons on the hotbar (drag it from your inventory to your hotbar) to make switching sets easier. That way, you don't need to keep on finding your weapons on your inventory every time (ISSUE: Doesn't work if all attunement slots are used)_

## Actions
* Help stabilizes the target (Medicine `DC 10`), and the stabilized character is healed once out of combat. If the character is stabilized own their own by succeeding the Death Saving Throws, they will still require a Help Action (and the Medicine Check) to regain 1 HP.

## Feats
* Dual Wielder: Allows you to equip two weapons for free per turn (See [Global Changes](https://github.com/kvnbias/ZerdBG3/blob/main/Features.md#global-changes))

## Global changes
* The first weapon equipped in a turn doesn't cost an Action Point. Further equips cost one Action Point each
