print("Esp Activated")

local Players = game:GetService("Players")

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        local function setupESP(char)
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = char
        end

        if player.Character then
            setupESP(player.Character)
        end

        player.CharacterAdded:Connect(function(char)
            setupESP(char)
        end)
    end
end

-- новые игроки
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char
    end)
end)