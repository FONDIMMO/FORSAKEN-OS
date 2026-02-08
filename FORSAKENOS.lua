--[[
    FORSAKEN DARK ADMIN v10.0
    КЛАВИШИ:
    [L] - Скрыть меню
    [E] - Полет
    [K] - Быстрое ВХ
]]

pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local tw = game:GetService("TweenService")
    local cg = game:GetService("CoreGui")

    if cg:FindFirstChild("ForsakenDark") then cg.ForsakenDark:Destroy() end
    local sg = Instance.new("ScreenGui", cg); sg.Name = "ForsakenDark"

    -- ГЛАВНОЕ ОКНО
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 400, 0, 450)
    main.Position = UDim2.new(0.5, -200, 0.5, -225)
    main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 3

    -- ШАПКА
    local header = Instance.new("TextLabel", main)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.Text = "FORSAKEN DARK OPS"
    header.TextColor3 = Color3.new(1, 1, 1)
    header.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 20
    Instance.new("UICorner", header)

    local container = Instance.new("ScrollingFrame", main)
    container.Size = UDim2.new(1, -20, 1, -70)
    container.Position = UDim2.new(0, 10, 0, 60)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 0
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

    -- [ ФУНКЦИЯ КНОПКИ ]
    local function addBtn(name, desc, cb)
        local b = Instance.new("TextButton", container)
        b.Size = UDim2.new(1, 0, 0, 50)
        b.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        b.Text = ""
        Instance.new("UICorner", b)
        local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(150, 0, 0)
        
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1, 0, 0, 25); t.Position = UDim2.new(0, 15, 0, 5)
        t.Text = name; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.GothamBold; t.TextXAlignment = 0; t.BackgroundTransparency = 1
        
        local d = Instance.new("TextLabel", b)
        d.Size = UDim2.new(1, 0, 0, 20); d.Position = UDim2.new(0, 15, 0, 25)
        d.Text = desc; d.TextColor3 = Color3.new(0.6,0,0); d.Font = Enum.Font.Gotham; d.TextSize = 10; d.TextXAlignment = 0; d.BackgroundTransparency = 1

        b.MouseButton1Click:Connect(cb)
    end

    -- [ 1. ВХ НА МАНЬЯКА (КРАСНЫЙ) ]
    addBtn("MANIAC ESP", "Подсветить маньяка (Красный)", function()
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local isKiller = pl.Character:FindFirstChildOfClass("Tool") or pl.Backpack:FindFirstChildOfClass("Tool")
                if isKiller then
                    local h = Instance.new("Highlight", pl.Character)
                    h.FillColor = Color3.new(1, 0, 0)
                    h.OutlineColor = Color3.new(1, 1, 1)
                    h.FillTransparency = 0.3
                    
                    local b = Instance.new("BillboardGui", pl.Character.Head)
                    b.AlwaysOnTop = true; b.Size = UDim2.new(0,100,0,50); b.ExtentsOffset = Vector3.new(0,3,0)
                    local l = Instance.new("TextLabel", b)
                    l.Size = UDim2.new(1,0,1,0); l.Text = "КРАСНЫЙ / МАНЬЯК"; l.TextColor3 = Color3.new(1,0,0); l.BackgroundTransparency = 1; l.Font = Enum.Font.GothamBold
                end
            end
        end
    end)

    -- [ 2. ОТКИДЫВАНИЕ ИГРОКОВ (PUSH) ]
    local pushing = false
    addBtn("PUSH PLAYERS", "Откидывать всех в радиусе 20м", function()
        pushing = not pushing
        if pushing then
            task.spawn(function()
                while pushing do
                    for _, pl in pairs(p:GetPlayers()) do
                        if pl ~= lp and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = pl.Character.HumanoidRootPart
                            local dist = (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if dist < 20 then
                                -- Мощный импульс + вращение
                                hrp.Velocity = (hrp.Position - lp.Character.HumanoidRootPart.Position).Unit * 600 + Vector3.new(0, 300, 0)
                                hrp.RotVelocity = Vector3.new(0, 1000, 0)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)

    -- [ 3. ПОЛЕТ (FLY) ]
    local flying = false
    addBtn("FLY MODE (E)", "Полет на клавишу E", function()
        flying = not flying
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        if flying then
            local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e8,1e8,1e8); bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e8,1e8,1e8); bg.P = 9e4
            task.spawn(function()
                while flying do
                    rs.RenderStepped:Wait()
                    local cam = workspace.CurrentCamera.CFrame
                    local dir = Vector3.zero
                    if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                    bv.Velocity = dir * 100
                    bg.CFrame = cam
                end
                bv:Destroy(); bg:Destroy()
            end)
        end
    end)

    -- [ 4. SPEED HACK ]
    addBtn("SPEED HACK", "Ускорение персонажа", function()
        lp.Character.Humanoid.WalkSpeed = 100
    end)

    -- [ 5. TP TO ITEMS ]
    addBtn("TP TO ITEMS", "Телепорт к предметам на карте", function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                lp.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                break
            end
        end
    end)

    -- УПРАВЛЕНИЕ СКРЫТИЕМ
    uis.InputBegan:Connect(function(k, m)
        if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
    end)

    print("DARK OPS v10.0 LOADED")
end)
