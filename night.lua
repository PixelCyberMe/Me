local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🌙 мягкое ночное зрение
local function enableNV()
    Lighting.Brightness = 2.5
    Lighting.ExposureCompensation = 0.8
    Lighting.Ambient = Color3.fromRGB(120, 255, 120)
    Lighting.OutdoorAmbient = Color3.fromRGB(120, 255, 120)
end

local function disableNV()
    Lighting.Brightness = 2
    Lighting.ExposureCompensation = 0
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

local enabled = false

-- 📱 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NVGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.Text = "Night Vision: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = gui

-- 🖱️ drag система
local dragging = false
local dragInput, startPos, startInput

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPos = button.Position
        startInput = input.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - startInput
        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- 🔘 кнопка toggle
button.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        enableNV()
        button.Text = "Night Vision: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        disableNV()
        button.Text = "Night Vision: OFF"
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- ⌨️ Q key toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.Q then
        enabled = not enabled

        if enabled then
            enableNV()
            button.Text = "Night Vision: ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            disableNV()
            button.Text = "Night Vision: OFF"
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
    end
end)