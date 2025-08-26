-- إنشاء واجهة GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GlobalWriterGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- TextBox للكتابة
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 300, 0, 50)
textBox.Position = UDim2.new(0.5, -150, 0.7, 0)
textBox.PlaceholderText = "اكتب هنا..."
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
textBox.TextColor3 = Color3.fromRGB(255,255,255)
textBox.Parent = screenGui

-- TextLabel لعرض النص المحلي قبل الإرسال
local displayLabel = Instance.new("TextLabel")
displayLabel.Size = UDim2.new(0, 400, 0, 50)
displayLabel.Position = UDim2.new(0.5, -200, 0.1, 0)
displayLabel.Text = ""
displayLabel.TextScaled = true
displayLabel.BackgroundTransparency = 0.5
displayLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
displayLabel.TextColor3 = Color3.fromRGB(255,255,255)
displayLabel.Parent = screenGui

-- تحديث النص المحلي فورًا عند الكتابة
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    displayLabel.Text = textBox.Text
end)

-- زر لإرسال الرسالة لكل اللاعبين لمدة 20 ثانية
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 200, 0, 50)
sendButton.Position = UDim2.new(0.5, -100, 0.8, 0)
sendButton.Text = "إرسال للجميع"
sendButton.TextScaled = true
sendButton.BackgroundColor3 = Color3.fromRGB(0,100,0)
sendButton.TextColor3 = Color3.fromRGB(255,255,255)
sendButton.Parent = screenGui

-- دالة لإرسال الرسالة لكل اللاعبين في السيرفر
local function sendMessageToAll(message)
    -- نستخدم RemoteEvent لإرسال الرسالة لجميع اللاعبين
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remote = replicatedStorage:FindFirstChild("GlobalMessageEvent")
    if not remote then
        remote = Instance.new("RemoteEvent")
        remote.Name = "GlobalMessageEvent"
        remote.Parent = replicatedStorage
    end
    remote:FireAllClients(message)
end

-- عند الضغط على الزر
sendButton.MouseButton1Click:Connect(function()
    if textBox.Text ~= "" then
        sendMessageToAll(textBox.Text)
        textBox.Text = "" -- مسح النص بعد الإرسال
    end
end)

-- استقبال الرسالة عند كل لاعب وعرضها
local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage:WaitForChild("GlobalMessageEvent")

remote.OnClientEvent:Connect(function(message)
    local label = displayLabel:Clone()
    label.Text = message
    label.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    task.delay(20, function()
        label:Destroy()
    end)
end)
