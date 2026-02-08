--[[
    FORSAKEN OS // MOD: MANIAC HUNTER & PUSH
    - Killer ESP: Подсвечивает маньяка ярко-красным сквозь стены.
    - Fling/Push: Откидывает игроков от тебя на огромной скорости.
]]

pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")

    -- 1. ФУНКЦИЯ ВХ НА МАНЬЯКА (KILLER ESP)
    -- В Forsaken маньяка обычно можно вычислить по наличию оружия или по роли.
    local function applyKillerESP()
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                -- Проверка: если у игрока в руках нож/оружие или специфический тег
                local isKiller = pl.Character:FindFirstChildOfClass("Tool") or pl.Backpack:FindFirstChildOfClass("Tool")
                
                if isKiller then
                    -- Если маньяк найден, вешаем жирный красный Highlight
                    local h = pl.Character:FindFirstChild("KillerHighlight") or Instance.new("Highlight", pl.Character)
                    h.Name = "KillerHighlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0) -- Ярко-красный
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.2
                    h.OutlineTransparency = 0

                    -- Надпись над головой
                    if not pl.Character.Head:FindFirstChild("KillerTag") then
                        local b = Instance.new("BillboardGui", pl.Character.Head)
                        b.Name = "KillerTag"
                        b.AlwaysOnTop = true
                        b.Size = UDim2.new(0, 100, 0, 50)
                        b.ExtentsOffset = Vector3.new(0, 3, 0)
                        local l = Instance.new("TextLabel", b)
                        l.Size = UDim2.new(1, 0, 1, 0)
                        l.Text = "МАНЬЯК / KILLER"
                        l.TextColor3 = Color3.new(1, 0, 0)
                        l.Font = Enum.Font.GothamBold
                        l.TextSize = 14
                        l.BackgroundTransparency = 1
                    end
                end
            end
        end
    end

    -- 2. ФУНКЦИЯ ОТКИДЫВАНИЯ (PUSH PLAYERS)
    _G.PushActive = false
    local function pushPlayers()
        _G.PushActive = not _G.PushActive
        if _G.PushActive then
            print("Силовое поле активировано!")
            task.spawn(function()
                while _G.PushActive do
                    for _, pl in pairs(p:GetPlayers()) do
                        if pl ~= lp and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (lp.Character.HumanoidRootPart.Position - pl.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 15 then -- Радиус действия 15 метров
                                -- Создаем мощный импульс
                                local direction = (pl.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Unit
                                pl.Character.HumanoidRootPart.Velocity = direction * 500 + Vector3.new(0, 100, 0)
                                -- В некоторых играх нужно "вращать" игрока для обхода защиты
                                pl.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 500, 0)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            print("Силовое поле выключено.")
        end
    end

    -- Добавляем кнопки в твое меню (если ты используешь прошлый скрипт)
    -- Если запускаешь отдельно, можно привязать к клавишам:
    
    uis.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        
        -- Клавиша K для обновления ВХ на маньяка
        if input.KeyCode == Enum.KeyCode.K then
            applyKillerESP()
        end
        
        -- Клавиша P для включения/выключения откидывания
        if input.KeyCode == Enum.KeyCode.P then
            pushPlayers()
        end
    end)

    print("--- МОДУЛЬ МАНЬЯКА И ОТКИДЫВАНИЯ ЗАГРУЖЕН ---")
    print("Нажми [K] чтобы подсветить маньяка")
    print("Нажми [P] чтобы включить Силовое Поле (Push)")
end)
