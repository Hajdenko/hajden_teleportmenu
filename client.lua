local options = {}
for _, v in ipairs(Hajden.Settings) do
    table.insert(options, {
        title = v.label,
        description = v.description,
        onSelect = function()
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, true) then
                local veh = GetVehiclePedIsIn(ped, false)
                SetEntityCoords(veh, v.playercoords)
                SetEntityHeading(veh, v.playerheading)
            else
                SetEntityCoords(ped, v.playercoords)
                SetEntityHeading(ped, v.playerheading)
            end
        end
    })
end

lib.registerContext({
    id = 'teleport_menu',
    title = Hajden.TeleportMenuTitle,
    options = options
})

local ox_target = exports.ox_target
Citizen.CreateThread(function()
    for _, v in ipairs(Hajden.Settings) do
    local modelHash = GetHashKey(Hajden.NPCmodel)
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    
    local teleport_ped = CreatePed(4, modelHash, v.NPCcoords.x, v.NPCcoords.y, v.NPCcoords.z-1, v.NPCheading, false, true)
    
    FreezeEntityPosition(teleport_ped, true)
    SetEntityVelocity(teleport_ped, 0.0, 0.0, 0.0)
    TaskStandStill(teleport_ped, -1)
    SetEntityAsMissionEntity(teleport_ped, true, true)
    SetPedCanBeTargetted(teleport_ped, true)
    SetPedCanPlayAmbientAnims(teleport_ped, true)
    SetPedCanRagdoll(teleport_ped, true)
    SetEntityAsMissionEntity(teleport_ped, true, true)
    SetEntityInvincible(teleport_ped, true)
    SetPedRelationshipGroupHash(teleport_ped, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetPedRelationshipGroupHash(ped))
    
        ox_target:addBoxZone({
            coords = vec3(v.NPCcoords.x, v.NPCcoords.y, v.NPCcoords.z),
            size = vec3(2, 2, 3),
            rotation = 45,
            drawSprite = false,
            options = {
                {
                    name = 'teleport_ped',
                    icon = 'fa-solid fa-person',
                    label = 'Open Teleport Menu',
                    onSelect = function()
                        lib.showContext('teleport_menu')
                    end
                }
            }
        })
    end
end)