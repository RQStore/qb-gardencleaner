local HasJobStarted = false
local HasJob = true
local SetRandomLocation
local CarParked = false
local POINTS_DONE_IN_JOB = 0
local haveBinBag = false
local JobsToDo
local NumberToDo = 0
local geeky
local PropsBlips = {}
local ClothesOn = false
local blip
local blipSY
local Player

local QBCore = exports['qb-core']:GetCoreObject()
Citizen.CreateThread(function()
	SpawnStartingPed()
    local Blip_Name = Config.Languages[Config.Lang]["BLIP_NAME"]
    blip = AddBlipForCoord(Config.Job.StartJob.Coords.x, Config.Job.StartJob.Coords.y, Config.Job.StartJob.Coords.z)
    SetBlipSprite(blip, Config.Job.StartJob.blip.SetBlipSprite)
    SetBlipDisplay(blip, Config.Job.StartJob.blip.SetBlipDisplay)
    SetBlipScale(blip, Config.Job.StartJob.blip.SetBlipScale)
    SetBlipColour(blip, Config.Job.StartJob.blip.SetBlipColour )
    SetBlipAsShortRange(blip, Config.Job.StartJob.blip.SetBlipAsShortRange )
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Blip_Name)
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
end)

--MAIN CODE--


RegisterNetEvent("qb-gardincleaner:stop:warking", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    LocaitonPed(false, true)
    JobsToDo = #Config.JobWork[SetRandomLocation].BinBags
    if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.Charvest then 
        if Config.JobWork[SetRandomLocation].Charvest then 
            JobsToDo = JobsToDo + #Config.JobWork[SetRandomLocation].Charvest
        end
    end
    if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.LeafBlower then 
        if Config.JobWork[SetRandomLocation].LeafBlower then 
            JobsToDo = JobsToDo + #Config.JobWork[SetRandomLocation].LeafBlower
        end
    end
    if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.CleanWindow then 
        if Config.JobWork[SetRandomLocation].CleanWindow then 
            JobsToDo = JobsToDo + #Config.JobWork[SetRandomLocation].CleanWindow
        end
    end
    NumberToDo = JobsToDo-POINTS_DONE_IN_JOB
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        DeleteVehicle(vehicle)
    end
    DeleteWaypoint();
    if NumberToDo == 0 then
        Notify(Config.Languages[Config.Lang]["JOB_FINISH_GIVE_ME_THE_FUCKING_MONEY"]..''..tonumber(JobsToDo)*tonumber(Config.JobWork[SetRandomLocation].PayForOnePoint))
        TriggerServerEvent("qb-gardencleaner:givemoney", JobsToDo, SetRandomLocation)
    end
    CarParked = false
    HasJobStarted = false
    SetRandomLocation = nil
    POINTS_DONE_IN_JOB = 0
    haveBinBag = false
    JobsToDo = 0
    NumberToDo = 0
    geeky = nil
    if Config.SpawnBack then
        SetEntityCoords(GetPlayerPed(-1), Config.Job.StartJob.Coords.x, Config.Job.StartJob.Coords.y, Config.Job.StartJob.Coords.z, false, false, false, true)
    end
end)

