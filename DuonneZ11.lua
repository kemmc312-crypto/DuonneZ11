--[[ 
    DuonneZ11 - Auto Chest FINAL
    TELE | Stable | Auto Team | Auto Hop
]]

--// ANTI DOUBLE LOAD
if getgenv().DuonneZ11_Loaded then return end
getgenv().DuonneZ11_Loaded = true

--// TEAM SYSTEM (SAVE WHEN HOP)
getgenv().DUONNE_TEAM = getgenv().DUONNE_TEAM or "MARINE" -- "MARINE" / "PIRATE"

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer
local PlaceId = game.PlaceId

task.spawn(function()
    local lp = game.Players.LocalPlayer
    local pg = lp:WaitForChild("PlayerGui")

    while task.wait(0.1) do
        for _,v in ipairs(pg:GetDescendants()) do
            if v:IsA("TextButton") then
                local t = v.Text:lower()
                if t:find("marine") then
                    firesignal(v.MouseButton1Click)
                    warn("AUTO CHOSE MARINE")
                    return
                end
            end
        end
    end
end)

--// CHARACTER
local function getHRP()
    local char = lp.Character or lp.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

--// ================= UI =================
local gui = Instance.new("ScreenGui")
gui.Name = "DuonneZ11_UI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,240,0,240)
frame.Position = UDim2.new(0,30,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-12,0,26)
title.Position = UDim2.new(0,6,0,6)
title.BackgroundTransparency = 1
title.Text = "DuonneZ11"
title.TextColor3 = Color3.fromRGB(120,200,120)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Auto Chest
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,-12,0,38)
toggle.Position = UDim2.new(0,6,0,36)
toggle.BackgroundColor3 = Color3.fromRGB(60,120,60)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 15
toggle.Text = "Auto Chest : ON"
toggle.AutoButtonColor = false
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

-- Move Mode
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1,-12,0,28)
modeBtn.Position = UDim2.new(0,6,0,80)
modeBtn.BackgroundColor3 = Color3.fromRGB(120,70,70)
modeBtn.TextColor3 = Color3.new(1,1,1)
modeBtn.Font = Enum.Font.Gotham
modeBtn.TextSize = 13
modeBtn.Text = "Move Mode : TELE"
modeBtn.AutoButtonColor = false
modeBtn.Parent = frame
Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0,8)

-- Server Hop
local hopToggle = Instance.new("TextButton")
hopToggle.Size = UDim2.new(1,-12,0,28)
hopToggle.Position = UDim2.new(0,6,0,118)
hopToggle.BackgroundColor3 = Color3.fromRGB(70,100,140)
hopToggle.TextColor3 = Color3.new(1,1,1)
hopToggle.Font = Enum.Font.Gotham
hopToggle.TextSize = 13
hopToggle.Text = "Server Hop : ON"
hopToggle.AutoButtonColor = false
hopToggle.Parent = frame
Instance.new("UICorner", hopToggle).CornerRadius = UDim.new(0,8)

-- Team Button (Blue X style)
local teamBtn = Instance.new("TextButton")
teamBtn.Size = UDim2.new(1,-12,0,28)
teamBtn.Position = UDim2.new(0,6,0,154)
teamBtn.BackgroundColor3 = Color3.fromRGB(90,140,90)
teamBtn.TextColor3 = Color3.new(1,1,1)
teamBtn.Font = Enum.Font.Gotham
teamBtn.TextSize = 13
teamBtn.AutoButtonColor = false
teamBtn.Parent = frame
Instance.new("UICorner", teamBtn).CornerRadius = UDim.new(0,8)

local function updateTeamText()
    teamBtn.Text = "Team : " .. getgenv().DUONNE_TEAM
end
updateTeamText()

teamBtn.MouseButton1Click:Connect(function()
    if getgenv().DUONNE_TEAM == "MARINE" then
        getgenv().DUONNE_TEAM = "PIRATE"
        teamBtn.BackgroundColor3 = Color3.fromRGB(140,90,90)
    else
        getgenv().DUONNE_TEAM = "MARINE"
        teamBtn.BackgroundColor3 = Color3.fromRGB(90,140,90)
    end
    updateTeamText()
end)

-- Hop Time
local hopLabel = Instance.new("TextLabel")
hopLabel.Size = UDim2.new(1,-12,0,22)
hopLabel.Position = UDim2.new(0,6,0,186)
hopLabel.BackgroundTransparency = 1
hopLabel.Text = "Hop Time: 25s"
hopLabel.TextColor3 = Color3.fromRGB(200,200,200)
hopLabel.Font = Enum.Font.Gotham
hopLabel.TextSize = 13
hopLabel.TextXAlignment = Enum.TextXAlignment.Left
hopLabel.Parent = frame

--// DRAG UI
do
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

--// ================= STATE =================
local AutoChest = true
local MoveMode = "TELE"
local SPEED = 320
local TELE_DIST = 25
local ServerHop = true
local HopTime = 25

--// BUTTON LOGIC
toggle.MouseButton1Click:Connect(function()
    AutoChest = not AutoChest
    toggle.Text = "Auto Chest : " .. (AutoChest and "ON" or "OFF")
    toggle.BackgroundColor3 = AutoChest and Color3.fromRGB(60,120,60) or Color3.fromRGB(35,35,35)
end)

modeBtn.MouseButton1Click:Connect(function()
    MoveMode = (MoveMode == "TELE") and "FLY" or "TELE"
    modeBtn.Text = "Move Mode : " .. MoveMode
end)

hopToggle.MouseButton1Click:Connect(function()
    ServerHop = not ServerHop
    hopToggle.Text = "Server Hop : " .. (ServerHop and "ON" or "OFF")
end)

--// ================= CHEST =================
local function getAllChests()
    local t = {}
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("chest") and v:FindFirstChild("TouchInterest") then
            table.insert(t, v)
        end
    end
    return t
end

--// ================= MOVE =================
local function moveTo(hrp, pos)
    if MoveMode == "TELE" then
        hrp.CFrame = CFrame.new(pos)
        return
    end

    local dist = (hrp.Position - pos).Magnitude
    local startCF = hrp.CFrame
    local endCF = CFrame.new(pos)
    local time = dist / SPEED
    local start = tick()

    while tick() - start < time do
        hrp.CFrame = startCF:Lerp(endCF, (tick() - start) / time)
        RunService.RenderStepped:Wait()
    end
    hrp.CFrame = endCF
end

--// ================= AUTO CHEST =================
task.spawn(function()
    while task.wait(0.4) do
        if not AutoChest then continue end

        local hrp = getHRP()
        local chests = getAllChests()

        table.sort(chests, function(a,b)
            return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
        end)

        for _,c in ipairs(chests) do
            if not AutoChest then break end
            if c and c.Parent and c:FindFirstChild("TouchInterest") then
                moveTo(hrp, c.Position + (hrp.Position - c.Position).Unit * 1.5)
                task.wait(0.15)
            end
        end
    end
end)

--// ================= SERVER HOP =================
task.spawn(function()
    while task.wait(1) do
        if not (ServerHop and AutoChest) then continue end
        HopTime -= 1
        hopLabel.Text = "Hop Time: " .. HopTime .. "s"
        if HopTime <= 0 then
            TeleportService:Teleport(PlaceId, lp)
            return
        end
    end
end)
