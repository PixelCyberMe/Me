print("ESP script loaded!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local enabled = true

local function createESP(char, player)
    if not char then return end
    if char:FindFirstChild("ESP") then return end

    -- ⚪ Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.Parent = char

    -- 🏷 НИК (фикс)
    task.spawn(function()
        local head = char:WaitForChild("Head", 5)
        if not head then return end

        if not head:FindFirstChild("ESP_Name") then
            local bill = Instance.new("BillboardGui")
            bill.Name = "ESP_Name"
            bill.Size = UDim2.new(0, 200, 0, 40)
            bill.StudsOffset = Vector3.new(0, 2.5, 0)
            bill.AlwaysOnTop = true
            bill.Adornee = head -- 🔥 ВАЖНО
            bill.Parent = head

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1,0,1,0)
            text.BackgroundTransparency = 1
            text.Text = player.Name
            text.TextColor3 = Color3.fromRGB(255,255,255)
            text.TextStrokeTransparency = 0
            text.TextScaled = true
            text.Font = Enum.Font.SourceSansBold
            text.Parent = bill
        end
    end)
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

-- 🚀 старт
task.wait(1)
applyESP()
print("ESP enabled with names (fixed)")