RegisterNetEvent("qb-gardencleaner:getjob", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local menu = {
        {
            header = 'Garden Cleaner Company',
            isMenuHeader = true,
            icon = 'fas fa-dumpster',
        },
    }
    local rep = PlayerData.metadata["jobrep"]["gardencleaner"].."%"
    print(rep)
    if PlayerData.metadata["jobrep"]["gardencleaner"] == 100 or PlayerData.metadata["jobrep"]["gardencleaner"] > 100 then 
        rep = "MAX"
    end
    menu[#menu + 1] = {
        header = 'Experience',
        txt = "your expirence is "..rep,
        isMenuHeader = true,
        icon = 'fas fa-radiation',
    }
    menu[#menu + 1] = {
        header = 'Start Job',
        txt = "In this job you have to go to the locaiton and clean it.",
        disabled = SetRandomLocation ~= nil,
        submenu = true,
        icon = 'fas fa-hand-sparkles',
        params = {
            event = "qb-gardincleaner:withvehicle",
        }    
    }
    menu[#menu + 1] = {
        header = 'Stop Warking',
        txt = "",
        disabled = not HasJobStarted,
        submenu = true,
        icon = 'fas fa-hand-sparkles',
        params = {
            event = "qb-gardincleaner:stop:warking",
        }    
    }
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent("qb-gardincleaner:withvehicle", function() 
    local PlayerData = QBCore.Functions.GetPlayerData()
    local menu = {
        {
            header = 'Start Warking',
            isMenuHeader = true,
            icon = 'fas fa-hand-sparkles',
        },
    }
    menu[#menu + 1] = {
        header = 'Garden cleaner job',
        txt = [[You have the right to rent a private vehicle in the job after passing 15 experience points.
        </br>You have the right to withdraw plants after you pass 10 experience points.
        </br>You have the right to blow leaves away after passing 30 experience points.
        </br>You have the right to clean windows after you pass 50 points of experience.]],
        isMenuHeader = true,
        icon = 'fas fa-info',
        params = {
            event = "qb-gardencleaner:startjob",
            args = {
                withcar = true
            }
        }    
    }
    menu[#menu + 1] = {
        header = 'Start With Vehicle',
        disabled = PlayerData.metadata["jobrep"]["gardencleaner"] <= Config.VehiclePoints,
        submenu = true,
        icon = 'fas fa-car-side',
        params = {
            event = "qb-gardencleaner:startjob",
            args = {
                withcar = true
            }
        }    
    }
    menu[#menu + 1] = {
        header = 'Start Without Vehicle',
        submenu = true,
        icon = 'fas fa-car-side',
        params = {
            event = "qb-gardencleaner:startjob",
            args = {
                withcar = false
            }
        }    
    }
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('qb-gardencleaner:startjob')
AddEventHandler('qb-gardencleaner:startjob', function(data)
        local PlayerData = QBCore.Functions.GetPlayerData()
        if HasJobStarted and not CarParked then
            HasJobStarted = false
            SetRandomLocation = nil
            CarParked = false
            POINTS_DONE_IN_JOB = 0
            haveBinBag = false
            JobsToDo = 0
            NumberToDo = 0
            geeky = nil
            RemoveBlip(blipSY)
        elseif not HasJobStarted then
            local CanSpawn = QBCore.Functions.IsSpawnPointClear(Config.Job.CarControl.Coords, 2.0)
            if not CanSpawn and data.withcar then TriggerEvent('QBCore:Notify', "can't spawn vehicle maybe the spawn point is not clear plase tray agen later.", "error") return end
                HasJobStarted = true
                local RandomLocal = math.random(1, #Config.JobWork)
                print(RandomLocal)
                if data.withcar then SpawnCar() end
                SetNewWaypoint(Config.JobWork[RandomLocal].ParkCarAt.x, Config.JobWork[RandomLocal].ParkCarAt.y);
                SetRandomLocation = RandomLocal
                Notify(Config.Languages[Config.Lang]["TALK_MIKE_GOTOPLACE"])
                local Blip_Name = Config.Languages[Config.Lang]["BLIP_HOUSE"]
                blipSY = AddBlipForCoord(Config.JobWork[SetRandomLocation].ParkCarAt.x, Config.JobWork[SetRandomLocation].ParkCarAt.y, Config.JobWork[SetRandomLocation].ParkCarAt.z)
                SetBlipSprite(blipSY, Config.JobWork[SetRandomLocation].Blip.SetBlipSprite)
                SetBlipDisplay(blipSY, Config.JobWork[SetRandomLocation].Blip.SetBlipDisplay)
                SetBlipScale(blipSY, Config.JobWork[SetRandomLocation].Blip.SetBlipScale)
                SetBlipColour(blipSY, Config.JobWork[SetRandomLocation].Blip.SetBlipColour )
                SetBlipAsShortRange(blipSY, Config.JobWork[SetRandomLocation].Blip.SetBlipAsShortRange )
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Blip_Name)
                EndTextCommandSetBlipName(blipSY)
                JobsToDo = #Config.JobWork[SetRandomLocation].BinBags
                if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.Charvest then 
                    if Config.JobWork[SetRandomLocation].Charvest then 
                        JobsToDo = JobsToDo + #Config.JobWork[SetRandomLocation].Charvest
                    end
                end
                if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.LeafBlower then 
                    if Config.JobWork[SetRandomLocation].LeafBlower then 
                        JobsToDo = JobsToDo + #Config.JobWork[SetRandomLocation].LeafBlower
                    end
                end
                if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.CleanWindow then 
                    if Config.JobWork[SetRandomLocation].CleanWindow then 
                        JobsToDo = JobsToDo + #Config.JobWork[SetRandomLocation].CleanWindow
                    end
                end
                NumberToDo = JobsToDo-POINTS_DONE_IN_JOB   
                LocaitonPed(true)  
        else
            Notify(Config.Languages[Config.Lang]["INFO_FIRST_FINISH_JOB"])
        end   
end)

function LocaitonPed(spawn, stop)
    if stop then 
        for k,v in pairs(PropsBlips) do
            RemoveBlip(v)
            DeleteEntity(v)
        end
        FreezeEntityPosition(CleanPed, false)
        TaskStartScenarioInPlace(CleanPed, "WORLD_HUMAN_CLIPBOARD", 0, false)
        ClearPedTasks(CleanPed)
        TaskWanderStandard(CleanPed,2,10)
        exports['qb-target']:RemoveZone("cleanerped"..SetRandomLocation)
        return
    end
    if spawn then 
        local model = Config.Peds[math.random(1, #Config.Peds)]
        RequestModel(model)
	    while not HasModelLoaded(model) do
	    	Citizen.Wait(50)
	    end
        CleanPed = CreatePed(0, model, Config.JobWork[SetRandomLocation].ParkCarAt.x, Config.JobWork[SetRandomLocation].ParkCarAt.y, Config.JobWork[SetRandomLocation].ParkCarAt.z - 1, Config.JobWork[SetRandomLocation].ParkCarAt.w, false, true)
        FreezeEntityPosition(CleanPed, true)
        TaskStartScenarioInPlace(CleanPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
        exports['qb-target']:AddCircleZone("cleanerped"..SetRandomLocation, vector3(Config.JobWork[SetRandomLocation].ParkCarAt.x, Config.JobWork[SetRandomLocation].ParkCarAt.y, Config.JobWork[SetRandomLocation].ParkCarAt.z), 0.3, { -- The name has to be unique, the coords a vector3 as shown and the 1.5 is the radius which has to be a float value
            name = "cleanerped"..SetRandomLocation, -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
            debugPoly = false, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
        }, {
          options = { -- This is your options table, in this table all the options will be specified for the target to accept
            { -- This is the first table with options, you can make as many options inside the options table as you want
              action = function()
                local PlayerData = QBCore.Functions.GetPlayerData()
                Notify(Config.Languages[Config.Lang]["TALK_MIKE_INPLACE"])
                CarParked = true
                SpawnBinBags()
                if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.Charvest then 
                    if Config.JobWork[SetRandomLocation].Charvest then 
                        SpawnCharvest()
                    end
                end
                if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.LeafBlower then 
                    if Config.JobWork[SetRandomLocation].LeafBlower then 
                        SpawnLeafs()
                    end
                end
                if PlayerData.metadata["jobrep"]["gardencleaner"] > Config.CleanWindow then 
                    if Config.JobWork[SetRandomLocation].CleanWindow then 
                        SpawnWindows()
                    end
                end
                RemoveBlip(blipSY)
                LocaitonPed(false)
              end, -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
              icon = 'fas fa-handshake', -- This is the icon that will display next to this trigger option
              label = 'Start Warking', -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
            }
          },
          distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
        })
    else 
        QBCore.Functions.Progressbar('infoshouse', 'Getting info....', 8000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_hang_out_street@Female_arm_side@idle_a",
            anim = "idle_a",
            flags = 20,
        }, {}, {}, function() -- Done
            PlayPedAmbientSpeechNative(CleanPed, "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL")
            FreezeEntityPosition(CleanPed, false)
            TaskStartScenarioInPlace(CleanPed, "WORLD_HUMAN_CLIPBOARD", 0, false)
            ClearPedTasks(CleanPed)
            TaskWanderStandard(CleanPed,2,10)
            exports['qb-target']:RemoveZone("cleanerped"..SetRandomLocation)
        end, function()
            ClearPedTasksImmediately(GetPlayerPed(-1))
        end)
    end
end

RegisterNetEvent('qb-gardencleaner:charvest')
AddEventHandler('qb-gardencleaner:charvest', function(data)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasitem)
        if hasitem then 
            ClearPedTasks(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_gardener_plant", 0, true)
            FreezeEntityPosition(GetPlayerPed(-1), true);
            QBCore.Functions.Progressbar('blowing', 'Drawing plant....', 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                DeleteEntity(data.entity)
                ClearPedTasks(GetPlayerPed(-1))
                POINTS_DONE_IN_JOB = POINTS_DONE_IN_JOB+1
                FreezeEntityPosition(GetPlayerPed(-1), false);
                Notify(Config.Languages[Config.Lang]["INFO_DONE"]..' '..POINTS_DONE_IN_JOB.."/"..JobsToDo)
                RemoveBlip(PropsBlips[data.entity])
                if NumberToDo == 0 then
                    Notify(Config.Languages[Config.Lang]["INFO_DONE_JOB"]..''..JobsToDo*Config.JobWork[SetRandomLocation].PayForOnePoint)
                end
                if Config.Seeds then 
                    local lock = math.random(1, 900)
                    if lock > 800 then 
                        TriggerServerEvent('QBCore:Server:AddItem', config.DrugItem, 1)
                    end
                end 
            end, function()
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end)
        else 
            TriggerEvent('QBCore:Notify', "Shovel Required!", "error")
        end  
    end, Config.ShovelItem)
end)

RegisterNetEvent('qb-gardencleaner:LeafBlower')
AddEventHandler('qb-gardencleaner:LeafBlower', function(data)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasitem)
        if hasitem then 
            ClearPedTasks(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GARDENER_LEAF_BLOWER", 0, true)
            FreezeEntityPosition(GetPlayerPed(-1), true);
            QBCore.Functions.Progressbar('blowing', 'Blowing Leafs....', 17000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                DeleteEntity(data.entity)
                ClearPedTasks(GetPlayerPed(-1))
                FreezeEntityPosition(GetPlayerPed(-1), false);
                ClearAreaOfObjects(GetEntityCoords(GetPlayerPed(-1)), 2.0, 0)
                POINTS_DONE_IN_JOB = POINTS_DONE_IN_JOB+1
                Notify(Config.Languages[Config.Lang]["INFO_DONE"]..' '..POINTS_DONE_IN_JOB.."/"..JobsToDo)
                RemoveBlip(PropsBlips[data.entity])
                if NumberToDo == 0 then
                    Notify(Config.Languages[Config.Lang]["INFO_DONE_JOB"]..''..JobsToDo*Config.JobWork[SetRandomLocation].PayForOnePoint)
                end  
            end, function()
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end)
        else 
            TriggerEvent('QBCore:Notify', "Electricer Blower Required!", "error")
        end  
    end, Config.Blower)
end)

RegisterNetEvent('qb-gardencleaner:collecttrash')
AddEventHandler('qb-gardencleaner:collecttrash', function(data)
    ClearPedTasks(GetPlayerPed(-1))

    if not HasAnimDictLoaded("anim@move_m@trash") then
        RequestAnimDict("anim@move_m@trash")
    end
    while not HasAnimDictLoaded("anim@move_m@trash") do
        Citizen.Wait(0)
    end

    TaskPlayAnim(GetPlayerPed(-1), 'anim@move_m@trash', 'pickup', 1.0, -1.0,-1,2,0,0, 0,0)
    FreezeEntityPosition(GetPlayerPed(-1), true);
    QBCore.Functions.Progressbar('gettinggadrbage', 'pickup Bin....', 1000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        DeleteEntity(data.entity)
        ClearPedTasks(GetPlayerPed(-1))
        haveBinBag = true
        RemoveBlip(PropsBlips[data.entity])
        if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
            RequestAnimDict("anim@heists@narcotics@trash")
        end
        while not HasAnimDictLoaded("anim@heists@narcotics@trash") do
            Citizen.Wait(0)
        end
        local boneindex = GetPedBoneIndex(PlayerPedId(-1), 57005)
        geeky = CreateObject(GetHashKey("hei_prop_heist_binbag"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(geeky, PlayerPedId(-1), boneindex, 0.12, 0.0, 0.00, 25.0, 270.0, 180.0, true, true, false, true, 1, true)
        TaskPlayAnim(PlayerPedId(-1), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
        FreezeEntityPosition(GetPlayerPed(-1), false);
        TriggerEvent("mt:missiontext", Config.Languages[Config.Lang]["INFO_BIN"])
    end, function()
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
end)

RegisterNetEvent('qb-gardencleaner:bin')
AddEventHandler('qb-gardencleaner:bin', function(data)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
    FreezeEntityPosition(GetPlayerPed(-1), true);
    QBCore.Functions.Progressbar('gettinggarbage', 'Getting Bin....', 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        haveBinBag = false
        POINTS_DONE_IN_JOB = POINTS_DONE_IN_JOB+1
        DeleteObject(geeky)
        Citizen.Wait(700)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        Notify(Config.Languages[Config.Lang]["INFO_DONE"]..' '..POINTS_DONE_IN_JOB.."/"..JobsToDo)
        if NumberToDo == 0 then
            Notify(Config.Languages[Config.Lang]["INFO_DONE_JOB"]..''..JobsToDo*Config.JobWork[SetRandomLocation].PayForOnePoint)
        end
        FreezeEntityPosition(GetPlayerPed(-1), false);
    end, function()
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
end)

RegisterNetEvent("qb-gardencleaner:cleanwindow", function(data)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_MAID_CLEAN", 0, true)
    QBCore.Functions.Progressbar('cleanwindow', 'Cleaning....', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        POINTS_DONE_IN_JOB = POINTS_DONE_IN_JOB+1
        Notify(Config.Languages[Config.Lang]["INFO_DONE"]..' '..POINTS_DONE_IN_JOB.."/"..JobsToDo)
        RemoveBlip(PropsBlips[data.Window])
        if NumberToDo == 0 then
            Notify(Config.Languages[Config.Lang]["INFO_DONE_JOB"]..''..JobsToDo*Config.JobWork[SetRandomLocation].PayForOnePoint)
        end  
        exports['qb-target']:RemoveZone(data.Window)
    end, function()
    
    end)
end)

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text)
        ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(text)
        DrawSubtitleTimed(5000, 1)
end)

RegisterNetEvent("qb-gardencleaner:putonclothes")
AddEventHandler("qb-gardencleaner:putonclothes", function()
    if ClothesOn then
        ChangeClothes()
    else
        ChangeClothes('work')
    end
end)


--- FUNCTIONS ---
function SpawnStartingPed()
    local model = Config.Job.StartJob.Ped
    RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end
    
    spawnedPed = CreatePed(0, model, Config.Job.StartJob.Coords.x, Config.Job.StartJob.Coords.y, Config.Job.StartJob.Coords.z - 1, Config.Job.StartJob.Coords.w, false, true)
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    SetEntityInvincible(spawnedPed, true)

    exports[Config.TargetName]:AddTargetModel({GetHashKey('prop_dumpster_01a'), GetHashKey('prop_dumpster_02b'), GetHashKey('prop_dumpster_02a'), GetHashKey('prop_bin_08a')}, {
        options = {
            {
                event = "qb-gardencleaner:bin",
                icon = Config.StartJobEmote,
                label = Config.Languages[Config.Lang]["TARGET_PUTINBIN"],
                canInteract = function(entity)
                    if haveBinBag then
                        return true
                    end
                    return false
                end
            },
        },
        distance = 2.5
    })

    if not Config.job then
        exports[Config.TargetName]:AddTargetEntity(spawnedPed, {
            options = {
                {
                    event = "qb-gardencleaner:getjob",
                    icon = Config.StartJobEmote,
                    label = Config.Languages[Config.Lang]["TalktoCompany"],
                },
                --{
                --    event = "qb-gardencleaner:startjob",
                --    icon = Config.StartJobEmote,
                --    label = Config.Languages[Config.Lang]["TARGET_STARTJOB"],
                --},
                --{
                --    event = "qb-gardencleaner:putonclothes",
                --    icon = Config.ClothesJobEmote,
                --    label = Config.Languages[Config.Lang]["TARGET_PUTONCLOTHES"],
                --},
            },
            distance = 2.5
        })
    else 
        exports[Config.TargetName]:AddTargetEntity(spawnedPed, {
            options = {
                {
                    event = "qb-gardencleaner:startjob",
                    icon = Config.StartJobEmote,
                    label = Config.Languages[Config.Lang]["TARGET_STARTJOB"],
                    job = Config.Job
                },
                {
                    event = "qb-gardencleaner:putonclothes",
                    icon = Config.ClothesJobEmote,
                    label = Config.Languages[Config.Lang]["TARGET_PUTONCLOTHES"],
                    job = Config.Job
                },
            },
            distance = 2.5
        })
    end
end

function SpawnCar()
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetEntityHeading(veh, Config.Job.CarControl.heading)
	    SetVehicleFixed(veh)
	    SetVehicleDeformationFixed(veh)
	    SetVehicleEngineOn(veh, true, true)
	    SetCarFuel(veh)
	    --TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
    end, Config.JobCar, Config.Job.CarControl.Coords, false)
end

function DrawText3Ds(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.030+ factor, 0.03, 0, 0, 0, 150)
end

RegisterCommand('testdumb', function(source, args, RawCommand)
    SetRandomLocation = 1
    SpawnDumbster()
end)

function SpawnDumbster()
    local model = GetHashKey('prop_dumpster_02a')
    RequestModel(model)
    while (not HasModelLoaded(model)) do
        Wait(1)
    end
	local p = CreateObject(model, Config.JobWork[SetRandomLocation].Dumpster.x, Config.JobWork[SetRandomLocation].Dumpster.y, Config.JobWork[SetRandomLocation].Dumpster.z-1.30, true, true, true)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(p, true, true);
    FreezeEntityPosition(p, false)
	SetEntityInvincible(p, true)
    SetEntityHeading(p, Config.JobWork[SetRandomLocation].Dumpster.w)

end

function SpawnWindows()
    if Config.JobWork[SetRandomLocation].CleanWindow then 
        for i=1, #Config.JobWork[SetRandomLocation].CleanWindow do

            PropsBlips["cleeanwindow"..i] = AddBlipForCoord(Config.JobWork[SetRandomLocation].CleanWindow[i].x, Config.JobWork[SetRandomLocation].CleanWindow[i].y, Config.JobWork[SetRandomLocation].CleanWindow[i].z)
            SetBlipSprite(PropsBlips["cleeanwindow"..i], 1)
            SetBlipDisplay(PropsBlips["cleeanwindow"..i], 4)
            SetBlipScale(PropsBlips["cleeanwindow"..i], 0.4)
            SetBlipColour(PropsBlips["cleeanwindow"..i], 5)
            SetBlipAsShortRange(PropsBlips["cleeanwindow"..i], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('CleanWindow')
            EndTextCommandSetBlipName(PropsBlips["cleeanwindow"..i])
           exports['qb-target']:AddBoxZone("cleeanwindow"..i, vector3(Config.JobWork[SetRandomLocation].CleanWindow[i].x, Config.JobWork[SetRandomLocation].CleanWindow[i].y, Config.JobWork[SetRandomLocation].CleanWindow[i].z), 1.5, 1.6, {
                name = "cleeanwindow"..i, 
                heading = Config.JobWork[SetRandomLocation].CleanWindow[i].w, 
                debugPoly = false,
                minZ = Config.JobWork[SetRandomLocation].CleanWindow[i].z - 1,
                maxZ = Config.JobWork[SetRandomLocation].CleanWindow[i].z + 1,
            }, {
                options = {
                  {
                    event = "qb-gardencleaner:cleanwindow",
                    icon = 'fas fa-hand-sparkles',
                    label = 'Clean',
                    Window = "cleeanwindow"..i
                  }
                },
                distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
            })
        end
    end
end

function SpawnLeafs()
    local playerPos = GetEntityCoords(GetPlayerPed(-1), true)		
    for i=1, #Config.JobWork[SetRandomLocation].LeafBlower do
    local model = GetHashKey('prop_veg_crop_04_leaf')
    RequestModel(model)
    while (not HasModelLoaded(model)) do
        Wait(1)
    end
    local p = CreateObject(model, Config.JobWork[SetRandomLocation].LeafBlower[i].x, Config.JobWork[SetRandomLocation].LeafBlower[i].y, Config.JobWork[SetRandomLocation].LeafBlower[i].z-1.80, true, true, true)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(p, true, true);
    FreezeEntityPosition(p, true)
    SetEntityInvincible(p, true)

    PropsBlips[p] = AddBlipForCoord(Config.JobWork[SetRandomLocation].LeafBlower[i].x, Config.JobWork[SetRandomLocation].LeafBlower[i].y, Config.JobWork[SetRandomLocation].LeafBlower[i].z)
    SetBlipSprite(PropsBlips[p], 1)
    SetBlipDisplay(PropsBlips[p], 4)
    SetBlipScale(PropsBlips[p], 0.4)
    SetBlipColour(PropsBlips[p], 5)
    SetBlipAsShortRange(PropsBlips[p], true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('LeafBlower')
    EndTextCommandSetBlipName(PropsBlips[p])

    exports[Config.TargetName]:AddTargetEntity(p, {
        options = {
            {
                event = "qb-gardencleaner:LeafBlower",
                icon = Config.StartJobEmote,
                label = Config.Languages[Config.Lang]["TARGET_START_LEAFS"],
                canInteract = function(entity)
                    if not haveBinBag and HasJobStarted then
                        return true
                    end
                    return false
                end
            },
        },
        distance = 2.5
    })
end
end
function SpawnCharvest()
		local playerPos = GetEntityCoords(GetPlayerPed(-1), true)		
		for i=1, #Config.JobWork[SetRandomLocation].Charvest do
        local model = GetHashKey('prop_plant_01b')
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Wait(1)
        end
		local p = CreateObject(model, Config.JobWork[SetRandomLocation].Charvest[i].x, Config.JobWork[SetRandomLocation].Charvest[i].y, Config.JobWork[SetRandomLocation].Charvest[i].z-1.30, true, true, true)
        SetModelAsNoLongerNeeded(model)
        SetEntityAsMissionEntity(p, true, true);
        FreezeEntityPosition(p, true)
		SetEntityInvincible(p, true)

        PropsBlips[p] = AddBlipForCoord(Config.JobWork[SetRandomLocation].Charvest[i].x, Config.JobWork[SetRandomLocation].Charvest[i].y, Config.JobWork[SetRandomLocation].Charvest[i].z)
        SetBlipSprite(PropsBlips[p], 1)
        SetBlipDisplay(PropsBlips[p], 4)
        SetBlipScale(PropsBlips[p], 0.4)
        SetBlipColour(PropsBlips[p], 5)
        SetBlipAsShortRange(PropsBlips[p], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Charvest')
        EndTextCommandSetBlipName(PropsBlips[p])

        exports[Config.TargetName]:AddTargetEntity(p, {
            options = {
                {
                    event = "qb-gardencleaner:charvest",
                    icon = Config.StartJobEmote,
                    label = Config.Languages[Config.Lang]["TARGET_START_CHARVEST"],
                    canInteract = function(entity)
                        if not haveBinBag and HasJobStarted then
                            return true
                        end
                        return false
                    end
                },
            },
            distance = 2.5
        })
	end
end
function SpawnBinBags()
    local playerPos = GetEntityCoords(GetPlayerPed(-1), true)		
    for i=1, #Config.JobWork[SetRandomLocation].BinBags do
    local model = GetHashKey('prop_rub_binbag_sd_02')
    RequestModel(model)
    while (not HasModelLoaded(model)) do
        Wait(1)
    end
    local p = CreateObject(model, Config.JobWork[SetRandomLocation].BinBags[i].x, Config.JobWork[SetRandomLocation].BinBags[i].y, Config.JobWork[SetRandomLocation].BinBags[i].z-0.99, true, true, true)
    SetModelAsNoLongerNeeded(model)
    FreezeEntityPosition(p, true)
    SetEntityAsMissionEntity(p, true, true);
    SetEntityInvincible(p, true)

    PropsBlips[p] = AddBlipForCoord(Config.JobWork[SetRandomLocation].BinBags[i].x, Config.JobWork[SetRandomLocation].BinBags[i].y, Config.JobWork[SetRandomLocation].BinBags[i].z)
    SetBlipSprite(PropsBlips[p], 1)
    SetBlipDisplay(PropsBlips[p], 4)
    SetBlipScale(PropsBlips[p], 0.4)
    SetBlipColour(PropsBlips[p], 5)
    SetBlipAsShortRange(PropsBlips[p], true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Bin Bag')
    EndTextCommandSetBlipName(PropsBlips[p])

    exports[Config.TargetName]:AddTargetEntity(p, {
        options = {
            {
                event = "qb-gardencleaner:collecttrash",
                icon = Config.StartJobEmote,
                label = Config.Languages[Config.Lang]["TARGET_START_BINBAGS"],
                canInteract = function(entity)
                    if not haveBinBag and HasJobStarted then
                        return true
                    end
                    return false
                end
            },
        },
        distance = 2.5
    })
    end
end

function ChangeClothes(type) 
    if type == "work" then
        local gender
        if GetFrameWork() == 'ESX' then
        TriggerEvent('skinchanger:getSkin', function(skin)
            gender = skin.sex
        end)
        elseif GetFrameWork() == 'QBCORE' then
            local Player = QBCore.Functions.GetPlayerData()
            gender = Player.charinfo.gender
        end
        local PlayerPed = PlayerPedId()
        ClothesOn = true
        if gender == 0 then
            for k,v in pairs(Config.Clothes.male.components) do
                SetPedComponentVariation(PlayerPed, v["component_id"], v["drawable"], v["texture"], 0)
            end
        else
            for k,v in pairs(Config.Clothes.female.components) do
                SetPedComponentVariation(PlayerPed, v["component_id"], v["drawable"], v["texture"], 0)
            end
        end
    else       
        ClothesOn = false 
        if GetFrameWork() == 'ESX' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        elseif GetFrameWork() == 'QBCORE' then
            TriggerServerEvent('qb-clothes:loadPlayerSkin')
        end
    end
end
