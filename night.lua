local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🌌 эффект ночного зрения
local function enableNightVision()
    Lighting.Brightness = 3
    Lighting.ExposureCompensation = 2
    Lighting.Ambient = Color3.fromRGB(180, 255, 180)
    Lighting.OutdoorAmbient = Color3.fromRGB(180, 255, 180)
end

local function disableNightVision()
    Lighting.Brightness = 2
    Lighting.ExposureCompensation = 0
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

-- 📱 GUI кнопка
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NightVisionGui"
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.Text = "Night Vision: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

local enabled = false

button.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        enableNightVision()
        button.Text = "Night Vision: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        disableNightVision()
        button.Text = "Night Vision: OFF"
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)