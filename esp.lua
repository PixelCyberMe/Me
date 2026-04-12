print("ESP PRO loaded!")

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
    h.OutlineColor = Color3.fromRGB(0,255,100) -- 🟩 зелёный
    h.Parent = char
end

-- 📦 Box + 🦴 Skeleton (Drawing API)
local function createDrawings(player)
    drawings[player] = {
        box = Drawing.new("Square"),
        lines = {}
    }

    local box = drawings[player].box
    box.Thickness = 1.5
    box.Color = Color3.fromRGB(0,255,100)
    box.Filled = false

    -- скелет (несколько линий)
    for i = 1, 10 do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = Color3.fromRGB(0,255,100)
        table.insert(drawings[player].lines, line)
    end
end

local function removeDrawings(player)
    if drawings[player] then
        drawings[player].box:Remove()
        for _, l in pairs(drawings[player].lines) do
            l:Remove()
        end
        drawings[player] = nil
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then return end

    createDrawings(player)

    if player.Character then
        createHighlight(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if enabled then
            createHighlight(char)
        end
    end)
end

-- 🔄 обновление ESP
RunService.RenderStepped:Connect(function()
    if not enabled then return end

    for player, data in pairs(drawings) do
        local char = player.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if onScreen then
            local size = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0,3,0)).Y - pos.Y) * 2

            -- 📦 BOX
            data.box.Size = Vector2.new(size, size*1.5)
            data.box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
            data.box.Visible = true

            -- 🦴 Skeleton (примитив)
            local parts = {
                "Head","UpperTorso","LowerTorso",
                "LeftUpperArm","RightUpperArm",
                "LeftUpperLeg","RightUpperLeg"
            }

            for i, partName in ipairs(parts) do
                local part = char:FindFirstChild(partName)
                local nextPart = char:FindFirstChild(parts[i+1])

                if part and nextPart then
                    local p1 = Camera:WorldToViewportPoint(part.Position)
                    local p2 = Camera:WorldToViewportPoint(nextPart.Position)

                    local line = data.lines[i]
                    if line then
                        line.From = Vector2.new(p1.X, p1.Y)
                        line.To = Vector2.new(p2.X, p2.Y)
                        line.Visible = true
                    end
                end
            end
        else
            data.box.Visible = false
            for _, l in pairs(data.lines) do
                l.Visible = false
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
            for _, d in pairs(drawings) do
                d.box.Visible = false
                for _, l in pairs(d.lines) do
                    l.Visible = false
                end
            end
        end
    end
end)