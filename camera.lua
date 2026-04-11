local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 📱 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ThirdPersonGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.Text = "3rd Person: OFF"
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = gui

local enabled = false

local function enable3rd()
    player.CameraMinZoomDistance = 0.5
    player.CameraMaxZoomDistance = 20
end

local function disable3rd()
    player.CameraMinZoomDistance = 0
    player.CameraMaxZoomDistance = 0
end

button.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        enable3rd()
        button.Text = "3rd Person: ON"
        button.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        disable3rd()
        button.Text = "3rd Person: OFF"
        button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    end
end)