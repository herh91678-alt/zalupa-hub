-- [[ ZALUPKA HUB v1.0 - MULTI-GAME EXPLOIT ]] --
-- Совместимость: KRNL, Fluxus, Delta, Hydrogen, Codex

local L_Players = game:GetService("Players")
local L_LP = L_Players.LocalPlayer
local L_RS = game:GetService("RunService")
local L_UIS = game:GetService("UserInputService")
local L_Http = game:GetService("HttpService")

-- Проверка пароля
local CorrectPass = "2012"
local function CheckAuth()
    -- В реальном гитхабе тут была бы подгрузка, но делаем встроенную логику
    print("Zalupka Hub: Ожидание ввода кода...")
end

-- Глобальные переменные
getgenv().Zalupka_Config = {
    Aimbot = false,
    ESP = false,
    Fly = false,
    Speed = 16,
    Jump = false,
    Hitbox = 2,
    BypassMethod = "CFrame", -- CFrame, Velocity, Impulse, Pulse
    Theme = "Rainbow"
}

-- 1. СИСТЕМА АВТОРИЗАЦИИ (UI)
local AuthGui = Instance.new("ScreenGui", L_LP.PlayerGui)
local AuthFrame = Instance.new("Frame", AuthGui)
AuthFrame.Size = UDim2.new(0, 300, 0, 150)
AuthFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
AuthFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local AuthInput = Instance.new("TextBox", AuthFrame)
AuthInput.Size = UDim2.new(0.8, 0, 0, 40)
AuthInput.Position = UDim2.new(0.1, 0, 0.2, 0)
AuthInput.PlaceholderText = "Введите код..."
AuthInput.Text = ""

local AuthBtn = Instance.new("TextButton", AuthFrame)
AuthBtn.Size = UDim2.new(0.8, 0, 0, 40)
AuthBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
AuthBtn.Text = "Войти"
AuthBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

AuthBtn.MouseButton1Click:Connect(function()
    if AuthInput.Text == CorrectPass then
        AuthGui:Destroy()
        StartZalupkaHub()
    else
        L_LP:Kick("Код не правильный! Обратитесь к разработчику. Код: " .. AuthInput.Text)
    end
end)

function StartZalupkaHub()
    -- 2. ГЛАВНОЕ МЕНЮ (Стиль Minecraft ClickGUI)
    local Library = {Toggle = true} -- Заглушка под твой gui.txt
    local MainGui = Instance.new("ScreenGui", L_LP.PlayerGui)
    MainGui.Name = "ZalupkaHub_Main"
    
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Кнопка для мобилок
    local MobileBtn = Instance.new("TextButton", MainGui)
    MobileBtn.Size = UDim2.new(0, 50, 0, 50)
    MobileBtn.Position = UDim2.new(0, 10, 0.5, 0)
    MobileBtn.Text = "ZH"
    MobileBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    MobileBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -- 3. ФУНКЦИИ ОБХОДА И ПЕРЕМЕЩЕНИЯ
    L_RS.Stepped:Connect(function()
        local char = L_LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hrp and hum then
            -- Speed Bypass (CFrame / Velocity)
            if hum.MoveDirection.Magnitude > 0 then
                if getgenv().Zalupka_Config.BypassMethod == "CFrame" then
                    hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (getgenv().Zalupka_Config.Speed / 50))
                elseif getgenv().Zalupka_Config.BypassMethod == "Velocity" then
                    hrp.Velocity = Vector3.new(hum.MoveDirection.X * getgenv().Zalupka_Config.Speed, hrp.Velocity.Y, hum.MoveDirection.Z * getgenv().Zalupka_Config.Speed)
                end
            end

            -- Fly Logic
            if getgenv().Zalupka_Config.Fly then
                hrp.Velocity = Vector3.new(0, 0, 0) -- Обнуляем гравитацию
                if L_UIS:IsKeyDown(Enum.KeyCode.Space) then hrp.CFrame = hrp.CFrame * CFrame.new(0, 1, 0) end
                if L_UIS:IsKeyDown(Enum.KeyCode.LeftControl) then hrp.CFrame = hrp.CFrame * CFrame.new(0, -1, 0) end
                hrp.CFrame = hrp.CFrame * CFrame.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)
            end
            
            -- Infinity Jump
            if getgenv().Zalupka_Config.Jump and L_UIS:IsKeyDown(Enum.KeyCode.Space) then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- 4. STEEL BRAIN ROT & MILITARY TYCOON BOOSTERS
    local function AutoFarmSteel()
        -- Пример маментального воровства (зависит от пути в игре)
        -- Допустим, предмет лежит в workspace.Drops
        for _, item in pairs(workspace:GetDescendants()) do
            if item.Name == "StealTarget" or item:FindFirstChild("TouchTransmitter") then
                local oldPos = L_LP.Character.HumanoidRootPart.CFrame
                L_LP.Character.HumanoidRootPart.CFrame = item.CFrame
                task.wait(0.1)
                L_LP.Character.HumanoidRootPart.CFrame = oldPos
                break
            end
        end
    end

    local function CrystalFarm()
        -- Поиск кристаллов/эйрдропов
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name:lower():find("crystal") or obj.Name:lower():find("airdrop") then
                local hrp = L_LP.Character.HumanoidRootPart
                local old = hrp.CFrame
                hrp.CFrame = obj.CFrame
                task.wait(0.5)
                hrp.CFrame = old
            end
        end
    end

    -- 5. ESP & ARROWS
    local function CreateESP()
        for _, p in pairs(L_Players:GetPlayers()) do
            if p ~= L_LP and p.Character and p.Character:FindFirstChild("Head") then
                -- Рисование стрелочек и дистанции (концепт)
                local head = p.Character.Head
                local dist = (L_LP.Character.HumanoidRootPart.Position - head.Position).Magnitude
                -- Здесь логика отрисовки Drawing API...
            end
        end
    end

    -- Интеграция Rainbow темы
    task.spawn(function()
        while task.wait() do
            if getgenv().Zalupka_Config.Theme == "Rainbow" then
                MainFrame.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            end
        end
    end)
    
    print("Zalupka Hub успешно загружен!")
end

-- Бинд на кнопку (ПК)
L_UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        local main = L_LP.PlayerGui:FindFirstChild("ZalupkaHub_Main")
        if main then main.Enabled = not main.Enabled end
    end
end)
