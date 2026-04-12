print("Script Loaded")

local Workspace = game:GetService("Workspace")

local highlights = {}

local function createESP(obj)
    if highlights[obj] then return end

    local h = Instance.new("Highlight")
    h.FillTransparency = 1
    h.OutlineTransparency = 0
    h.OutlineColor = Color3.fromRGB(255,255,255)
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

    if obj:IsA("Tool") then
        createESP(obj)
    end

    if obj:IsA("ClickDetector") then
        local parent = obj.Parent
        if parent then
            createESP(parent)
        end
    end
end

for _, v in pairs(Workspace:GetDescendants()) do
    handle(v)
end

Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.1)
    handle(v)
end)

print("Finding")