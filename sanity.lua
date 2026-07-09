local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if LocalPlayer then
    print("[Sanity-Hack]: Цель найдена! Замораживаем рассудок.")
    
    -- Жесткий цикл на каждый кадр игры
    RunService.Heartbeat:Connect(function()
        -- Ставим ровно 100% рассудка
        LocalPlayer:SetAttribute("Sanity", 100)
    end)
    
    -- Дополнительно проверяем принудительное изменение через событие
    LocalPlayer:GetAttributeChangedSignal("Sanity"):Connect(function()
        if LocalPlayer:GetAttribute("Sanity") < 100 then
            LocalPlayer:SetAttribute("Sanity", 100)
        end
    end)
end
