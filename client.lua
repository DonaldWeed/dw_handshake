-- dw_handshake
-- Simple handshake interaction
-- Author: donald weed
-- License: MIT

local RANGE = 2.0
local COOLDOWN = 3000
local lastUse = 0

local function getClosestPlayer()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    local closestPlayer = nil
    local closestDist = RANGE

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            local dist = #(coords - GetEntityCoords(targetPed))

            if dist < closestDist then
                closestDist = dist
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

local function playHandshake()
    local ped = PlayerPedId()

    RequestAnimDict("mp_ped_interaction")
    while not HasAnimDictLoaded("mp_ped_interaction") do
        Wait(10)
    end

    TaskPlayAnim(
        ped,
        "mp_ped_interaction",
        "handshake_guy_a",
        8.0, -8.0, 2000,
        49, 0, false, false, false
    )
end

RegisterCommand("dw_handshake", function()
    local now = GetGameTimer()
    if now - lastUse < COOLDOWN then return end
    lastUse = now

    local target = getClosestPlayer()
    if not target then
        TriggerEvent('chat:addMessage', {
            args = { '^1Niemand in der Nähe.' }
        })
        return
    end

    playHandshake()

    TriggerEvent('chat:addMessage', {
        args = { '^2Du gibst jemandem die Hand.' }
    })
end, false)

-- Taste P
RegisterKeyMapping(
    "dw_handshake",
    "Handshake mit nächstem Spieler",
    "keyboard",
    "P"
)


