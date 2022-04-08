------
-- Tesla Autopilot by ZuuZoo
-- Version: 1.0
------
-- This script can prevent car crash, control high beam lights,
-- give feedback when reversing, set Tesla driving modes and drive the car automatically in the speed
-- range of 5-40mph.
-- Here you can find client side functions and server side call's.
-- This is the final version! I made this script free, but it takes a lot of work. 
-- If you consider supporting me, contact me on my discord (ZuuZoo#8951) or email: hollosibendeguz2007@gmail.com. I appriciate it!
------

local alert = false
local sensorstate = false
local reverse = false 
local timer = 200 -- Error sound delay
local sensor = 25 -- Sensor beeping delay
local ground = 0 -- Ground finder
local autodrive = false -- Autodrive state
local fposx = 0 -- Front posx
local fposy = 0 -- Front posy
local cruisespeed = 10 -- Default autodrive speed. You can change the speed with (num +) and (num -) 
local display = false
local xpos = 0
local ypos = 0 
local sportmode = false
Citizen.CreateThread(function()    
    while true do
        Citizen.Wait(0)   
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local model = GetEntityModel(vehicle)    
        local namelower = string.lower(GetDisplayNameFromVehicleModel(model))
        local nameupper = string.upper(GetDisplayNameFromVehicleModel(model))                
        if table.contains(Config.AllowedModels, namelower) or table.contains(Config.AllowedModels, nameupper) then
            if DoesEntityExist(vehicle) then                                           
                local veh = GetVehiclePedIsUsing(PlayerPedId())   
                local gear = GetEntitySpeedVector(veh,true)      
                local gear2 = GetVehicleCurrentGear(veh)         
                local retval, lights, highbeam = GetVehicleLightsState(veh)                
                local xPlayer = PlayerPedId()
                local s_key = 72
                local w_key = 71
                local space = 76 
                local a_key = 63
                local d_key = 64                                   
                if Config.EnableColAvoidance and sportmode ~= true then
                    if gear2 > 0 and gear.y >= 0 and reverse == false and autodrive == false then
                        SetVehicleHandbrake(veh, false)  
                        speed = (GetEntitySpeed(veh)* 2.236936)                                       
                        local heading = GetEntityPhysicsHeading(veh)
                        local wheelheading = GetVehicleWheelSteeringAngle(veh)*50
                        local pos = GetEntityCoords(veh)
                
                        posx = (4+(speed/10)*(speed/10)*0.4)*math.cos((heading+90+wheelheading)/57.5)
                        posy = (4+(speed/10)*(speed/10)*0.4)*math.sin((heading+90+wheelheading)/57.5)
                        fposx = 4*math.cos((heading+90+(wheelheading))/57.5)
                        fposy = 4*math.sin((heading+90+(wheelheading))/57.5)   
                
                        radarobject = getNearestVeh()
                        radarveh = GetEntityCoords(radarobject)
                        frontobject = getClosestVeh()
                        frontveh = GetEntityCoords(frontobject)  
                        
                        radarobject2 = getNearestObj()
                        radarveh2 = GetEntityCoords(radarobject2)
                        frontobject2 = getClosestObj()
                        frontveh2 = GetEntityCoords(frontobject2)  
                
                        gr, ground = GetGroundZFor_3dCoord(pos.x + posx, pos.y + posy, pos.z+4, 0)
                        distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, radarveh.x, radarveh.y, radarveh.z, false) 
                        distance2 = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, radarveh2.x, radarveh2.y, radarveh2.z, false)                               
                        if radarobject ~= 0 or radarobject2 ~= 0 then
                            objectspeed = (GetEntitySpeed(radarobject)* 2.236936)      
                            slowdistance = ((objectspeed*objectspeed)-(speed*speed))/(2*(distance)) 
                            objectspeed2 = (GetEntitySpeed(radarobject2)* 2.236936)      
                            slowdistance2 = ((objectspeed2*objectspeed2)-(speed*speed))/(2*(distance2))                     
                            if speed > 10 and speed > objectspeed+20 and slowdistance < 0 and slowdistance*-1 >= distance+(distance/((speed-objectspeed)/10)) or speed > 10 and speed > objectspeed2+20 and slowdistance2 < 0 and slowdistance2*-1 >= distance2+(distance2/((speed-objectspeed2)/10)) then
                                if speed > 0.8 then
                                    TaskVehicleTempAction(PlayerPedId(),veh,3,1) 
                                    SetVehicleBrake(veh, true)
                                    SetVehicleBrakeLights(veh, true)
                                end
                                SetVehicleBrake(veh, false)
                                SetVehicleBrakeLights(veh, false)
                                DisableControlAction(2,71,true)
                                if alert == false then
                                    alert = true
                                    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'error', Config.BeepSoundVolume)                          
                                end                                                
                            end                                     
                        end
                        if frontobject ~= 0 or frontobject2 ~= 0 then
                            objectspeed = (GetEntitySpeed(frontobject)* 2.236936) 
                            objectspeed2 = (GetEntitySpeed(frontobject2)* 2.236936)               
                            if speed > objectspeed or speed > objectspeed2 then                        
                                if speed > 0.8 then
                                    TaskVehicleTempAction(PlayerPedId(),veh,3,1) 
                                    SetVehicleBrake(veh, true)
                                    SetVehicleBrakeLights(veh, true)
                                end
                                SetVehicleBrake(veh, false)
                                SetVehicleBrakeLights(veh, false)
                                DisableControlAction(2,71,true)                                           
                            end                                     
                        end  
                    end                
                end
    
                if reverse and autodrive == false then
                    local pos = GetEntityCoords(veh)
                    local heading = GetEntityPhysicsHeading(veh)
                    local wheelheading = GetVehicleWheelSteeringAngle(veh)*20           
                    local gear = GetVehicleCurrentGear(veh)                        
                    pitch = GetEntityPitch(veh)
            
                    speed = (GetEntitySpeed(veh)* 2.236936)                 
                    rrobject4 = getRR4()
                    rrobject3 = getRR3()
                    rrobject2 = getRR2()
                    rrobject1 = getRR1()
            
                    fposx = math.cos((heading+270+wheelheading*-1)/57.5)
                    fposy = math.sin((heading+270+wheelheading*-1)/57.5)                                              
            
                    if Config.EnableReverseCamera then
                        SetCamCoord(cam, pos.x + (2.6*math.cos((heading+272.25)/57.5)), pos.y + (2.6*math.sin((heading+272.25)/57.5)), pos.z-(pitch/25)+0.25)
                        PointCamAtCoord(cam, pos.x + (5*math.cos((heading+272)/57.5)), pos.y + (5*math.sin((heading+272)/57.5)), pos.z-(pitch/10)-1)
                        SetCamFov(cam, 100.0)    
                
                        SetCamActive(cam, true)
                        RenderScriptCams(true, true, 500, true, true)
                    end
            
                    if rrobject4 ~= 0 then
                        DisableControlAction(2,72,true)                
                        if sensorstate == false then
                            sensorstate = true
                            sensor = 100
                            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'error', Config.BeepSoundVolume)                        
                        end          
                    end
                    if rrobject1 ~= 0 and rrobject2 ~= 0 and rrobject3 ~= 0 and rrobject4 == 0 then                  
                        if sensorstate == false then
                            sensorstate = true
                            sensor = 20
                            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'sensor', Config.BeepSoundVolume)                        
                        end          
                    end
                    if rrobject1 ~= 0 and rrobject2 ~= 0 and rrobject3 == 0 then
                        if sensorstate == false then
                            sensorstate = true
                            sensor = 22.5
                            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'sensor', Config.BeepSoundVolume)                      
                        end                                     
                    end
                    if rrobject1 ~= 0 and rrobject2 == 0 and rrobject3 == 0 then
                        if sensorstate == false then
                            sensorstate = true                        
                            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'sensor', Config.BeepSoundVolume)                          
                        end                                     
                    end                
            
                    if Config.EnableReverseCamera and Config.EnableReverseLines then
                        SendInfo(GetVehicleWheelSteeringAngle(veh)*500)
                    end
            
                    if gear == 1 and speed > 20 or IsControlJustPressed(1, 23) then
                        if Config.EnableReverseCamera then
                            SetCamActive(cam, false)
                            RenderScriptCams(0, true, 500, true, true)
                            if Config.EnableReverseLines then
                                SetDisplay(false)
                            end 
                        end
                        reverse = false                   
                    end
                end                    
    
                if alert then
                    if timer > 0 then
                        timer = timer - 1
                    else
                        alert = false
                        timer = 200
                    end
                end 

                if sensorstate then
                    if sensor > 0 then
                        sensor = sensor - 1
                    else
                        sensorstate = false
                        sensor = 100
                    end
                end 
    
                if IsControlJustPressed(1, Config.ReverseKeycode) then                
                    if reverse then
                        reverse = false
                        if Config.EnableReverseCamera then
                            SetCamActive(cam, false)
                            RenderScriptCams(0, true, 500, true, true)
                            if Config.EnableReverseLines then
                                SetDisplay(false)
                            end
                        end
                    else                                    
                        reverse = true                  
                        if Config.EnableReverseCamera then 
                            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')                    
                            if Config.EnableReverseLines then
                                SetDisplay(true)
                            end
                        end
                    end            
                end

                if IsControlJustPressed(1, Config.SportModeKey) then      
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    local model = GetEntityModel(vehicle)    
                    local namelower = string.lower(GetDisplayNameFromVehicleModel(model))
                    local nameupper = string.upper(GetDisplayNameFromVehicleModel(model))           
                    if sportmode then
                        if Config.EnableSportMode then 
                            sportmode = false                     
                            if namelower == "models" then
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionForce', 1.400000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionCompDamp', 0.900000) 
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionUpperLimit', 0.110000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionLowerLimit', -0.120000) 
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionReboundDamp', 1.300000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise', 0.020000)  
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveInertia', 0.200000)   
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax', 3.000000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin', 2.500000)
                            end
                            SendNotification({
                                text = "Normal mode.",
                                timeout = 3000
                            })
                        end
                    else                               
                        if Config.EnableSportMode then
                            sportmode = true
                            if namelower == "models" then
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionForce', 3.400000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionCompDamp', 2.900000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionUpperLimit', 0.050000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionLowerLimit', -0.120000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionReboundDamp', 2.300000)  
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise', -0.050000)  
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveInertia', 1.000000)       
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax', 5.000000)
                                SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin', 4.000000)  
                            end        
                            SendNotification({
                                text = "Sport mode.",
                                timeout = 3000
                            })                            
                        end
                    end            
                end
    
                if lights > 0 and highbeam < 1 and IsControlJustPressed(1, 74) then
                    road = getRightSide()
                    if road ~= 0 then
                        reflector = GetEntityCoords(road)
                        DisableControlAction(2,74,true)
                        SendNotification({
                            text = "The reflector would blind the oncoming traffic.",
                            timeout = 3000
                        })
                    end
                elseif lights > 0 and highbeam > 0 or lights > 0 and light2 and highbeam then
                    road = getRightSide()                
                    if road ~= 0 then
                        SetVehicleLightMultiplier(veh, 0.3)
                    else
                        SetVehicleLightMultiplier(veh, 1.0)
                    end          
                end

                if Config.EnableAutodrive then
                    if IsControlJustPressed(1, Config.AutodriveKeycode) and autodrive == false then
                        if IsWaypointActive() then                              
                            local WaypointHandle = GetFirstBlipInfoId(8)                    
                            x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())) 
                            xpos = x
                            ypos = y
                            gr, ground = GetGroundZFor_3dCoord(x, y, z+1000, 0)                 
                            local veh = GetVehiclePedIsIn(PlayerPedId(), false)   
                            TaskVehicleDriveToCoordLongrange(xPlayer, veh, x, y, ground, 10.0, 1 | 2 | 4 | 8 | 16 | 128 | 256 | 786603, 20.0)
                            SetDriverAbility(PlayerPedId(), 100.0)
                            SendNotification({
                                text = "Autopilot enabled.",
                                timeout = 3000
                            })
                            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', Config.BeepSoundVolume) 
                            autodrive = true                                             
                        else
                            SendNotification({
                                text = "Select the destination.",
                                timeout = 3000
                            })
                        end
                    end
                    if IsControlJustPressed(1, s_key) and autodrive or IsControlJustPressed(1, w_key) and autodrive or IsControlJustPressed(1, space) and autodrive or IsControlJustPressed(1, a_key) and autodrive or IsControlJustPressed(1, d_key) and autodrive then
                        ClearPedTasks(PlayerPedId())
                        SendNotification({
                            text = "Autopilot disabled.",
                            timeout = 3000
                        })
                        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', Config.BeepSoundVolume) 
                        autodrive = false
                    end
                    if autodrive then
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)  
                        local pos = GetEntityCoords(veh)               
                        SetDriveTaskCruiseSpeed(PlayerPedId(),cruisespeed*2.236936)
                        destinationlength = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, xpos, ypos, 100.0, false) 
                        speed = (GetEntitySpeed(veh)* 2.236936)
                        if destinationlength < 10 then                                                
                            if speed > 1 then
                                TaskVehicleTempAction(PlayerPedId(),veh,3,1) 
                                SetVehicleBrake(veh, true)
                                SetVehicleBrakeLights(veh, true)
                            else
                                ClearPedTasks(PlayerPedId())
                                SendNotification({
                                    text = "Autopilot disabled.",
                                    timeout = 3000
                                })
                                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', Config.BeepSoundVolume) 
                                autodrive = false
                            end
                        end
                        if IsControlJustPressed(1, Config.AutodriveDecreaseSpeedKey) then
                            if cruisespeed > Config.AutodriveMinSpeed then
                                cruisespeed = cruisespeed - 2.5
                            else
                                SendNotification({
                                    text = "Minimum speed limit reached.",
                                    timeout = 3000
                                })
                            end
                        elseif IsControlJustPressed(1, Config.AutodriveIncreaseSpeedKey) then
                            if cruisespeed < Config.AutodriveMaxSpeed then
                                cruisespeed = cruisespeed + 2.5
                            else
                                SendNotification({
                                    text = "Maximum speed limit reached.",
                                    timeout = 3000
                                })
                            end
                        end
                    end                
                end                                                       
            end 
        end
    end    
