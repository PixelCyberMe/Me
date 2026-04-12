print("ALL ITEM ESP (WHITE) LOADED!")

local Workspace = game:GetService("Workspace")

local highlights = {}

local function createESP(obj)
    if highlights[obj] then return end

    local h = Instance.new("Highlight")
    h.FillTransparency = 1
    h.OutlineTransparency = 0
    h.OutlineColor = Color3.fromRGB(255,255,255) -- ⚪ белая обводка
    h.Parent = obj

    highlights[obj] = true
end

local function handle(obj)
    -- 🧲 ProximityPrompt
    if obj:IsA("ProximityPrompt") then
        local model = obj:FindFirstAncestorOfClass("Model") or obj.Parent
        if model then
            createESP(model)
        end
    end

    -- 🛠 Tool
    if obj:IsA("Tool") then
        createESP(obj)
    end

    -- 📦 ClickDetector
    if obj:IsA("ClickDetector") then
        local parent = obj.Parent
        if parent then
            createESP(parent)
        end
    end
end

-- 🔍 начальный скан
for _, v in pairs(Workspace:GetDescendants()) do
    handle(v)
end

-- 🆕 новые предметы
Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.1)
    handle(v)
end)

print("ALL ITEM ESP ENABLED (WHITE)")