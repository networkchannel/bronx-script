-- AimLock + ESP LocalScript AMÉLIORÉ
-- Place dans StarterPlayerScripts

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ══════════════════════════════════════════════════════════════════════════════
-- ── DESTRUCTION COMPLÈTE DES UI EXISTANTES ───────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function destroyAllExistingUIs()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Détruit toutes les instances de notre GUI
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "AimLockGui" then
            gui:Destroy()
        end
    end
    
    -- Nettoie aussi les ESP orphelins
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("Folder") and child.Name:match("^ESP_") then
                    child:Destroy()
                end
                -- Nettoie les éléments ESP directement dans le ScreenGui
                if child:IsA("Frame") and (
                    child.BackgroundColor3 == Color3.fromRGB(255, 60, 60) or
                    child.BackgroundColor3 == Color3.fromRGB(30, 30, 30)
                ) then
                    child:Destroy()
                end
                if child:IsA("TextLabel") and child.TextStrokeTransparency == 0.4 then
                    child:Destroy()
                end
            end
        end
    end
    
    -- Attend un frame pour être sûr que tout est détruit
    task.wait()
end

-- Exécute le nettoyage avant de créer la nouvelle UI
destroyAllExistingUIs()

-- ══════════════════════════════════════════════════════════════════════════════
-- ── CRÉATION DE L'UI UNIQUE ───────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "AimLockGui"
ScreenGui.ResetOnSpawn    = false
ScreenGui.IgnoreGuiInset  = true
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent          = LocalPlayer.PlayerGui

local FRAME_W, FRAME_H = 180, 110

local Frame = Instance.new("Frame")
Frame.Size            = UDim2.new(0, FRAME_W, 0, FRAME_H)
Frame.Position        = UDim2.new(0.5, -FRAME_W / 2, 0.5, -FRAME_H / 2)
Frame.BackgroundColor3= Color3.fromRGB(18, 18, 22)
Frame.BorderSizePixel = 0
Frame.Active          = true
Frame.ZIndex          = 10
Frame.Parent          = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Ombre portée
local Shadow = Instance.new("ImageLabel")
Shadow.Size                   = UDim2.new(1, 20, 1, 20)
Shadow.Position               = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image                  = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3            = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency      = 0.7
Shadow.ScaleType              = Enum.ScaleType.Slice
Shadow.SliceCenter            = Rect.new(10, 10, 10, 10)
Shadow.ZIndex                 = 9
Shadow.Parent                 = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color     = Color3.fromRGB(60, 60, 68)
Stroke.Thickness = 1
Stroke.Parent    = Frame

-- Header avec titre
local Header = Instance.new("Frame")
Header.Size              = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3  = Color3.fromRGB(25, 25, 30)
Header.BorderSizePixel   = 0
Header.ZIndex            = 11
Header.Parent            = Frame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size                 = UDim2.new(1, -20, 1, 0)
Title.Position             = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text                 = "⚡ AimLock & ESP"
Title.TextColor3           = Color3.fromRGB(255, 255, 255)
Title.TextSize             = 15
Title.Font                 = Enum.Font.GothamBold
Title.TextXAlignment       = Enum.TextXAlignment.Left
Title.ZIndex               = 12
Title.Parent               = Header

-- Conteneur pour les options
local Container = Instance.new("Frame")
Container.Size              = UDim2.new(1, 0, 1, -32)
Container.Position          = UDim2.new(0, 0, 0, 32)
Container.BackgroundTransparency = 1
Container.ZIndex            = 11
Container.Parent            = Frame

-- Layout vertical
local Layout = Instance.new("UIListLayout")
Layout.FillDirection  = Enum.FillDirection.Vertical
Layout.Padding        = UDim.new(0, 2)
Layout.Parent         = Container

-- ══════════════════════════════════════════════════════════════════════════════
-- ── HELPER : Crée une ligne toggle améliorée ─────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function makeRow(labelText, icon)
    local row = Instance.new("Frame")
    row.Size              = UDim2.new(1, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.ZIndex            = 11
    row.Parent            = Container

    local lbl = Instance.new("TextLabel")
    lbl.Size                 = UDim2.new(0.6, 0, 1, 0)
    lbl.Position             = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                 = (icon or "") .. " " .. labelText
    lbl.TextColor3           = Color3.fromRGB(220, 220, 220)
    lbl.TextSize             = 14
    lbl.Font                 = Enum.Font.GothamMedium
    lbl.TextXAlignment       = Enum.TextXAlignment.Left
    lbl.ZIndex               = 12
    lbl.Parent               = row

    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 50, 0, 26)
    btn.Position         = UDim2.new(1, -60, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    btn.BorderSizePixel  = 0
    btn.Text             = ""
    btn.ZIndex           = 12
    btn.Parent           = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 20, 0, 20)
    knob.Position         = UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(130, 130, 135)
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 13
    knob.Parent           = btn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    return btn, knob
end

local aimBtn,  aimKnob  = makeRow("AimLock", "🎯")
local espBtn,  espKnob  = makeRow("ESP", "👁️")

