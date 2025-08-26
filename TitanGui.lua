-- TitanGui.lua
-- GUI لليازن يعطي سرعة + طيران + كل العناصر (الأدوات)

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TitanGui"
gui.Parent = plr:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- زر السرعة
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1, 0, 0, 50)
speedBtn.Text = "🚀 السرعة"
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- زر الطيران
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(1, 0, 0, 50)
flyBtn.Position = UDim2.new(0, 0, 0, 60)
flyBtn.Text = "🕊️ الطيران"
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- زر كل العناصر
local allBtn = Instance.new("TextButton", frame)
allBtn.Size = UDim2.new(1, 0, 0, 50)
allBtn.Position = UDim2.new(0, 0, 0, 120)
allBtn.Text = "⚔️ كل العناصر"
allBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
allBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- وظيفة السرعة
speedBtn.MouseButton1Click:Connect(function()
    plr.Character:WaitForChild("Humanoid").WalkSpeed = 100
end)

-- وظيفة الطيران (بسيطة للأعلى)
flyBtn.MouseButton1Click:Connect(function()
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0, 150, 0)
    end
end)

-- وظيفة جلب كل العناصر (من ReplicatedStorage و ServerStorage)
allBtn.MouseButton1Click:Connect(function()
    local backpack = plr.Backpack
    local storages = {game:GetService("ReplicatedStorage"), game:GetService("ServerStorage")}

    for _,storage in ipairs(storages) do
        for _, item in ipairs(storage:GetChildren()) do
            if item:IsA("Tool") then
                item:Clone().Parent = backpack
            end
        end
    end
end)
