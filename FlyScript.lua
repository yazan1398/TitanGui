-- LocalScript للطيران والسرعة للهاتف
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local flySpeed = 50
local walkSpeed = 16
local bodyVelocity

-- GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "FlyGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0.5, -110, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- زر الطيران
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0, 200, 0, 50)
flyBtn.Position = UDim2.new(0, 10, 0, 10)
flyBtn.Text = "Fly: OFF"
flyBtn.TextScaled = true
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
end)

-- تعديل سرعة الطيران
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 200, 0, 50)
speedBox.Position = UDim2.new(0, 10, 0, 70)
speedBox.PlaceholderText = "Fly Speed"
speedBox.TextScaled = true
speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then flySpeed = val end
end)

-- تعديل سرعة المشي
local walkBox = Instance.new("TextBox", frame)
walkBox.Size = UDim2.new(0, 200, 0, 50)
walkBox.Position = UDim2.new(0, 10, 0, 130)
walkBox.PlaceholderText = "Walk Speed"
walkBox.TextScaled = true
walkBox.FocusLost:Connect(function()
    local val = tonumber(walkBox.Text)
    if val and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = val
    end
end)

-- زر إغلاق
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(0.5, -25, 1, -60)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- الطيران
runService.RenderStepped:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = walkSpeed
    end

    if flying then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Parent = hrp
        end

        local moveDir = Vector3.new()
        if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + hrp.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - hrp.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - hrp.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + hrp.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end

        bodyVelocity.Velocity = moveDir.Unit * flySpeed
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end)
