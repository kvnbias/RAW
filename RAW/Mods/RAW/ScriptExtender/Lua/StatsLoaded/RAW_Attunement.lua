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

-- Source: https://docs.google.com/spreadsheets/d/1yCJ9ITC180dqykK713iHMEsrvVOHkgOmLF882-yr_hQ/edit#gid=0&fvid=1734738953
ENUM_RAW_AttunementList = {
    "ACT1_HAG_HagMask",
    "ARM_BootsOfSpeed",
    "ARM_CircletOfBlasting",
    "ARM_HeadbandOfIntellect",
    "ARM_RingOfPoisonResistance",
    "ARM_TalismanOfJergal",
    "CHA_OutpostJewelry",
    "CRE_BloodOfLathander",
    "CRE_Hatchery_AcidPoisonImmunity_Boots",
    "CRE_MAG_Githborn_Amulet",
    "CRE_MAG_Psychic_Githborn_Circlet",
    "DEN_HellridersPride",
    "FOR_DeathOfATrueSoul_TrueSoul_Ring",
    "FOR_NightWalkers",
    "FOR_OgresForHire_HeadbandOfIntellect",
    "FOR_OwlbearCubs_Armor",
    "GOB_DrowCommander_Amulet",
    "GOB_DrowCommander_Leather_Armor",
    "GOB_DrowCommander_Mace",
    "GOB_GoblinKing_Warhammer",
    "GOB_Priest_Shield",
    "LOW_DeadMansSwitch_Shield",
    "LOW_Elfsong_EmperorSword_LongSword",
    "LOW_JannathRing_Ring",
    "LOW_KerriRing_Ring",
    "LOW_OfWindrider_Amulet",
    "LOW_OrphicHammer",
    "LOW_PendulumOfMalagard",
    "MAG_Absolute_Protecter_Shield",
    "MAG_Acid_AcidDamageOnWeaponAttack_Ring",
    "MAG_Acid_AcidMeleeCounter_Cloak",
    "MAG_Acid_NoxiousFumes_Gloves",
    "MAG_Acrobat_Shoes",
    "MAG_Ambusher_Shortsword",
    "MAG_Arcanist_Gloves",
    "MAG_BG_Gargoyle_Boots",
    "MAG_BG_OfCrushing_Gloves",
    "MAG_BG_OfDevotion_Shield",
    "MAG_BG_OfDexterity_Gloves",
    "MAG_BG_OfTheMasters_Legacy_Gauntlet",
    "MAG_BG_Wondrous_Gloves",
    "MAG_Banites_Gloves",
    "MAG_BarbMonk_Cloth_Hat_A_1_Late",
    "MAG_BarbMonk_Defensive_Cloth",
    "MAG_BarbMonk_Offensive_Cloth",
    "MAG_Barbarian_BoneSpike_Armor",
    "MAG_Barbarian_BoneSpike_Helmet",
    "MAG_Barbarian_BoneSpike_Shoes",
    "MAG_Barbarian_Magic_Armor_1",
    "MAG_Bard_HealingBardicInspiration_Hat",
    "MAG_Bard_RefreshBardicInspirationSlot_Shoes",
    "MAG_Bard_TempHP_Armor",
    "MAG_Bhaalist_Armor",
    "MAG_Bhaalist_Gloves",
    "MAG_Bhaalist_Hat",
    "MAG_BlackTentacle_Amulet",
    "MAG_Blindside_Shortsword",
    "MAG_Bonded_Baneful_Shortsword",
    "MAG_Bonded_Lethal_Longsword",
    "MAG_Bonded_Shield",
    "MAG_Bonded_Shocking_Warhammer",
    "MAG_BonusAttack_AgainstMarked_Circlet",
    "MAG_CKM_SerpenScale_Armor",
    "MAG_CQCaster_ArcaneChargeAfterDash_Boots",
    "MAG_CQCaster_CloseRangedSpellMastery_Gloves",
    "MAG_CQCaster_GainArcaneChargeOnDamaged_Robe",
    "MAG_CQCaster_TempHPAfterCast_Cloak",
    "MAG_ChargedLightning_AbilityCheckBoost_Gloves",
    "MAG_ChargedLightning_BonusAC_Robe",
    "MAG_ChargedLightning_Dash_Boots",
    "MAG_ChargedLightning_ElectricSurface_Boots",
    "MAG_ChargedLightning_Electrocute_Armor",
    "MAG_ChargedLightning_EnsnaringShock_Ring",
    "MAG_ChargedLightning_LightningBlast_Amulet",
    "MAG_ChargedLightning_Resistance_Ring",
    "MAG_ChargedLightning_StaticDischarge_Amulet",
    "MAG_ChargedLightning_StaticDischarge_Shield",
    "MAG_ChargedLightning_TempHP_Helmet",
    "MAG_ChargedLightning_Trident",
    "MAG_CharismaCaster_Robe",
    "MAG_Cleric_Devotees_Mace",
    "MAG_Critical_ArcanicCritical_Gloves",
    "MAG_Critical_BolsteringCritical_Armor",
    "MAG_Critical_CriticalExecution_Ring",
    "MAG_Critical_CriticalSwiftness_Boots",
    "MAG_Critical_Force_Gloves",
    "MAG_Critical_HidingCritical_Cloak",
    "MAG_DarkJusticiar_HalfPlate",
    "MAG_Dawn_Morningstar",
    "MAG_DevilsBlackmith_ScaleMail",
    "MAG_Drowelf_SpiderSnare_Longsword",
    "MAG_Druid_Land_Magic_Leather_Armor",
    "MAG_Druid_Late_Hide_Armor_1",
    "MAG_Druid_Late_Hide_Armor_2",
    "MAG_Druid_Magic_Hide_Armor",
    "MAG_Druid_Magic_StuddedLeather_Armor",
    "MAG_Druid_Moon_Magic_Leather_Armor",
    "MAG_Druid_Spore_Magic_Leather_Armor",
    "MAG_Druid_Wildshape_Hat",
    "MAG_Duergar_Sword_KingsKnife",
    "MAG_ElementalGish_AbsorbElements_Cloak",
    "MAG_ElementalGish_BaneOnElementalWeaponDamage_Gloves",
    "MAG_ElementalGish_CantripBooster_Amulet",
    "MAG_ElementalGish_ElementalInfusion_Ring",
    "MAG_EndGameCaster_Cloak",
    "MAG_EndGameCaster_Hood",
    "MAG_EndGameCaster_Robe",
    "MAG_EndGame_HalfPlate",
    "MAG_EndGame_Metal_Boots",
    "MAG_EndGame_Plate_Armor",
    "MAG_EndGame_StuddedLeather_Armor",
    "MAG_Enforcer_NonLethalBlessing_Shield",
    "MAG_Enforcer_RejunevatingKnock_Helmet",
    "MAG_Evasive_Shoes",
    "MAG_Fighter_ActionSurge_AttackBonus_Gloves",
    "MAG_Finesse_Longsword",
    "MAG_Fire_ApplyBurningOnFireDamage_Gloves",
    "MAG_Fire_ArcaneAcuityOnFireDamage_Hat",
    "MAG_Fire_BonusActionOnFireSpell_Circlet",
    "MAG_Fire_BurningDamage_Longsword",
    "MAG_Fire_BurningOnDamaged_Cloak",
    "MAG_Fire_HeatOnInflictBurning_Boots",
    "MAG_Fire_IncreaseSlashingDamageToBurning_Handaxe",
    "MAG_Fire_IncreasedDamage_Ring",
    "MAG_FlamingFist_BattleWizardGloves",
    "MAG_FlamingFist_Flame_Armor",
    "MAG_FlamingFist_FlamingBlade",
    "MAG_FlamingFist_Flaming_Shield",
    "MAG_FlamingFist_ScoutRing",
    "MAG_FreeCast_Shortsword",
    "MAG_Frost_GenerateFrostOnDamage_Robe",
    "MAG_Frost_IceSurfaceProneImmunity_Boots",
    "MAG_Gish_ArcaneAcuity_Gloves",
    "MAG_Gish_ArcaneSynergy_Ring",
    "MAG_Gish_PsychicDamageBonusWhileConcentrating_Ring",
    "MAG_Gish_TempHPWhileConcentrating_Boots",
    "MAG_Gish_WeaknessBranding_Amulet",
    "MAG_Githborn_MagicEating_HalfPlate",
    "MAG_GleamingSorcery_Hat",
    "MAG_Gortash_Boots",
    "MAG_Gortash_Cloth",
    "MAG_Gortash_Gloves",
    "MAG_HAV_Sylvan_Scimitar",
    "MAG_HAV_ThornBlade_Scimitar",
    "MAG_Harpers_Harmonizing_Rapier",
    "MAG_Harpers_HarpersAmulet",
    "MAG_Harpers_SingingSword",
    "MAG_Hat_Barbarian_Hide",
    "MAG_Hat_Butler",
    "MAG_Healer_DisengageOnHeal_ChainShirt",
    "MAG_Healer_HPRestoration_Amulet",
    "MAG_Healer_HealSelf_Helmet",
    "MAG_Healer_TempHPOnHeal_Boots",
    "MAG_Heat_Fire_Robe",
    "MAG_Illithid_Carapace_Armor",
    "MAG_Illithid_MindOverload_Weapon_Longsword",
    "MAG_Illithid_Regen_Circlet",
    "MAG_Infernal_Longsword",
    "MAG_Infernal_Mace",
    "MAG_Infernal_Mace_2",
    "MAG_Infernal_Metal_Boots",
    "MAG_Infernal_Metal_Gloves",
    "MAG_Infernal_Metal_Helmet",
    "MAG_Infernal_Plate_Armor",
    "MAG_Infernal_Warhammer",
    "MAG_JusticiarArmor_Gloves",
    "MAG_Justiciar_Scimitar",
    "MAG_Justiciar_Shield",
    "MAG_Ketheric_Shield",
    "MAG_LC_BurnOnDamage_Scimitar",
    "MAG_LC_DrowSpider_Gloves",
    "MAG_LC_Fleshred_Longsword",
    "MAG_LC_Fleshrend_Shortsword",
    "MAG_LC_Frigid_Trident",
    "MAG_LC_HellishMadness_Amulet",
    "MAG_LC_Jannath_Hat",
    "MAG_LC_Lorroakan_Robe",
    "MAG_LC_Nymph_Cloak",
    "MAG_LC_OfTheFist_MorningStar",
    "MAG_LC_PirateCommander_Scimitar",
    "MAG_LC_RadiantLight_Rapier",
    "MAG_LC_TheAmplifier_Amulet",
    "MAG_LC_Umberlee_Cold_Sickle",
    "MAG_LC_Umberlee_Protection_Cape",
    "MAG_LC_Umberlee_Regeneration_Boots",
    "MAG_LC_Umberlee_Regeneration_Robe",
    "MAG_LC_Wave_Trident",
    "MAG_LegendaryEvasion_Amulet",
    "MAG_Lesser_Infernal_Plate_Armor",
    "MAG_LowHP_BonusAction_Helmet",
    "MAG_LowHP_CounterOnDamage_ChainShirt",
    "MAG_LowHP_IgnoreAttackOfOpportunity_Amulet",
    "MAG_LowHP_IncreaseDamagePsychic_GithLongsword",
    "MAG_LowHP_IncreaseDamagePsychic_GithShortsword",
    "MAG_LowHP_IncreaseSpeed_Boots",
    "MAG_LowHP_IncreasedSpellDamage_Amulet",
    "MAG_LowHP_ResistanceFire_Gloves",
    "MAG_LowHP_TemporaryHP_Shield",
    "MAG_LuckySeven_Amulet",
    "MAG_MM_Sorcery_SeekingSpell_Gloves",
    "MAG_MeleeDebuff_AttackDebuff12versatile_OnDamage_Longsword",
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Helmet",
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Mace",
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_ScaleMail",
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Scimitar",
    "MAG_MeleeDebuff_AttackDebuff1_OnDamage_Shield",
    "MAG_MeleeDebuff_AttackDebuff2_OnDamage_SplintMail",
    "MAG_MissileProtection_Shield",
    "MAG_Mobility_JumpOnDash_Gloves",
    "MAG_Mobility_LowHP_Momentum_Ring",
    "MAG_Mobility_MomentumOnAttack_Scimitar",
    "MAG_Mobility_MomentumOnCombatStart_Helmet",
    "MAG_Mobility_MomentumOnDash_Boots",
    "MAG_Mobility_SprintForMomentum_ChainShirt",
    "MAG_Monk_Cold_Gloves",
    "MAG_Monk_Fire_Gloves",
    "MAG_Monk_Lightning_Gloves",
    "MAG_Monk_Magic_Armor_1",
    "MAG_Monk_SoulPerception_Hat",
    "MAG_Monk_SoulRejunevation_Armor",
    "MAG_Monk_Thunder_Gloves",
    "MAG_Myrkulites_CircletOfMyrkul_Circlet",
    "MAG_OB_Paladin_DeathKnight_Armor",
    "MAG_OB_Paladin_DeathKnight_Gloves",
    "MAG_OB_Paladin_DeathKnight_Longsword",
    "MAG_OB_Paladin_DeathKnight_Shield",
    "MAG_OfArcanicAssault_Robe",
    "MAG_OfArcanicDefense_Robe",
    "MAG_OfAutomaton_Gloves",
    "MAG_OfBlink_Ring",
    "MAG_OfFeywildSparks_Ring",
    "MAG_OfGreaterSorcery_Amulet",
    "MAG_OfRevivify_Gloves",
    "MAG_OfRupture_Rapier",
    "MAG_OfSharpCaster_Hat",
    "MAG_OfShielding_Shield",
    "MAG_OfSpellResistance_Robe",
    "MAG_OfSwordmaster_Gloves",
    "MAG_OfTheBalancedHands_Gloves",
    "MAG_OfTheDevout_Amulet",
    "MAG_OfTheDuelist_Gloves",
    "MAG_OfTheShapeshifter_Mask",
    "MAG_OpenHand_Radiant_Gloves",
    "MAG_PHB_CloakOfDisplacement_Cloak",
    "MAG_PHB_CloakOfProtection_Cloak",
    "MAG_PHB_DwarvenThrower_Warhammer",
    "MAG_PHB_OfEvasion_Ring",
    "MAG_PHB_OfFreeAction_Ring",
    "MAG_PHB_OfJumping_Ring",
    "MAG_PHB_OfLifestealing_Shortsword",
    "MAG_PHB_OfRegeneration_Ring",
    "MAG_PHB_OfSoulCatching_Gloves",
    "MAG_PHB_OfSpeed_Scimitar",
    "MAG_PHB_PeriaptofWoundClosure_Amulet",
    "MAG_PHB_Ring_Of_Protection",
    "MAG_PHB_ScarabOfProtection_Amulet",
    "MAG_PHB_Sentinel_Shield",
    "MAG_PHB_ofPower_Pearl_Amulet",
    "MAG_Paladin_LayOnHandsSupport_Gloves",
    "MAG_Paladin_MomentumOnConcentration_Boots",
    "MAG_Paladin_RestoreChannelDivinity_Armor",
    "MAG_Paladin_SmiteSpellsSupport_Helmet",
    "MAG_ParalyzingRay_Ring",
    "MAG_Poison_InflictPoisonHealSelf_Cloak",
    "MAG_Poison_PoisonExposure_Gloves",
    "MAG_Primeval_Silver_Longsword",
    "MAG_Psychic_MentalFatigue_Cape",
    "MAG_Psychic_MentalFatigue_Gloves",
    "MAG_Psychic_MentalOverload_Ring",
    "MAG_Psychic_PsychicFeedback_Armor",
    "MAG_Psychic_Staggering_Amulet",
    "MAG_Psychic_TempHP_Ring",
    "MAG_RadiantLight_Morningstar",
    "MAG_Radiant_CrusaderMantle_Cloak",
    "MAG_Radiant_DamageBonusOnIlluminatedTarget_Ring",
    "MAG_Radiant_RadiatingOrb_Armor",
    "MAG_Radiant_RadiatingOrb_Gloves",
    "MAG_Radiant_RadiatingOrb_Ring",
    "MAG_Radiant_Radiating_Hammer",
    "MAG_Radiant_Radiating_Helmet",
    "MAG_Restoration_SpellSlotRestoration_Amulet",
    "MAG_Revitalizing_Warpick",
    "MAG_RiskyAttack_Ring",
    "MAG_Selunite_Isobel_Robe",
    "MAG_Shadow_BlindImmunity_Ring",
    "MAG_Shadow_CriticalBoostWhileObscured_Helmet",
    "MAG_Shadow_ShadowBlade_Ring",
    "MAG_Shadow_Shadowstep_Boots",
    "MAG_Shadow_Shortsword",
    "MAG_Shove_ACboost_Ring",
    "MAG_Slicing_Shortsword",
    "MAG_SpectatorEye_Amulet",
    "MAG_Steadfast_Shield",
    "MAG_Surgeon_Bonesaw",
    "MAG_Surgeon_Leech",
    "MAG_Surgeon_Trepan",
    "MAG_TWN_Surgeon_ParalyzingCritical_Amulet",
    "MAG_TWN_Taxblade_Morningstar",
    "MAG_Taras_Collar_Amulet",
    "MAG_TerrainWalkers_Boots",
    "MAG_TheBulwark_Shield",
    "MAG_TheClover_Scimitar",
    "MAG_TheCrimson_Shortsword",
    "MAG_TheDueller_Rapier",
    "MAG_TheThorns_Trident",
    "MAG_Thunder_ArcaneAcuityOnThunderDamage_Hat",
    "MAG_Thunder_InflictDazeOnReverberatedCreature_Cloak",
    "MAG_Thunder_InflictDazeOnThunderDamage_Ring",
    "MAG_Thunder_ReverberationOnRangeSpellDamage_Amulet",
    "MAG_Thunder_ReverberationOnStatusApply_Boots",
    "MAG_Thunder_Reverberation_Gloves",
    "MAG_Tyrrant_Warhammer",
    "MAG_Vampiric_Gloves",
    "MAG_Vicious_Shortsword",
    "MAG_Viconia_Mace",
    "MAG_Viconia_Robe",
    "MAG_Violence_LowHP_Violence_Clothes",
    "MAG_Violence_ViolenceOnDamaged_Helmet",
    "MAG_Violence_ViolenceOnDash_Boots",
    "MAG_WYRM_Commander_Longsword",
    "MAG_WYRM_OfBalduran_Helmet",
    "MAG_WYRM_OfTruthTelling_Ring",
    "MAG_WYRM_UndeadProtector_Robe",
    "MAG_Warlock_Quickened_Gloves",
    "MAG_Warlock_Twinned_Gloves",
    "MAG_WoodWoad_Nature_Shield",
    "MAG_ZOC_RampartAura_Amulet",
    "MAG_Zhentarim_BloodfeederBlade_Rapier",
    "MAG_Zhentarim_Lockpicking_Gloves",
    "MAG_Zhentarim_Swap_Gloves",
    "MAG_ofGreaterHealth_Amulet",
    "MOO_Ketheric_Armor",
    "MOO_WulbrenHammer",
    "ORI_Wyll_Infernal_Rapier",
    "ORI_Wyll_Infernal_Robe",
    "PLA_ZhentCave_Gloves",
    "Quest_DEN_ARM_LuckyBoots",
    "Quest_GLO_DevilDeal_ResurrectRod",
    "Quest_GLO_Moonlantern",
    "Quest_GLO_Moonlantern_Gale",
    "Quest_SCL_Moonblade",
    "SCE_KhalidsGift",
    "SCL_SpidersLyre",
    "SHA_JusticiarArmor_Gloves",
    "SHA_SandthiefsRing",
    "TWN_NecklaceOfCharming",
    "TWN_RegretfulHunter_SoulAmulet",
    "TWN_ShortswordOfStealth",
    "UND_DeadInWater_CallarduranTrinket",
    "UND_DuergarBlacksmithHammer",
    "UND_DuergarRaft_GruesomeHammer",
    "UND_Duergar_ShortswordOfFirstBlood",
    "UND_KC_Elder_Warpick",
    "UND_KC_RingOfAbsolute",
    "UND_MonkAmulet_Amulet",
    "UND_Myco_Alchemist_HealerGloves",
    "UND_MyconidAmulet_Evil",
    "UND_MyconidAmulet_Good",
    "UND_Nere_Sword",
    "UND_ShadowOfMenzoberranzan",
    "UND_SocietyOfBrilliance_MagicMissileNecklace",
    "UND_SocietyOfBrilliance_PullingRing",
    "UND_SwordInStone",
    "UND_Tower_AmuletDetectThoughts",
    "UND_Tower_BootsFeatherFall",
    "UND_Tower_RingLight",
    "UNI_ARM_OfArchery_Gloves",
    "UNI_ARM_OfDefense_Gloves",
    "UNI_ARM_OfGiantHillStrength_Gloves",
    "UNI_ARM_OfMissileSnaring_Gloves",
    "UNI_ARM_OfTeleportation_Helm",
    "UNI_ARM_Sarevok_Armor",
    "UNI_ARM_Sarevok_Horned_Helmet",
    "UNI_DarkJusticiarArmor_HalfPlate",
    "UNI_DarkJusticiar_Helmet",
    "UNI_DarkUrge_Bhaal_Cloak",
    "UNI_GLO_Orin_TeleportRing",
    "UNI_MartyrAmulet",
    "UNI_MassHealRing",
    "UNI_Ravengard_Plate",
    "UNI_RobeOfSummer",
    "UNI_SHA_DarkJusticiar_Boots",
    "UNI_WYR_Circus_ClownHammer",
    "WPN_Apostle_Scythe",
    "WPN_Bonesaw",
    "WPN_Djinni_Scimitar_PlanarAlly",
    "WPN_Leech",
    "WPN_Mace_Deva",
    "WPN_Orthon_ShortSword",
    "WPN_Scimitar_Fire_Myrmidon",
    "WPN_Scimitar_Fire_Myrmidon_ConjureElemental",
    "WPN_Scimitar_Fire_Myrmidon_Wildshape",
    "WPN_SkullFlail_1",
    "WPN_Trepan",
    "WPN_Trident_Water_Myrmidon",
    "WPN_Trident_Water_Myrmidon_ConjureElemental",
    "WPN_Trident_Water_Myrmidon_WildShape",
    "WPN_Warhammer_Azer",
    "WYR_Circus_HandaxeReturning",
    "WYR_Circus_TeleportBoots",


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

    -- IN ATTUNEMENT
    --- BATTLEAXE
    "MAG_Critical_CriticalCombo_BattleAxe", -- COMBINATION AXE
    "MAG_Bonded_Throwing_Battleaxe", -- REBOUND BATTLEAXE
    "MAG_Shadow_Battleaxe", -- SHADOW BATTLEAXE
    "MAG_Fire_HeatOnWeaponDamage_Battleaxe", -- THERMODYNAMO AXE
    "MAG_Vicious_Battleaxe", -- VICIOUS BATTLEAXE
    "MAG_Spellbreaker_Battleaxe", -- WITCHBREAKER
    --- DAGGER
    "WPN_Syringe", -- SYRINGE
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
    "PLA_ConflictedFlind_Flail_Broken", -- SHATTERED FLAIL
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

    -- SUMMONS/NPC/???
        -- "HAV_MAG_ShadowRending_Dagger",
        -- "WPN_Club_WoodWoad_Conjure",
        -- "WPN_Flail_Air_Myrmidon", -- AIR MYRMIDON FLAIL
        -- "WPN_Flail_Air_Myrmidon_ConjureElemental", -- FLAIL OF THE VORTEX
        -- "WPN_Flail_Air_Myrmidon_Wildshape", -- FLAIL OF THE VORTEX
        -- "PLA_WPN_DreadedSkullsFlail",
        -- "WPN_Orthon_Crossbow", -- ORTHON CROSSBOW
        -- "WPN_Quaterstaff_Dryad_ConjureWoodlandBeings", -- TWISTED OAK CROOK

    -- MISSING ID
    --- DAGGER
        -- PROMISE
        -- RITUAL DAGGER OF SHAR
    --- FLAIL
        -- FLAIL OF MYRKUL
        -- MYRKULITE SCOURGE
    --- GREATAXE
        -- DOOM AXE

    "NONEXISTENT_ITEM",
}