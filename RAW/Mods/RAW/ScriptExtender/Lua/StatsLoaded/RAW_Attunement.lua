local maxAttunementStatus, maxAttunementStatusArtificer, ENUM_RAW_AttunementList

local function RAW_AddAttunement(item)
    local useConditionsPrefix = ""
    if item.UseConditions ~= nil and item.UseConditions ~= "" then
        useConditionsPrefix = "(" .. item.UseConditions .. ") and "
    end

    -- Attunement items can't be equipped in combat, except weapons (because of thrown weapons and weapon sets)
    local combatRestriction = "RAW_AttunementCombatRestriction(context.Source) and "
    if item.Slot == "Melee Main Weapon" or item.Slot == "Ranged Main Weapon" then
        combatRestriction = ""
    end

    item.UseConditions = useConditionsPrefix .. combatRestriction ..
            "RAW_AttunementMaximumRestriction(context.Source, '" .. maxAttunementStatus .. "','" .. maxAttunementStatusArtificer .. "')"
    RAW_PrintIfDebug("\tUseConditions: " .. item.UseConditions, RAW_PrintTable_Attunement)

    item.StatusOnEquip = RAW_RemoveRepeatedSemicolon(item.StatusOnEquip .. ";RAW_ATTUNEMENT_COUNT_TECHNICAL")
    RAW_PrintIfDebug("\tStatusOnEquip: " .. item.StatusOnEquip, RAW_PrintTable_Attunement)

    -- TO DO: reactivate the item-specific passive when Ext.Stats.Create works again
    -- Creates a specific passive to each item so they show up separately on the Character Sheet
    -- local passiveName = "RAW_Attunement_" .. item.Name
    -- local newPassive = Ext.Stats.Create(passiveName, "PassiveData", "RAW_Attunement")

    -- Uses a separate passive for each slot so, in most cases, the passives show separately on the Character Sheet
    local passiveName = "RAW_Attunement_" .. string.gsub(item.Slot, " ", "_")
    item.PassivesOnEquip = RAW_RemoveRepeatedSemicolon(item.PassivesOnEquip .. ";" .. passiveName)
    RAW_PrintIfDebug("\tPassivesOnEquip: " .. item.PassivesOnEquip, RAW_PrintTable_Attunement)
end

---------------------------------------- STATS FUNCTION ----------------------------------------

function RAW_Attunement()
    Ext.Utils.Print("\n====================================================================================================")
    Ext.Utils.Print(CentralizedString("Option: attunement"))

    if not IsModOptionEnabled("attunement") then
        Ext.Utils.Print(CentralizedString("Disabled!"))
        Ext.Utils.Print(CentralizedString("Skipping the Attunement rules application"))
        Ext.Utils.Print("====================================================================================================\n")
        return
    end

    Ext.Utils.Print(CentralizedString("Enabled!"))
    Ext.Utils.Print(CentralizedString("Starting the Attunement rules application"))

    local maxAttunement = ModOptions["attunement"].value
    if not RAW_IsIntegerBetween(maxAttunement, 1, 12) then
        RAW_PrintIfDebug("Zerd's RAW\nInvalid attunement value on config file (should be an integer between 1 and 12)\nReverting to default (5)",
            RAW_PrintTable_ModOptions, RAW_PrintTypeError)
        maxAttunement = 5
    end

    maxAttunementStatus = "RAW_ATTUNEMENT_COUNT_" .. tostring(maxAttunement)
    maxAttunementStatusArtificer = "RAW_ATTUNEMENT_COUNT_" .. tostring(maxAttunement+1)

    for _, name in pairs(ENUM_RAW_AttunementList) do
        local item = Ext.Stats.Get(name)
        RAW_PrintIfDebug("\nAdding attunement to " .. name, RAW_PrintTable_Attunement)
        RAW_AddAttunement(item)
    end

    Ext.Utils.Print("\n" .. CentralizedString("Finished the Attunement rules application"))
    Ext.Utils.Print("====================================================================================================\n")
end

---------------------------------------- MODELS ----------------------------------------

