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

function createDatasheetHUD(playerColor, suffix, weaponCount)
    suffix = suffix or "_"..playerColor

    local current = UI.getXmlTable({player=playerColor}) or {}
    local filtered = {}
    for _, node in ipairs(current) do
        if not (node.attributes and node.attributes.id == "datasheetHUD_body"..suffix) then
            table.insert(filtered, node)
        end
    end

    local bodyWidth = 600
    local bodyHeight = 300
    local spacing = 2
    local statsPanelHeight = 50
    local statsNameWidth = 350
    local statsBGColor = "#222222"
    local orangeColor = "#FF8800"
    local weaponsPanelHeight = 40
    local weaponNameWidth = 150
    local weaponRulesWidth = 200
    local weaponBGColor = "#CCCCCC"
    local weaponsSeparatorHeight = 2
    local basePanelHeight = 50

    local xmlNode = buildDatasheetHUD(
        suffix, bodyWidth, bodyHeight, spacing,
        statsPanelHeight, statsNameWidth, statsBGColor, orangeColor,
        weaponsPanelHeight, weaponNameWidth, weaponRulesWidth, weaponBGColor,
        weaponsSeparatorHeight, basePanelHeight,
        weaponCount or 1
    )

    xmlNode.attributes.visibility = playerColor

    table.insert(filtered, xmlNode)
    UI.setXmlTable(filtered, {player=playerColor})
end

function buildDatasheetHUD(suffix, bodyWidth, bodyHeight, spacing,
                           statsPanelHeight, statsNameWidth, statsBGColor, orangeColor,
                           weaponsPanelHeight, weaponNameWidth, weaponRulesWidth, weaponBGColor,
                           weaponsSeparatorHeight, basePanelHeight,
                           weaponCount)

    weaponCount = weaponCount or 5

    local children = {}

    -- Stats Panel (offset 0)
    table.insert(children, {
        tag="Panel",
        attributes={
            id="statsPanel"..suffix,
            height=tostring(statsPanelHeight),
            flexibleWidth="true",
            offsetXY="0 0",
            rectAlignment="UpperLeft"
        },
        children={ buildStatsPanel(suffix, bodyWidth, statsPanelHeight, statsNameWidth, spacing, statsBGColor, orangeColor) }
    })

    -- Weapons Header (offset = statsPanelHeight + spacing)
    table.insert(children, {
        tag="Panel",
        attributes={
            id="weaponsHeader"..suffix,
            height=tostring(weaponsPanelHeight),
            flexibleWidth="true",
            offsetXY="0 -50",
            rectAlignment="UpperLeft"
        },
        children={ buildWeaponsHeader(suffix, bodyWidth, weaponsPanelHeight, weaponNameWidth, weaponRulesWidth, weaponBGColor, orangeColor) }
    })

    -- Top Separator
    table.insert(children, {
        tag="Panel",
        attributes={
            id="topSeparator"..suffix,
            height=tostring(weaponsSeparatorHeight),
            flexibleWidth="true",
            offsetXY="0 -88",
            rectAlignment="UpperLeft"
        },
        children=buildWeaponsSeparator(suffix.."_top", weaponsSeparatorHeight, orangeColor)
    })

    -- Weapon Info Panels
    for i=1,weaponCount do
        local yOffset = -(90 + weaponsPanelHeight * (i - 1))

        table.insert(children, {
            tag="Panel",
            attributes={
                id="weaponRow"..i..suffix,
                height=tostring(weaponsPanelHeight),
                flexibleWidth="true",
                offsetXY = "0 "..tostring(yOffset),
                rectAlignment="UpperLeft"
            },
            children={ buildWeaponInfoRow(i, bodyWidth, weaponsPanelHeight, spacing,
                                          weaponBGColor, orangeColor, weaponNameWidth, weaponRulesWidth) }
        })
    end

    -- Bottom Separator
    local bottomOffset = -(90 + weaponsPanelHeight * weaponCount)

    table.insert(children, {
        tag="Panel",
        attributes={
            id="bottomSeparator"..suffix,
            height=tostring(weaponsSeparatorHeight),
            flexibleWidth="true",
            offsetXY="0 "..tostring(bottomOffset),
            rectAlignment="UpperLeft"
        },
        children=buildWeaponsSeparator(suffix.."_bottom", weaponsSeparatorHeight, orangeColor)
    })

    -- Abilities Panel
    local abilitiesOffset = bottomOffset
    table.insert(children, {
        tag="Panel",
        attributes={
            id="abilitiesPanel"..suffix,
            height=tostring(basePanelHeight),
            flexibleWidth="true",
            offsetXY="0 "..tostring(bottomOffset-5),
            rectAlignment="UpperLeft"
        },
        children={ buildAbilitiesPanel(suffix, bodyWidth, weaponBGColor, basePanelHeight) }
    })

    return {
        tag="Panel",
        attributes={
            id="datasheetHUD_body"..suffix,
            width=tostring(bodyWidth),
            height=tostring(bodyHeight),
            rectAlignment="MiddleRight",
            spacing=tostring(spacing),
            allowDragging="true",
            returnToOriginalPositionWhenReleased="false"
        },
        children={
            {
                tag="Panel",
                attributes={
                    id="datasheetHUD_panel"..suffix,
                    width=tostring(bodyWidth),
                    height=tostring(bodyHeight)
                },
                children=children
            }
        }
    }
