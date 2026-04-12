print("ESP Activated")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local enabled = true

local function createESP(char)
    if char:FindFirstChild("ESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillTransparency = 1 -- ❌ без заливки
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 170, 255) -- 🔵 синяя обводка
    highlight.Parent = char
end

local function addPlayer(player)
    if player == LocalPlayer then return end

    if player.Character then
        createESP(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if enabled then
            createESP(char)
        end
    end)
end

local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        addPlayer(player)
    end
end

local function disableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local esp = player.Character:FindFirstChild("ESP")
            if esp then esp:Destroy() end
        end
    end
end

-- новые игроки
Players.PlayerAdded:Connect(function(player)
    if enabled then
        addPlayer(player)
    end
end)

-- ⌨️ кнопка M
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.M then
        enabled = not enabled

        if enabled then
            enableESP()
            print("ESP ON")
        else
            disableESP()
            print("ESP OFF")
        end
    end
end)

-- 🚀 включено по умолчанию
enableESP()