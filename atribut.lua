-- Скрипт-сканер атрибутов игрока от KtoKot
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if LocalPlayer then
    local attributes = LocalPlayer:GetAttributes()
    
    print("========================================")
    print("   [СКАНИРОВАНИЕ АТРИБУТОВ ИГРОКА]      ")
    print("========================================")
    
    local count = 0
    for name, value in pairs(attributes) do
        count = count + 1
        print(string.format("[%d] Название: %s | Значение: %s | Тип: %s", count, name, tostring(value), typeof(value)))
    end
    
    if count == 0 then
        print("У твоего игрока сейчас нет активных атрибутов.")
    end
    print("========================================")
else
    warn("Ошибка: Не удалось найти LocalPlayer")
end
