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
   
    local spacing = 2
    local bodyWidth = 600

    -- Stats panel formatting
    local statsPanelHeight = 60
    local statsPanelSubHeight = 28
    local StatsSubPanels = 4
    local totalStatsSpacing = spacing * StatsSubPanels
    local usableStatsWidth = bodyWidth - totalStatsSpacing
    local statsNameWidth = math.floor(usableStatsWidth / 2)
    local statsSubWidth = math.floor(usableStatsWidth / 8)

    -- Weapons panel formatting
    local weaponsPanels = {"gun", "knife"}
    local numWeapons = #weaponsPanels
    local totalWeaponsSpacing = spacing * numWeapons
    local usableWeaponsWidth = bodyWidth - totalWeaponsSpacing
    local weaponCellWidth = math.floor(usableWeaponsWidth / 15)
    local weaponNameWidth = math.floor(usableWeaponsWidth * 4/15)
    local weaponRulesWidth = math.floor(usableWeaponsWidth * 7/15)

    -- Abilities panel formatting
    local abilitiesPanels = {"ability1", "ability2"}
    local numAbilities = #abilitiesPanels
    local totalAbilitiesSpacing = spacing * numAbilities
    local usableAbilitiesWidth = bodyWidth - totalAbilitiesSpacing

    local xmlNode = {
        tag="VerticalLayout",
        attributes={
            id="datasheetHUD_body"..suffix,
            width=tostring(bodyWidth), height=tostring(statsPanelHeight+basePanelHeight*2 + spacing*2),
            position="0 0 0",
            rectAlignment="MiddleCenter",
            spacing=tostring(spacing),
            allowDragging="true",
            returnToOriginalPositionWhenReleased="false"
        },
        children={
            {
                tag="HorizontalLayout",
                attributes={
                    spacing="2",
                    rectAlignment="UpperLeft",
                    flexibleWidth="true",
                    height=tostring(statsPanelHeight)
                },
                children={
                    {
                        tag="Panel", attributes={id="stats_name"..suffix, width=tostring(statsNameWidth), height=tostring(statsPanelHeight)},
                        children={
                            {tag="Image", attributes={color="#222222DD", width=tostring(statsNameWidth), height=tostring(statsPanelHeight)}},
                            {tag="Image", attributes={color="#ff5e00", width="295", height="3", position="0 -10 0", alignment="MiddleLeft"}},
                            {tag="Text", attributes={id="statsNameText"..suffix, text="Operative name", fontSize="18", fontStyle="Bold", color="#FFFFFF", alignment="MiddleLeft"}}
                        }
                    },
                    {
                        tag="HorizontalLayout",
                        attributes={flexibleWidth="true", height=tostring(statsPanelHeight), spacing="2"},
                        children={
                            {
                                tag="Panel", attributes={id="stats_APL"..suffix, flexibleWidth="true", height=tostring(statsPanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(statsPanelHeight)}},
                                    {tag="Text", attributes={id="statsAPLHeader"..suffix, text="APL", fontSize="18", fontStyle="Bold", color="#FFFFFF", alignment="UpperCenter"}},
                                    {tag="Image", attributes={color="#ff5e00", width="20", height="20", position="-10 -9 0", alignment="MiddleCenter"}},
                                    {tag="Text", attributes={id="statsAPLValue"..suffix, text="0", fontSize="18", fontStyle="Bold", color="#FFFFFF", position="10 -9 0", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_move"..suffix, flexibleWidth="true", height=tostring(statsPanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(statsPanelHeight)}},
                                    {tag="Text", attributes={id="statsMoveText"..suffix, text="move", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_save"..suffix, flexibleWidth="true", height=tostring(statsPanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(statsPanelHeight)}},
                                    {tag="Text", attributes={id="statsSaveText"..suffix, text="save", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_wounds"..suffix, flexibleWidth="true", height=tostring(statsPanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(statsPanelHeight)}},
                                    {tag="Text", attributes={id="statsWoundsText"..suffix, text="wounds", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            }
                        }
                    }
                }
            },
            {
                tag="Panel", attributes={id="datasheetHUD_weapons"..suffix, flex="1", flexibleWidth="true", height=tostring(basePanelHeight)},
                children={
                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(basePanelHeight)}},
                    {tag="Text", attributes={id="hudMiddleText"..suffix, text="weapons", fontSize="24", color="#FFFFFF", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="datasheetHUD_abilities"..suffix, flex="1", flexibleWidth="true", height=tostring(basePanelHeight)},
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
    safeSetAttribute("statsMoveText"..suffix, "text", tostring(data.move or "move"), playerColor)
    safeSetAttribute("statsSaveText"..suffix, "text", tostring(data.save or "save"), playerColor)
    safeSetAttribute("statsWoundsText"..suffix, "text", tostring(data.wounds or "wounds"), playerColor)

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