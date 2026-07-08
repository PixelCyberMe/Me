local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Функция защиты от АФК
local function preventKick()
    if LocalPlayer then
        -- Симулируем нажатие кнопки мыши на экране (невидимо для других)
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
        
        -- Заставляем персонажа слегка подпрыгнуть
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid.Jump = true
            end
        end
        
        print("[Anti-AFK]: Активность симулирована, таймер сброшен!")
    end
end

-- Подключаем защиту к событию Idled (когда уходишь в АФК)
LocalPlayer.Idled:Connect(function()
    preventKick()
end)

-- Жесткая проверка каждые 5 минут (300 секунд)
task.spawn(function()
    while task.wait(300) do
        preventKick()
    end
end)

print("[Anti-AFK]: Скрипт успешно запущен. Персонаж будет прыгать каждые 5 минут!")