end

-- Build Stats Panel
function buildStatsPanel(suffix, bodyWidth, statsPanelHeight, statsNameWidth, spacing, statsBGColor, orangeColor)
    return {
        tag="HorizontalLayout",
        attributes={spacing=tostring(spacing), width=tostring(bodyWidth), height=tostring(statsPanelHeight), rectAlignment="UpperLeft"},
        children={
            {
                tag="Panel", attributes={id="stats_name"..suffix, preferredwidth=statsNameWidth, height=tostring(statsPanelHeight), rectAlignment="UpperLeft"},
                children={
                    {tag="Image", attributes={color=statsBGColor, flexibleWidth="true", height=tostring(statsPanelHeight)}},
                    {tag="Image", attributes={color=orangeColor, flexibleWidth="true", height="3", position="0 -10 0"}},
                    {tag="Text", attributes={id="statsNameText"..suffix, text="Operative name", fontSize="18", fontStyle="Bold", color="#FFFFFF", overflow="Shrink", alignment="MiddleLeft", position="10 0 0"}}
                }
            },
            {
                tag="Panel", attributes={id="stats_APL"..suffix, height=tostring(statsPanelHeight)},
                children={
                    {tag="Image", attributes={color=statsBGColor, height=tostring(statsPanelHeight)}},
                    {tag="Text", attributes={id="statsAPLHeader"..suffix, text="APL", fontSize="10", fontStyle="Bold", color="#FFFFFF", alignment="MiddleCenter", position="0 13 0"}},
                    {tag="Image", attributes={color=orangeColor, width="20", height="20", position="-12 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsAPLValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="12 -9 0", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="stats_move"..suffix, height=tostring(statsPanelHeight)},
                children={
                    {tag="Image", attributes={color=statsBGColor, height=tostring(statsPanelHeight)}},
                    {tag="Text", attributes={id="statsMoveHeader"..suffix, text="MOVE", fontSize="10", fontStyle="Bold", color="#FFFFFF", alignment="MiddleCenter", position="0 13 0"}},
                    {tag="Image", attributes={color=orangeColor, width="20", height="20", position="-12 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsMoveValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="12 -9 0", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="stats_save"..suffix, height=tostring(statsPanelHeight)},
                children={
                    {tag="Image", attributes={color=statsBGColor, height=tostring(statsPanelHeight)}},
                    {tag="Text", attributes={id="statsSaveHeader"..suffix, text="SAVE", fontSize="10", fontStyle="Bold", color="#FFFFFF", alignment="MiddleCenter", position="0 13 0"}},
                    {tag="Image", attributes={color=orangeColor, width="20", height="20", position="-12 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsSaveValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="12 -9 0", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="stats_wounds"..suffix, height=tostring(statsPanelHeight)},
                children={
                    {tag="Image", attributes={color=statsBGColor, height=tostring(statsPanelHeight)}},
                    {tag="Text", attributes={id="statsWoundsHeader"..suffix, text="WOUNDS", fontSize="10", fontStyle="Bold", color="#FFFFFF", alignment="MiddleCenter", position="0 13 0"}},
                    {tag="Image", attributes={color=orangeColor, width="20", height="20", position="-12 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsWoundsValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="12 -9 0", alignment="MiddleCenter"}}
                }
            }
        }
    }
end

-- Build Weapons Header
function buildWeaponsHeader(suffix, bodyWidth, weaponsPanelHeight, weaponNameWidth, weaponRulesWidth, weaponBGColor, orangeColor)
    return {
        tag="HorizontalLayout",
        attributes={width=tostring(bodyWidth), height=tostring(weaponsPanelHeight), spacing="0"},
        children={
            {tag="Panel", attributes={id="weaponsHeaderBlank"..suffix, height=tostring(weaponsPanelHeight)},
                children={{tag="Image", attributes={color=weaponBGColor, flexibleWidth="true", height=tostring(weaponsPanelHeight)}},{tag="Image", attributes={color=weaponBGColor, width="20", height="20", rectAlignment="MiddleCenter"}}}},
            {tag="Panel", attributes={id="weaponsHeaderName"..suffix, preferredWidth=weaponNameWidth, height=tostring(weaponsPanelHeight)},
                children={{tag="Image", attributes={color=weaponBGColor, flexibleWidth="true", height=tostring(weaponsPanelHeight)}},{tag="Text", attributes={id="weaponsHeaderNameText"..suffix, text="NAME", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleLeft", position="10 0 0"}}}},
            {tag="Panel", attributes={id="weaponsHeaderATK"..suffix, height=tostring(weaponsPanelHeight)},
                children={{tag="Image", attributes={color=weaponBGColor, flexibleWidth="true", height=tostring(weaponsPanelHeight)}},{tag="Text", attributes={id="weaponsHeaderATKText"..suffix, text="ATK", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleCenter"}}}},
            {tag="Panel", attributes={id="weaponsHeaderHIT"..suffix, height=tostring(weaponsPanelHeight)},
                children={{tag="Image", attributes={color=weaponBGColor, flexibleWidth="true", height=tostring(weaponsPanelHeight)}},{tag="Text", attributes={id="weaponsHeaderHITText"..suffix, text="HIT", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleCenter"}}}},
            {tag="Panel", attributes={id="weaponsHeaderDMG"..suffix, height=tostring(weaponsPanelHeight)},
                children={{tag="Image", attributes={color=weaponBGColor, flexibleWidth="true", height=tostring(weaponsPanelHeight)}},{tag="Text", attributes={id="weaponsHeaderDMGText"..suffix, text="DMG", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleCenter"}}}},
            {tag="Panel", attributes={id="weaponsHeaderWR"..suffix, preferredWidth=weaponRulesWidth, height=tostring(weaponsPanelHeight)},
                children={{tag="Image", attributes={color=weaponBGColor, flexibleWidth="true", height=tostring(weaponsPanelHeight)}},{tag="Text", attributes={id="weaponsHeaderWRText"..suffix, text="WR", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleLeft", position="10 0 0"}}}}
        }
    }
end

-- Build Weapons Separator
function buildWeaponsSeparator(suffix, weaponsSeparatorHeight, orangeColor)
    return {
        {
            tag="Panel",
            attributes={
                id="weaponsHUD_separator"..suffix,
                flexibleWidth="true",
                height=tostring(weaponsSeparatorHeight)
            },
            children={
                {tag="Image", attributes={color=orangeColor, flexibleWidth="true", height=tostring(weaponsSeparatorHeight)}}
            }
        }
    }
end

-- Build  Abilities Panel

function buildAbilitiesPanel(suffix, bodyWidth, weaponBGColor, basePanelHeight)
    return {
        tag="Panel", attributes={id="datasheetHUD_abilities"..suffix, width=tostring(bodyWidth), height=tostring(basePanelHeight)},
        children={
            {tag="Image", attributes={color=weaponBGColor, width=tostring(bodyWidth), height=tostring(basePanelHeight)}},
            {tag="Text", attributes={id="abilitiesText"..suffix, text=" ", fontSize="15", fontStyle="Bold", color="#000000", alignment="UpperLeft", position="10 0 0"}}
        }
    }
end

-- Weapon Info Module

function buildWeaponInfoRow(idWeapon, bodyWidth, weaponsPanelHeight, spacing,
                            weaponBGColor, orangeColor, weaponNameWidth, weaponRulesWidth)

    local suffix = "_"..tostring(idWeapon)

    return {
        tag = "HorizontalLayout",
        attributes = {
            width = tostring(bodyWidth),
            height = tostring(weaponsPanelHeight),
            spacing = "0"
        },
        children = {
            -- Icon
            {
                tag = "Panel", attributes = {id = "weaponIcon"..suffix, height = tostring(weaponsPanelHeight)},
                children = {
                    {tag="Image", attributes={color=weaponBGColor, height=tostring(weaponsPanelHeight)}},
                    {tag="Image", attributes={color=orangeColor, width="20", height="20", rectAlignment="MiddleCenter"}}
                }
            },
            -- Name
            {
                tag = "Panel", attributes = {id = "weaponName"..suffix, preferredWidth = weaponNameWidth, height = tostring(weaponsPanelHeight)},
                children = {
                    {tag="Image", attributes={color=weaponBGColor, height=tostring(weaponsPanelHeight)}},
                    {tag="Text", attributes={id="weaponNameText"..suffix, text=" ", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleLeft", position="10 0 0"}}
                }
            },
            -- ATK
            {
                tag = "Panel", attributes = {id = "weaponATK"..suffix, height = tostring(weaponsPanelHeight)},
                children = {
                    {tag="Image", attributes={color=weaponBGColor, height=tostring(weaponsPanelHeight)}},
                    {tag="Text", attributes={id="weaponATKText"..suffix, text=" ", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleCenter"}}
                }
            },
            -- HIT
            {
                tag = "Panel", attributes = {id = "weaponHIT"..suffix, height = tostring(weaponsPanelHeight)},
                children = {
                    {tag="Image", attributes={color=weaponBGColor, height=tostring(weaponsPanelHeight)}},
                    {tag="Text", attributes={id="weaponHITText"..suffix, text=" ", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleCenter"}}
                }
            },
            -- DMG
            {
                tag = "Panel", attributes = {id = "weaponDMG"..suffix, height = tostring(weaponsPanelHeight)},
                children = {
                    {tag="Image", attributes={color=weaponBGColor, height=tostring(weaponsPanelHeight)}},
                    {tag="Text", attributes={id="weaponDMGText"..suffix, text=" ", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleCenter"}}
                }
            },
            -- WR
            {
                tag = "Panel", attributes = {id = "weaponWR"..suffix, preferredWidth = weaponRulesWidth, height = tostring(weaponsPanelHeight)},
                children = {
                    {tag="Image", attributes={color=weaponBGColor, height=tostring(weaponsPanelHeight)}},
                    {tag="Text", attributes={id="weaponWRText"..suffix, text=" ", fontSize="15", fontStyle="Bold", color="#000000", alignment="MiddleLeft", position="10 0 0"}}
                }
            }
        }
    }
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
    safeSetAttribute("abilitiesText"..suffix, "text", tostring(data.abilities or " "), playerColor)
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
    if current then
        for _, node in ipairs(current) do
            if node.attributes and node.attributes.id == "datasheetHUD_body"..suffix then
                return
            end
        end
    end
    createDatasheetHUD(playerColor, suffix)
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

local function countWeapons(desc)
    local count = 0
    for _ in string.gmatch(desc, "ATK") do
        count = count + 1
    end
    return count
end

local function parseWeapons(desc)
    local weapons = {}
    local inWeaponsSection = false

    for line in desc:gmatch("[^\r\n]+") do
        if line:match("Weapons") then
            inWeaponsSection = true
        elseif inWeaponsSection then
            local weaponType, weaponName = line:match("^%s*([RM])%s+(.+)")
            if weaponType and weaponName then
                table.insert(weapons, {
                    type = weaponType,
                    name = weaponName,
                    atk  = "-",
                    hit  = "-",
                    dmg  = "-",
                    wr   = "-"
                })
            else
                local current = weapons[#weapons]
                if current then
                    local atk = line:match("ATK%s*([%d%+]+)")
                    if atk then current.atk = atk end

                    local hit = line:match("HIT%s*([%d%+]+%+)")
                    if hit then current.hit = hit end

                    local dmg = line:match("DMG%s*([%d/]+)")
                    if dmg then current.dmg = dmg end

                    local wr = line:match("WR%s*:?%s*(.+)")
                    if wr and wr ~= "" then
                        current.wr = wr
                    end
                end
            end
        end
    end

    for _, w in ipairs(weapons) do
        w.atk = w.atk ~= "" and w.atk or "-"
        w.hit = w.hit ~= "" and w.hit or "-"
        w.dmg = w.dmg ~= "" and w.dmg or "-"
        w.wr  = w.wr  ~= "" and w.wr  or "-"
    end

    return weapons
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

        local weapons = parseWeapons(cleanDesc)
        local weaponCount = #weapons

        createDatasheetHUD(playerColor, "_"..playerColor, weaponCount)

        Wait.time(function()
            updateDatasheetHUD(playerColor, {
                name      = operativeName,
                apl       = apl,
                move      = move,
                save      = save,
                wounds    = wounds,
                weapons   = "weapons",
                abilities = " "
            })

            for i, w in ipairs(weapons) do
                local suffix = "_"..i
                safeSetAttribute("weaponNameText"..suffix, "text", w.name, playerColor)
                safeSetAttribute("weaponATKText"..suffix, "text", w.atk, playerColor)
                safeSetAttribute("weaponHITText"..suffix, "text", w.hit, playerColor)
                safeSetAttribute("weaponDMGText"..suffix, "text", w.dmg, playerColor)
                safeSetAttribute("weaponWRText"..suffix, "text", w.wr, playerColor)
            end
        end, 0.05)
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