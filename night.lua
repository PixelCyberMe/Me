print("FullBright loaded!")

local Lighting = game:GetService("Lighting")

-- 💡 запоминаем старые значения (если захочешь вернуть)
local old = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}

-- 🌞 делаем ярко
Lighting.Brightness = 3
Lighting.ClockTime = 14 -- день
Lighting.FogEnd = 100000
Lighting.GlobalShadows = false

-- убираем эффекты
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect") or
       v:IsA("BlurEffect") or
       v:IsA("ColorCorrectionEffect") or
       v:IsA("SunRaysEffect") then
        v.Enabled = false
    end
end

print("FullBright enabled!")