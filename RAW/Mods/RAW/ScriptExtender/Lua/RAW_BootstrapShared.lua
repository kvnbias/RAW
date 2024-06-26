-- Lib
Ext.Require("RAW_Lib.lua")

-- Config
Ext.Require("RAW_Config.lua")
RAW_LoadModOptions()

-- StatsLoaded Event
local RAW_StatsLoadedPath = "StatsLoaded/"

Ext.Require(RAW_StatsLoadedPath .. "RAW_Attunement.lua")
Ext.Require(RAW_StatsLoadedPath .. "RAW_CharacterPassives.lua")
Ext.Require(RAW_StatsLoadedPath .. "RAW_Spells_BonusAction.lua")
Ext.Require(RAW_StatsLoadedPath .. "RAW_Concentration.lua")
Ext.Require(RAW_StatsLoadedPath .. "RAW_EquipAction.lua")

local function RAW_StatsLoaded()
    RAW_PrintIfDebug("\n====================================================================================================", RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug(CentralizedString("[RAW:BootstrapShared.lua] StatsLoaded Start"), RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug("====================================================================================================\n", RAW_PrintTable_ModOptions)

    RAW_CharacterPassives()
    RAW_Spells_BonusAction()
    RAW_Concentration()
    RAW_EquipAction()
    RAW_Attunement()

    RAW_PrintIfDebug("\n====================================================================================================", RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug(CentralizedString("[RAW:BootstrapShared.lua] StatsLoaded Ended"), RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug("====================================================================================================\n", RAW_PrintTable_ModOptions)
end

Ext.Events.StatsLoaded:Subscribe(RAW_StatsLoaded)

-- Osiris Files
local RAW_OsirisFilesPath = "Osiris/"

Ext.Require(RAW_OsirisFilesPath .. "RAW_WeaponSets.lua")

if Ext.IsServer() then
    RAW_PrintIfDebug("\n====================================================================================================", RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug(CentralizedString("[RAW:BootstrapShared.lua] Osiris Registration Start"), RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug("====================================================================================================\n", RAW_PrintTable_ModOptions)

    RAW_WeaponSets()

    RAW_PrintIfDebug("\n====================================================================================================", RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug(CentralizedString("[RAW:BootstrapShared.lua] Osiris Registration Ended"), RAW_PrintTable_ModOptions)
    RAW_PrintIfDebug("====================================================================================================\n", RAW_PrintTable_ModOptions)
end

-- To-do: Activate this when the changes to RAW_Config.lua ShowError is made
-- Menu event for Config popup
-- Ext.Events.GameStateChanged:Subscribe(function(e)
--     if e.ToState == "Menu" then
        -- RAW_LoadModOptions(true)
--     end
-- end)
