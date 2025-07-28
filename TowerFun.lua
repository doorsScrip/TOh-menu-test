local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui); gui.Name = "TOHMenu"
local toggleBtn = Instance.new("TextButton", gui); toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,20,0.5,-25); toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggleBtn.Text = "≡"; toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Draggable = true; toggleBtn.Active = true

local main = Instance.new("Frame", gui); main.Size = UDim2.new(0,200,0,260)
main.Position = UDim2.new(0,80,0.5,-130); main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Visible = false; main.Draggable = true; main.Active = true
local layout = Instance.new("UIListLayout", main); layout.Padding = UDim.new(0,5)

-- Auto Win
local autoWinBtn = Instance.new("TextButton", main); autoWinBtn.Size = UDim2.new(1,-10,0,40)
autoWinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60); autoWinBtn.TextColor3 = Color3.new(1,1,1)
autoWinBtn.Text = "🏁 Auto Win"
autoWinBtn.MouseButton1Click:Connect(function()
    spawn(function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local finish
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("finish") or obj.Name:lower():find("win")) then
                finish = obj
                break
            end
        end
        if finish then
            hrp.CFrame = finish.CFrame + Vector3.new(0,3,0)
        else
            warn("Topo da torre não encontrado.")
        end
    end)
end)

-- God Mode robusto
local godBtn = Instance.new("TextButton", main); godBtn.Size = UDim2.new(1,-10,0,40)
godBtn.BackgroundColor3 = Color3.fromRGB(60,60,60); godBtn.TextColor3 = Color3.new(1,1,1)
godBtn.Text = "🛡️ God Mode"
local godMode = false
local healthConn
godBtn.MouseButton1Click:Connect(function()
    godMode = not godMode
    if godMode then
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            healthConn = humanoid.HealthChanged:Connect(function()
                if godMode and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
            for _, p in ipairs(workspace:GetDescendants()) do
                if p:IsA("BasePart") and p.Name:lower():find("kill") then
                    p.CanTouch = false
                    local tt = p:FindFirstChildWhichIsA("TouchTransmitter", true)
                    if tt then tt:Destroy() end
                end
            end
        end
        godBtn.Text = "🛡️ God Mode [ON]"
    else
        if healthConn then healthConn:Disconnect() healthConn = nil end
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Name:lower():find("kill") then
                p.CanTouch = true
            end
        end
        godBtn.Text = "🛡️ God Mode [OFF]"
    end
end)

-- Speed Hack
local speedBtn = Instance.new("TextButton", main); speedBtn.Size = UDim2.new(1,-10,0,40)
speedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60); speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Text = "💨 Speed Hack [OFF]"
local speedOn = false
local speedConn
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if speedOn then
        speedConn = game:GetService("RunService").RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 100
            end
        end)
        speedBtn.Text = "💨 Speed Hack [ON]"
    else
        if speedConn then speedConn:Disconnect() speedConn = nil end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        speedBtn.Text = "💨 Speed Hack [OFF]"
    end
end)

-- Jump Boost
local jumpBtn = Instance.new("TextButton", main); jumpBtn.Size = UDim2.new(1,-10,0,40)
jumpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60); jumpBtn.TextColor3 = Color3.new(1,1,1)
jumpBtn.Text = "🦘 Jump Boost [OFF]"
local jumpOn = false
local jumpConn
jumpBtn.MouseButton1Click:Connect(function()
    jumpOn = not jumpOn
    if jumpOn then
        jumpConn = game:GetService("RunService").RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = 100
            end
        end)
        jumpBtn.Text = "🦘 Jump Boost [ON]"
    else
        if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
        jumpBtn.Text = "🦘 Jump Boost [OFF]"
    end
end)

-- Skip Stage
local skipBtn = Instance.new("TextButton", main); skipBtn.Size = UDim2.new(1,-10,0,40)
skipBtn.BackgroundColor3 = Color3.fromRGB(60,60,60); skipBtn.TextColor3 = Color3.new(1,1,1)
skipBtn.Text = "↩️ Skip Stage"
skipBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local nextStage = workspace:FindFirstChild("Part") -- ajustar nome conforme mapa
    if hrp and nextStage then
        hrp.CFrame = nextStage.Position + Vector3.new(0,3,0)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
