--using Kitanoi snippet from discord
--Rinn#4747

retrievemateria= { }
retrievemateria.running = false
retrievemateria.lastticks = 0
retrievemateria.GUI = {}
retrievemateria.GUI.open = true
retrievemateria.GUI.visible = true
retrievemateria.GUI.hue = 125
retrievemateria.timer = 0
retrievemateria.counter = 0
local timerretrieve = retrievemateria.timer
local counter = retrievemateria.counter

function retrievemateria.ModuleInit()
	retrievemateria.CheckMenu()
end

function retrievemateria.ToggleRun()
    retrievemateria.running = not retrievemateria.running
end

function retrievemateria.CheckMenu()
    local Status = false
    local Menu = ml_gui.ui_mgr.menu.components
    if table.valid(Menu) then
        for i,e in pairs(Menu) do
            if (e.members ~= nil) then
                for k,v in pairs(e.members) do
                    if (v.name ~= nil and v.name == "retrievemateria") then
                        Status = true
                    end
                end
            end
        end
    end
    if (not Status) then
        ml_gui.ui_mgr:AddMember({ id = "FFXIVMINION##retrievemateria", name = "retrievemateria", texture = menuiconpath, test = "retrievemateria"},"FFXIVMINION##MENU_HEADER")
        ml_gui.ui_mgr:AddSubMember({ id = "FFXIVMINION##retrievemateria", name = "retrievemateria", onClick = function() retrievemateria.GUI.open = not retrievemateria.GUI.open end, tooltip = "retrievemateria", texture = iconpath},"FFXIVMINION##MENU_HEADER","FFXIVMINION##retrievemateria")
    elseif (Status) then
        ml_gui.ui_mgr:AddSubMember({ id = "FFXIVMINION##retrievemateria", name = "retrievemateria", onClick = function() retrievemateria.GUI.open = not retrievemateria.GUI.open end, tooltip = "retrievemateria", texture = iconpath},"FFXIVMINION##MENU_HEADER","FFXIVMINION##retrievemateria")
    end
end

function retrievemateria.Draw( event, ticks )
    local gamestate = GetGameState()
    if ( gamestate == FFXIV.GAMESTATE.INGAME ) then
        if ( retrievemateria.GUI.open ) then
			GUI:SetNextWindowSize(285,75,GUI.SetCond_FirstUseEver) 			
            retrievemateria.GUI.visible, retrievemateria.GUI.open = GUI:Begin("retrievemateria", retrievemateria.GUI.open)
            if ( retrievemateria.GUI.visible ) then
                retrievemateria.Enable,changed = GUI:Checkbox("Enable##Enable", retrievemateria.Enable)
				local toggleTTdeck = GUI:Button("Toggle")
                if GUI:IsItemClicked(ToggleTTdeck) then 
					retrievemateria.ToggleRun()
					d(toggleTTdeck)
                end
				GUI:SameLine()
				GUI:InputText([[##State]], tostring(retrievemateria.running), (GUI.InputTextFlags_ReadOnly))				
            end
            GUI:End()
        end
    end
end


function retrievemateria.OnUpdateHandler( Event, ticks )
	if retrievemateria.running then
		local bagone = Inventory:Get(1000)
		if (table.valid(bagone)) then
			local ilist = bagone:GetList()
			if (table.valid(ilist)) then
				for slot,item in pairs(ilist) do
					--d(item.name)
					--d(item.Spiritbond)
					--d(item.MateriaSlotCount)					
					--d(table.size(item.materias))
					if table.size(item.materias) > 0 then
						if TimeSince(timerretrieve) > 5000 then
							item:RetrieveMateria()
							timerretrieve = Now()
						end
						counter = counter + 1
					end
				end
			end
		end
		if counter == 0 then
			retrievemateria.ToggleRun()
		else
			counter = 0
		end
	end	
end

RegisterEventHandler("Gameloop.Update",retrievemateria.OnUpdateHandler)
RegisterEventHandler("retrievemateria.TOGGLE", retrievemateria.ToggleRun) 
RegisterEventHandler("Module.Initalize",retrievemateria.ModuleInit) 
RegisterEventHandler("Gameloop.Draw", retrievemateria.Draw, "retrievemateria Draw")
