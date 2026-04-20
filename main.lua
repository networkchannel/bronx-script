-- AimLock + ESP + TP - ULTIMATE VERSION
-- Place dans StarterPlayerScripts
-- UI Glass Morphism Design

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ══════════════════════════════════════════════════════════════════════════════
-- ── DESTRUCTION COMPLÈTE DES UI EXISTANTES ───────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function destroyAllExistingUIs()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "AimLockGui" then
            gui:Destroy()
        end
    end
    
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("Folder") and child.Name:match("^ESP_") then
                    child:Destroy()
                end
                if child:IsA("Frame") and (
                    child.BackgroundColor3 == Color3.fromRGB(255, 60, 60) or
                    child.BackgroundColor3 == Color3.fromRGB(20, 20, 20)
                ) then
                    child:Destroy()
                end
                if child:IsA("TextLabel") and child.TextStrokeTransparency and child.TextStrokeTransparency < 0.5 then
                    child:Destroy()
                end
            end
        end
    end
    
    task.wait(0.05)
end

destroyAllExistingUIs()

-- ══════════════════════════════════════════════════════════════════════════════
-- ── UI GLASS MORPHISM DESIGN ──────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "AimLockGui"
ScreenGui.ResetOnSpawn    = false
ScreenGui.IgnoreGuiInset  = true
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent          = LocalPlayer.PlayerGui

local FRAME_W, FRAME_H = 320, 280

-- Container principal avec effet glass
local MainContainer = Instance.new("Frame")
MainContainer.Size            = UDim2.new(0, FRAME_W, 0, FRAME_H)
MainContainer.Position        = UDim2.new(0.5, -FRAME_W / 2, 0.5, -FRAME_H / 2)
MainContainer.BackgroundColor3= Color3.fromRGB(15, 15, 20)
MainContainer.BackgroundTransparency = 0.3
MainContainer.BorderSizePixel = 0
MainContainer.Active          = true
MainContainer.ZIndex          = 10
MainContainer.Parent          = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainContainer

-- Effet Glass Blur
local GlassBlur = Instance.new("ImageLabel")
GlassBlur.Size                   = UDim2.new(1, 0, 1, 0)
GlassBlur.BackgroundTransparency = 1
GlassBlur.Image                  = "rbxassetid://8992230677"
GlassBlur.ImageColor3            = Color3.fromRGB(20, 25, 35)
GlassBlur.ImageTransparency      = 0.7
GlassBlur.ScaleType              = Enum.ScaleType.Slice
GlassBlur.SliceCenter            = Rect.new(100, 100, 100, 100)
GlassBlur.ZIndex                 = 9
GlassBlur.Parent                 = MainContainer
Instance.new("UICorner", GlassBlur).CornerRadius = UDim.new(0, 16)

-- Border glow effect
local BorderGlow = Instance.new("UIStroke")
BorderGlow.Color          = Color3.fromRGB(100, 120, 255)
BorderGlow.Thickness      = 1.5
BorderGlow.Transparency   = 0.5
BorderGlow.Parent         = MainContainer

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Size                   = UDim2.new(1, 40, 1, 40)
Shadow.Position               = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image                  = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3            = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency      = 0.5
Shadow.ScaleType              = Enum.ScaleType.Slice
Shadow.SliceCenter            = Rect.new(10, 10, 10, 10)
Shadow.ZIndex                 = 8
Shadow.Parent                 = MainContainer

-- ══════════════════════════════════════════════════════════════════════════════
-- ── HEADER ────────────────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local Header = Instance.new("Frame")
Header.Size              = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3  = Color3.fromRGB(25, 30, 45)
Header.BackgroundTransparency = 0.4
Header.BorderSizePixel   = 0
Header.ZIndex            = 11
Header.Parent            = MainContainer
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

-- Header gradient
local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 70, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 35, 50))
}
HeaderGradient.Rotation = 90
HeaderGradient.Parent = Header

