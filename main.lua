local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function destroyAllExistingUIs()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "AimLockGui" then
            gui:Destroy()
        end
    end
    task.wait(0.05)
end

destroyAllExistingUIs()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimLockGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

local FRAME_W, FRAME_H = 340, 320

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
MainContainer.Position = UDim2.new(0.5, -FRAME_W / 2, 0.5, -FRAME_H / 2)
MainContainer.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
MainContainer.BackgroundTransparency = 0.08
MainContainer.BorderSizePixel = 0
MainContainer.Active = true
MainContainer.ZIndex = 10
MainContainer.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainContainer

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 90, 120)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.7
MainStroke.Parent = MainContainer

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.Position = UDim2.new(0, -30, 0, -30)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.3
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.ZIndex = 9
Shadow.Parent = MainContainer

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.ZIndex = 11
Header.Parent = MainContainer

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 20)
HeaderCover.Position = UDim2.new(0, 0, 1, -20)
HeaderCover.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
HeaderCover.BackgroundTransparency = 0.3
HeaderCover.BorderSizePixel = 0
HeaderCover.ZIndex = 11
HeaderCover.Parent = Header

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 40, 0, 40)
TitleIcon.Position = UDim2.new(0, 16, 0, 10)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "⚡"
TitleIcon.TextColor3 = Color3.fromRGB(130, 150, 255)
TitleIcon.TextSize = 26
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.ZIndex = 12
TitleIcon.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 28)
Title.Position = UDim2.new(0, 60, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "ULTIMATE TOOLKIT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -70, 0, 16)
Subtitle.Position = UDim2.new(0, 60, 0, 34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "AimLock • ESP • Teleport"
Subtitle.TextColor3 = Color3.fromRGB(160, 170, 200)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.TextTransparency = 0.3
Subtitle.ZIndex = 12
Subtitle.Parent = Header

local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -32, 1, -84)
ContentContainer.Position = UDim2.new(0, 16, 0, 72)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.ScrollBarThickness = 4
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(130, 150, 255)
ContentContainer.ZIndex = 11
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.Parent = MainContainer

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.Padding = UDim.new(0, 12)
Layout.Parent = ContentContainer

local function makeSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 32)
    section.BackgroundTransparency = 1
    section.ZIndex = 11
    section.Parent = ContentContainer

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 1, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = title
    sectionLabel.TextColor3 = Color3.fromRGB(130, 150, 255)
    sectionLabel.TextSize = 13
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.ZIndex = 12
    sectionLabel.Parent = section

    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0, 50, 0, 2)
    underline.Position = UDim2.new(0, 0, 1, -6)
    underline.BackgroundColor3 = Color3.fromRGB(130, 150, 255)
    underline.BorderSizePixel = 0
    underline.ZIndex = 12
    underline.Parent = section
    
    local underlineCorner = Instance.new("UICorner")
    underlineCorner.CornerRadius = UDim.new(1, 0)
    underlineCorner.Parent = underline

    return section
end

