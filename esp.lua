print("ESP Skeleton loaded!")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local enabled = true
local drawings = {}

-- 🟩 Highlight
local function createHighlight(char)
    if char:FindFirstChild("ESP") then return end

    local h = Instance.new("Highlight")
    h.Name = "ESP"
    h.FillTransparency = 1
    h.OutlineTransparency = 0
    h.OutlineColor = Color3.fromRGB(0,255,100)
    h.Parent = char
end

-- 🦴 Skeleton
local function createSkeleton(player)
    drawings[player] = {}

    for i = 1, 10 do
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Color = Color3.fromRGB(0,255,100)
        line.Visible = false
        table.insert(drawings[player], line)
    end
end

local function removeSkeleton(player)
    if drawings[player] then
        for _, l in pairs(drawings[player]) do
            l:Remove()
        end
        drawings[player] = nil
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then return end

    createSkeleton(player)

    if player.Character then
        createHighlight(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if enabled then
            createHighlight(char)
        end
    end)
end

-- 🔄 обновление
RunService.RenderStepped:Connect(function()
    if not enabled then return end

    for player, lines in pairs(drawings) do
        local char = player.Character
        if not char then continue end

        local parts = {
            "Head","UpperTorso","LowerTorso",
            "LeftUpperArm","RightUpperArm",
            "LeftUpperLeg","RightUpperLeg"
        }

        for i = 1, #parts - 1 do
            local p1 = char:FindFirstChild(parts[i])
            local p2 = char:FindFirstChild(parts[i+1])

            local line = lines[i]

            if p1 and p2 and line then
                local v1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                local v2, vis2 = Camera:WorldToViewportPoint(p2.Position)

                if vis1 and vis2 then
                    line.From = Vector2.new(v1.X, v1.Y)
                    line.To = Vector2.new(v2.X, v2.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            end
        end
    end
end)

-- 🆕 новые игроки
Players.PlayerAdded:Connect(function(player)
    if enabled then
        setupPlayer(player)
    end
end)

-- 🚀 запуск
for _, p in pairs(Players:GetPlayers()) do
    setupPlayer(p)
end

-- ⌨️ toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.M then
        enabled = not enabled

        if enabled then
            print("ESP ON")
        else
            print("ESP OFF")
            for _, lines in pairs(drawings) do
                for _, l in pairs(lines) do
                    l.Visible = false
                end
            end
        end
    end
end)