-- Title avec icon
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size                 = UDim2.new(0, 40, 0, 40)
TitleIcon.Position             = UDim2.new(0, 10, 0, 5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text                 = "⚡"
TitleIcon.TextColor3           = Color3.fromRGB(120, 140, 255)
TitleIcon.TextSize             = 24
TitleIcon.Font                 = Enum.Font.GothamBold
TitleIcon.ZIndex               = 12
TitleIcon.Parent               = Header

local Title = Instance.new("TextLabel")
Title.Size                 = UDim2.new(1, -60, 0, 25)
Title.Position             = UDim2.new(0, 50, 0, 5)
Title.BackgroundTransparency = 1
Title.Text                 = "ULTIMATE TOOLKIT"
Title.TextColor3           = Color3.fromRGB(255, 255, 255)
Title.TextSize             = 16
Title.Font                 = Enum.Font.GothamBold
Title.TextXAlignment       = Enum.TextXAlignment.Left
Title.ZIndex               = 12
Title.Parent               = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size                 = UDim2.new(1, -60, 0, 15)
Subtitle.Position             = UDim2.new(0, 50, 0, 28)
Subtitle.BackgroundTransparency = 1
Subtitle.Text                 = "AimLock • ESP • Teleport"
Subtitle.TextColor3           = Color3.fromRGB(150, 160, 200)
Subtitle.TextSize             = 11
Subtitle.Font                 = Enum.Font.Gotham
Subtitle.TextXAlignment       = Enum.TextXAlignment.Left
Subtitle.TextTransparency     = 0.3
Subtitle.ZIndex               = 12
Subtitle.Parent               = Header

-- ══════════════════════════════════════════════════════════════════════════════
-- ── CONTAINER POUR LES OPTIONS ────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size              = UDim2.new(1, -20, 1, -70)
ContentContainer.Position          = UDim2.new(0, 10, 0, 60)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel   = 0
ContentContainer.ScrollBarThickness = 4
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 120, 255)
ContentContainer.ZIndex            = 11
ContentContainer.CanvasSize        = UDim2.new(0, 0, 0, 0)
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.Parent            = MainContainer

local Layout = Instance.new("UIListLayout")
Layout.FillDirection  = Enum.FillDirection.Vertical
Layout.Padding        = UDim.new(0, 8)
Layout.Parent         = ContentContainer

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft   = UDim.new(0, 5)
Padding.PaddingRight  = UDim.new(0, 5)
Padding.PaddingTop    = UDim.new(0, 5)
Padding.PaddingBottom = UDim.new(0, 5)
Padding.Parent        = ContentContainer

