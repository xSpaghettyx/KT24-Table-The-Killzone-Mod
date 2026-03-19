function onLoad()
    local targetColors = {"Red", "Blue", "Yellow", "Teal", "Black"}
    for _, color in ipairs(targetColors) do
        if Player[color].seated then
            createDatasheetHUD(color)
        end
    end
    self.addContextMenuItem("Delete Datasheet HUD", function(playerColor) deleteDatasheetHUD(playerColor) end)
    self.addContextMenuItem("Refresh Datasheet HUD", function(playerColor) refreshDatasheetHUD(playerColor) end)
end

function createDatasheetHUD(playerColor)
    local suffix = "_"..playerColor

    local basePanelHeight = 30
   
    local spacing = 5
    local bodyWidth = 700

    -- Stats panel formatting
    local statsPanelHeight = 60
    local statsPanelSubHeight = 28
    local StatsSubPanels = 4
    local usableStatsWidth = bodyWidth - spacing
    local statsNameWidth = math.floor(usableStatsWidth * 6/10)
    local statsSubWidth = math.floor(usableStatsWidth * 1/10)
    local statsSubRowWidth = math.floor(usableStatsWidth * 4/10)

    local nameLineSize = 350
    local nameLineOffset = math.floor((statsNameWidth-nameLineSize)/-2)
    local nameLinePosition = string.format("%d -10 0", nameLineOffset)

    -- Weapons panel formatting
    local weaponsPanelHeight = 25
    local totalWeaponsSpacing = spacing * 5
    local usableWeaponsWidth = bodyWidth - totalWeaponsSpacing
    local weaponCellWidth = math.floor(usableWeaponsWidth / 15)
    local weaponNameWidth = math.floor(usableWeaponsWidth * 4/15)
    local weaponStatsWidth = math.floor(weaponCellWidth * 3 + spacing * 2)
    local weaponRulesWidth = math.floor(usableWeaponsWidth * 7/15)

    local weaponNameOffset = math.floor(weaponCellWidth + spacing)
    local weaponATKOffset = math.floor(weaponNameOffset + weaponNameWidth + spacing)
    local weaponHITOffset = math.floor(weaponATKOffset + weaponCellWidth + spacing)
    local weaponDMGOffset = math.floor(weaponHITOffset + weaponCellWidth + spacing)
    local weaponRulesOffset = math.floor(weaponDMGOffset + weaponCellWidth + spacing)

    local weaponNamePosition = string.format("%d 0 0", weaponNameOffset)
    local weaponATKPosition = string.format("%d 0 0", weaponATKOffset)
    local weaponHITPosition = string.format("%d 0 0", weaponHITOffset)
    local weaponDMGPosition = string.format("%d 0 0", weaponDMGOffset)
    local weaponRulesPosition = string.format("%d 0 0", weaponRulesOffset)

    -- Abilities panel formatting
    local abilitiesPanels = {"ability1", "ability2"}
    local numAbilities = #abilitiesPanels
    local totalAbilitiesSpacing = spacing * numAbilities
    local usableAbilitiesWidth = bodyWidth - totalAbilitiesSpacing