local function makeToggleRow(labelText, icon)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 56)
    row.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.ZIndex = 11
    row.Parent = ContentContainer
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 12)
    rowCorner.Parent = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Color3.fromRGB(60, 70, 90)
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.8
    rowStroke.Parent = row

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 12, 0.5, -20)
    iconLabel.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    iconLabel.BackgroundTransparency = 0.4
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(130, 150, 255)
    iconLabel.TextSize = 22
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 12
    iconLabel.Parent = row
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 10)
    iconCorner.Parent = iconLabel

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -140, 1, 0)
    lbl.Position = UDim2.new(0, 60, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(245, 245, 250)
    lbl.TextSize = 15
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 56, 0, 30)
    btn.Position = UDim2.new(1, -68, 0.5, -15)
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 12
    btn.Parent = row
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(70, 80, 100)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = UDim2.new(0, 3, 0.5, -12)
    knob.BackgroundColor3 = Color3.fromRGB(110, 120, 140)
    knob.BorderSizePixel = 0
    knob.ZIndex = 13
    knob.Parent = btn
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local knobShadow = Instance.new("ImageLabel")
    knobShadow.Size = UDim2.new(1, 12, 1, 12)
    knobShadow.Position = UDim2.new(0, -6, 0, -6)
    knobShadow.BackgroundTransparency = 1
    knobShadow.Image = "rbxassetid://5554236805"
    knobShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    knobShadow.ImageTransparency = 0.6
    knobShadow.ScaleType = Enum.ScaleType.Slice
    knobShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    knobShadow.ZIndex = 12
    knobShadow.Parent = knob

    row.MouseEnter:Connect(function()
        TweenService:Create(rowStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(rowStroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
    end)

    return btn, knob, row
end

local function makeActionButton(labelText, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 56)
    btn.BackgroundColor3 = Color3.fromRGB(90, 110, 220)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 12
    btn.Parent = ContentContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn

    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 130, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 100, 220))
    }
    btnGradient.Rotation = 45
    btnGradient.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(140, 160, 255)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn

    local btnShadow = Instance.new("ImageLabel")
    btnShadow.Size = UDim2.new(1, 20, 1, 20)
    btnShadow.Position = UDim2.new(0, -10, 0, -10)
    btnShadow.BackgroundTransparency = 1
    btnShadow.Image = "rbxassetid://5554236805"
    btnShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    btnShadow.ImageTransparency = 0.5
    btnShadow.ScaleType = Enum.ScaleType.Slice
    btnShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    btnShadow.ZIndex = 11
    btnShadow.Parent = btn

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 12, 0.5, -20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 22
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 13
    iconLabel.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 60, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 15
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
    end)

    return btn
end

local function makeDropdown(labelText, icon)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 56)
    container.BackgroundTransparency = 1
    container.ZIndex = 11
    container.Parent = ContentContainer

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 56)
    mainBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    mainBtn.BackgroundTransparency = 0.5
    mainBtn.BorderSizePixel = 0
    mainBtn.Text = ""
    mainBtn.ZIndex = 12
    mainBtn.Parent = container
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainBtn

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(60, 70, 90)
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.8
    mainStroke.Parent = mainBtn

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 12, 0.5, -20)
    iconLabel.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    iconLabel.BackgroundTransparency = 0.4
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(130, 150, 255)
    iconLabel.TextSize = 22
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 13
    iconLabel.Parent = mainBtn
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 10)
    iconCorner.Parent = iconLabel

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 60, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(245, 245, 250)
    label.TextSize = 15
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = mainBtn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 30, 0, 30)
    arrow.Position = UDim2.new(1, -42, 0.5, -15)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(160, 170, 200)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 13
    arrow.Parent = mainBtn

    local dropList = Instance.new("ScrollingFrame")
    dropList.Size = UDim2.new(1, 0, 0, 0)
    dropList.Position = UDim2.new(0, 0, 0, 62)
    dropList.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
    dropList.BackgroundTransparency = 0.1
    dropList.BorderSizePixel = 0
    dropList.ScrollBarThickness = 3
    dropList.ScrollBarImageColor3 = Color3.fromRGB(130, 150, 255)
    dropList.Visible = false
    dropList.ZIndex = 15
    dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropList.Parent = container
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 12)
    dropCorner.Parent = dropList

    local dropStroke = Instance.new("UIStroke")
    dropStroke.Color = Color3.fromRGB(80, 90, 120)
    dropStroke.Thickness = 1
    dropStroke.Transparency = 0.7
    dropStroke.Parent = dropList

    local dropShadow = Instance.new("ImageLabel")
    dropShadow.Size = UDim2.new(1, 20, 1, 20)
    dropShadow.Position = UDim2.new(0, -10, 0, -10)
    dropShadow.BackgroundTransparency = 1
    dropShadow.Image = "rbxassetid://5554236805"
    dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    dropShadow.ImageTransparency = 0.4
    dropShadow.ScaleType = Enum.ScaleType.Slice
    dropShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    dropShadow.ZIndex = 14
    dropShadow.Parent = dropList

    local dropLayout = Instance.new("UIListLayout")
    dropLayout.FillDirection = Enum.FillDirection.Vertical
    dropLayout.Padding = UDim.new(0, 2)
    dropLayout.Parent = dropList

    local dropPadding = Instance.new("UIPadding")
    dropPadding.PaddingLeft = UDim.new(0, 6)
    dropPadding.PaddingRight = UDim.new(0, 6)
    dropPadding.PaddingTop = UDim.new(0, 6)
    dropPadding.PaddingBottom = UDim.new(0, 6)
    dropPadding.Parent = dropList

    local isOpen = false

    mainBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            local numPlayers = #Players:GetPlayers() - 1
            local height = math.min(numPlayers * 44 + 12, 200)
            
            dropList.Visible = true
            TweenService:Create(dropList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, height)
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
            TweenService:Create(container, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 56 + height + 6)
            }):Play()
        else
            TweenService:Create(dropList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(container, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 56)
            }):Play()
            
            task.wait(0.2)
            dropList.Visible = false
        end
    end)

    return container, dropList
