local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("InterimStorage") or game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local LibFolder = ReplicatedStorage:FindFirstChild("Lib")
if not LibFolder then
    print("[Error] Этот скрипт работает только в определенной хоррор-игре!")
    return

local Library = require(LibFolder)

local function keepSanityFull()
    if LocalPlayer then
        LocalPlayer:SetAttribute("Sanity", 100)
    end
end

Library.Inject("PlayerLostSanity", keepSanityFull)
LocalPlayer:GetAttributeChangedSignal("Sanity"):Connect(keepSanityFull)
RunService.Heartbeat:Connect(keepSanityFull)

keepSanityFull()
print("[Success] Читы на рассудок успешно активированы!")