-- ══════════════════════════════════════════════════════════════════════════════
-- ── HELPER : Créer une section ────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function makeSection(title)
    local section = Instance.new("Frame")
    section.Size              = UDim2.new(1, 0, 0, 28)
    section.BackgroundTransparency = 1
    section.ZIndex            = 11
    section.Parent            = ContentContainer

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size                 = UDim2.new(1, 0, 1, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text                 = title
    sectionLabel.TextColor3           = Color3.fromRGB(120, 140, 255)
    sectionLabel.TextSize             = 13
    sectionLabel.Font                 = Enum.Font.GothamBold
    sectionLabel.TextXAlignment       = Enum.TextXAlignment.Left
    sectionLabel.ZIndex               = 12
    sectionLabel.Parent               = section

    local underline = Instance.new("Frame")
    underline.Size              = UDim2.new(0, 40, 0, 2)
    underline.Position          = UDim2.new(0, 0, 1, -4)
    underline.BackgroundColor3  = Color3.fromRGB(120, 140, 255)
    underline.BorderSizePixel   = 0
    underline.ZIndex            = 12
    underline.Parent            = section
    Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)

    return section
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ── HELPER : Créer une ligne toggle ──────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function makeToggleRow(labelText, icon)
    local row = Instance.new("Frame")
    row.Size              = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3  = Color3.fromRGB(25, 30, 45)
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel   = 0
    row.ZIndex            = 11
    row.Parent            = ContentContainer
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    -- Hover effect background
    local hoverBg = Instance.new("Frame")
    hoverBg.Size              = UDim2.new(1, 0, 1, 0)
    hoverBg.BackgroundColor3  = Color3.fromRGB(255, 255, 255)
    hoverBg.BackgroundTransparency = 1
    hoverBg.BorderSizePixel   = 0
    hoverBg.ZIndex            = 11
    hoverBg.Parent            = row
    Instance.new("UICorner", hoverBg).CornerRadius = UDim.new(0, 10)

    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size                 = UDim2.new(0, 36, 0, 36)
    iconLabel.Position             = UDim2.new(0, 8, 0.5, -18)
    iconLabel.BackgroundColor3     = Color3.fromRGB(40, 50, 70)
    iconLabel.BackgroundTransparency = 0.5
    iconLabel.Text                 = icon
    iconLabel.TextColor3           = Color3.fromRGB(120, 140, 255)
    iconLabel.TextSize             = 20
    iconLabel.Font                 = Enum.Font.GothamBold
    iconLabel.ZIndex               = 12
    iconLabel.Parent               = row
    Instance.new("UICorner", iconLabel).CornerRadius = UDim.new(0, 8)

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Size                 = UDim2.new(1, -120, 1, 0)
    lbl.Position             = UDim2.new(0, 52, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                 = labelText
    lbl.TextColor3           = Color3.fromRGB(240, 240, 250)
    lbl.TextSize             = 14
    lbl.Font                 = Enum.Font.GothamMedium
    lbl.TextXAlignment       = Enum.TextXAlignment.Left
    lbl.ZIndex               = 12
    lbl.Parent               = row

    -- Toggle button
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 54, 0, 28)
    btn.Position         = UDim2.new(1, -64, 0.5, -14)
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    btn.BorderSizePixel  = 0
    btn.Text             = ""
    btn.ZIndex           = 12
    btn.Parent           = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color       = Color3.fromRGB(60, 70, 90)
    btnStroke.Thickness   = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent      = btn

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 22, 0, 22)
    knob.Position         = UDim2.new(0, 3, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(100, 110, 130)
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 13
    knob.Parent           = btn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    -- Hover animation
    row.MouseEnter:Connect(function()
        TweenService:Create(hoverBg, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(hoverBg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)

    return btn, knob, row
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ── HELPER : Créer un bouton d'action ────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function makeActionButton(labelText, icon)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = Color3.fromRGB(80, 100, 200)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel  = 0
    btn.Text             = ""
    btn.ZIndex           = 12
    btn.Parent           = ContentContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 90, 200))
    }
    btnGradient.Rotation = 45
    btnGradient.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color       = Color3.fromRGB(120, 140, 255)
    btnStroke.Thickness   = 1
    btnStroke.Transparency = 0.7
    btnStroke.Parent      = btn

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size                 = UDim2.new(0, 36, 0, 36)
    iconLabel.Position             = UDim2.new(0, 8, 0.5, -18)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text                 = icon
    iconLabel.TextColor3           = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize             = 20
    iconLabel.Font                 = Enum.Font.GothamBold
    iconLabel.ZIndex               = 13
    iconLabel.Parent               = btn

    local label = Instance.new("TextLabel")
    label.Size                 = UDim2.new(1, -52, 1, 0)
    label.Position             = UDim2.new(0, 52, 0, 0)
    label.BackgroundTransparency = 1
    label.Text                 = labelText
    label.TextColor3           = Color3.fromRGB(255, 255, 255)
    label.TextSize             = 14
    label.Font                 = Enum.Font.GothamBold
    label.TextXAlignment       = Enum.TextXAlignment.Left
    label.ZIndex               = 13
    label.Parent               = btn

    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    end)

    return btn
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ── CRÉATION DE L'UI ──────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
makeSection("🎮 COMBAT")
local aimBtn, aimKnob = makeToggleRow("AimLock", "🎯")

makeSection("👁️ VISUAL")
local espBtn, espKnob = makeToggleRow("ESP", "📊")

makeSection("🚀 MOVEMENT")
local tpBtn = makeActionButton("Teleport to Player", "⚡")