end

makeSection("🎮 COMBAT")
local aimBtn, aimKnob = makeToggleRow("AimLock", "🎯")

makeSection("👁️ VISUAL")
local espBtn, espKnob = makeToggleRow("ESP", "📊")

makeSection("🚀 MOVEMENT")
local tpContainer, tpDropList = makeDropdown("Teleport to Player", "⚡")

local dragging, dragStart, frameStart = false, Vector2.new(), Vector2.new()

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(MainContainer.AbsolutePosition.X, MainContainer.AbsolutePosition.Y)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        local vp = Camera.ViewportSize
        local newX = math.clamp(frameStart.X + delta.X, 0, vp.X - FRAME_W)
        local newY = math.clamp(frameStart.Y + delta.Y, 0, vp.Y - FRAME_H)
        MainContainer.Position = UDim2.fromOffset(newX, newY)
    end
end)

local aimEnabled = false
local espEnabled = false
local smoothing = 0.18

local espObjects = {}
local connections = {}

local function setVisual(btn, knob, state)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if state then
        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(70, 210, 130)}):Play()
        TweenService:Create(knob, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(0, 29, 0.5, -12)
        }):Play()
    else
        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 50, 65)}):Play()
        TweenService:Create(knob, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(110, 120, 140),
            Position = UDim2.new(0, 3, 0.5, -12)
        }):Play()
    end
end

local function createESP(player)
    if espObjects[player] then return end

    local function makeLine()
        local f = Instance.new("Frame")
        f.BackgroundColor3 = Color3.fromRGB(130, 150, 255)
        f.BorderSizePixel = 0
        f.ZIndex = 5
        f.Parent = ScreenGui
        return f
    end

    local top = makeLine()
    local bottom = makeLine()
    local left = makeLine()
    local right = makeLine()

    local distLabel = Instance.new("TextLabel")
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(130, 150, 255)
    distLabel.TextSize = 13
    distLabel.Font = Enum.Font.GothamBold
    distLabel.Text = ""
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Size = UDim2.new(0, 100, 0, 18)
    distLabel.ZIndex = 6
    distLabel.Parent = ScreenGui

    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextSize = 15
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Text = player.Name
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLbl.Size = UDim2.new(0, 150, 0, 20)
    nameLbl.ZIndex = 6
    nameLbl.Parent = ScreenGui

    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    hpBg.BorderSizePixel = 0
    hpBg.ZIndex = 5
    hpBg.Parent = ScreenGui
    
    local hpBgCorner = Instance.new("UICorner")
    hpBgCorner.CornerRadius = UDim.new(0, 3)
    hpBgCorner.Parent = hpBg

    local hpBar = Instance.new("Frame")
    hpBar.BackgroundColor3 = Color3.fromRGB(70, 230, 90)
    hpBar.BorderSizePixel = 0
    hpBar.ZIndex = 6
    hpBar.Parent = hpBg
    
    local hpBarCorner = Instance.new("UICorner")
    hpBarCorner.CornerRadius = UDim.new(0, 3)
    hpBarCorner.Parent = hpBar

    espObjects[player] = {
        top = top, bottom = bottom, left = left, right = right,
        nameLbl = nameLbl, hpBg = hpBg, hpBar = hpBar, distLabel = distLabel
    }
