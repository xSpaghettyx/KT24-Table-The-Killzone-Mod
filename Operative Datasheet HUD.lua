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
            width=tostring(bodyWidth), height=tostring(basePanelHeight*3 + spacing*2),
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
                    height=tostring(basePanelHeight)
                },
                children={
                    {
                        tag="Panel", attributes={id="stats_name"..suffix, width=tostring(statsNameWidth), height=tostring(basePanelHeight)},
                        children={
                            {tag="Image", attributes={color="#222222DD", width=tostring(statsNameWidth), height=tostring(basePanelHeight)}},
                            {tag="Text", attributes={id="statsNameText"..suffix, text="Operative name", fontSize="20", color="#FFFFFF", alignment="MiddleCenter"}}
                        }
                    },
                    {
                        tag="HorizontalLayout",
                        attributes={flexibleWidth="true", height=tostring(basePanelHeight), spacing="2"},
                        children={
                            {
                                tag="Panel", attributes={id="stats_APL"..suffix, flexibleWidth="true", height=tostring(basePanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(basePanelHeight)}},
                                    {tag="Text", attributes={id="statsAPLText"..suffix, text="APL", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_move"..suffix, flexibleWidth="true", height=tostring(basePanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(basePanelHeight)}},
                                    {tag="Text", attributes={id="statsMoveText"..suffix, text="move", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_save"..suffix, flexibleWidth="true", height=tostring(basePanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(basePanelHeight)}},
                                    {tag="Text", attributes={id="statsSaveText"..suffix, text="save", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_wounds"..suffix, flexibleWidth="true", height=tostring(basePanelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(basePanelHeight)}},
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
    safeSetAttribute("statsAPLText"..suffix, "text", tostring(data.apl or "APL"), playerColor)
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

function onOperativeRandomize(params)
    local operative = params[1]
    local playerColor = params[2]

    if operative.hasTag("Operative") then
        local operativeName = operative.getName()
        ensureDatasheetHUD(playerColor)
        updateDatasheetHUD(playerColor, {
            name = operativeName,
            apl = "APL",
            move = "move",
            save = "save",
            wounds = "wounds",
            weapons = "weapons",
            abilities = "abilities"
        })
    end
end