ENUM_RAW_AttunementList = {
    -------------------------------------------- ARMOR -------------------------------------------- 

    -- NOT INCLUDED IN ATTUNEMENT
    --- CLOAK
    "MAG_Shadow_FogOfCloudDisengage_Cloak", -- CLOAK OF CUNNING BRUME
    "WYR_Circus_WetCloak", -- REVERSE RAIN CLOAK
    --- BOOTS
    "MAG_Githborn_PsionicMovement_Boots", -- BOOTS OF PSIONIC MOVEMENT
    "MAG_OB_Paladin_DeathKnight_Boots", -- BLACKGUARD'S GREAVES
    "TWN_BootsOfApparentDeath", -- BOOTS OF APPARENT DEATH
    "MAG_Monk_Magic_Boots", -- BOOTS OF UNINHIBITED KUSHIGO
    "MAG_Projectile_Shoes", -- SLINGING SHOES
    "ARM_BootsOfDimensionalDoor", -- SPACESHUNT BOOTS
    "MAG_Jumping_Shoes", -- SWIRESY SHOES
    "MAG_Gortash_Boots", -- TYRANNICAL JACKBOOTS
    "MAG_ElementalGish_MomentumOnElementalDamage_Boots", -- BOOTS OF ELEMENTAL MOMENTUM
    "MAG_Thunder_ReverberationOnStatusApply_Boots", -- BOOTS OF STORMY CLAMOUR
    "FOR_SpiderstepBoots", -- SPIDERSTEP BOOTS
    "MAG_ZOC_ForceConduitWhileSurounded_Boots", -- TENACIOUS BOOTS
    "MAG_DevilsBlackmith_Boots", -- UNWANTED MASTERWORK GREAVES
    --- GLOVES
    "MAG_Zhentarim_Demonspirit_Gloves", -- ABYSS BECKONERS
    "MAG_Barbarian_BoneSpike_Gloves", -- BONESPIKE GLOVES
    "MAG_Illithid_Carapace_Gloves", -- CEREBRAL CITADEL GLOVES
    "MAG_OfWarMaster_Gloves", -- GAUNTLETS OF THE WARMASTER
    "MAG_PHB_OfThievery_Gloves", -- GLOVES OF THIEVERY
    "MAG_Monk_Magic_Gloves", -- GLOVES OF UNINHIBITED KUSHIGO
    "MAG_ZOC_AdvantageOnMeleeAttackWhileSurounded_Gloves", -- GLOVES OF THE GROWLING UNDERDOG
    "MAG_Githborn_MageHandSupport_Gloves", -- HR'A'CKNIR BRACERS
    "MAG_Harpers_JhannylGloves", -- JHANNYL'S GLOVES
    "MAG_Martial_Exertion_Gloves", -- MARTIAL EXERTION GLOVES
    "MAG_BG_Nimblefinger_Gloves", -- NIMBLEFINGER GLOVES
    "MAG_Raven_Gloves", -- RAVEN GLOVES
    "MAG_Stalker_Gloves", -- STALKER GLOVES
    "MAG_Fire_HeatOnFireDamage_Gloves", -- THERMOARCANIC GLOVES
    "WYR_Circus_ThiefGloves", -- UNLUCKY THIEF'S GLOVES
    "MAG_LC_Tinkerer_Gloves", -- WINKLING GLOVES
    "MAG_Frost_GenerateFrostOnDamage_Gloves", -- WINTER'S CLUTCHES
    "MAG_Rage_TempHPOnExit_Gloves", -- REASON'S GRASP
    "DEN_RaidingParty_GoblinCaptain_Gloves", -- GLOVES OF POWER
    "MAG_DevilsBlackmith_Gloves", -- UNWANTED MASTERWORK GAUNTLETS
    --- HELM
    -- "ARM_MerregonMask", -- DEVILFOIL MASK
    "MAG_Gish_ArcaneSynergy_Circlet", -- DIADEM OF ARCANE SYNERGY
    "MAG_Hat_Circushat", -- HAT OF UPROARIOUS LAUGHTER
    "MAG_Monk_Magic_Hat", -- HAT OF UNINHIBITED KUSHIGO
    "MAG_Lesser_Infernal_Metal_Helmet", -- HELLGLOOM HELMET (FLAWED HELLDUSK HELMET)
    "MAG_BarbMonk_Leather_Circlet", -- SCABBY PUGILIST CIRCLET
    "MAG_Helmet_Human_Watcher", -- STEELWATCHER HELMET
    "MAG_Wizard_Pointy_Hat", -- THE POINTY HAT
    "MAG_ZOC_Force_Helmet", -- TIGHTENING ORBIT HELM
    "UNI_Druid_Helmet_Circlet", -- KEY OF THE ANCIENT (ARCANE CIRCLET)
    "MAG_CQCaster_SpellDCBonusWhileThreatened_Circlet", -- BROWBEATEN CIRCLET
    "MAG_Frost_GenerateFrostOnStatusApply_Hat", -- COLDBRIM HAT
    "UND_Justiciar_Helmet_Magic", -- DARK JUSTICIAR MASK
    -- "UND_Justiciar_Mask_Magic", -- DARK JUSTICIAR MASK (MEH)
    "MAG_ElementalGish_ArcaneAcuity_Helmet", -- HELMET OF ARCANE ACUITY
    "UND_FairyRing_AntiCharmHelmet", -- HELMET OF AUTONOMY
    "MAG_ChargedLightning_TempHP_Helmet", -- THE LIFEBRINGER
    "MAG_ofMarksmanship_Hat", -- MARKSMANSHIP HAT
    "MAG_Shadow_SpellDCBonusWhileObscured_Circlet", -- THE SHADESPELL CIRCLET
    --- ROBE
    "MAG_Monk_Magic_Armor_1", -- GARB OF THE LAND AND SKY
    "MAG_Drunken_Cloth", -- DRUNKEN CLOTH
    "FOR_SpiderQueen_Robe", -- POISONER'S ROBE
    "UNI_RobeOfSummer", -- ROBE OF SUMMER
    "MAG_Monk_Magic_Armor", -- ARMOUR OF UNINHIBITED KUSHIGO
    --- LIGHT ARMOR
    "MAG_Shadow_StealthBonusWhileObscured_Armor", -- PENUMBRAL ARMOUR
    "MAG_Harpers_ArmorOfShadows", -- SHADECLINGER ARMOUR
    "MAG_Psychic_PsychicFeedback_Armor", -- PSYCHIC FEEDBACK ARMOR?
    --- MEDIUM ARMOR
    "UND_Justiciar_Chainshirt_Magic", -- DARK JUSTICIAR MAIL
    "MAG_PHB_ElvenChain_Armor", -- ELVEN CHAIN
    "MAG_FlamingFist_Flame_Armor", -- FLAME ENAMELLED ARMOUR
    "MAG_Druid_Magic_Hide_Armor", -- HEDGE WANDERER ARMOUR
    --- HEAVY ARMOR
    "MAG_ZOC_ForceConduit_ChainMail", -- RIPPLING FORCE MAIL

    -- IN ATTUNEMENT
    --- CLOAK
    "MAG_Psychic_MentalFatigue_Cape", -- BRAINDRAIN CAPE
    "MAG_Fire_BurningOnDamaged_Cloak", -- CINDERMOTH CLOAK
    "MAG_PHB_CloakOfDisplacement_Cloak", -- CLOAK OF DISPLACEMENT
    "MAG_ElementalGish_AbsorbElements_Cloak", -- CLOAK OF ELEMENTAL ABSORPTION
    "MAG_PHB_CloakOfProtection_Cloak", -- CLOAK OF PROTECTION
    "MAG_EndGameCaster_Cloak", -- CLOAK OF THE WEAVE
    "MAG_Poison_InflictPoisonHealSelf_Cloak", -- DERIVATION CLOAK
    "MAG_Acid_AcidMeleeCounter_Cloak", -- FLESHMELTER CLOAK
    "MAG_Radiant_CrusaderMantle_Cloak", -- MANTLE OF THE HOLY WARRIOR
    "MAG_LC_Nymph_Cloak", -- NYMPH CLOAK
    "MAG_Critical_HidingCritical_Cloak", -- SHADE-SLAYER CLOAK
    "UNI_DarkUrge_Bhaal_Cloak", -- THE DEATHSTALKER MANTLE
    "MAG_Thunder_InflictDazeOnReverberatedCreature_Cloak", -- THUNDERSKIN CLOAK
    "MAG_CQCaster_TempHPAfterCast_Cloak", -- VIVACIOUS CLOAK
    "MAG_LC_Umberlee_Protection_Cape", -- WAVEMOTHER'S CLOAK
    --- BOOTS
    "MAG_Barbarian_BoneSpike_Shoes", -- BONESPIKE BOOTS
    "MAG_EndGame_Metal_Boots", -- BOOTS OF PERSISTENCE
    "FOR_NightWalkers", -- DISINTEGRATING NIGHT WALKERS
    "MAG_BG_Gargoyle_Boots", -- GARGOYLE BOOTS
    "MAG_Infernal_Metal_Boots", -- HELLDUSK BOOTS
    "MAG_Acrobat_Shoes", -- ACROBAT SHOES
    "MAG_CQCaster_ArcaneChargeAfterDash_Boots", -- BOOTS OF ARCANE BOLSTERING
    "MAG_Bard_RefreshBardicInspirationSlot_Shoes", -- BOOTS OF BRILLIANCE
    "MAG_TerrainWalkers_Boots", -- BOOTS OF GENIAL STRIDING
    "ARM_BootsOfSpeed", -- BOOTS OF SPEED
    "MAG_Critical_CriticalSwiftness_Boots", -- BRISKWIND BOOTS
    "UNI_SHA_DarkJusticiar_Boots", -- DARK JUSTICIAR BOOTS
    "MAG_Evasive_Shoes", -- EVASIVE SHOES
    "MAG_ChargedLightning_Dash_Boots", -- THE SPEEDY LIGHTFEET
    "MAG_ChargedLightning_ElectricSurface_Boots", -- THE WATERSPARKERS
    "MAG_Mobility_MomentumOnDash_Boots", -- SPRINGSTEP BOOTS
    "MAG_LC_Umberlee_Regeneration_Boots", -- WAVEMOTHER'S BOOTS
    "MAG_Gish_TempHPWhileConcentrating_Boots", -- VITAL CONDUIT BOOTS
    "MAG_Fire_HeatOnInflictBurning_Boots", -- CINDER SHOES
    "MAG_Healer_TempHPOnHeal_Boots", -- BOOTS OF AID AND COMFORT
    "WYR_Circus_TeleportBoots", -- BOOTS OF VERY FAST BLINKING
    "MAG_LowHP_IncreaseSpeed_Boots", -- FEATHERLIGHT BOOTS
    "MAG_Frost_IceSurfaceProneImmunity_Boots", -- HOARFROST BOOTS
    "UND_Tower_BootsFeatherFall", -- MYSTRA'S GRACE
    "MAG_Shadow_Shadowstep_Boots", -- SHADOWSTEP BOOTS
    "CRE_Hatchery_AcidPoisonImmunity_Boots", -- VARSH KO'KUU'S BOOTS
    "MAG_Paladin_MomentumOnConcentration_Boots", -- BOOTS OF STRIDING
    "MAG_Violence_ViolenceOnDash_Boots", -- LINEBREAKER BOOTS,
    --- GLOVES
    "MAG_Bhaalist_Gloves", -- BHAALIST GLOVES
    "MAG_OB_Paladin_DeathKnight_Gloves", -- BLACKGUARD'S GAUNTLETS
    "UNI_ARM_OfDefense_Gloves", -- BRACERS OF DEFENCE
    "MAG_Psychic_MentalFatigue_Gloves", -- BRAINDRAIN GLOVES
    "MAG_FlamingFist_BattleWizardGloves", -- CINDERSNAP GLOVES
    "MAG_Critical_Force_Gloves", -- CRATERFLESH GLOVES
    "MAG_CQCaster_CloseRangedSpellMastery_Gloves", -- DAREDEVIL GLOVES
    "MAG_Zhentarim_Swap_Gloves", -- DARK DISPLACEMENT GLOVES
    "SHA_JusticiarArmor_Gloves", -- DARK JUSTICIAR GAUNTLETS
    "MAG_JusticiarArmor_Gloves", -- DARK JUSTICIAR GAUNTLETS (RARE)
    "MAG_Critical_ArcanicCritical_Gloves", -- DEADLY CHANNELLER GLOVES
    "MAG_Lesser_Infernal_Metal_Gloves", -- FLAWED HELLDUSK GLOVES
    "MAG_Gortash_Gloves", -- GAUNTLET OF THE TYRANT (NETHERSTONE-STUDDED GAUNTLET)
    "UNI_ARM_OfGiantHillStrength_Gloves", -- GAUNTLETS OF HILL GIANT STRENGTH
    "MAG_Fighter_ActionSurge_AttackBonus_Gloves", -- GAUNTLETS OF SURGING ACCURACY
    "MAG_Warlock_Twinned_Gloves", -- GEMINI GLOVES
    "UNI_ARM_OfArchery_Gloves", -- GLOVES OF ARCHERY
    "MAG_ElementalGish_BaneOnElementalWeaponDamage_Gloves", -- GLOVES OF BANEFUL STRIKING
    "MAG_Gish_ArcaneAcuity_Gloves", -- GLOVES OF BATTLEMAGE'S POWER
    "MAG_Thunder_Reverberation_Gloves", -- GLOVES OF BELLIGERENT SKIES
    "MAG_Monk_Fire_Gloves", -- GLOVES OF CINDER AND SIZZLE
    "MAG_BG_OfCrushing_Gloves", -- GLOVES OF CRUSHING
    "MAG_BG_OfDexterity_Gloves", -- GLOVES OF DEXTERITY
    "MAG_LowHP_ResistanceFire_Gloves", -- GLOVES OF FIRE RESISTANCE
    "MAG_Fire_ApplyBurningOnFireDamage_Gloves", -- GLOVES OF FLINT AND STEEL
    "PLA_ZhentCave_Gloves", -- GLOVES OF HAIL OF THORNS
    "MAG_Paladin_LayOnHandsSupport_Gloves", -- GLOVES OF HEROISM
    "UNI_ARM_OfMissileSnaring_Gloves", -- GLOVES OF MISSILE SNARING
    "MAG_PHB_OfSoulCatching_Gloves", -- GLOVES OF SOUL CATCHING
    "MAG_OfAutomaton_Gloves", -- GLOVES OF THE AUTOMATON
    "MAG_OfTheBalancedHands_Gloves", -- GLOVES OF THE BALANCED HANDS
    "MAG_OfTheDuelist_Gloves", -- GLOVES OF THE DUELLIST
    "MAG_Infernal_Metal_Gloves", -- HELLDUSK GLOVES
    "DEN_HellridersPride", -- HELLRIDER'S PRIDE
    "UND_Myco_Alchemist_HealerGloves", -- HERBALIST'S GLOVES
    "MAG_Acid_NoxiousFumes_Gloves", -- ICHOROUS GLOVES
    "MAG_Zhentarim_Lockpicking_Gloves", -- KNOCK KNUCKLE GLOVES
    "MAG_BG_OfTheMasters_Legacy_Gauntlet", -- LEGACY OF THE MASTERS
    "MAG_Radiant_RadiatingOrb_Gloves", -- LUMINOUS GLOVES
    "MAG_LC_DrowSpider_Gloves", -- PALE WIDOW GLOVES
    "MAG_Poison_PoisonExposure_Gloves", -- POISONER'S GLOVES
    "MAG_Warlock_Quickened_Gloves", -- QUICKSPELL GLOVES
    "MAG_OpenHand_Radiant_Gloves", -- SERAPHIC PUGILIST GLOVES
    "MAG_Banites_Gloves", -- SERVITOR OF THE BLACK HAND GLOVES
    "MAG_Monk_Cold_Gloves", -- SNOW-DUSTED MONASTERY
    "MAG_Arcanist_Gloves", -- SPELLMIGHT GLOVES
    "MAG_MM_Sorcery_SeekingSpell_Gloves", -- SPELLSEEKING GLOVES
    "MAG_OfSwordmaster_Gloves", -- SWORDMASTER GLOVES
    "MAG_Monk_Lightning_Gloves", -- THE FORK-LIGHTNING FINGERS
    "MAG_OfRevivify_Gloves", -- THE REVIVING HANDS
    "MAG_ChargedLightning_AbilityCheckBoost_Gloves", -- THE SPARKLE HANDS
    "MAG_Monk_Thunder_Gloves", -- THUNDERPALM STRIKERS
    "MAG_Vampiric_Gloves", -- VAMPIRIC GLOVES
    "MAG_BG_Wondrous_Gloves", -- WONDROUS GLOVES
    "MAG_Mobility_JumpOnDash_Gloves", -- FLEETFINGERS
    --- HELM
    -- "ACT1_HAG_HagMask", -- HAG MASK
    "MAG_WYRM_OfBalduran_Helmet", -- HELM OF BALDURAN
    "MAG_Bhaalist_Hat", -- ASSASSIN OF BHAAL COWL
    "MAG_GleamingSorcery_Hat", -- BIRTHRIGHT
    "MAG_Barbarian_BoneSpike_Helmet", -- BONESPIKE HELMET
    "MAG_BonusAttack_AgainstMarked_Circlet", -- CIRCLET OF HUNTING
    "UNI_DarkJusticiar_Helmet", -- DARK JUSTICIAR HELMET
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Helmet", -- GRYMSKULL HELM
    "MAG_Infernal_Metal_Helmet", -- HELLDUSK HELMET
    "MAG_LowHP_BonusAction_Helmet", -- HELMET OF GRIT
    "MAG_EndGameCaster_Hood", -- HOOD OF THE WEAVE
    "MAG_Hat_Barbarian_Hide", -- HORNS OF THE BERSERKER
    "MAG_LC_Jannath_Hat", -- JANNATH'S HAT
    "MAG_Monk_SoulPerception_Hat", -- MASK OF SOUL PERCEPTION
    "MAG_Fire_BonusActionOnFireSpell_Circlet", -- PYROQUICKNESS HAT (CIRCLET OF FIRE)
    "UNI_ARM_Sarevok_Horned_Helmet", -- SAREVOK'S HORNED HELMET
    "MAG_Druid_Wildshape_Hat", -- SHAPESHIFTER HAT
    "MAG_Violence_ViolenceOnDamaged_Helmet", -- CAP OF WRATH
    "MAG_Myrkulites_CircletOfMyrkul_Circlet", -- CIRCLE OF BONES
    "ARM_CircletOfBlasting", -- CIRCLET OF BLASTING
    "MAG_Illithid_Regen_Circlet", -- CIRCLET OF MENTAL ANGUISH
    "CRE_MAG_Psychic_Githborn_Circlet", -- CIRCLET OF PSIONIC REVENGE
    "MAG_BarbMonk_Cloth_Hat_A_1_Late", -- FISTBREAKER HELM
    "MAG_Hat_Butler", -- GIBUS OF THE WORSHIPFUL SERVANT
    "MAG_Mobility_MomentumOnCombatStart_Helmet", -- HASTE HELM
    "MAG_OfSharpCaster_Hat", -- HAT OF THE SHARP CASTER
    "UNI_ARM_OfTeleportation_Helm", -- HELM OF ARCANE GATE
    "UND_ShadowOfMenzoberranzan", -- SHADOW OF MENZOBERRANZAN
    "MAG_Bard_HealingBardicInspiration_Hat", -- CAP OF CURING
    "MAG_Shadow_CriticalBoostWhileObscured_Helmet", -- COVERT COWL
    "MAG_Enforcer_RejunevatingKnock_Helmet", -- ENFORCER HELMET
    "MAG_Fire_ArcaneAcuityOnFireDamage_Hat", -- HAT OF FIRE ACUITY
    "MAG_Thunder_ArcaneAcuityOnThunderDamage_Hat", -- HAT OF STORM SCION'S POWER
    "MAG_Paladin_SmiteSpellsSupport_Helmet", -- HELMET OF SMITING
    "MAG_Radiant_Radiating_Helmet", -- HOLY LANCE HELM
    "MAG_Healer_HealSelf_Helmet", -- WAPIRA'S CROWN
    "ARM_HeadbandOfIntellect", -- WARPED HEADBAND OF INTELLECT
    "MAG_OfTheShapeshifter_Mask", -- MASK OF THE SHAPESHIFTER
    --- ROBE
    "MAG_Monk_SoulRejunevation_Armor", -- VEST OF SOUL REJUVENATION
    "MAG_BarbMonk_Defensive_Cloth", -- THE GRACEFUL CLOTH (CAT)
    "MAG_LC_Lorroakan_Robe", -- SHELTER OF ATHKATLA
    "MAG_OfArcanicAssault_Robe", -- ROBE OF EXQUISITE FOCUS
    "MAG_OfSpellResistance_Robe", -- ROBE OF SPELL RESISTANCE
    "MAG_OfArcanicDefense_Robe", -- ROBE OF SUPREME DEFENCES
    "MAG_EndGameCaster_Robe", -- ROBE OF THE WEAVE
    "MAG_CharismaCaster_Robe", -- POTENT ROBE
    "ORI_Wyll_Infernal_Robe", -- INFERNAL ROBE
    "MAG_Barbarian_BoneSpike_Armor", -- BONESPIKE GARB
    "MAG_ChargedLightning_BonusAC_Robe", -- THE PROTECTY SPARKSWALL
    "MAG_Violence_LowHP_Violence_Clothes", -- BLOODGUZZLER GARB
    "MAG_CQCaster_GainArcaneChargeOnDamaged_Robe", -- BIDED TIME
    "MAG_Heat_Fire_Robe", -- OBSIDIAN LACED ROBE
    "MAG_BarbMonk_Offensive_Cloth", -- THE MIGHTY CLOTH
    "MAG_Barbarian_Magic_Armor_1", -- ENRAGING HEART GARB
    "MAG_Frost_GenerateFrostOnDamage_Robe", -- ICEBITE ROBE
    "MAG_Viconia_Robe", -- VICONIA'S PRIESTESS ROBE
    "MAG_Selunite_Isobel_Robe", -- MOON DEVOTION ROBE
    "MAG_Gortash_Cloth", -- CLOTH OF AUTHORITY
    "MAG_WYRM_UndeadProtector_Robe", -- VEIL OF THE MORNING
    "MAG_LC_Umberlee_Regeneration_Robe", -- WAVEMOTHER'S ROBE
    --- LIGHT ARMOR
    -- "MAG_Druid_Magic_StuddedLeather_Armor", -- Studded Leather Armour +2
    "MAG_Druid_Land_Magic_Leather_Armor", -- ARMOUR OF LANDFALL
    "MAG_Druid_Moon_Magic_Leather_Armor", -- ARMOUR OF MOONBASKING
    "MAG_Druid_Spore_Magic_Leather_Armor", -- ARMOUR OF THE SPOREKEEPER
    "MAG_Bhaalist_Armor", -- BHAALIST ARMOUR
    "MAG_Bard_TempHP_Armor", -- BLAZER OF BENEVOLENCE
    "GOB_DrowCommander_Leather_Armor", -- SPIDERSILK ARMOUR
    "MAG_EndGame_StuddedLeather_Armor", -- ELEGANT STUDDED LEATHER
    "MAG_Critical_BolsteringCritical_Armor", -- TORMENT DRINKER ARMOUR
    --- MEDIUM ARMOR
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_ScaleMail", -- ADAMANTINE SCALE MAIL
    "MAG_EndGame_HalfPlate", -- ARMOUR OF AGILITY
    "MAG_Druid_Late_Hide_Armor_1", -- BARKSKIN ARMOUR
    "MAG_Mobility_SprintForMomentum_ChainShirt", -- CHAIN OF LIBERATION
    "MAG_DarkJusticiar_HalfPlate", -- DARK JUSTICIAR HALF-PLATE
    "UNI_DarkJusticiarArmor_HalfPlate", -- DARK JUSTICIAR HALF-PLATE (SHADOWHEART)
    "MAG_Radiant_RadiatingOrb_Armor", -- LUMINOUS ARMOUR
    "MAG_Githborn_MagicEating_HalfPlate", -- PSIONIC WARD ARMOUR
    "MAG_LowHP_CounterOnDamage_ChainShirt", -- ROBUST CHAIN SHIRT
    "MAG_Druid_Late_Hide_Armor_2", -- SHARPENED SNARE CUIRASS
    "MAG_Healer_DisengageOnHeal_ChainShirt", -- SLIPPERY CHAIN SHIRT
    "MAG_ChargedLightning_Electrocute_Armor", -- THE JOLTY VEST
    "FOR_OwlbearCubs_Armor", -- THE OAK FATHER'S EMBRACE
    "MAG_DevilsBlackmith_ScaleMail", -- UNWANTED MASTERWORK SCALEMAIL
    "MAG_CKM_SerpenScale_Armor", -- YUAN-TI SCALE MAIL
    --- HEAVY ARMOR
    "MAG_Infernal_Plate_Armor", -- HELLDUSK ARMOUR
    "MAG_MeleeDebuff_AttackDebuff2_OnDamage_SplintMail", -- ADAMANTINE SPLINT ARMOUR
    "MAG_OB_Paladin_DeathKnight_Armor", -- BLACKGUARD'S PLATE
    "MOO_Ketheric_Armor", -- REAPER'S EMBRACE
    "UNI_Ravengard_Plate", -- EMBLAZONED PLATE OF THE MARSHAL
    "MAG_EndGame_Plate_Armor", -- ARMOUR OF PERSISTENCE
    "MAG_Lesser_Infernal_Plate_Armor", -- FLAWED HELLDUSK ARMOUR
    "MAG_Illithid_Carapace_Armor", -- CEREBRAL CITADEL ARMOUR
    "MAG_Paladin_RestoreChannelDivinity_Armor", -- ARMOR OF DEVOTION
    "UNI_ARM_Sarevok_Armor", -- SAREVOK ARMOR

    -- SUMMONS/NPC/???
        -- "Quest_DEN_ARM_LuckyBoots",

    -- MISSING ID
    --- GLOVES
        -- GLOVES OF SUCCOUR

    ----------------------------------------- ACCESSORIES ----------------------------------------- 

    -- NOT INCLUDED IN ATTUNEMENT
    --- AMULET
    "MAG_TheOptimist_Amulet", -- ABSOLUTE CONFIDENCE AMULET
    "GOB_Priest_Amulet", -- ABSOLUTE'S TALISMAN
    "QUEST_LOW_Bhaal_Amulet", -- AMULET OF BHAAL
    "UNI_GOB_SeluneAmulet", -- AMULET OF SELÛNE'S CHOSEN
    "DEN_BearReward_Amulet", -- AMULET OF SILVANUS
    "MAG_EGW_OfTheDrunkard_Amulet", -- AMULET OF THE DRUNKARD
    "UND_Minotaur_BeltAmulet", -- AMULET OF THE UNWORTHY
    "GOB_Pens_BeastmasterAmulet", -- BEASTMASTER'S CHAIN
    "MAG_Healer_HealSelfPoisonWeapon_Amulet", -- BROODMOTHER'S REVENGE
    "MAG_Greenstone_Amulet", -- FEY SEMBLANCE AMULET
    "MAG_Fire_HeatOnTakingFireDamage_Amulet", -- FIREHEART
    "MAG_Frost_Frostbite_Amulet", -- FROST PRINCE
    "MAG_Shadow_FogCloud_Amulet", -- HAMMERGRIM MIST AMULET
    "DEN_Arabella_Locket", -- KOMIRA'S LOCKET
    "MAG_SecondChance_Amulet", -- MAGIC AMULET
    "MAG_Illithid_MindTax_Amulet", -- SYNAPTIC NEEDLE AMULET
    "ARM_HAG_Phylactery", -- TARNISHED CHARM
    "HAG_EyeballNecklace", -- THE EVER-SEEING EYE
    "MAG_WYRM_SleepImmunity_Amulet", -- WAKEFUL AMULET
    --- RING
    "MAG_ArcaneTrickster_Ring", -- BAND OF THE MYSTIC SCOUNDREL
    "ARM_DrunkGoblinRing", -- CRUSHER'S RING
    "UNI_WYR_Circus_WheelRing", -- DJINNI RING
    "UND_MushroomHunger_RingOfExploration", -- EXPLORER'S RING
    "HAG_HagsRing", -- HAG'S RING
    "CRA_HermitCrab_Ring", -- HERMIT CRAB
    "MAG_LOW_Rat_Keepsake_Ring", -- KEEPSAKE RING
    "MAG_Orpheus_Ring", -- ORPHIC RING
    "MAG_Poison_PoisonLethality_Ring", -- POISONER'S RING
    "MAG_Psychic_TempHP_Ring", -- PYSCHIC BOLSTERING RING
    "MAG_Illithid_CharmPerson_Ring", -- RING OF BEGUILING
    "DEN_HarpyMeal_NestRing", -- RING OF COLOUR SPRAY
    "MAG_Myrkulites_RingofMyrkul_Ring", -- RING OF EXALTED MARROW
    "MAG_Fire_IncreasedDamage_Ring", -- RING OF FIRE
    "MAG_Harpers_RingOfProjection", -- RING OF FLINGING
    "MAG_Harpers_RingOfAttraction", -- RING OF GENIALITY
    "UNI_UND_RingOfMindShielding", -- RING OF MIND-SHIELDING
    "MAG_Fire_SelfImmolation_Ring", -- RING OF SELF IMMOLATION
    "MAG_PassWithoutTrace_Ring", -- RING OF SHADOWS
    "MAG_Harpers_RingOfTwilight", -- RING OF TWILIGHT
    "MAG_TheOptimist_Ring", -- SEEMINGLY GLEAMING RING
    "SCL_MastiffPoachers_Ring", -- SHADOW-CLOAKED RING
    "MAG_ShapeshiftersBurgeon_Ring", -- SHAPESHIFTER'S BOON RING
    "MAG_FlamingFist_ScoutRing", -- SHIFTING CORPUS RING
    "PLA_SmugglerRing", -- SMUGGLER'S RING
    "MAG_Frost_GenerateSurfaceOnColdDamage_Ring", -- SNOWBURST RING
    "UND_SocietyOfBrilliance_DarkvisionRing", -- SUNWALKER'S GIFT
    "UND_Tower_RingArcana", -- THE MAGE'S FRIEND
    "TWN_BondedByLove_WifesRing", -- TRUE LOVE'S CARESS
    "TWN_BondedByLove_HusbandsRing", -- TRUE LOVE'S EMBRACE
    "MAG_OfUndeadServant_Ring", -- CRYPT LORD RING

    -- IN ATTUNEMENT --
    --- AMULET
    "CRE_MAG_Githborn_Amulet", -- ABERRATION HUNTERS' AMULET
    "MAG_Gish_WeaknessBranding_Amulet", -- AMULET OF BRANDING
    "UNI_MartyrAmulet", -- AMULET OF ELEMENTAL TORMENT
    "MAG_ofGreaterHealth_Amulet", -- AMULET OF GREATER HEALTH
    "GOB_DrowCommander_Amulet", -- AMULET OF MISTY STEP
    "MAG_Healer_HPRestoration_Amulet", -- AMULET OF RESTORATION
    "LOW_OfWindrider_Amulet", -- AMULET OF WINDRIDER
    "MAG_OfTheDevout_Amulet", -- AMULET OF THE DEVOUT
    "MAG_Harpers_HarpersAmulet", -- AMULET OF THE HARPERS
    "UND_MyconidAmulet_Evil", -- CHAMPION'S CHAIN
    "MAG_LuckySeven_Amulet", -- CORVID TOKEN
    "UND_MyconidAmulet_Good", -- ENVOY'S AMULET
    "MAG_LowHP_IgnoreAttackOfOpportunity_Amulet", -- MOONDROP PENDANT
    "SCE_KhalidsGift", -- KHALID'S GIFT
    "MAG_LC_HellishMadness_Amulet", -- KRUZNABIR'S ASYLUM AMULET
    "MAG_ChargedLightning_StaticDischarge_Amulet", -- LIGHTNING AURA AMULET
    "MAG_OfGreaterSorcery_Amulet", -- LOFTY SORCERER'S AMULET
    "MAG_ElementalGish_CantripBooster_Amulet", -- NECKLACE OF ELEMENTAL AUGMENTATION
    "MAG_PHB_ofPower_Pearl_Amulet", -- PEARL OF POWER AMULET
    "MAG_PHB_PeriaptofWoundClosure_Amulet", -- PERIAPT OF WOUND CLOSURE
    "UND_SocietyOfBrilliance_MagicMissileNecklace", -- PSYCHIC SPARK
    "MAG_PHB_ScarabOfProtection_Amulet", -- SCARAB OF PROTECTION
    "UND_MonkAmulet_Amulet", -- SENTIENT AMULET
    "TWN_NecklaceOfCharming", -- SHAR'S TEMPTATION
    "CHA_OutpostJewelry", -- SILVER PENDANT
    "MAG_LC_TheAmplifier_Amulet", -- SPELL SAVANT AMULET
    "MAG_Restoration_SpellSlotRestoration_Amulet", -- SPELLCRUX AMULET
    "MAG_Thunder_ReverberationOnRangeSpellDamage_Amulet", -- SPINESHUDDER AMULET
    "MAG_BlackTentacle_Amulet", -- STRANGE TENDRIL AMULET
    "MAG_TWN_Surgeon_ParalyzingCritical_Amulet", -- SURGEON'S SUBJUGATION AMULET
    "ARM_TalismanOfJergal", -- THE AMULET OF LOST VOICES
    "MAG_ChargedLightning_LightningBlast_Amulet", -- THE BLAST PENDANT
    "MAG_SpectatorEye_Amulet", -- THE SPECTATOR EYES
    "MAG_ZOC_RampartAura_Amulet", -- TREACLEFLOW AMULET
    "MAG_Taras_Collar_Amulet", -- TRESSYM COLLAR
    "UND_Tower_AmuletDetectThoughts", -- UNCOVERED MYSTERIES
    "MAG_LegendaryEvasion_Amulet", -- UNFLINCHING PROTECTOR AMULET
    "MAG_LowHP_IncreasedSpellDamage_Amulet", -- ILMATER'S AID
    "MAG_Psychic_Staggering_Amulet", -- STAGGERING AMULET
    --- RING
    "MAG_ChargedLightning_EnsnaringShock_Ring", -- A SPARKING PROMISE
    "FOR_DeathOfATrueSoul_TrueSoul_Ring", -- ABSOLUTE'S SMITE
    "LOW_KerriRing_Ring", -- AFTER DEATH DO US PART
    "MAG_Shove_ACboost_Ring", -- BRACING BAND
    "MAG_ParalyzingRay_Ring", -- BURNISHED RING
    "MAG_Radiant_DamageBonusOnIlluminatedTarget_Ring", -- CALLOUS GLOW RING
    "MAG_Acid_AcidDamageOnWeaponAttack_Ring", -- CAUSTIC BAND
    "MAG_Radiant_RadiatingOrb_Ring", -- CORUSCATION RING
    "MAG_Shadow_BlindImmunity_Ring", -- EVERSIGHT RING
    "UND_DeadInWater_CallarduranTrinket", -- FETISH OF CALLARDURAN SMOOTHHANDS
    "UND_Tower_RingLight", -- GUIDING LIGHT
    "MAG_Critical_CriticalExecution_Ring", -- KILLER'S SWEETHEART
    "UNI_GLO_Orin_TeleportRing", -- ORIN'S TEMPLE RING
    "UND_KC_RingOfAbsolute", -- RING OF ABSOLUTE FORCE
    "MAG_Gish_ArcaneSynergy_Ring", -- RING OF ARCANE SYNERGY
    "MAG_OfBlink_Ring", -- RING OF BLINK
    "MAG_ElementalGish_ElementalInfusion_Ring", -- RING OF ELEMENTAL INFUSION
    "MAG_PHB_OfEvasion_Ring", -- RING OF EVASION
    "MAG_OfFeywildSparks_Ring", -- RING OF FEYWILD SPARKS
    "MAG_PHB_OfFreeAction_Ring", -- RING OF FREE ACTION
    "MAG_PHB_OfJumping_Ring", -- RING OF JUMPING
    "MAG_Psychic_MentalOverload_Ring", -- RING OF MENTAL INHIBITION
    "ARM_RingOfPoisonResistance", -- RING OF POISON RESISTANCE
    "MAG_PHB_Ring_Of_Protection", -- RING OF PROTECTION
    "MAG_PHB_OfRegeneration_Ring", -- RING OF REGENERATION
    "UND_SocietyOfBrilliance_PullingRing", -- RING OF SALVING
    "MAG_Thunder_InflictDazeOnThunderDamage_Ring", -- RING OF SPITEFUL THUNDER
    "MAG_WYRM_OfTruthTelling_Ring", -- RING OF TRUTHFULNESS
    "MAG_RiskyAttack_Ring", -- RISKY RING
    "SHA_SandthiefsRing", -- SANDTHIEF'S RING
    "MAG_Shadow_ShadowBlade_Ring", -- SHADOW BLADE RING
    "MAG_Mobility_LowHP_Momentum_Ring", -- SPURRED BAND
    "MAG_Gish_PsychicDamageBonusWhileConcentrating_Ring", -- STRANGE CONDUIT RING
    "MAG_ChargedLightning_Resistance_Ring", -- THE SPARKSWALL
    "UNI_MassHealRing", -- THE WHISPERING PROMISE
    "LOW_JannathRing_Ring", -- TILL DEATH DO US PART
    "MAG_Psychic_TempHP_Ring", -- PYSCHIC BOLSTERING RING

    -- SUMMONS/NPC/???
        -- "LOW_PendulumOfMalagard", -- PENDULUM OF MALAGARD
        -- "TWN_RegretfulHunter_SoulAmulet",

    -- MISSING ID
        -- FAMILY RING
        -- TARNISHED RING

    ------------------------------------------- WEAPONS ------------------------------------------- 

    -- NOT INCLUDED IN ATTUNEMENT
    --- CLUB
    "UND_StrengthChair_Leg", -- CLUB OF HILL GIANT STRENGTH
    --- DAGGER
    "MAG_Psychic_MentalSundering_Dagger", -- MIND SUNDERING DAGGER
    "FOR_IncompleteMasterwork_SussurDagger", -- SUSSUR DAGGER
    --- FLAIL
    "MAG_Corrosive_Flail", -- CORROSIVE FLAIL
    --- GREATCLUB
    "TWN_RatCatcher", -- RAT BAT???
    --- GREATSWORD
    "FOR_IncompleteMasterwork_SussurGreatsword", -- SUSSUR GREATSWORD
    --- HALBERD
    -- "WPN_Merregon_Halberd", -- MERREGON HALBERD (SAME WITH HALBERD +1)
    "WPN_Tower_AutomatonHalberd", -- LIGHT OF CREATION
    --- STAFF
    "UNI_StaffOfRain", -- RAIN DANCER
    --- RAPIER
    "UND_Nere_Sword", -- SWORD OF SCREAMS
    --- HANDAXE
    "GOB_PainPriest_Handaxe", -- RITUAL HANDAXE
    --- SICKLE
    "FOR_IncompleteMasterwork_SussurSickle", -- SUSSUR SICKLE
    --- MACE
    "GOB_PainPriest_Scourge", -- LOVIATAR'S SCOURGE
    --- SHIELD
    "MAG_Safeguard_Shield", -- SAFEGUARD SHIELD
    "TWN_ShieldOfWatcher", -- WATCHER'S SHIELD
    "MAG_Druid_Ironvine_Shield", -- IRONVINE SHIELD
    "MAG_Harpers_ShieldsOfShadows", -- GLOOMSTRAND SHIELD

    -- IN ATTUNEMENT
    --- BATTLEAXE
    "MAG_Critical_CriticalCombo_BattleAxe", -- COMBINATION AXE
    "MAG_Bonded_Throwing_Battleaxe", -- REBOUND BATTLEAXE
    "MAG_Shadow_Battleaxe", -- SHADOW BATTLEAXE
    "MAG_Fire_HeatOnWeaponDamage_Battleaxe", -- THERMODYNAMO AXE
    "MAG_Vicious_Battleaxe", -- VICIOUS BATTLEAXE
    "MAG_Spellbreaker_Battleaxe", -- WITCHBREAKER
    --- DAGGER
    -- "WPN_Syringe", -- SYRINGE
    "MAG_Surgeon_Syringe", -- SURGEON SYRINGE
    "DLC_DD_WPN_Sebilles_Needle", -- NEEDLE OF THE OUTLAW ROGUE (DLC SEBILLE)
    "GOB_PainPriest_Dagger", -- RITUAL DAGGER
    "MAG_ArcaneAbsorption_Dagger", -- ARCANE ABSORPTION DAGGER
    "DEN_CapturedGoblin_MurderDagger", -- ASSASSIN'S TOUCH
    "MAG_WYR_Orin_Bhaalist_Dagger", -- BLOODTHIRST - BLADE OF THE FIRST BLOOD
    "MAG_Frost_Offhand_Dagger", -- COLD SNAP
    "DEN_Apprentice_DaggerOfShar", -- DAGGER OF SHAR
    "TWN_SharDagger", -- SHARS STING
    "MAG_Zhentarim_SleeperDagger", -- DREAD IRON DAGGER
    "MAG_WYRM_Farlin_Dagger", -- GLEAMDANCE DAGGER
    "MAG_TheHunters_Dagger", -- HUNTER'S DAGGER
    "MAG_Murderous_Dagger", -- MURDEROUS CUT
    "UNI_Cazador_RitualDagger", -- RHAPSODY
    "MAG_Bhaalist_Paralyzing_Dagger", -- STILLMAKER
    "GOB_Pens_Dagger", -- WORGFANG - GOBLINBANE DAGGER
    "MAG_Vicious_Dagger", -- DOLOR AMARUS
    ---CLUB
    "MAG_Enforcer_NonLethalFright_Club", -- ENFORCER CLUB
    "MAG_Druid_IronWood_Club", -- IRONWOOD CLUB
    --- FLAIL
    "MAG_BG_OfEasthaven_Defender_Flail", -- DEFENDER FLAIL
    "MAG_BG_OfAges_Flail", -- FLAIL OF AGES
    "MAG_LC_ChainDevil_Flail", -- PLANESLAYER FLAIL
    --- GLAIVE
    "MAG_BG_DragonsBreath_Glaive", -- DRAKETHROAT GLAIVE
    "DEN_HalsinBlade", -- SORROW
    "MAG_MonsterSlayer_Glaive", -- MONSTER SLAYER GLAIVE
    "MAG_Moonlight_Glaive", -- MOONLIGHT GLAIVE
    "MAG_Finesse_Glaive", -- THE DANCING BREEZE
    --- GREATAXE
    "MAG_LowHP_IncreaseDamage_Greataxe", -- BLOODED GREATAXE
    "MAG_Bloodsoaked_Greataxe", -- BLOODSOAKED GREATAXE
    "MAG_PHB_Defender_Greataxe", -- DEFENDER GREATAXE
    "UND_DuergarRaft_PestKillerAxe", -- EXTERMINATOR'S AXE
    "MAG_WATCHER_Human_Greataxe", -- HELLFIRE GREATAXE
    "MAG_SpiritualStand_Greataxe", -- SETHAN
    "MAG_WYRM_UndeadBane_GreatAxe", -- THE UNDEAD BANE
    "UNI_SuperheavyWeapon", -- VERY HEAVY GREATAXE
    --- GREATCLUB
    "MAG_TWN_Brewery_Greatclub", -- PUNCH-DRUNK BASTARD
    "MAG_Poison_Greatclub", -- ARGUMENT SOLVER
    --- GREATSWORD
    "MAG_Fire_AlwaysDippedInFire_Greatsword", -- EVERBURN BLADE
    "MAG_LowHP_IncreaseDamagePsychic_GithGreatsword", -- GITHYANKI GREATSWORD
    "MAG_TheWoundSeeker_Greatsword", -- SVARTLEBEE'S WOUNDSEEKER
    "PLA_WPN_SwordOfJustice", -- SWORD OF JUSTICE
    "MAG_Colossal_Greatsword", -- JORGORAL'S GREATSWORD
    "MAG_Githborn_Mindcrusher_Greatsword", -- SOULBREAKER GREATSWORD
    "MAG_BG_Sarevok_OfChaos_Greatsword", -- SWORD OF CHAOS
    "MAG_Giantslayer_Greatsword", -- BALDURAN'S GIANTSLAYER
    "MAG_GreaterSilver_Greatsword", -- SILVER SWORD OF THE ASTRAL PLANE
    --- HALBERD
    "MAG_ZOC_ForceConduit_Halberd", -- THE SKINBURSTER
    "MAG_BG_Harmonium_Halberd", -- HARMONIUM HALBERD
    "MAG_Infernal_Hellbeard_Halberd", -- HELLBEARD HALBERD
    "MAG_PoR_OfVigilance_Halberd", -- HALBERD OF VIGILANCE
    --- MAUL
    "UNI_DoomHammer", -- DOOM HAMMER
    "MAG_Mobility_ExplosionOnJump_Maul", -- HAMARHRAFT
    "MAG_Steadfast_Maul", -- STEADFAST MAUL
    "MAG_SWA_Roaring_Maul", -- CORPSEGRINDER
    "MAG_TheDestroyer_Maul", -- FOEBREAKER
    --- PIKE
    "MAG_Throwable_Pike", -- RETURNING PIKE
    "MAG_Invisible_Pike", -- UNSEEN MENACE
    "MAG_Force_Pike", -- BREACHING PIKESTAFF
    "MAG_TheImpaler_Pike", -- THE IMPALER
    --- HEAVY CROSSBOW
    -- "MAG_LowHP_IncreaseDamagePsychic_GithHeavyCrossbow", -- GITHYANKI CROSSBOW? (SAME WITH HEAVY CROSSBOW +1)
    "MAG_Githborn_TelekineticBolt_HeavyCrossbow", -- CROSSBOW OF ARCANE FORCE
    "MAG_Gandrel_UndeadSlayer_HeavyCrossbow", -- GANDREL'S ASPIRATION
    "MAG_MeleeDebuff_AttackDebuff2_OnDamage_HeavyCrossbow", -- GIANTBREAKER
    "MAG_BG_Harold_HeavyCrossbow", -- HAROLD
    "MAG_Gortash_HeavyCrossbow", -- FABRICATED ARBALEST
    "MAG_WATCHER_Human_Crossbow", -- HELLFIRE ENGINE CROSSBOW
    "MAG_LC_UndeadSlayer_Crossbow", -- THE LONG ARM OF THE GUR
    --- LONGBOW
    "MAG_WYR_Hellrider_Longbow", -- HELLRIDER LONGBOW
    "UNI_Bow_SpellslotRecharge", -- SPELLTHIEF
    "MAG_ChargedLightning_Longbow", -- THE JOLTSHOOTER
    "MAG_StrongString_Longbow", -- TITANSTRING BOW
    "MAG_DeadShot_Longbow", -- THE DEAD SHOT
    "MAG_TheVictory_Longbow", -- GONTR MAEL
    --- SHORTBOW
    "MAG_OfAwareness_Bow", -- BOW OF AWARENESS
    "MAG_Hunting_Shortbow", -- HUNTING SHORTBOW
    "MAG_BG_OfTheBanshee_Bow", -- BOW OF THE BANSHEE
    "MAG_BG_Darkfire_Shortbow", -- DARKFIRE SHORTBOW
    "MAG_Shadow_Blinding_Bow", -- LEAST EXPECTED
    "MAG_Vicious_Shortbow", -- VICIOUS SHORTBOW
    "MAG_BG_BlightBringer_Shortbow", -- BLIGHTBRINGER
    --- LIGHT CROSSBOW
    -- "UND_SharranCrossbow", -- SHARRAN CROSSBOW (SAME WITH LIGHT CROSSBOW +1)
    "MAG_BG_OfSpeed_LightCrossbow", -- LIGHT CROSSBOW OF SPEED
    --- HAND CROSSBOW
    "MAG_Fire_IncreasePiercingDamageToBurning_HandCrossbow", -- FIRESTOKER
    "MAG_MagicMissile_HandCrossbow", -- NE'ER MISSER
    "MAG_Orthon_Hellfire_HandCrossbow", -- HELLFIRE HAND CROSSBOW
    "MAG_Cunning_HandCrossbow", -- MAGICAL HAND CROSSBOW
    --- SPEAR
    "GOB_Torturer_Spear", -- JAGGED SPEAR
    "MAG_Kuotoa_Lightning_Spear", -- LIGHTNING JABBER
    "CHA_CompassSpear", -- THE WATCHER'S GUIDE
    "FOR_TrueSoul_Spear", -- VISION OF THE ABSOLUTE
    "SHA_SharSpear", -- SPEAR OF NIGHT
    "MAG_Infernal_Spear", -- INFERNAL SPEAR
    "MAG_SHA_SeluneBlessing_Spear", -- SELUNE'S SPEAR OF NIGHT
    "MAG_SHA_SharBlessing_Spear", -- SHAR'S SPEAR OF EVENING
    "HAV_SpearOfSelune", -- ???
    -- QUARTERSTAFF
    "FOR_WebStaff", -- SPIDERSTEP STAFF
    "WYR_Circus_MumblingStaff", -- STAFF OF A MUMBLING WIZARD
    "UNI_RepeatStaff", -- CORELLON'S GRACE
    "MAG_BasicEnchanted_Quarterstaff", -- MELF'S FIRST STAFF
    "DEN_TunnelStaff", -- NATURE'S SNARE
    "UND_Tower_StaffBlessMystra", -- STAFF OF ARCANE BLESSING
    "Quest_HAG_HagLair_Staff", -- STAFF OF CRONES?
    "MAG_Combat_Quarterstaff", -- BIGBOY'S CHEW TOY
    "MAG_Thunder_ThunderClap_Quarterstaff", -- CACOPHONY
    "MAG_PHB_PactKeeper_Quarterstaff", -- CAITIFF STAFF
    "UND_SocietyOfBrilliance_ResonanceStaff", -- CREATION'S ECHO
    "MAG_LC_Lorroakan_Quarterstaff", -- DESPAIR OF ATHKATLA
    "MAG_Fire_FireDamage_Quarterstaff", -- GOLD WYRMLING STAFF
    "MAG_Harpers_OfWeapons_Quarterstaff", -- HARPER SACREDSTRIKER
    "MAG_HigherNecromancy_Staff", -- HOLLOW'S STAFF
    "DEN_FaithwardenStaff", -- PALE OAK
    "MAG_CQCaster_GainArcaneChargeOnDamage_Quarterstaff", -- STAFF OF ACCRETION
    "MAG_LC_Counterspell_Quarterstaff", -- STAFF OF INTERRUPTION
    "END_Emperor_Staff", -- STAFF OF THE EMPEROR
    "MAG_ChargedLightning_Quarterstaff", -- THE SPELLSPARKLER
    "MAG_FlamingFist_StaffOfFire", -- INCANDESCENT STAFF
    "MAG_Cold_IncreaseColdDamageOnCast_Staff", -- MOURNING FROST
    "MAG_GreaterNecromancy_Staff", -- STAFF OF CHERISHED NECROMANCY
    "MAG_OfSpellPower_Quarterstaff", -- STAFF OF SPELL POWER
    "MAG_LC_OfTheRam_Quarterstaff", -- STAFF OF THE RAM
    "MAG_LC_CazadorVampiric_Quarterstaff", -- WOE
    "MAG_TheChromatic_Staff", -- MARKOHESHKIR
    --- LONGSWORD
    -- "MAG_LowHP_IncreaseDamagePsychic_GithLongsword", -- GITHYANKI LONGSWORD (SAME AS LONGSWORD +1)
    "MAG_OB_Paladin_DeathKnight_Longsword", -- BLACKGUARD'S SWORD
    "MAG_Illithid_MindOverload_Weapon_Longsword", -- BLADE OF OPPRESSED SOULS
    "MAG_Drowelf_SpiderSnare_Longsword", -- CRUEL STING
    "MAG_WYRM_Commander_Longsword", -- DUKE RAVENGARD'S LONGSWORD
    "MAG_Finesse_Longsword", -- LARETHIAN'S WRATH
    "UND_SwordInStone", -- PHALAR ALUVE?
    "MAG_Harpers_SingingSword", -- PHALAR ALUVE?
    "MAG_Bonded_Lethal_Longsword", -- BLOOD BOUND BLADE
    "LOW_Elfsong_EmperorSword_LongSword", -- SWORD OF THE EMPEROR
    "MAG_Primeval_Silver_Longsword", -- VOSS' SILVER SWORD
    "MAG_Infernal_Longsword", -- INFERNAL LONGSWORD
    "MAG_LC_Fleshred_Longsword", -- RENDER OF SCRUMPTIOUS FLESH
    "MAG_MeleeDebuff_AttackDebuff12versatile_OnDamage_Longsword", -- ADAMANTINE LONGSWORD
    "MAG_FlamingFist_FlamingBlade", -- ARDUOS FLAME BLADE?
    "MAG_Fire_BurningDamage_Longsword", -- ARDUOS FLAME BLADE?
    --- TRIDENT
    "MAG_LC_Frigid_Trident", -- ALLANDRA'S WHELM
    "MAG_ChargedLightning_Trident", -- THE SPARKY POINTS
    "MAG_LC_Wave_Trident", -- TRIDENT OF THE WAVES
    "MAG_TheThorns_Trident", -- NYRULNA
    --- WARHAMMER
    -- "LOW_OrphicHammer", -- ORPHIC HAMMER (QUEST ITEM)
    "GOB_GoblinKing_Warhammer", -- FAITHBREAKER
    "UND_DuergarRaft_GruesomeHammer", -- INTRANSIGENT WARHAMMER
    "MAG_Bonded_Shocking_Warhammer", -- CHARGE-BOUND WARHAMMER
    "UNI_WYR_Circus_ClownHammer", -- CLOWN HAMMER
    "MAG_Tyrrant_Warhammer", -- HAMMER OF THE JUST
    "MAG_PHB_DwarvenThrower_Warhammer", -- DWARVEN THROWER
    "MAG_Infernal_Warhammer", -- INFERNAL WARHAMMER
    "MAG_Ketheric_Warhammer", -- KETHERIC'S WARHAMMER
    --- MORNING STAR
    "MAG_Dawn_Morningstar", -- TOUGH SUNRISES
    "MAG_LC_OfTheFist_MorningStar", -- RAVENGARD'S SCOURGER
    "MAG_TWN_Taxblade_Morningstar", -- TWIST OF FORTUNE
    "MAG_RadiantLight_Morningstar", -- THE SACRED STAR
    --- RAPIER
    "MAG_OfRupture_Rapier", -- RUPTURING BLADE
    "MAG_Zhentarim_BloodfeederBlade_Rapier", -- SANGUINE BLADE
    "MAG_Harpers_Harmonizing_Rapier", -- HARMONIC DUELLER
    "ORI_Wyll_Infernal_Rapier", -- INFERNAL RAPIER
    "MAG_LC_RadiantLight_Rapier", -- PELORSUN BLADE
    "MAG_TheDueller_Rapier", -- DUELLIST'S PREROGATIVE
    --- SCIMITAR
    "MAG_Mobility_MomentumOnAttack_Scimitar", -- SPEEDY REPLY
    "MAG_HAV_Sylvan_Scimitar", -- SYLVAN SCIMITAR
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Scimitar", -- ADAMANTINE SCIMITAR
    "MAG_HAV_ThornBlade_Scimitar", -- THORN BLADE
    "MAG_PHB_OfSpeed_Scimitar", -- BELM
    "MAG_Justiciar_Scimitar", -- JUSTICIAR'S SCIMITAR
    "MAG_LC_BurnOnDamage_Scimitar", -- KURWIN'S CAUTERISER
    "MAG_LC_PirateCommander_Scimitar", --- SALTY SCIMITAR (RRR)
    --- SHORTSWORD
    -- "MAG_LowHP_IncreaseDamagePsychic_GithShortsword", -- GITHYANKI SHORTSWORD (SAME WITH SHORTSWORD +1)
    -- "WPN_Trepan", -- TREPAN (TOO WEAK)
    "MAG_Surgeon_Trepan", -- SURGEON TREPAN
    "TWN_ShortswordOfStealth", -- ASSASSIN'S SHORTSWORD
    "MAG_Blindside_Shortsword", -- RENDER OF MIND AND BODY
    "UND_Duergar_ShortswordOfFirstBlood", -- SHORTSWORD OF FIRST BLOOD
    "MAG_Ambusher_Shortsword", -- AMBUSHER
    "MAG_FreeCast_Shortsword", -- EXECUTIONER SWORD
    "MAG_LC_Fleshrend_Shortsword", -- FLESHRENDER
    "MAG_Slicing_Shortsword", -- SLICING SHORTSWORD
    "MAG_Shadow_Shortsword", -- SWORD OF CLUTCHING UMBRA
    "MAG_Bonded_Baneful_Shortsword", -- THE BANEFUL
    "MAG_Vicious_Shortsword", -- VICIOUS SHORTSWORD
    "MAG_Duergar_Sword_KingsKnife", -- KNIFE OF THE UNDERMOUNTAIN KING
    "MAG_PHB_OfLifestealing_Shortsword", -- SWORD OF LIFE STEALING
    "MAG_TheCrimson_Shortsword", -- CRIMSON MISCHIEF
    "MAG_TheClover_Scimitar", -- THE CLOVER
    --- WARPICK
    "UND_KC_Elder_Warpick", -- DEEP DELVER
    "MAG_Revitalizing_Warpick", -- HOPPY
    --- HANDAXE
    "WYR_Circus_HandaxeReturning", -- COMEBACK HANDAXE
    "MAG_Fire_IncreaseSlashingDamageToBurning_Handaxe", -- DRAGON'S GRASP
    --- LIGHT HAMMER
    "MAG_Radiant_Radiating_Hammer", -- SHINING STAVER-OF-SKULLS
    "UND_DuergarBlacksmithHammer", -- SKYBREAKER
    "MOO_WulbrenHammer", -- WULBREN'S HAMMER
    --- SICKLE
    "MAG_LC_Umberlee_Cold_Sickle", -- WAVEMOTHER'S SICKLE
    --- MACE
    "WPN_Mace_Deva", -- DEVA MACE
    "GOB_DrowCommander_Mace", -- XYANYDE
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Mace", -- ADAMANTINE MACE
    "MAG_Infernal_Mace", -- INFERNAL MACE
    "MAG_Infernal_Mace_2", -- INFERNAL MACE
    "PLA_ConflictedFlind_Flail_Broken", -- SHATTERED FLAIL
    "MAG_Viconia_Mace", -- HANDMAIDEN'S MACE
    "MAG_Cleric_Devotees_Mace", -- DEVOTEE'S MACE
    "CRE_BloodOfLathander", -- THE BLOOD OF LATHANDER
    --- SHIELD
    "MAG_MissileProtection_Shield", -- ABDEL'S TRUSTED SHIELD
    "MAG_Absolute_Protecter_Shield", -- ABSOLUTE'S PROTECTOR
    "GOB_Priest_Shield", -- ABSOLUTE'S WARBOARD
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Shield", -- ADAMANTINE SHIELD
    "MAG_Enforcer_NonLethalBlessing_Shield", -- ENFORCER SHIELD
    "MAG_LowHP_TemporaryHP_Shield", -- GLOWING SHIELD -- MAG_Druid_Ironvine_Shield
    "MAG_Justiciar_Shield", -- JUSTICIAR'S GREATSHIELD
    "MAG_Ketheric_Shield", -- KETHERIC'S SHIELD
    "MAG_PHB_Sentinel_Shield", -- SENTINEL SHIELD
    "MAG_BG_OfDevotion_Shield", -- SHIELD OF DEVOTION
    "MAG_Bonded_Shield", -- SHIELD OF RETURNING
    "MAG_FlamingFist_Flaming_Shield", -- SHIELD OF SCORCHING REPRISAL
    "MAG_OfShielding_Shield", -- SHIELD OF SHIELDING
    "MAG_OB_Paladin_DeathKnight_Shield", -- SHIELD OF THE UNDEVOUT
    "MAG_Steadfast_Shield", -- SWIRES' SLEDBOARD
    "MAG_ChargedLightning_StaticDischarge_Shield", -- THE REAL SPARKY SPARKSWALL
    "MAG_TheBulwark_Shield", -- VICONIA'S WALKING FORTRESS
    "MAG_WoodWoad_Nature_Shield", -- WOOD WOAD SHIELD

    -- UNCATEGORIZED WEAPONS
    -- "WPN_Bonesaw",
    "MAG_Surgeon_Bonesaw",
    -- "WPN_Leech",
    "MAG_Surgeon_Leech",

    -- SUMMONS/NPC/???
        -- "Quest_SCL_Moonblade",
        -- "HAV_MAG_ShadowRending_Dagger",
        -- "WPN_Club_WoodWoad_Conjure",
        -- "WPN_SkullFlail_1",
        -- "WPN_Flail_Air_Myrmidon", -- AIR MYRMIDON FLAIL
        -- "WPN_Flail_Air_Myrmidon_ConjureElemental", -- FLAIL OF THE VORTEX
        -- "WPN_Flail_Air_Myrmidon_Wildshape", -- FLAIL OF THE VORTEX
        -- "WPN_Trident_Water_Myrmidon", -- TRIDENT OF THE DEPTHS
        -- "WPN_Trident_Water_Myrmidon_ConjureElemental", -- TRIDENT OF THE DEPTHS
        -- "WPN_Trident_Water_Myrmidon_WildShape", -- TRIDENT OF THE DEPTHS
        -- "PLA_WPN_DreadedSkullsFlail",
        -- "WPN_Orthon_Crossbow", -- ORTHON CROSSBOW
        -- "WPN_Quaterstaff_Dryad_ConjureWoodlandBeings", -- TWISTED OAK CROOK
        -- "WPN_Warhammer_Azer", -- AZER WARHAMMER
        -- "WPN_Djinni_Scimitar_PlanarAlly", -- DJINNI SCIMITAR
        -- "WPN_Scimitar_Fire_Myrmidon", -- SCIMITAR OF CINDER
        -- "WPN_Scimitar_Fire_Myrmidon_ConjureElemental", -- SCIMITAR OF CINDER
        -- "WPN_Scimitar_Fire_Myrmidon_Wildshape", -- SCIMITAR OF CINDER
        -- "WPN_Orthon_ShortSword", -- YURGIR SHORTSWORD
        -- "WPN_Apostle_Scythe", -- MYRKUL'S SCYTE?
        -- "LOW_DeadMansSwitch_Shield", -- SOMETHING IN STEELWATCH FOUNDRY

    -- MISSING ID
    --- DAGGER
        -- PROMISE
        -- RITUAL DAGGER OF SHAR
    --- FLAIL
        -- FLAIL OF MYRKUL
        -- MYRKULITE SCOURGE
    --- GREATAXE
        -- DOOM AXE
    --- SCIMITAR
        -- KURWIN'S CAUTERISER
}