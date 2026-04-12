print("ESP script loaded!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local enabled = true

local function createESP(char)
    if not char then return end
    if char:FindFirstChild("ESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"

    highlight.FillTransparency = 1 -- ❌ полностью убираем заливку
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- ⚪ белая обводка

    highlight.Parent = char
end

local function applyESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                createESP(player.Character)
            end

            player.CharacterAdded:Connect(function(char)
                if enabled then
                    createESP(char)
                end
            end)
        end
    end
end

local function removeESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local esp = player.Character:FindFirstChild("ESP")
            if esp then esp:Destroy() end
        end
    end
end

-- ⌨️ M toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.M then
        enabled = not enabled

        if enabled then
            print("ESP ON")
            applyESP()
        else
            print("ESP OFF")
            removeESP()
        end
    end
end)

-- 🚀 запуск
task.wait(1)
applyESP()
print("ESP enabled (white outline)")