print("Item ESP loaded!")

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local enabled = true
local highlights = {}

-- 🔍 ключевые слова (можешь менять)
local keywords = {
    "ore","stone","rock","gold","iron","diamond","coal"
}

local function isOre(name)
    name = string.lower(name)
    for _, word in pairs(keywords) do
        if string.find(name, word) then
            return true
        end
    end
    return false
end

local function createESP(obj)
    if highlights[obj] then return end

    local h = Instance.new("Highlight")
    h.FillTransparency = 1
    h.OutlineTransparency = 0
    h.OutlineColor = Color3.fromRGB(0, 255, 255) -- 💎 голубой
    h.Parent = obj

    highlights[obj] = h
end

local function removeESP(obj)
    if highlights[obj] then
        highlights[obj]:Destroy()
        highlights[obj] = nil
    end
end

-- 🔄 скан карты
RunService.RenderStepped:Connect(function()
    if not enabled then return end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if isOre(obj.Name) then
                createESP(obj)
            end
        end
    end
end)

print("Item ESP enabled")