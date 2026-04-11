print("GitHub script loaded!")

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Sky Hub 🌌",
   LoadingTitle = "Sky",
   LoadingSubtitle = "By Gagaga",
   ConfigurationSaving = {
      Enabled = false
   }
})

local Tab = Window:CreateTab("Sky", 4483362458)

-- 🌙 Ночь / День
Tab:CreateToggle({
   Name = "Night Mode",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game.Lighting.ClockTime = 0
      else
         game.Lighting.ClockTime = 14
      end
   end
})

-- 🔆 Яркость
Tab:CreateToggle({
   Name = "Bright Screen",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game.Lighting.Brightness = 5
         game.Lighting.ExposureCompensation = 1
      else
         game.Lighting.Brightness = 2
         game.Lighting.ExposureCompensation = 0
      end
   end
})

-- 🌫️ Туман
Tab:CreateToggle({
   Name = "Soft Fog",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game.Lighting.FogStart = 50
         game.Lighting.FogEnd = 300
         game.Lighting.FogColor = Color3.fromRGB(200, 200, 200)
      else
         game.Lighting.FogStart = 0
         game.Lighting.FogEnd = 100000
      end
   end
})

-- 🌈 Радуга
local rainbow = false
Tab:CreateToggle({
   Name = "Rainbow Sky",
   CurrentValue = false,
   Callback = function(Value)
      rainbow = Value
      if Value then
         task.spawn(function()
            while rainbow do
               game.Lighting.Ambient = Color3.fromHSV(tick()%5/5,1,1)
               task.wait(0.1)
            end
         end)
      else
         game.Lighting.Ambient = Color3.fromRGB(128,128,128)
      end
   end
})

-- 💥 Хаос
local chaos = false
Tab:CreateToggle({
   Name = "Chaos Mode",
   CurrentValue = false,
   Callback = function(Value)
      chaos = Value
      if Value then
         task.spawn(function()
            while chaos do
               game.Lighting.Brightness = math.random(1,10)
               game.Lighting.ClockTime = math.random(0,24)
               game.Lighting.Ambient = Color3.new(math.random(), math.random(), math.random())
               task.wait(0.5)
            end
         end)
      else
         game.Lighting.Brightness = 2
         game.Lighting.ClockTime = 14
         game.Lighting.Ambient = Color3.fromRGB(128,128,128)
      end
   end
})