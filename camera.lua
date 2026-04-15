print("Camera Toggle FIX loaded!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local thirdPerson = false

-- 📷 камера (жёсткий метод)
local function setCamera()
    if thirdPerson then
        player.CameraMaxZoomDistance = 15
        player.CameraMinZoomDistance = 5
        print("3RD PERSON ON")
    else
        player.CameraMaxZoomDistance = 0.5
        player.CameraMinZoomDistance = 0.5
        print("1ST PERSON ON")
    end
end

-- 🔁 переключение
local function toggle()
    thirdPerson = not thirdPerson
    setCamera()
end

-- ⌨️ клавиши
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- ❗ Alt может не работать
    if input.KeyCode == Enum.KeyCode.LeftAlt 
    or input.KeyCode == Enum.KeyCode.V then -- 👈 запасная кнопка
        toggle()
    end
end)

-- 🔄 после смерти
player.CharacterAdded:Connect(function()
    task.wait(1)
    setCamera()
end)

-- 🚀 старт
task.wait(1)
setCamera()
print("Press ALT or V")