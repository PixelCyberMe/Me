-- Ждем полной загрузки игры
while not game:IsLoaded() do
	task.wait(1)
end

local Services = setmetatable({}, {
	__index = function(self, Key)
		return game:GetService(Key)
	end
})

local LocalPlayer = Services.Players.LocalPlayer
local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
local CurrentRooms = Services.Workspace:FindFirstChild("CurrentRooms")
local GameData = Services.ReplicatedStorage:FindFirstChild("GameData")

local function SendCaption(Text)
	if firesignal and RemotesFolder and RemotesFolder:FindFirstChild("Caption") then
		firesignal(RemotesFolder.Caption.OnClientEvent, "[Fast Knob Farm] " .. Text)
	elseif RemotesFolder and RemotesFolder:FindFirstChild("CaptionClient") then
		RemotesFolder.CaptionClient:Fire("[Fast Knob Farm] " .. Text)
	end
end

-- 1. ТЕСТ НА ЛОББИ: Если мы в главном меню, автоматически создаем приватный лифт
if game.PlaceId == 6516141723 then
	SendCaption("Starting fast run...")
	if RemotesFolder and RemotesFolder:FindFirstChild("CreateElevator") then
		RemotesFolder.CreateElevator:FireServer({
			Mods = {},
			Settings = {},
			Destination = "Hotel",
			FriendsOnly = false,
			MaxPlayers = "1"
		})
	end
	return
end

-- 2. ТЕСТ НА ЭТАЖ: Возвращаемся в отель, если занесло не туда
if GameData and GameData:FindFirstChild("Floor") and GameData.Floor.Value ~= "Hotel" then
	SendCaption("Returning to Hotel...")
	if RemotesFolder and RemotesFolder:FindFirstChild("Lobby") then
		RemotesFolder.Lobby:FireServer()
	end
	return
end

if game.PlaceId ~= 6839171747 then
	return
end

-- 3. Ждем прогрузку самого матча
while #CurrentRooms:GetChildren() < 1 or not LocalPlayer.Character do
	task.wait(1)
end

local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI", 9e9)

-- Пропускаем магазин, если он вылез
if MainUI:FindFirstChild("ItemShop") then
	MainUI.ItemShop.Visible = false
	if RemotesFolder and RemotesFolder:FindFirstChild("PreRunShop") then
		RemotesFolder.PreRunShop:FireServer({}, true)
	end
end

task.wait(1)
if Services.Workspace:FindFirstChild("SkipPrompt", true) then
	fireproximityprompt(Services.Workspace:FindFirstChild("SkipPrompt", true))
end
if Services.Workspace:FindFirstChild("Luggage_Cart_Crouch", true) then
	Services.Workspace:FindFirstChild("Luggage_Cart_Crouch", true):Destroy()
end

local function WalkPosition(TargetPosition)
	local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid", 9e9)
	local Finished = false
	local Connection = Services.RunService.RenderStepped:Connect(function()
		Humanoid:MoveTo(TargetPosition)
		if LocalPlayer:DistanceFromCharacter(TargetPosition) < 6 then
			Finished = true
		end
	end)
	while task.wait() do
		if Finished then
			Connection:Disconnect()
			break
		end
	end
	task.wait()
	return true
end

task.wait(1)

-- Убираем коллизии в комнате 0 для быстрого прохода
if CurrentRooms:FindFirstChild("0") and CurrentRooms["0"]:FindFirstChild("Assets") then
	for Index, Object in pairs(CurrentRooms["0"].Assets:GetChildren()) do
		if Object.Name == "Potted_Plant" then
			Object.Collision.CanCollide = false
		end
	end
end

-- Быстро берем ключ и открываем дверь
SendCaption("Getting the key...")
local Door = CurrentRooms["0"]:FindFirstChild("Door")
if Door and Door:FindFirstChild("Lock") then
	Door.Lock.CanCollide = false
	WalkPosition(Door.Lock.Position)
end

local Key = CurrentRooms["0"]:FindFirstChild("KeyObtain", true)
if Key and Key:FindFirstChild("Hitbox") then
	WalkPosition(Key.Hitbox.Position)
	fireproximityprompt(Key:FindFirstChild("ModulePrompt", true))
end

SendCaption("Opening the door...")
if Door and Door:FindFirstChild("Lock") then
	WalkPosition(Door.Lock.Position)
	fireproximityprompt(Door:FindFirstChild("UnlockPrompt", true))
end

-- Ждем комнату 2
while not CurrentRooms:FindFirstChild("2") do
	task.wait()
end

SendCaption("Claiming reward and restarting...")
if RemotesFolder and RemotesFolder:FindFirstChild("Statistics") then
	pcall(function()
		RemotesFolder.Statistics:FireServer()
	end)
end

task.wait(0.25)

-- Моментальная смерть
if replicatesignal then
	replicatesignal(LocalPlayer.Kill)
else
	LocalPlayer.Character.Humanoid.Health = 0
end

LocalPlayer:GetAttributeChangedSignal("Alive"):Wait()

-- Перезапуск матча (игра сама перенесет в лобби/меню, где скрипт снова сработает через Autoexecute)
if RemotesFolder and RemotesFolder:FindFirstChild("PlayAgain") then
	RemotesFolder.PlayAgain:FireServer()
end