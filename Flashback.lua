if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

player.CharacterAdded:Wait()

--------------------------------------------------
-- ♾️ MEMORY SYSTEM
--------------------------------------------------
local MAX_DATA = 4000
local data = table.create(MAX_DATA)

local index = 1
local recording = true
local lastPos = nil

task.spawn(function()
    while true do
        if recording then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local pos = root.Position

                if not lastPos or (pos - lastPos).Magnitude > 0.5 then
                    data[index] = pos
                    index += 1
                    lastPos = pos

                    if index > MAX_DATA then
                        index = 1
                    end
                end
            end
        end
        task.wait(0.08)
    end
end)

--------------------------------------------------
-- 🔁 FLASHBACK
--------------------------------------------------
local function flashback()
    recording = false

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local i = index - 1
    local count = 0

    while count < MAX_DATA do
        if i <= 0 then i = MAX_DATA end

        local pos = data[i]
        if pos then
            root.CFrame = CFrame.new(pos)
        end

        i -= 1
        count += 1

        task.wait(0.04)
    end

    recording = true
end

--------------------------------------------------
-- 🗑️ RESET
--------------------------------------------------
local function resetData()
    data = table.create(MAX_DATA)
    index = 1
end

--------------------------------------------------
-- 📱 GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,150)
frame.Position = UDim2.new(0.3,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BackgroundTransparency = 0.2
frame.Active = true

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "FLASHBACK SYSTEM"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1

-- FLASHBACK BUTTON
local fbBtn = Instance.new("TextButton", frame)
fbBtn.Size = UDim2.new(0.9,0,0,40)
fbBtn.Position = UDim2.new(0.05,0,0.35,0)
fbBtn.Text = "FLASHBACK"
fbBtn.TextScaled = true
fbBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
fbBtn.TextColor3 = Color3.fromRGB(0,255,0)

-- RESET BUTTON
local resetBtn = Instance.new("TextButton", frame)
resetBtn.Size = UDim2.new(0.9,0,0,40)
resetBtn.Position = UDim2.new(0.05,0,0.7,0)
resetBtn.Text = "RESET"
resetBtn.TextScaled = true
resetBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
resetBtn.TextColor3 = Color3.fromRGB(255,0,0)

--------------------------------------------------
-- 🎮 BUTTON
--------------------------------------------------
fbBtn.MouseButton1Click:Connect(flashback)
resetBtn.MouseButton1Click:Connect(resetData)

--------------------------------------------------
-- 🖱️ DRAG
--------------------------------------------------
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch 
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch 
    or input.UserInputType == Enum.UserInputType.MouseMovement) then
        
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch 
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
