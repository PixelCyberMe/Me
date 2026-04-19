print("Auto ClickDetector loaded!")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local enabled = false

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 45)
button.Position = UDim2.new(0.1, 0, 0.6, 0)
button.Text = "AUTO CLICK: OFF"
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = gui

local function toggle()
    enabled = not enabled
    if enabled then
        button.Text = "AUTO CLICK: ON"
        print("AutoClick ON")
    else
        button.Text = "AUTO CLICK: OFF"
        print("AutoClick OFF")
    end
end

button.MouseButton1Click:Connect(toggle)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then
        toggle()
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if enabled then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ClickDetector") then
                        local part = obj.Parent
                        if part and part:IsA("BasePart") then
                            local dist = (hrp.Position - part.Position).Magnitude
                            if dist <= 15 then
                                fireclickdetector(obj)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local dragging = false
local dragStart
local startPos
local dragInput

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("Press Q or use button")