end)

Citizen.CreateThread(function()    
    while true do
        Citizen.Wait(0)          
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local model = GetEntityModel(vehicle)    
        local namelower = string.lower(GetDisplayNameFromVehicleModel(model))
        local nameupper = string.upper(GetDisplayNameFromVehicleModel(model))                         
        if namelower == "models" then
            if DoesEntityExist(vehicle) then                        
                if IsPedGettingIntoAVehicle(PlayerPedId()) then            
                    sportmode = false
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionForce', 1.400000)
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionCompDamp', 0.900000) 
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionUpperLimit', 0.110000)
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionLowerLimit', -0.120000) 
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionReboundDamp', 1.300000)
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise', 0.020000)  
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveInertia', 0.200000)   
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax', 3.000000)
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin', 2.500000)                            
                end
            end
        end        
    end    
end)

function SetDisplay(bool)
    display = bool
    SendNUIMessage({
        type="ui",
        status = bool,
    })
end
function SendInfo(info)
    SendNUIMessage({
        type="angleinfo",
        angle = info,
    })
end

function getNearestVeh()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+speed/100, 1+speed/100, 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + posx, pos.y + posy, ground, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 10, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getClosestVeh()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+speed/100, 1+speed/100, 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + fposx, pos.y + fposy, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 10, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getNearestObj()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+(speed/100), 1+(speed/100), 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + posx, pos.y + posy, ground+1, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 2, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getClosestObj()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+speed/100, 1+speed/100, 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + fposx, pos.y + fposy, pos.z+1, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 2, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end