-- ══════════════════════════════════════════════════════════════════════════════
-- ── DRAG AMÉLIORÉ avec limites d'écran ───────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local dragging, dragStart, frameStart = false, Vector2.new(), Vector2.new()

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging   = true
        dragStart  = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(Frame.AbsolutePosition.X, Frame.AbsolutePosition.Y)
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
        Frame.Position = UDim2.fromOffset(newX, newY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- ── ÉTAT ──────────────────────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local aimEnabled = false
local espEnabled = false
local smoothing  = 0.18  -- Smoothing amélioré pour un aim plus naturel

local espObjects = {} -- { [player] = { top, bottom, left, right, nameLbl, hpBg, hpBar } }
local connections = {} -- Pour stocker les connections et les nettoyer proprement

-- ══════════════════════════════════════════════════════════════════════════════
-- ── TOGGLE VISUEL AMÉLIORÉ avec animation ────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")

local function setVisual(btn, knob, state)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if state then
        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30, 110, 60)}):Play()
        TweenService:Create(knob, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(74, 222, 128),
            Position = UDim2.new(0, 27, 0.5, -10)
        }):Play()
    else
        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
        TweenService:Create(knob, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(130, 130, 135),
            Position = UDim2.new(0, 3, 0.5, -10)
        }):Play()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ── ESP : Création des éléments par joueur OPTIMISÉE ─────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local function createESP(player)
    if espObjects[player] then return end

    local function makeLine()
        local f = Instance.new("Frame")
        f.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        f.BorderSizePixel  = 0
        f.ZIndex           = 5
        f.Parent           = ScreenGui
        return f
    end

    local top    = makeLine()
    local bottom = makeLine()
    local left   = makeLine()
    local right  = makeLine()

    -- Nom avec meilleur contraste
    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3             = Color3.fromRGB(255, 255, 255)
    nameLbl.TextSize               = 14
    nameLbl.Font                   = Enum.Font.GothamBold
    nameLbl.Text                   = player.Name
    nameLbl.TextStrokeTransparency = 0.3
    nameLbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    nameLbl.Size                   = UDim2.new(0, 120, 0, 18)
    nameLbl.ZIndex                 = 6
    nameLbl.Parent                 = ScreenGui

    -- Barre de vie améliorée
    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
        nameLbl = nameLbl, hpBg = hpBg, hpBar = hpBar
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
-- ── MISE À JOUR ESP OPTIMISÉE ─────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
local THICKNESS = 2     -- Épaisseur augmentée pour meilleure visibilité
local HP_W      = 5     -- Largeur de barre de vie augmentée

local function updateESP()
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

        local pos     = root.Position
        local topWorld = pos + Vector3.new(0, 3.5, 0)
        local botWorld = pos - Vector3.new(0, 3.2, 0)

        local topScreen, topVis = Camera:WorldToScreenPoint(topWorld)
        local botScreen, botVis = Camera:WorldToScreenPoint(botWorld)

        if not topVis or not botVis then
            hideESP(player)
            continue
        end

        local h = math.abs(topScreen.Y - botScreen.Y)
        local w = h * 0.5
        local cx = topScreen.X
        local cy = (topScreen.Y + botScreen.Y) / 2

        local x1 = cx - w / 2
        local y1 = cy - h / 2
        local x2 = cx + w / 2
        local y2 = cy + h / 2

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

        -- Nom centré
        obj.nameLbl.Position = UDim2.fromOffset(cx - 60, y1 - 20)
        obj.nameLbl.Visible  = true

        -- Barre de vie
        local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        obj.hpBg.Size     = UDim2.fromOffset(HP_W, h)
        obj.hpBg.Position = UDim2.fromOffset(x1 - HP_W - 4, y1)
        obj.hpBg.Visible  = true

        obj.hpBar.Size     = UDim2.new(1, 0, hpRatio, 0)
        obj.hpBar.Position = UDim2.new(0, 0, 1 - hpRatio, 0)
        
        -- Couleur dynamique de la vie
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
-- ── GESTION DES JOUEURS ───────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
connections.playerAdded = Players.PlayerAdded:Connect(function(p)
    if espEnabled then 
        task.wait(0.1) -- Petit délai pour s'assurer que le personnage est chargé
        createESP(p) 
    end
end)

connections.playerRemoving = Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- ── AIMLOCK AMÉLIORÉ ──────────────────────────────────────────────────────────
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
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            
            if root and head and hum and hum.Health > 0 then
                -- Calcul de distance à l'écran pour un meilleur ciblage
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
-- ── BOUTONS AVEC FEEDBACK ─────────────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    setVisual(aimBtn, aimKnob, aimEnabled)
    if not aimEnabled then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
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

-- ══════════════════════════════════════════════════════════════════════════════
-- ── BOUCLE PRINCIPALE OPTIMISÉE ───────────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
connections.renderStepped = RunService.RenderStepped:Connect(function()
    -- AimLock
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

    -- ESP
    if espEnabled then
        updateESP()
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- ── NETTOYAGE LORS DE LA DESTRUCTION ──────────────────────────────────────────
-- ══════════════════════════════════════════════════════════════════════════════
ScreenGui.Destroying:Connect(function()
    -- Déconnecte toutes les connections
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    
    -- Nettoie tous les ESP
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
end)

print("✅ AimLock & ESP chargé avec succès!")
