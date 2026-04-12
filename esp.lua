print("ESP script loaded!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local enabled = true

local function createESP(char, player)
    if not char then return end
    if char:FindFirstChild("ESP") then return end

    -- ⚪ Highlight (обводка)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = char

    -- 🏷 ник над головой
    local head = char:FindFirstChild("Head")
    if head and not head:FindFirstChild("ESP_Name") then
        local bill = Instance.new("BillboardGui")
        bill.Name = "ESP_Name"
        bill.Size = UDim2.new(0, 200, 0, 50)
        bill.StudsOffset = Vector3.new(0, 2, 0)
        bill.AlwaysOnTop = true
        bill.Parent = head

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = player.Name
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Parent = bill
    end
end

local function applyESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                createESP(player.Character, player)
            end

            player.CharacterAdded:Connect(function(char)
                if enabled then
                    createESP(char, player)
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

            local head = player.Character:FindFirstChild("Head")
            if head then
                local name = head:FindFirstChild("ESP_Name")
                if name then name:Destroy() end
            end
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
print("ESP enabled with names")