function getRightSide()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 50.0, 50.0, 5.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + 7*fposx, pos.y + 7*fposy, ground, entityWorld.x, entityWorld.y, entityWorld.z, 50.0, 10, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end

function getRR4()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (1.8*fposx), pos.y + (1.8*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getRR3()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (3*fposx), pos.y + (3*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getRR2()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (4*fposx), pos.y + (4*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getRR1()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (5*fposx), pos.y + (5*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local body = {
	scale = 0.3,
	offsetLine = 0.02,
	offsetX = 0.005,
	offsetY = 0.004,
	dict = 'commonmenu',
	sprite = 'gradient_bgd',
	width = 0.16,
	height = 0.012,
	heading = -90.0,
	gap = 0.002,
}

RequestStreamedTextureDict(body.dict)

local function goDown(v, id) 
	for i = 1, #v do
		if v[i].draw and i ~= id then
			v[i].y = v[i].y + 150
		end
	end
end

local function CountLines(v, text)
	BeginTextCommandLineCount("STRING")
    SetTextScale(body.scale, body.scale)
    SetTextWrap(v.x, v.x + body.width - body.offsetX)
	AddTextComponentSubstringPlayerName(text)
	local nbrLines = GetTextScreenLineCount(v.x + body.offsetX, v.y + body.offsetY)
	return nbrLines
end

local function DrawText(v, text)
	SetTextScale(body.scale, body.scale)
    SetTextWrap(v.x, v.x + body.width - body.offsetX)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(v.x + body.offsetX, v.y + body.offsetY)
end

local function DrawBackground(v)
	DrawSprite(body.dict, body.sprite, v.x + body.width/2, v.y + (body.height + v.lines*body.offsetLine)/2, body.width, body.height + v.lines*body.offsetLine, body.heading, 255, 255, 255, 255)
end

local positions = {
	['bottomLeft'] = { x = 0.160, y = 0.94, notif = {} },
}

function SendNotification(options)
    local text = options.text 
    local timeout = options.timeout 

	local p = positions['bottomLeft']
	local id = #p.notif + 1
	local nbrLines = CountLines(p, text)

	p.notif[id] = {
		x = p.x,
		y = p.y,
		lines = nbrLines, 
		draw = true,
	}

	if id > 1 then
		goDown(p.notif, id)
    end
    
    Citizen.CreateThread(function()
		Wait(timeout)
		p.notif[id].draw = false
	end)
	
	Citizen.CreateThread(function()
		while p.notif[id].draw do
			Wait(0)
			DrawBackground(p.notif[id])
			DrawText(p.notif[id], text)
		end
	end)
end