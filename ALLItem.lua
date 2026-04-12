print("Pickup ESP (ProximityPrompt FIX) loaded!")

local Workspace = game:GetService("Workspace")

local highlights = {}

local function createESP(model, part)
    if highlights[model] then return end

    -- 🟡 подсветка
    local h = Instance.new("Highlight")
    h.FillTransparency = 1
    h.OutlineTransparency = 0
    h.OutlineColor = Color3.fromRGB(255,255,0)
    h.Parent = model

    -- 🏷 название
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,100,0,20)
    bill.StudsOffset = Vector3.new(0,2,0)
    bill.AlwaysOnTop = true
    bill.Adornee = part
    bill.Parent = part

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = model.Name
    text.TextColor3 = Color3.fromRGB(255,255,0)
    text.TextStrokeTransparency = 0.3
    text.TextSize = 10
    text.Parent = bill

    highlights[model] = h
end

local function findMainPart(obj)
    if obj:IsA("Model") then
        return obj:FindFirstChildWhichIsA("BasePart")
    elseif obj:IsA("BasePart") then
        return obj
    end
end

local function handlePrompt(prompt)
    local parent = prompt.Parent
    if not parent then return end

    local model = parent:FindFirstAncestorOfClass("Model") or parent
    local part = findMainPart(model)

    if part then
        createESP(model, part)
    end
end

-- 🔍 ищем ВСЕ prompt
for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        handlePrompt(obj)
    end
end

-- 🆕 новые
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        task.wait(0.1)
        handlePrompt(obj)
    end
end)

print("Pickup ESP working!")