-- ══════════════════════════════════════════════════════════════════════════════
-- ── DRAG SYSTEM ───────────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local dragging, dragStart, frameStart = false, Vector2.new(), Vector2.new()

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging   = true
        dragStart  = Vector2.new(input.Position.X, input.Position.Y)
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
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        local vp    = Camera.ViewportSize
        local newX  = math.clamp(frameStart.X + delta.X, 0, vp.X - FRAME_W)
        local newY  = math.clamp(frameStart.Y + delta.Y, 0, vp.Y - FRAME_H)
        MainContainer.Position = UDim2.fromOffset(newX, newY)
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- ── ÉTAT ──────────────────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local aimEnabled = false
local espEnabled = false
local smoothing  = 0.18

local espObjects = {}
local connections = {}

-- ══════════════════════════════════════════════════════════════════════════════
-- ── TOGGLE VISUEL AVEC ANIMATION ──────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function setVisual(btn, knob, state)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if state then
        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 200, 120)}):Play()
        TweenService:Create(knob, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(0, 29, 0.5, -11)
        }):Play()
    else
        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 45, 60)}):Play()
        TweenService:Create(knob, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(100, 110, 130),
            Position = UDim2.new(0, 3, 0.5, -11)
        }):Play()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ── ESP AMÉLIORÉ (FIX POSITION) ───────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function createESP(player)
    if espObjects[player] then return end

    local function makeLine()
        local f = Instance.new("Frame")
        f.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
        f.BorderSizePixel  = 0
        f.ZIndex           = 5
        f.Parent           = ScreenGui
        return f
    end

    local top    = makeLine()
    local bottom = makeLine()
    local left   = makeLine()
    local right  = makeLine()

    -- Distance label
    local distLabel = Instance.new("TextLabel")
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3             = Color3.fromRGB(120, 140, 255)
    distLabel.TextSize               = 12
    distLabel.Font                   = Enum.Font.GothamBold
    distLabel.Text                   = ""
    distLabel.TextStrokeTransparency = 0.2
    distLabel.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    distLabel.Size                   = UDim2.new(0, 100, 0, 16)
    distLabel.ZIndex                 = 6
    distLabel.Parent                 = ScreenGui

    -- Nom
    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3             = Color3.fromRGB(255, 255, 255)
    nameLbl.TextSize               = 14
    nameLbl.Font                   = Enum.Font.GothamBold
    nameLbl.Text                   = player.Name
    nameLbl.TextStrokeTransparency = 0.2
    nameLbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    nameLbl.Size                   = UDim2.new(0, 150, 0, 18)
    nameLbl.ZIndex                 = 6
    nameLbl.Parent                 = ScreenGui

    -- Barre de vie
    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    hpBg.BorderSizePixel  = 0
    hpBg.ZIndex           = 5
    hpBg.Parent           = ScreenGui
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 2)

    local hpBar = Instance.new("Frame")
    hpBar.BackgroundColor3 = Color3.fromRGB(60, 220, 80)
    hpBar.BorderSizePixel  = 0
    hpBar.ZIndex           = 6
    hpBar.Parent           = hpBg
    Instance.new("UICorner", hpBar).CornerRadius = UDim.new(0, 2)

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

-- ══════════════════════════════════════════════════════════════════════════════
-- ── MISE À JOUR ESP CORRIGÉE ──────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local THICKNESS = 2
local HP_W      = 5

