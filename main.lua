-- [[ ZALUPKA HUB v1.1 - FULL INTEGRATION ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 1. АВТОРИЗАЦИЯ (Блокирует всё до ввода кода)
local AuthGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainAuth = Instance.new("Frame", AuthGui)
MainAuth.Size = UDim2.new(0, 300, 0, 160)
MainAuth.Position = UDim2.new(0.5, -150, 0.4, 0)
MainAuth.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainAuth.BorderSizePixel = 0
Instance.new("UICorner", MainAuth).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainAuth)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ZALUPKA HUB - Введите код"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

local Box = Instance.new("TextBox", MainAuth)
Box.Size = UDim2.new(0.8, 0, 0, 35)
Box.Position = UDim2.new(0.1, 0, 0.35, 0)
Box.PlaceholderText = "ПАРОЛЬ..."
Box.Text = ""

local btn = Instance.new("TextButton", MainAuth)
btn.Size = UDim2.new(0.8, 0, 0, 40)
btn.Position = UDim2.new(0.1, 0, 0.65, 0)
btn.Text = "LOG IN"
btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
btn.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()
    if Box.Text == "2012" then
        AuthGui:Destroy()
        LoadZalupka()
    else
        LP:Kick("НЕВЕРНЫЙ КОД! ПИШИ РАЗРАБУ. ТВОЙ ВВОД: " .. Box.Text)
    end
end)

-- 2. ОСНОВНАЯ ЗАГРУЗКА (СВЯЗКА С ТВОИМ GITHUB GUI)
function LoadZalupka()
    -- Подгружаем твой GUI файл
    local Success, MyGui = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/herh91678-alt/zalupa-hub/main/gui.lua"))()
    end)

    if not Success then
        warn("Ошибка загрузки GUI с GitHub! Проверь ссылку.")
        return
    end

    -- Настройка функций (Пример связки с твоими кнопками/тоглами)
    -- В твоем GUI должны быть переменные или функции для кликов.
    
    -- ПРИМЕР: ОБХОДЫ (CFrame / Velocity)
    local SpeedVal = 16
    local UseCFrame = true

    RS.Stepped:Connect(function()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            if UseCFrame then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (SpeedVal / 60))
            else
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * SpeedVal, hrp.Velocity.Y, hum.MoveDirection.Z * SpeedVal)
            end
        end
    end)

    -- ФУНКЦИЯ ДЛЯ STEEL BRAIN ROT (Мгновенная кража)
    local function FastSteal()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") or v.Name == "Steal" then
                local oldPos = LP.Character.HumanoidRootPart.CFrame
                LP.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                task.wait(0.1)
                -- Эмуляция нажатия E (если есть промпт)
                if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                LP.Character.HumanoidRootPart.CFrame = oldPos
                break
            end
        end
    end

    -- АВТО-КРИСТАЛЛЫ ДЛЯ MILITARY TYCOON
    local function AutoCrystals()
        while task.wait(1) do
            for _, crystal in pairs(workspace:GetChildren()) do
                if crystal.Name:lower():find("crystal") or crystal.Name:lower():find("crate") then
                    local hrp = LP.Character.HumanoidRootPart
                    local old = hrp.CFrame
                    hrp.CFrame = crystal.CFrame
                    task.wait(0.5)
                    hrp.CFrame = old
                end
            end
        end
    end

    -- Добавляем кнопку закрытия/скрытия (Minecraft Style)
    local function SetupBinds()
        UIS.InputBegan:Connect(function(key, chat)
            if not chat and key.KeyCode == Enum.KeyCode.RightShift then
                -- Тут логика скрытия твоего GUI
                -- Если в твоем gui.lua есть переменная ScreenGui, то:
                -- MyGui.Enabled = not MyGui.Enabled
            end
        end)
    end
    
    SetupBinds()
    print("--- ZALUPKA HUB LOADED ---")
end
