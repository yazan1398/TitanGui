-- LocalScript للطيران، السرعة، والانتقال مع GUI صغير
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local flying = false
local flySpeed = 50
local walkSpeed = 16
local speedOn = false
local bodyVelocity

-- GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "FlyGui"

-- زر فتح/إغلاق GUI
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 80, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.Text = "GUI"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 450)
frame.Position = UDim2.new(0.5, -150, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Visible = false

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- زر إغلاق
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -55, 0, 5)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

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

-- زر السرعة مع TextBox صغير لتحديد السرعة
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0, 120, 0, 50)
speedBtn.Position = UDim2.new(0, 10, 0, 70)
speedBtn.Text = "Speed: OFF"
speedBtn.TextScaled = true
speedBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 60, 0, 50)
speedBox.Position = UDim2.new(0, 140, 0, 70)
speedBox.PlaceholderText = "35"
speedBox.TextScaled = true

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if speedOn then
        local val = tonumber(speedBox.Text)
        if val then walkSpeed = val else walkSpeed = 35 end
        speedBtn.Text = "Speed: ON"
    else
        walkSpeed = 16
        speedBtn.Text = "Speed: OFF"
    end
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = walkSpeed
    end
end)

-- قائمة اللاعبين مع الخطوط بين الأسماء
local playerList = Instance.new("ScrollingFrame", frame)
playerList.Size = UDim2.new(0, 280, 0, 300)
playerList.Position = UDim2.new(0, 10, 0, 130)
playerList.BackgroundColor3 = Color3.fromRGB(30,30,30)
playerList.CanvasSize = UDim2.new(0,0,0,0)
playerList.ScrollBarThickness = 10

local layout = Instance.new("UIListLayout", playerList)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

local function addPlayerButton(p)
    local nameLabel = Instance.new("TextLabel", playerList)
    nameLabel.Size = UDim2.new(1,0,0,30)
    nameLabel.Text = p.Name
    nameLabel.TextScaled = true
    nameLabel.BackgroundColor3 = Color3.fromRGB(60,60,60)
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)

    local line = Instance.new("TextLabel", playerList)
    line.Size = UDim2.new(1,0,0,10)
    line.Text = "--------"
    line.TextScaled = true
    line.BackgroundColor3 = Color3.fromRGB(50,50,50)
    line.TextColor3 = Color3.fromRGB(200,200,200)

    nameLabel.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") 
        and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
        end
    end)
end

local function updatePlayers()
    playerList:ClearAllChildren()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            addPlayerButton(p)
        end
    end
    playerList.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

players.PlayerAdded:Connect(updatePlayers)
players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

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

        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end)
