local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Настройки триггербота
local TriggerBotEnabled = true -- Включен ли скрипт (true - да, false - нет)
local TeamCheck = true         -- Проверять ли команды (true - не стрелять в своих)

-- Функция для проверки, является ли цель живым врагом
local function isValidTarget(instance)
    if not instance then return nil end
    
    -- Ищем персонажа (модель), поднимаясь вверх по иерархии от детальки, на которую навелись
    local character = instance:FindFirstAncestorOfClass("Model")
    if not character then return nil end
    
    -- Проверяем, есть ли у модели Humanoid (значит это игрок или NPC)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    
    -- Находим, какому игроку принадлежит этот персонаж
    local targetPlayer = Players:GetPlayerFromCharacter(character)
    if targetPlayer and targetPlayer ~= Players.LocalPlayer then
        -- Проверка на команду (если включена)
        if TeamCheck and targetPlayer.Team == Players.LocalPlayer.Team then
            return nil -- Свой, не стреляем
        end
        return character
    end
    
    return nil
end

-- Основной цикл, который проверяет прицел каждый кадр
RunService.RenderStepped:Connect(function()
    if not TriggerBotEnabled then return end
    
    -- Mouse.Target возвращает объект, на который сейчас наведен курсор/прицел
    local target = Mouse.Target
    local validCharacter = isValidTarget(target)
    
    if validCharacter then
        -- Симулируем клик мышки (выстрел)
        -- mouse1press() нажимает ЛКМ, mouse1release() отпускает её
        if mouse1press and mouse1release then
            mouse1press()
            task.wait(0.01) -- Микро-пауза, чтобы игра засчитала нажатие
            mouse1release()
        else
            -- Альтернативный вариант через виртуальный ввод, если экзекутор не поддерживает mouse1press
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
        end
        
        -- Небольшая задержка между выстрелами, чтобы не спамить кликами слишком быстро
        task.wait(0.1) 
    end
end)
