-- // Auto Gold Collect & Smart Farm Script for Doors
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local RemotesFolder = ReplicatedStorage:FindFirstChild("RemotesFolder") or ReplicatedStorage:FindFirstChild("EntityInfo")
local CurrentRooms = Workspace:FindFirstChild("CurrentRooms")
local GameData = ReplicatedStorage:FindFirstChild("GameData")

local QueueTeleport = queue_on_teleport or queueonteleport
-- Ссылка на текущий скрипт для авто-перезапуска (замени на свою актуальную ссылку при необходимости, либо используется текущий код)
local ScriptUrl = "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau" 

local function SendCaption(Text)
    pcall(function()
        if RemotesFolder and RemotesFolder:FindFirstChild("Caption") and firesignal then
            firesignal(RemotesFolder.Caption.OnClientEvent, "[AutoGoldFarm] " .. Text)
        elseif RemotesFolder and RemotesFolder:FindFirstChild("CaptionClient") then
            RemotesFolder.CaptionClient:Fire("[AutoGoldFarm] " .. Text)
        end
    end)
end

-- 1. Логика нахождения в Лобби (PlaceId: 6516141723)
if game.PlaceId == 6516141723 then
    SendCaption("Joining a run...")
    if QueueTeleport then QueueTeleport('loadstring(game:HttpGet("' .. ScriptUrl .. '"))()') end
    if RemotesFolder and RemotesFolder:FindFirstChild("CreateElevator") then
        RemotesFolder.CreateElevator:FireServer({
            Mods = {},
            Settings = {},
            Destination = "Hotel",
            FriendsOnly = false,
            MaxPlayers = "1"
        })
    end
    return
end

-- Проверка правильности этапа (должен быть Hotel)
if GameData and GameData:FindFirstChild("Floor") and GameData.Floor.Value ~= "Hotel" then
    if QueueTeleport then QueueTeleport('loadstring(game:HttpGet("' .. ScriptUrl .. '"))()') end
    SendCaption("Returning to lobby...")
    if RemotesFolder and RemotesFolder:FindFirstChild("Lobby") then
        RemotesFolder.Lobby:FireServer()
    end
    return
end

if game.PlaceId ~= 6839171747 then
    if QueueTeleport then QueueTeleport('loadstring(game:HttpGet("' .. ScriptUrl .. '"))()') end
    TeleportService:Teleport(6516141723)
    return
end

while not LocalPlayer.Character or not CurrentRooms do
    task.wait(1)
end

-- 2. Функция ходьбы до позиции через Pathfinding
local function WalkToPosition(targetPos)
    local Character = LocalPlayer.Character
    if not Character then return false end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not RootPart then return false end

    local path = PathfindingService:CreatePath({
        AgentCanJump = true,
        AgentRadius = 2,
        AgentHeight = 5,
    })

    local success = pcall(function()
        path:ComputeAsync(RootPart.Position, targetPos)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            if not LocalPlayer.Character or Humanoid.Health <= 0 then return false end
            Humanoid:MoveTo(waypoint.Position)
            
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end

            local reached = false
            local conn
            conn = Humanoid.MoveToFinished:Connect(function()
                reached = true
                if conn then conn:Disconnect() end
            end)

            task.spawn(function()
                task.wait(1.5)
                if not reached then
                    reached = true
                    if conn then conn:Disconnect() end
                end
            end)

            repeat task.wait() until reached
        end
        return true
    else
        Humanoid:MoveTo(targetPos)
        task.wait(1)
        return true
    end
end

-- Функция поиска ближайшего золота
local function GetNearestGold()
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    local RootPart = Character.HumanoidRootPart

    local nearest = nil
    local shortestDist = math.huge

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GoldPile" and obj:GetAttribute("GoldValue") then
            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("ModulePrompt", true)
            local part = obj.PrimaryPart or obj:FindFirstChild("Hitbox") or obj:FindFirstChildOfClass("BasePart")
            if prompt and part then
                local dist = (RootPart.Position - part.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

-- Функция подбора
local function TryInteract(obj)
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("ModulePrompt", true)
    if prompt then
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end
    end
end

-- 3. Основной игровой цикл: Сбор золота -> Смерть -> Статистика -> Перезапуск
task.spawn(function()
    SendCaption("Auto Gold Farm started. Collecting gold...")

    while true do
        task.wait(0.5)
        local Character = LocalPlayer.Character
        if not Character then continue end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart or Humanoid.Health <= 0 then continue end

        local gold = GetNearestGold()

        if gold then
            local targetPart = gold.PrimaryPart or gold:FindFirstChild("Hitbox") or gold:FindFirstChildOfClass("BasePart")
            if targetPart then
                -- Идем к золоту честно (ногами)
                WalkToPosition(targetPart.Position)

                -- Если подошли близко — собираем
                if (RootPart.Position - targetPart.Position).Magnitude < 12 then
                    TryInteract(gold)
                    task.wait(0.4)
                end
            end
        else
            -- Золото в комнате/доступе закончилось. Переходим к суициду и сохранению статистики.
            SendCaption("No more gold found. Dying to save stats...")
            task.wait(1)

            if replicatesignal then
                replicatesignal(LocalPlayer.Kill)
            else
                Humanoid.Health = 0
            end

            -- Ожидаем смерть
            repeat task.wait() until LocalPlayer:GetAttribute("Alive") == false or Humanoid.Health <= 0
            task.wait(1)

            -- Обновляем статистику / отправляем запрос на перезапуск забега
            SendCaption("Restarting run for next gold loop...")
            if QueueTeleport then QueueTeleport('loadstring(game:HttpGet("' .. ScriptUrl .. '"))()') end
            
            if RemotesFolder and RemotesFolder:FindFirstChild("Statistics") then
                pcall(function() RemotesFolder.Statistics:FireServer() end)
            end
            
            task.wait(0.5)
            if RemotesFolder and RemotesFolder:FindFirstChild("PlayAgain") then
                RemotesFolder.PlayAgain:FireServer()
            end
            
            break
        end
    end
end)