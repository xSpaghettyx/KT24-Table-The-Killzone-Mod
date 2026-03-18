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
    local panelHeight = 30
    local spacing = 2

    local weaponsPanels = {"gun", "knife"}
    local abilitiesPanels = {"ability1", "ability2"}

    local numWeapons = #weaponsPanels
    local numAbilities = #abilitiesPanels

    local bodyWidth = 600
    local spacing = 2
    local StatsSubPanels = 4
    local WeaponsSubPanels = 5
    local AbilitiesSubPanels = 1

    local totalStatsSpacing = spacing * numStats
    local usableStatsWidth = bodyWidth - totalStatsSpacing

    local statsNameWidth = math.floor(usableWidth / 2)
    local statsSubWidth = math.floor(usableWidth / 8)

    local weaponCellWidth = math.floor(usableWidth / 15)
    local weaponNameWidth = math.floor(usableWidth * 4/15)
    local weaponRulesWidth = math.floor(usableWidth * 7/15)

    local xmlNode = {
        tag="VerticalLayout",
        attributes={
            id="datasheetHUD_body",
            width=tostring(bodyWidth), height=tostring(panelHeight*3 + spacing*2),
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
                    height=tostring(panelHeight)
                },
                children={
                    {
                        tag="Panel", attributes={id="stats_name", width=tostring(statsNameWidth), height=tostring(panelHeight)},
                        children={
                            {tag="Image", attributes={color="#222222DD", width=tostring(statsNameWidth), height=tostring(panelHeight)}},
                            {tag="Text", attributes={id="statsMainText", text="Operative name", fontSize="20", color="#FFFFFF", alignment="MiddleCenter"}}
                        }
                    },
                    {
                        tag="HorizontalLayout",
                        attributes={flexibleWidth="true", height=tostring(panelHeight), spacing="2"},
                        children={
                            {
                                tag="Panel", attributes={id="stats_APL", flexibleWidth="true", height=tostring(panelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(panelHeight)}},
                                    {tag="Text", attributes={id="statsSub1Text", text="APL", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_move", flexibleWidth="true", height=tostring(panelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(panelHeight)}},
                                    {tag="Text", attributes={id="statsSub2Text", text="move", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_save", flexibleWidth="true", height=tostring(panelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(panelHeight)}},
                                    {tag="Text", attributes={id="statsSub3Text", text="save", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            },
                            {
                                tag="Panel", attributes={id="stats_wounds", flexibleWidth="true", height=tostring(panelHeight)},
                                children={
                                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(panelHeight)}},
                                    {tag="Text", attributes={id="statsSub4Text", text="wounds", fontSize="12", color="#FFFFFF", alignment="MiddleCenter"}}
                                }
                            }
                        }
                    }
                }
            },
            {
                tag="Panel", attributes={id="datasheetHUD_weapons", flex="1", flexibleWidth="true", height=tostring(panelHeight)},
                children={
                    {tag="Image", attributes={color="#333333DD", flexibleWidth="true", height=tostring(panelHeight)}},
                    {tag="Text", attributes={id="hudMiddleText", text="weapons", fontSize="24", color="#FFFFFF", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="datasheetHUD_abilities", flex="1", flexibleWidth="true", height=tostring(panelHeight)},
                children={
                    {tag="Image", attributes={color="#444444DD", flexibleWidth="true", height=tostring(panelHeight)}},
                    {tag="Text", attributes={id="hudBottomText", text="abilities", fontSize="24", color="#FFFFFF", alignment="MiddleCenter"}}
                }
            }
        }
    }

    local current = UI.getXmlTable({player=playerColor})
    if current == nil then current = {} end
    table.insert(current, xmlNode)
    UI.setXmlTable(current, {player=playerColor})
end

function updateDatasheetHUD(playerColor, mainStat, sub1, sub2, sub3, sub4, weapons, abilities)
    UI.setAttribute("statsMainText", "text", tostring(mainStat), {player=playerColor})
    UI.setAttribute("statsSub1Text", "text", tostring(sub1), {player=playerColor})
    UI.setAttribute("statsSub2Text", "text", tostring(sub2), {player=playerColor})
    UI.setAttribute("statsSub3Text", "text", tostring(sub3), {player=playerColor})
    UI.setAttribute("statsSub4Text", "text", tostring(sub4), {player=playerColor})
    UI.setAttribute("hudMiddleText", "text", tostring(weapons), {player=playerColor})
    UI.setAttribute("hudBottomText", "text", tostring(abilities), {player=playerColor})
end

function deleteDatasheetHUD(playerColor)
    local current = UI.getXmlTable({player=playerColor})
    if current == nil then return end
    local filtered = {}
    for _, node in ipairs(current) do
        if node.attributes == nil or node.attributes.id ~= "datasheetHUD_body" then
            table.insert(filtered, node)
        end
    end
    UI.setXmlTable(filtered, {player=playerColor})
end

function refreshDatasheetHUD(playerColor)
    deleteDatasheetHUD(playerColor)
    createDatasheetHUD(playerColor)
end
