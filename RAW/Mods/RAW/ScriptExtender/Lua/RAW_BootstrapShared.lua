-- Lib
Ext.Require("RAW_Lib.lua")

-- Config
Ext.Require("RAW_Config.lua")
RAW_LoadModOptions()

-- StatsLoaded Event
local RAW_StatsLoadedPath = "StatsLoaded/"

Ext.Require(RAW_StatsLoadedPath .. "RAW_CharacterPassives.lua")
Ext.Require(RAW_StatsLoadedPath .. "RAW_Concentration.lua")
Ext.Require(RAW_StatsLoadedPath .. "RAW_Attunement.lua")
Ext.Require(RAW_StatsLoadedPath .. "RAW_EquipAction.lua")

local function RAW_StatsLoaded()
    Ext.Utils.Print("\n====================================================================================================")
    Ext.Utils.Print(CentralizedString("[RAW:BootstrapShared.lua] StatsLoaded Start"))
    Ext.Utils.Print("====================================================================================================\n")

    RAW_CharacterPassives()
    RAW_Concentration()
    RAW_EquipAction()
    RAW_Attunement()

    Ext.Utils.Print("\n====================================================================================================")
    Ext.Utils.Print(CentralizedString("[RAW:BootstrapShared.lua] StatsLoaded Ended"))
    Ext.Utils.Print("====================================================================================================\n")
end

Ext.Events.StatsLoaded:Subscribe(RAW_StatsLoaded)

-- Osiris Files
local RAW_OsirisFilesPath = "Osiris/"

Ext.Require(RAW_OsirisFilesPath .. "RAW_WeaponSets.lua")

if Ext.IsServer() then
    Ext.Utils.Print("\n====================================================================================================")
    Ext.Utils.Print(CentralizedString("[RAW:BootstrapShared.lua] Osiris Registration Start"))
    Ext.Utils.Print("====================================================================================================\n")

    RAW_WeaponSets()

    Ext.Utils.Print("\n====================================================================================================")
    Ext.Utils.Print(CentralizedString("[RAW:BootstrapShared.lua] Osiris Registration Ended"))
    Ext.Utils.Print("====================================================================================================\n")
end
