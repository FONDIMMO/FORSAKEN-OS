--[[
    FORSAKEN BYPASS v11.0 (DARK NEON)
    ФУНКЦИИ:
    - Killer ESP (Highlight Bypass)
    - Velocity Push (Откидывание через Netless)
    - Fly (CFrame Mode)
    
    Клавиши: [L] - Меню, [E] - Полет
]]

pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local cg = game:GetService("CoreGui")

    if cg:FindFirstChild("BypassPanel") then cg.BypassPanel:Destroy() end
    local sg = Instance.new("ScreenGui", cg) sg.Name = "BypassPanel"

    -- КРАСИВОЕ МЕНЮ
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 350, 0, 400)
    main.Position = UDim2.new(0.5, -175, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    main.Active = true main.Draggable = true
    Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1, 0, 0) stroke.Thickness = 2

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "FORSAKEN BYPASS V11"
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    Instance.new("UICorner", title)

    local container = Instance.new("ScrollingFrame", main)
    container.Size = UDim2.new(1, -20, 1, -60)
    container.Position = UDim2.new(0, 10, 0, 50)
    container.BackgroundTransparency = 1
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

    local function btn(txt, cb)
        local b = Instance.new("TextButton", container)
        b.Size = UDim2.new(1, 0, 0, 45)
        b.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
        b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.Code; b.TextSize = 14
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(cb)
    end

    -- 1. МОЩНЫЙ ВХ (ЧЕРЕЗ КОРНЕВОЙ ВЫЗОВ)
    btn("ENABLE KILLER ESP", function()
        for _, v in pairs(p:GetPlayers()) do
            if v ~= lp and v.Character then
                local h = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
                -- В Forsaken маньяк обычно подсвечивается, если у него есть Tool в руках
                if v.Character:FindFirstChildOfClass("Tool") or v.Backpack:FindFirstChildOfClass("Tool") then
                    h.FillColor = Color3.new(1, 0, 0)
                    h.FillTransparency = 0.2
                else
                    h.FillColor = Color3.new(1, 1, 1)
                    h.FillTransparency = 0.8
                end
            end
        end
    end)

    -- 2. СУПЕР ОТКИДЫВАНИЕ (BYPASS PUSH)
    local pushing = false
    btn("ACTIVATE FORCE-FIELD (PUSH)", function()
        pushing = not pushing
        if pushing then
            task.spawn(function()
                while pushing do
                    for _, target in pairs(p:GetPlayers()) do
                        if target ~= lp and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = target.Character.HumanoidRootPart
                            local dist = (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if dist < 15 then
                                -- Принудительное изменение Velocity через симуляцию касания
                                hrp.Velocity = Vector3.new(1000, 1000, 1000)
                                hrp.RotVelocity = Vector3.new(1000, 1000, 1000)
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end)

    -- 3. FLY (BYPASS)
    local flying = false
    btn("TOGGLE FLY (E)", function()
        flying = not flying
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        if flying then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
            bv.Velocity = Vector3.new(0,0,0)
            task.spawn(function()
                while flying do
                    rs.Heartbeat:Wait()
                    local cam = workspace.CurrentCamera.CFrame
                    local dir = Vector3.new(0,0,0)
                    if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                    bv.Velocity = dir * 100
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
                end
                bv:Destroy()
            end)
        end
    end)

    -- 4. SPEED (METHOD 2)
    btn("SUPER SPEED", function()
        lp.Character.Humanoid.WalkSpeed = 150
    end)

    -- КЛАВИШИ
    uis.InputBegan:Connect(function(k, m)
        if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
    end)

    print("BYPASS v11 LOADED")
end)