local xmlNode = {
    tag="Panel",
    attributes={
        id="datasheetHUD_body"..suffix,
        width=tostring(bodyWidth),
        height=300,
        rectAlignment="MiddleCenter",
        spacing=tostring(spacing),
        allowDragging="true",
        returnToOriginalPositionWhenReleased="false"
    },
    children={
        {
            tag="Panel",
            attributes={spacing="2", rectAlignment="UpperLeft", width=tostring(bodyWidth), height=tostring(statsPanelHeight)},
            children={
                {
                    tag="Panel", attributes={id="stats_name"..suffix, width=tostring(statsNameWidth), height=tostring(statsPanelHeight), rectAlignment="UpperLeft"},
                    children={
                        {tag="Image", attributes={color="#222222DD", width=tostring(statsNameWidth), height=tostring(statsPanelHeight)}},
                        {tag="Image", attributes={color="#ff5e00", width=tostring(nameLineSize), height="3", position=nameLinePosition}},
                        {tag="Text", attributes={id="statsNameText"..suffix, text="Operative name", fontSize="18", fontStyle="Bold", color="#FFFFFF", alignment="MiddleLeft", position="10 0 0"}}
                    }
                },
                {
                    tag="HorizontalLayout",
                    attributes={width=tostring(statsSubRowWidth), height=tostring(statsPanelHeight), spacing=tostring(spacing), rectAlignment="UpperRight"},
                    children={
                        {
                            tag="Panel", attributes={id="stats_APL"..suffix, width=tostring(statsSubWidth), height=tostring(statsPanelHeight)},
                            children={
                                {tag="Image", attributes={color="#333333DD", width=tostring(statsSubWidth), height=tostring(statsPanelHeight)}},
                                {tag="Text", attributes={id="statsAPLHeader"..suffix, text="APL", fontSize="13", fontStyle="Bold", color="#FFFFFF", alignment="UpperCenter", position="0 -8 0"}},
                                {tag="Image", attributes={color="#ff5e00", width="20", height="20", position="-13 -9 0", alignment="MiddleCenter"}},
                                {tag="Text", attributes={id="statsAPLValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="13 -9 0", alignment="MiddleCenter"}}
                            }
                        },
                        {
                            tag="Panel", attributes={id="stats_move"..suffix, width=tostring(statsSubWidth), height=tostring(statsPanelHeight)},
                            children={
                                {tag="Image", attributes={color="#333333DD", width=tostring(statsSubWidth), height=tostring(statsPanelHeight)}},
                                {tag="Text", attributes={id="statsMoveHeader"..suffix, text="MOVE", fontSize="13", fontStyle="Bold", color="#FFFFFF", alignment="UpperCenter", position="0 -8 0"}},
                                {tag="Image", attributes={color="#ff5e00", width="20", height="20", position="-14 -9 0", alignment="MiddleCenter"}},
                                {tag="Text", attributes={id="statsMoveValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="14 -9 0", alignment="MiddleCenter"}}
                            }
                        },
                        {
                            tag="Panel", attributes={id="stats_save"..suffix, width=tostring(statsSubWidth), height=tostring(statsPanelHeight)},
                            children={
                                {tag="Image", attributes={color="#333333DD", width=tostring(statsSubWidth), height=tostring(statsPanelHeight)}},
                                {tag="Text", attributes={id="statsSaveHeader"..suffix, text="SAVE", fontSize="13", fontStyle="Bold", color="#FFFFFF", alignment="UpperCenter", position="0 -8 0"}},
                                {tag="Image", attributes={color="#ff5e00", width="20", height="20", position="-14 -9 0", alignment="MiddleCenter"}},
                                {tag="Text", attributes={id="statsSaveValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="14 -9 0", alignment="MiddleCenter"}}
                            }
                        },
                        {
                            tag="Panel", attributes={id="stats_wounds"..suffix, width=tostring(statsSubWidth), height=tostring(statsPanelHeight)},
                            children={
                                {tag="Image", attributes={color="#333333DD", width=tostring(statsSubWidth), height=tostring(statsPanelHeight)}},
                                {tag="Text", attributes={id="statsWoundsHeader"..suffix, text="WOUNDS", fontSize="13", fontStyle="Bold", color="#FFFFFF", alignment="UpperCenter", position="0 -8 0"}},
                                {tag="Image", attributes={color="#ff5e00", width="20", height="20", position="-13 -9 0", alignment="MiddleCenter"}},
                                {tag="Text", attributes={id="statsWoundsValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="13 -9 0", alignment="MiddleCenter"}}
                            }
                        }
                    }
                }
            }
        },
        {
            tag="Panel",
            attributes={width=tostring(bodyWidth), height=tostring(weaponsPanelHeight), position="0 -35 0"},
            children={
                {
                    tag="HorizontalLayout",
                    attributes={width=tostring(bodyWidth), height=tostring(weaponsPanelHeight), spacing=tostring(spacing)},
                    children={
                        {tag="Panel", attributes={id="weaponsHeaderBlank"..suffix, height=tostring(weaponsPanelHeight)},
                            children={{tag="Image", attributes={color="#ff5e00", width="20", height="20", rectAlignment="MiddleCenter"}}}},
                        {tag="Panel", attributes={id="weaponsHeaderName"..suffix, preferredWidth=weaponNameWidth, height=tostring(weaponsPanelHeight)},
                            children={{tag="Text", attributes={id="weaponsHeaderNameText"..suffix, text="NAME", fontSize="20", color="#000000", alignment="MiddleLeft", position="10 0 0"}}}},
                        {tag="Panel", attributes={id="weaponsHeaderATK"..suffix, height=tostring(weaponsPanelHeight)},
                            children={{tag="Text", attributes={id="weaponsHeaderATKText"..suffix, text="ATK", fontSize="20", color="#000000", alignment="MiddleLeft", position="10 0 0"}}}},
                        {tag="Panel", attributes={id="weaponsHeaderHIT"..suffix, height=tostring(weaponsPanelHeight)},
                            children={{tag="Text", attributes={id="weaponsHeaderHITText"..suffix, text="HIT", fontSize="20", color="#000000", alignment="MiddleLeft", position="10 0 0"}}}},
                        {tag="Panel", attributes={id="weaponsHeaderDMG"..suffix, height=tostring(weaponsPanelHeight)},
                            children={{tag="Text", attributes={id="weaponsHeaderDMGText"..suffix, text="DMG", fontSize="20", color="#000000", alignment="MiddleLeft", position="10 0 0"}}}},
                        {tag="Panel", attributes={id="weaponsHeaderWR"..suffix, preferredWidth=weaponRulesWidth, height=tostring(weaponsPanelHeight)},
                            children={{tag="Text", attributes={id="weaponsHeaderWRText"..suffix, text="WR", fontSize="20", color="#000000", alignment="MiddleLeft", position="10 0 0"}}}}
                    }
                }
            }
        },
        {
            tag="Panel", attributes={id="datasheetHUD_abilities"..suffix, flex="1", flexibleWidth="true", height=tostring(basePanelHeight), position="0 -90 0"},
            children={
                {tag="Image", attributes={color="#444444DD", flexibleWidth="true", height=tostring(basePanelHeight)}},
                {tag="Text", attributes={id="hudBottomText"..suffix, text="abilities", fontSize="24", color="#FFFFFF", alignment="MiddleCenter"}}
            }
        }
    }
}

    local current = UI.getXmlTable({player=playerColor}) or {}
    table.insert(current, xmlNode)
    UI.setXmlTable(current, {player=playerColor})
end

local function safeSetAttribute(id, attr, value, playerColor)
    UI.setAttribute(id, attr, value, {player=playerColor})
end

function updateDatasheetHUD(playerColor, data)
    local suffix = "_"..playerColor

    safeSetAttribute("statsNameText"..suffix, "text", tostring(data.name or "Operative name"), playerColor)
    safeSetAttribute("statsAPLValue"..suffix, "text", tostring(data.apl or "APL"), playerColor)
    safeSetAttribute("statsMoveValue"..suffix, "text", tostring(data.move or "move"), playerColor)
    safeSetAttribute("statsSaveValue"..suffix, "text", tostring(data.save or "save"), playerColor)
    safeSetAttribute("statsWoundsValue"..suffix, "text", tostring(data.wounds or "wounds"), playerColor)

    safeSetAttribute("hudMiddleText"..suffix, "text", tostring(data.weapons or "weapons"), playerColor)
    safeSetAttribute("hudBottomText"..suffix, "text", tostring(data.abilities or "abilities"), playerColor)
end


function deleteDatasheetHUD(playerColor)
    local suffix = "_"..playerColor
    local current = UI.getXmlTable({player=playerColor})
    if current == nil then return end
    local filtered = {}
    for _, node in ipairs(current) do
        if node.attributes == nil or node.attributes.id ~= "datasheetHUD_body"..suffix then
            table.insert(filtered, node)
        end
    end
    UI.setXmlTable(filtered, {player=playerColor})
end

function refreshDatasheetHUDAll()
    for _, color in ipairs(Player.getColors()) do
        UI.setXmlTable({}, {player=color})
        createDatasheetHUD(color)
    end
end

function ensureDatasheetHUD(playerColor)
    local suffix = "_"..playerColor
    local current = UI.getXmlTable({player=playerColor})
    local found = false

    if current then
        for _, node in ipairs(current) do
            if node.attributes and node.attributes.id == "datasheetHUD_body"..suffix then
                found = true
                break
            end
        end
    end

    if not found then
        createDatasheetHUD(playerColor)
    end
end

local function cleanDescription(desc)
    local cleaned = desc:gsub("%[[^%]]*%]", "")
    return cleaned
end

local function extractStat(desc, keyword)
    local pattern = keyword .. "%s*([%d%+]+\"?)"
    local value = desc:match(pattern)
    return value or "?"
end


function onOperativeRandomize(params)
    local operative = params[1]
    local playerColor = params[2]

    if operative and operative.hasTag("Operative") then
        local rawName = operative.getName()
        local operativeName = extractOperativeName(rawName)

        local desc = operative.getDescription()
        local cleanDesc = cleanDescription(desc)

        local apl    = extractStat(cleanDesc, "APL")
        local move   = extractStat(cleanDesc, "MOVE")
        local save   = extractStat(cleanDesc, "SAVE")
        local wounds = extractStat(cleanDesc, "WOUNDS")

        ensureDatasheetHUD(playerColor)
        updateDatasheetHUD(playerColor, {
            name     = operativeName,
            apl      = apl,
            move     = move,
            save     = save,
            wounds   = wounds,
            weapons  = "weapons",
            abilities= "abilities"
        })
    end
end



function extractOperativeName(rawName)
    local parts = {}
    for word in string.gmatch(rawName, "%S+") do
        table.insert(parts, word)
    end
    local operativeName
    if #parts >= 3 then
        operativeName = table.concat(parts, " ", 3)
    else
        operativeName = rawName
    end
    return string.upper(operativeName)
end