end

local function removeESP(player)
    local obj = espObjects[player]
    if not obj then return end
    for _, v in pairs(obj) do
        if typeof(v) == "Instance" and v then
            pcall(function() v:Destroy() end)
        end
    end
    espObjects[player] = nil
end

local function hideESP(player)
    local obj = espObjects[player]
    if not obj then return end
    for _, v in pairs(obj) do
        if typeof(v) == "Instance" and v then
            pcall(function() v.Visible = false end)
        end
    end
end

local THICKNESS = 2
local HP_W = 6

local function updateESP()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local obj = espObjects[player]
        if not obj then continue end

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not root or not hum or hum.Health <= 0 then
            hideESP(player)
            continue
        end

        local rootPos = root.Position
        local headPos = char:FindFirstChild("Head") and char.Head.Position or rootPos + Vector3.new(0, 2, 0)
        
        local topWorld = headPos + Vector3.new(0, 0.6, 0)
        local botWorld = rootPos - Vector3.new(0, 2.8, 0)

        local topScreen, topVis = Camera:WorldToScreenPoint(topWorld)
        local botScreen, botVis = Camera:WorldToScreenPoint(botWorld)

        if not topVis then
            hideESP(player)
            continue
        end

        local h = math.abs(botScreen.Y - topScreen.Y)
        local w = h * 0.48
        local cx = (topScreen.X + botScreen.X) / 2
        local cy = (topScreen.Y + botScreen.Y) / 2

        local x1 = cx - w / 2
        local y1 = topScreen.Y
        local x2 = cx + w / 2
        local y2 = botScreen.Y

        obj.top.Size = UDim2.fromOffset(w, THICKNESS)
        obj.top.Position = UDim2.fromOffset(x1, y1)
        obj.top.Visible = true

        obj.bottom.Size = UDim2.fromOffset(w, THICKNESS)
        obj.bottom.Position = UDim2.fromOffset(x1, y2)
        obj.bottom.Visible = true

        obj.left.Size = UDim2.fromOffset(THICKNESS, h)
        obj.left.Position = UDim2.fromOffset(x1, y1)
        obj.left.Visible = true

        obj.right.Size = UDim2.fromOffset(THICKNESS, h)
        obj.right.Position = UDim2.fromOffset(x2, y1)
        obj.right.Visible = true

        obj.nameLbl.Position = UDim2.fromOffset(cx - 75, y1 - 26)
        obj.nameLbl.Visible = true

        if myRoot then
            local dist = (root.Position - myRoot.Position).Magnitude
            obj.distLabel.Text = string.format("%.0fm", dist)
            obj.distLabel.Position = UDim2.fromOffset(cx - 50, y2 + 6)
            obj.distLabel.Visible = true
        end

        local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        obj.hpBg.Size = UDim2.fromOffset(HP_W, h)
        obj.hpBg.Position = UDim2.fromOffset(x1 - HP_W - 5, y1)
        obj.hpBg.Visible = true

        obj.hpBar.Size = UDim2.new(1, 0, hpRatio, 0)
        obj.hpBar.Position = UDim2.new(0, 0, 1 - hpRatio, 0)
        
        if hpRatio > 0.7 then
            obj.hpBar.BackgroundColor3 = Color3.fromRGB(70, 230, 90)
        elseif hpRatio > 0.3 then
            obj.hpBar.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
        else
            obj.hpBar.BackgroundColor3 = Color3.fromRGB(230, 70, 70)
        end
        obj.hpBar.Visible = true
    end
end

connections.playerAdded = Players.PlayerAdded:Connect(function(p)
    if espEnabled then 
        task.wait(0.1)
        createESP(p) 
    end
end)

connections.playerRemoving = Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