local function updateESP()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local obj  = espObjects[player]
        if not obj then continue end

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")

        if not root or not hum or hum.Health <= 0 then
            hideESP(player)
            continue
        end

        -- Calcul de la taille réelle du personnage
        local rootPos = root.Position
        local headPos = char:FindFirstChild("Head") and char.Head.Position or rootPos + Vector3.new(0, 2, 0)
        
        -- Points haut (tête + offset) et bas (pieds)
        local topWorld = headPos + Vector3.new(0, 0.5, 0)
        local botWorld = rootPos - Vector3.new(0, 2.5, 0) -- Ajusté pour les pieds

        local topScreen, topVis = Camera:WorldToScreenPoint(topWorld)
        local botScreen, botVis = Camera:WorldToScreenPoint(botWorld)

        if not topVis then
            hideESP(player)
            continue
        end

        -- Dimensions
        local h = math.abs(botScreen.Y - topScreen.Y)
        local w = h * 0.45
        local cx = (topScreen.X + botScreen.X) / 2
        local cy = (topScreen.Y + botScreen.Y) / 2

        local x1 = cx - w / 2
        local y1 = topScreen.Y
        local x2 = cx + w / 2
        local y2 = botScreen.Y

        -- Box
        obj.top.Size     = UDim2.fromOffset(w, THICKNESS)
        obj.top.Position = UDim2.fromOffset(x1, y1)
        obj.top.Visible  = true

        obj.bottom.Size     = UDim2.fromOffset(w, THICKNESS)
        obj.bottom.Position = UDim2.fromOffset(x1, y2)
        obj.bottom.Visible  = true

        obj.left.Size     = UDim2.fromOffset(THICKNESS, h)
        obj.left.Position = UDim2.fromOffset(x1, y1)
        obj.left.Visible  = true

        obj.right.Size     = UDim2.fromOffset(THICKNESS, h)
        obj.right.Position = UDim2.fromOffset(x2, y1)
        obj.right.Visible  = true

        -- Nom
        obj.nameLbl.Position = UDim2.fromOffset(cx - 75, y1 - 22)
        obj.nameLbl.Visible  = true

        -- Distance
        if myRoot then
            local dist = (root.Position - myRoot.Position).Magnitude
            obj.distLabel.Text = string.format("%.0fm", dist)
            obj.distLabel.Position = UDim2.fromOffset(cx - 50, y2 + 5)
            obj.distLabel.Visible = true
        end

        -- Barre de vie
        local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        obj.hpBg.Size     = UDim2.fromOffset(HP_W, h)
        obj.hpBg.Position = UDim2.fromOffset(x1 - HP_W - 4, y1)
        obj.hpBg.Visible  = true

        obj.hpBar.Size     = UDim2.new(1, 0, hpRatio, 0)
        obj.hpBar.Position = UDim2.new(0, 0, 1 - hpRatio, 0)
        
        -- Couleur dynamique
        if hpRatio > 0.7 then
            obj.hpBar.BackgroundColor3 = Color3.fromRGB(60, 220, 80)
        elseif hpRatio > 0.3 then
            obj.hpBar.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
        else
            obj.hpBar.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        end
        obj.hpBar.Visible = true
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ── GESTION JOUEURS ───────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
connections.playerAdded = Players.PlayerAdded:Connect(function(p)
    if espEnabled then 
        task.wait(0.1)
        createESP(p) 
    end
end)

connections.playerRemoving = Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- ── AIMLOCK ───────────────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
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
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            
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

-- ══════════════════════════════════════════════════════════════════════════════
-- ── TELEPORT TO PLAYER ────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function teleportToNearestPlayer()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local nearest = getNearestPlayer()
    if nearest then
        -- Teleport avec offset pour éviter de spawn dans le joueur
        local targetPos = nearest.Parent.HumanoidRootPart.Position
        myRoot.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, 3))
        
        -- Notification visuelle
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(0, 200, 0, 40)
        notif.Position = UDim2.new(0.5, -100, 0.1, 0)
        notif.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
        notif.BackgroundTransparency = 0.3
        notif.Text = "✓ Teleported to " .. nearest.Parent.Name
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.TextSize = 14
        notif.Font = Enum.Font.GothamBold
        notif.ZIndex = 100
        notif.Parent = ScreenGui
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
        
        TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
        task.wait(1.5)
        TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        task.wait(0.3)
        notif:Destroy()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ── BOUTONS ───────────────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
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

tpBtn.MouseButton1Click:Connect(function()
    teleportToNearestPlayer()
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- ── BOUCLE PRINCIPALE ─────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
connections.renderStepped = RunService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getNearestPlayer()
        if target then
            local targetPos = target.Position
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPos)
            
            if onScreen then
                local vp     = Camera.ViewportSize
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

-- ══════════════════════════════════════════════════════════════════════════════
-- ── NETTOYAGE ─────────────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
ScreenGui.Destroying:Connect(function()
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
end)

-- Animation d'entrée
MainContainer.Position = UDim2.new(0.5, -FRAME_W / 2, -0.5, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -FRAME_W / 2, 0.5, -FRAME_H / 2)
}):Play()

print("✨ Ultimate Toolkit loaded successfully!")
print("🎯 Features: AimLock • ESP • Teleport")
