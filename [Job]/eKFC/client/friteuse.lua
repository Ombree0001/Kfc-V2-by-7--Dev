
local ESX = nil
local BigCreate = true
local selectedSymbol = 1
local cVarLongC = {"/", "-", "\\", "|"}
local cVarLong = function()
    return cVarLongC[selectedSymbol]
end

Citizen.CreateThread(function()
    TriggerEvent('esx:getSharedObject', function(lib) ESX = lib end)
    while ESX == nil do Citizen.Wait(100) end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('eKFC:animationCreateFrite')
AddEventHandler('eKFC:animationCreateFrite', function()
    BigFunctionBaba()
	TaskStartScenarioInPlace(PlayerPedId(), "prop_human_bbq", 0, true)
	Citizen.Wait(21000) -- 21s
	ClearPedTasksImmediately(PlayerPedId())
    BigCreate = true
end)

local function menuFrite()
    local menuP = RageUI.CreateMenu('Fourneaux', '~r~KFC')
    menuP:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

        RageUI.Visible(menuP, not RageUI.Visible(menuP))

        while menuP do
        Citizen.Wait(0)        

        RageUI.IsVisible(menuP, true, true, true, function()


            if not BigCreate then
            RageUI.Separator("~o~En cours... ["..cVarLong().."]")
            end

        for k,v in pairs(Config.allFrite) do

            RageUI.ButtonWithStyle(v.label,"Ingrédients requis:\n~y~"..v.ingredients[1].label.." (x"..v.ingredients[1].amout.."), " ..v.ingredients[2].label.." (x"..v.ingredients[2].amout..")", {RightLabel = "~r~21s"}, BigCreate, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('eKFC:createFrite', v.name, v.ingredients)
                end
            end)

        end

        end, function()
        end)
            if not RageUI.Visible(menuP) then
            menuP = RMenu:DeleteType("menuP", true)
        end
    end
end

BigFunctionBaba = function()
    BigCreate = false
    Citizen.CreateThread(function()
        while not BigCreate do
            Wait(800)
            selectedSymbol = selectedSymbol + 1
            if selectedSymbol > #cVarLongC then
                selectedSymbol = 1
            end
        end
    end)
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
            for k,v in pairs(Config.posFriteuse) do
                local dist = #(plyPos-v)
                if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName then
                    if dist <= Config.Marker.DrawDistance then
                        Timer = 0
                        DrawMarker(Config.Marker.Type,  v.x, v.y, v.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
                    end
                    if dist <= Config.Marker.DrawInteract then
                        Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir → ~r~Fourneaux Frites", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            menuFrite()
                        end
                    end
                end
            end
        Citizen.Wait(Timer)
    end
end)