local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Настройки триггербота
local TriggerBotEnabled = true 
local TeamCheck = true         

-- ЦВЕТОВАЯ ПАЛИТРА
local ColorOn = Color3.fromRGB(135, 55, 48)   -- Нежно-красный
local ColorOff = Color3.fromRGB(70, 74, 76)   -- Аккуратный серый (графитовый)

-- ==========================================
-- СОЗДАНИЕ КОМПАКТНОЙ КНОПКИ НА ЭКРАНЕ (GUI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TriggerBot_Gui"
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or Players.LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 130, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10) 
ToggleButton.BackgroundColor3 = ColorOn 
ToggleButton.TextColor3 = Color3.fromRGB(245, 245, 245) 
ToggleButton.TextSize = 11
ToggleButton.Font = Enum.Font.RobotoBold
ToggleButton.Text = "TriggerBot: ON [P]"
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = ToggleButton

-- Функция переключения состояния
local function toggleTriggerBot()
    TriggerBotEnabled = not TriggerBotEnabled
    if TriggerBotEnabled then
        ToggleButton.BackgroundColor3 = ColorOn
        ToggleButton.Text = "TriggerBot: ON [P]"
    else
        ToggleButton.BackgroundColor3 = ColorOff
        ToggleButton.Text = "TriggerBot: OFF [P]"
    end
end

-- Клик по кнопке
ToggleButton.MouseButton1Click:Connect(toggleTriggerBot)

-- Нажатие клавиши "P"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end 
    if input.KeyCode == Enum.KeyCode.P then
        toggleTriggerBot()
    end
end)

-- ==========================================
-- ЛОГИКА ТРИГГЕРБОТА
-- ==========================================
local function isValidTarget(instance)
    if not instance then return nil end
    local character = instance:FindFirstAncestorOfClass("Model")
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    
    local targetPlayer = Players:GetPlayerFromCharacter(character)
    if targetPlayer and targetPlayer ~= Players.LocalPlayer then
        if TeamCheck and targetPlayer.Team == Players.LocalPlayer.Team then
            return nil
        end
        return character
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    if not TriggerBotEnabled then return end
    
    local target = Mouse.Target
    local validCharacter = isValidTarget(target)
    
    if validCharacter then
        if mouse1press and mouse1release then
            mouse1press()
            task.wait(0.01)
            mouse1release()
        else
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
        end
        task.wait(0.1) 
    end
end)
