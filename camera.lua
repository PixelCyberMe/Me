local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- попытка разблокировать zoom
player.CameraMaxZoomDistance = 1000
player.CameraMinZoomDistance = 0.5

-- переключение камеры в Custom (если игра не блокирует)
local function unlockCamera()
    local cam = workspace.CurrentCamera
    if cam then
        cam.CameraType = Enum.CameraType.Custom
    end
end

unlockCamera()

-- на случай если игра постоянно фиксирует камеру
player.CharacterAdded:Connect(function()
    task.wait(1)
    unlockCamera()
end)