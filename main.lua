-- [[ ZALUPKA HUB v1.2 - PC & MOBILE HYBRID ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 1. СИСТЕМА ПАРОЛЯ
local AuthGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainAuth = Instance.new("Frame", AuthGui)
MainAuth.Size = UDim2.new(0, 300, 0, 160)
MainAuth.Position = UDim2.new(0.5, -150, 0.4, 0)
MainAuth.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", MainAuth)

local Title = Instance.new("TextLabel", MainAuth)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "ZALUPKA HUB - ENTER CODE"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1

local Box = Instance.new("TextBox", MainAuth)
Box.Size = UDim2.new(0.8, 0, 0, 35); Box.Position = UDim2.new(0.1, 0, 0.35, 0); Box.PlaceholderText = "CODE: 2012"; Box.Text = ""

local Btn = Instance.new("TextButton", MainAuth)
Btn.Size = UDim2.new(0.8, 0, 0, 40); Btn.Position = UDim2.new(0.1, 0, 0.65, 0); Btn.Text = "LOGIN"; Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); Btn.TextColor3 = Color3.new(1,1,1)

Btn.MouseButton1Click:Connect(function()
    if Box.Text == "2012" then
        AuthGui:Destroy()
        LoadMainScript()
    else
        LP:Kick("НЕВЕРНЫЙ КОД! ПИШИ РАЗРАБУ. ТВОЙ ВВОД: " .. Box.Text)
    end
end)

function LoadMainScript()
    -- Загрузка Orion Library (Стандарт для ПК/Мобилок)
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
    
    local Window = OrionLib:MakeWindow({Name = "Zalupka Hub | PC Edition", HidePremium = false, SaveConfig = true, ConfigFolder = "ZalupkaConfig", IntroText = "Zalupka Hub Loading..."})

    -- Переменные функций
    local SpeedVal = 16
    local JumpEnabled = false
    local FlyEnabled = false

    -- ВКЛАДКА: COMBAT (AIM & HITBOX)
    local Combat = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    
    Combat:AddToggle({Name = "Aimbot (Key: Q)", Default = false, Callback = function(Value) _G.Aimbot = Value end})
    Combat:AddSlider({Name = "Hitbox Size", Min = 2, Max = 20, Default = 2, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Studs", Callback = function(Value) 
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(Value, Value, Value)
                p.Character.HumanoidRootPart.Transparency = 0.7
            end
        end
    end})

    -- ВКЛАДКА: VISUALS (ESP)
    local Visuals = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    Visuals:AddToggle({Name = "ESP Boxes", Default = false, Callback = function(Value) _G.ESP = Value end})

    -- ВКЛАДКА: MOVEMENT (SPEED/FLY)
    local Movement = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    Movement:AddSlider({Name = "Speed Bypass", Min = 16, Max = 200, Default = 16, Increment = 1, Callback = function(Value) SpeedVal = Value end})
    Movement:AddToggle({Name = "Fly (CFrame)", Default = false, Callback = function(Value) FlyEnabled = Value end})
    Movement:AddToggle({Name = "Infinite Jump", Default = false, Callback = function(Value) JumpEnabled = Value end})

    -- ВКЛАДКА: GAMES (STEEL BRAIN ROT & MILITARY)
    local Games = Window:MakeTab({Name = "Game Boosters", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    
    Games:AddButton({Name = "Steel Brain Rot: Fast Steal", Callback = function() 
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
                break
            end
        end
    end})

    Games:AddButton({Name = "Military Tycoon: Farm Crystals", Callback = function() 
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name:lower():find("crystal") or obj.Name:lower():find("drop") then
                LP.Character.HumanoidRootPart.CFrame = obj.CFrame
                task.wait(0.2)
            end
        end
    end})

    -- СИСТЕМНЫЕ ЦИКЛЫ
    RS.Stepped:Connect(function()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hrp and hum then
            -- Speed Bypass
            if hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (SpeedVal / 60))
            end
            -- Fly
            if FlyEnabled then
                hrp.Velocity = Vector3.new(0, 0.1, 0)
            end
        end
    end)

    UIS.JumpRequest:Connect(function()
        if JumpEnabled then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3) end
    end)

    OrionLib:Init()
end