local function getNearestPlayer()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    local nearest, minDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if head and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < minDist then 
                        minDist = dist
                        nearest = head
                    end
                end
            end
        end
    end
    return nearest
end

local function teleportToPlayer(targetPlayer)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local targetChar = targetPlayer.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if targetRoot then
        local targetPos = targetRoot.Position
        myRoot.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, 4))
        
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(0, 220, 0, 44)
        notif.Position = UDim2.new(0.5, -110, 0.08, 0)
        notif.BackgroundColor3 = Color3.fromRGB(70, 210, 130)
        notif.BackgroundTransparency = 0.2
        notif.Text = "✓ Teleported to " .. targetPlayer.Name
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.TextSize = 15
        notif.Font = Enum.Font.GothamBold
        notif.ZIndex = 100
        notif.Parent = ScreenGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notif
        
        local notifShadow = Instance.new("ImageLabel")
        notifShadow.Size = UDim2.new(1, 20, 1, 20)
        notifShadow.Position = UDim2.new(0, -10, 0, -10)
        notifShadow.BackgroundTransparency = 1
        notifShadow.Image = "rbxassetid://5554236805"
        notifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        notifShadow.ImageTransparency = 0.4
        notifShadow.ScaleType = Enum.ScaleType.Slice
        notifShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        notifShadow.ZIndex = 99
        notifShadow.Parent = notif
        
        TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        task.wait(1.8)
        TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        task.wait(0.3)
        notif:Destroy()
    end
end

local function updatePlayerList()
    for _, child in ipairs(tpDropList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, 0, 0, 40)
            playerBtn.BackgroundColor3 = Color3.fromRGB(32, 38, 50)
            playerBtn.BackgroundTransparency = 0.3
            playerBtn.BorderSizePixel = 0
            playerBtn.Text = ""
            playerBtn.ZIndex = 16
            playerBtn.Parent = tpDropList
            
            local playerCorner = Instance.new("UICorner")
            playerCorner.CornerRadius = UDim.new(0, 8)
            playerCorner.Parent = playerBtn

            local playerLabel = Instance.new("TextLabel")
            playerLabel.Size = UDim2.new(1, -16, 1, 0)
            playerLabel.Position = UDim2.new(0, 8, 0, 0)
            playerLabel.BackgroundTransparency = 1
            playerLabel.Text = player.Name
            playerLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
            playerLabel.TextSize = 14
            playerLabel.Font = Enum.Font.GothamMedium
            playerLabel.TextXAlignment = Enum.TextXAlignment.Left
            playerLabel.ZIndex = 17
            playerLabel.Parent = playerBtn

            playerBtn.MouseEnter:Connect(function()
                TweenService:Create(playerBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
            end)
            playerBtn.MouseLeave:Connect(function()
                TweenService:Create(playerBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
            end)

            playerBtn.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)
        end
    end
end

Players.PlayerAdded:Connect(function()
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList()
end)

updatePlayerList()

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    setVisual(aimBtn, aimKnob, aimEnabled)
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    setVisual(espBtn, espKnob, espEnabled)
    
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then 
                task.spawn(function() createESP(p) end)
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            removeESP(p)
        end
    end
end)

connections.renderStepped = RunService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getNearestPlayer()
        if target then
            local targetPos = target.Position
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPos)
            
            if onScreen then
                local vp = Camera.ViewportSize
                local deltaX = (screenPos.X - vp.X / 2) * smoothing
                local deltaY = (vp.Y / 2 - screenPos.Y) * smoothing
                
                Camera.CFrame = Camera.CFrame * CFrame.Angles(
                    math.rad(deltaY * 0.12), 
                    math.rad(-deltaX * 0.12), 
                    0
                )
            end
        end
    end

    if espEnabled then
        updateESP()
    end
end)

ScreenGui.Destroying:Connect(function()
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
end)

MainContainer.Position = UDim2.new(0.5, -FRAME_W / 2, -0.5, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -FRAME_W / 2, 0.5, -FRAME_H / 2)
}):Play()

print("✨ Ultimate Toolkit loaded!")
