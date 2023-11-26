local ENUM_RAW_ShieldMaster

---------------------------------------- STATS FUNCTION ----------------------------------------

function RAW_ShieldMaster()
    RAW_PrintIfDebug("\n====================================================================================================", RAW_PrintTable_ShieldMaster)
    RAW_PrintIfDebug(CentralizedString("Option: feats"), RAW_PrintTable_ShieldMaster)

    if not IsModOptionEnabled("feats") then
        RAW_PrintIfDebug(CentralizedString("Disabled!"), RAW_PrintTable_ShieldMaster)
        RAW_PrintIfDebug(CentralizedString("Skipping the Shield Master changes"), RAW_PrintTable_ShieldMaster)
        RAW_PrintIfDebug("====================================================================================================\n", RAW_PrintTable_ShieldMaster)
        return
    end

    RAW_PrintIfDebug(CentralizedString("Enabled!"), RAW_PrintTable_ShieldMaster)
    RAW_PrintIfDebug(CentralizedString("Starting the Shield Master changes"), RAW_PrintTable_ShieldMaster)

    RAW_ApplyStaticData(ENUM_RAW_ShieldMaster, RAW_PrintTable_ShieldMaster)

    RAW_PrintIfDebug("\n" .. CentralizedString("Finished the Feats changes"), RAW_PrintTable_ShieldMaster)
    RAW_PrintIfDebug("====================================================================================================\n", RAW_PrintTable_ShieldMaster)
end

---------------------------------------- MODELS ----------------------------------------

ENUM_RAW_ShieldMaster = {
    ["Feat"] = {
        ["3fe71254-d1b2-44c7-886c-927552fe5f2e"] = {
            ["PassivesAdded"] = {
                ["Type"] = "add",
                ["Value"] = "RAW_ShieldMaster_Shove",
            },
        },
    },
}
