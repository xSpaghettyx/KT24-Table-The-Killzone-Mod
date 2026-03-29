-- Kill Team 24 Operative Datasheet HUD by Spaghetty

function onLoad()
    local targetColors = {"Red", "Blue", "Yellow", "Teal", "Black"}
    self.addContextMenuItem("Delete Datasheet HUD", function(playerColor) deleteDatasheetHUD(playerColor) end)
    self.addContextMenuItem("Refresh Datasheet HUD", function(playerColor) refreshDatasheetHUD(playerColor) end)
end

local ICONS = {
    APL    = "https://steamusercontent-a.akamaihd.net/ugc/9369305430220912809/CC6EC4AAB9725BF7852567DB374B35301735FA62/",
    WOUNDS = "https://steamusercontent-a.akamaihd.net/ugc/16384741150793604760/CB8B9ED02F9F267F78B2E854E75A871290364190/",
    SAVE   = "https://steamusercontent-a.akamaihd.net/ugc/13684861407307316890/556F46D8F1A313F5FD3456FFBDD45CA418FD7789/",
    RANGED = "https://steamusercontent-a.akamaihd.net/ugc/13462888711902053286/AFE9392A03B3E558180E3C2F357BECAACE715DF6/",
    MOVE   = "https://steamusercontent-a.akamaihd.net/ugc/15432009711221783432/A02CDBA6FEF031FCD18784875D989EF99AD59740/",
    MELEE  = "https://steamusercontent-a.akamaihd.net/ugc/18196645127188580175/57D0C8FBC2A931C1DB98C8D731C73FC915BF9F20/"
}

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

    -- Stats Panel
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

    -- Weapons Header
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

    -- Weapon Buttons
    for i=1,weaponCount do
        local yOffset = -(90 + weaponsPanelHeight * (i - 1))
        local buttonId = "weaponButton_"..i..suffix

        table.insert(children, {
            tag="Button",
            attributes={
                id=buttonId,
                height=tostring(weaponsPanelHeight),
                flexibleWidth="true",
                offsetXY = "0 "..tostring(yOffset),
                rectAlignment="UpperLeft",
                onClick=self.getGUID().."/onWeaponAttack"
            },
            children={ buildWeaponInfoRow(i, bodyWidth, weaponsPanelHeight, spacing,
                                          weaponBGColor, orangeColor, weaponNameWidth, weaponRulesWidth, suffix) }
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

    -- Close Button
    table.insert(children, {
        tag = "Panel",
        attributes = {
            id = "closeButtonPanel" .. suffix,
            height = "25",
            width = "25",
            offsetXY = "-25 0",
            rectAlignment = "UpperLeft"
        },
        children = { buildCloseButton(suffix) }
    })

    return {
        tag="Panel",
        attributes={
            id="datasheetHUD_body"..suffix,
            width=tostring(bodyWidth),
            height=tostring(bodyHeight),
            rectAlignment="MiddleRight",
            spacing=tostring(spacing)
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

-- ====================

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
                    {tag="Image", attributes={id="iconAPL"..suffix, image=ICONS.APL, width="20", height="20", position="-10 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsAPLValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="10 -9 0", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="stats_move"..suffix, height=tostring(statsPanelHeight)},
                children={
                    {tag="Image", attributes={color=statsBGColor, height=tostring(statsPanelHeight)}},
                    {tag="Text", attributes={id="statsMoveHeader"..suffix, text="MOVE", fontSize="10", fontStyle="Bold", color="#FFFFFF", alignment="MiddleCenter", position="0 13 0"}},
                    {tag="Image", attributes={id="iconMOVE"..suffix, image=ICONS.MOVE, width="20", height="20", position="-12 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsMoveValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="12 -9 0", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="stats_save"..suffix, height=tostring(statsPanelHeight)},
                children={
                    {tag="Image", attributes={color=statsBGColor, height=tostring(statsPanelHeight)}},
                    {tag="Text", attributes={id="statsSaveHeader"..suffix, text="SAVE", fontSize="10", fontStyle="Bold", color="#FFFFFF", alignment="MiddleCenter", position="0 13 0"}},
                    {tag="Image", attributes={id="iconSAVE"..suffix, image=ICONS.SAVE, width="20", height="20", position="-12 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsSaveValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="12 -9 0", alignment="MiddleCenter"}}
                }
            },
            {
                tag="Panel", attributes={id="stats_wounds"..suffix, height=tostring(statsPanelHeight)},
                children={
                    {tag="Image", attributes={color=statsBGColor, height=tostring(statsPanelHeight)}},
                    {tag="Text", attributes={id="statsWoundsHeader"..suffix, text="WOUNDS", fontSize="10", fontStyle="Bold", color="#FFFFFF", alignment="MiddleCenter", position="0 13 0"}},
                    {tag="Image", attributes={id="iconWOUNDS"..suffix, image=ICONS.WOUNDS, width="20", height="20", position="-10 -9 0", alignment="MiddleCenter"}},
                    {tag="Text", attributes={id="statsWoundsValue"..suffix, text="0", fontSize="20", fontStyle="Bold", color="#FFFFFF", position="7 -9 0", alignment="MiddleCenter"}}
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
            {tag="Text", attributes={id="abilitiesText"..suffix, text=" ", fontSize="15", fontStyle="Bold", color="#000000", alignment="UpperLeft", position="10 -10 0"}}
        }
    }
end

-- Weapon Info Module

function buildWeaponInfoRow(idWeapon, bodyWidth, weaponsPanelHeight, spacing,
                            weaponBGColor, orangeColor, weaponNameWidth, weaponRulesWidth, parentSuffix)

    local suffix = "_"..tostring(idWeapon)..parentSuffix

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
                    {tag="Image", attributes={id = "weaponTypeIcon"..suffix, image=ICONS.RANGED, width="30", height="30", rectAlignment="MiddleCenter"}}
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

--Build Close Button
function buildCloseButton(suffix)
    return {
        tag = "Button",
        attributes = {
            id = "closeButton" .. suffix,
            onClick = self.getGUID() .. "/closePlayerDatasheetHUD",
            text = "X",
            width = "25",
            height = "25",
            textColor = "Red",
            colors = "#222222|#303030|#444444"
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


function deleteDatasheetHUD(player, value)
    local suffix = "_" .. player
    local current = UI.getXmlTable({player=player})
    if current == nil then return end

    local filtered = {}
    for _, node in ipairs(current) do
        if node.attributes == nil or node.attributes.id ~= "datasheetHUD_body" .. suffix then
            table.insert(filtered, node)
        end
    end

    UI.setXmlTable(filtered, {player=player})
end

function closePlayerDatasheetHUD(player, value, id)

    local suffix = id:match("^closeButton(.+)$")
    if not suffix then return end

    local targetId = "datasheetHUD_body" .. suffix

    local xml = UI.getXmlTable(player.color)
    local filtered = {}
    for _, element in ipairs(xml) do
        if element.attributes.id ~= targetId then
            table.insert(filtered, element)
        end
    end

    UI.setXmlTable(filtered, player.color)
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

WeaponCache = {}

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

        WeaponCache[playerColor] = {
            operative = operativeName,
            stats = {
                apl = apl,
                move = move,
                save = save,
                wounds = wounds
            },
            weapons = weapons
        }

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
                local suffix = "_"..i.."_"..playerColor
                safeSetAttribute("weaponNameText"..suffix, "text", w.name, playerColor)
                safeSetAttribute("weaponATKText"..suffix, "text", w.atk, playerColor)
                safeSetAttribute("weaponHITText"..suffix, "text", w.hit, playerColor)
                safeSetAttribute("weaponDMGText"..suffix, "text", w.dmg, playerColor)
                safeSetAttribute("weaponWRText"..suffix, "text", w.wr, playerColor)

                local iconUrl = (w.type == "R") and ICONS.RANGED or ICONS.MELEE
                safeSetAttribute("weaponTypeIcon"..suffix, "image", iconUrl, playerColor)
            end
        end, 0.05)
    end
end

function onWeaponAttack(player, value, id)
    local index, hudColor = id:match("weaponButton_(%d+)_(%a+)")
    index = tonumber(index)

    local cache = WeaponCache[hudColor]
    if not cache or not cache.weapons[index] then return end

    local w = cache.weapons[index]
    local operativeName = cache.operative or "UNKNOWN OPERATIVE"

    local msg = operativeName.." attacks using "..w.name..", "..w.atk.." attacks"
    player.broadcast(msg)

    local roller
    for _, obj in ipairs(getAllObjects()) do
        if obj.hasTag("KTUIDiceRoller") then
            roller = obj
            break
        end
    end
    if not roller then return end

    local weaponAttacks = tonumber(w.atk) or 0

    Wait.frames(function()
        player.clearSelectedObjects()
        if value == "-1" then
            roller.call("askSpawn", { player = player, number = weaponAttacks, auto = 0 })
        elseif value == "-2" then
            roller.call("askSpawn", { player = player, number = weaponAttacks, auto = 1 })
        end
    end, 5)
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