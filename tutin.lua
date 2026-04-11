local Window = Rayfield:CreateWindow({
   Name = "Sky Madness 🌌",
   LoadingTitle = "Loading Sky...",
   LoadingSubtitle = "by you",
   ConfigurationSaving = {
      Enabled = false
   }
})

local Tab = Window:CreateTab("Sky", 4483362458)

-- 🌙 Ночь / ☀️ День
Tab:CreateToggle({
   Name = "Ночь",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game.Lighting.ClockTime = 0
      else
         game.Lighting.ClockTime = 14
      end
   end
})

-- 🔆 Яркость экрана
Tab:CreateToggle({
   Name = "Яркий экран",
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

-- 🌫️ Мягкий туман
Tab:CreateToggle({
   Name = "Туман",
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
_G.RainbowSky = false
Tab:CreateToggle({
   Name = "Радужное небо",
   CurrentValue = false,
   Callback = function(Value)
      _G.RainbowSky = Value
      if Value then
         task.spawn(function()
            while _G.RainbowSky do
               game.Lighting.Ambient = Color3.fromHSV(tick()%5/5,1,1)
               task.wait(0.1)
            end
         end)
      else
         game.Lighting.Ambient = Color3.fromRGB(128,128,128)
      end
   end
})

-- 💥 Хаос режим
_G.Chaos = false
Tab:CreateToggle({
   Name = "Хаос режим",
   CurrentValue = false,
   Callback = function(Value)
      _G.Chaos = Value
      if Value then
         task.spawn(function()
            while _G.Chaos do
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
