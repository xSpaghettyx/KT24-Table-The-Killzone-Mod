function onLoad()
    -- Create HUD for all seated players
    for _, color in ipairs(Player.getColors()) do
        if Player[color].seated then
            createDatasheetHUD(color)
        end
    end
end

function createDatasheetHUD(playerColor)
    -- Base position for the HUD group
    local posX = -400
    local posY = -200

    -- Predetermined vertical gap between main and secondary panels
    local gapY = 220

    local xml = string.format([[
        <!-- Parent HUD container -->
        <Panel id="datasheetHUD_group" width="400" height="%d"
               position="%d %d 0"
               rectAlignment="UpperRight"
               allowDragging="true"
               returnToOriginalPositionWhenReleased="false">

            <!-- Main HUD Panel -->
            <Panel id="datasheetHUD" width="400" height="200"
                   position="0 0 0"
                   rectAlignment="UpperLeft">
                
                <Image id="hudBackground" color="#222222DD" width="400" height="200"/>
                
                <Text id="hudTitle" text="Datasheet HUD" fontSize="24" color="#FFFFFF"
                      alignment="UpperCenter" offsetXY="0 -10"/>
                
                <VerticalLayout spacing="5" childForceExpandWidth="true" childForceExpandHeight="false"
                                rectAlignment="MiddleCenter" width="380" height="150">
                    
                    <Text id="hudLine1" text="HP: 100" fontSize="18" color="#00FF00" alignment="MiddleLeft"/>
                    <Text id="hudLine2" text="Armor: 50" fontSize="18" color="#00BFFF" alignment="MiddleLeft"/>
                    <Text id="hudLine3" text="Status: Ready" fontSize="18" color="#FFD700" alignment="MiddleLeft"/>
                    
                </VerticalLayout>
            </Panel>

            <!-- Secondary Panel locked below main -->
            <Panel id="datasheetHUD_secondary" width="400" height="150"
                   position="0 %d 0"
                   rectAlignment="UpperLeft">
                
                <Image id="hudBackground2" color="#333333DD" width="400" height="150"/>
                
                <Text id="hudSecondaryTitle" text="Extra Info" fontSize="20" color="#FFFFFF"
                      alignment="UpperCenter" offsetXY="0 -10"/>
                
                <VerticalLayout spacing="5" childForceExpandWidth="true" childForceExpandHeight="false"
                                rectAlignment="MiddleCenter" width="380" height="100">
                    
                    <Text id="hudExtra1" text="Notes: ..." fontSize="16" color="#FFFFFF" alignment="MiddleLeft"/>
                    <Text id="hudExtra2" text="Buffs: ..." fontSize="16" color="#ADFF2F" alignment="MiddleLeft"/>
                    
                </VerticalLayout>
            </Panel>
        </Panel>
    ]], 200 + gapY + 150, posX, posY, gapY)

    -- Assign HUD only to this player
    UI.setXml(xml, {player=playerColor})
end

-- Example helper to update HUD dynamically for a specific player
function updateDatasheetHUD(playerColor, hp, armor, status, notes, buffs)
    UI.setAttribute("hudLine1", "text", "HP: " .. tostring(hp), {player=playerColor})
    UI.setAttribute("hudLine2", "text", "Armor: " .. tostring(armor), {player=playerColor})
    UI.setAttribute("hudLine3", "text", "Status: " .. tostring(status), {player=playerColor})
    UI.setAttribute("hudExtra1", "text", "Notes: " .. tostring(notes), {player=playerColor})
    UI.setAttribute("hudExtra2", "text", "Buffs: " .. tostring(buffs), {player=playerColor})
end
