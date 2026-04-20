-- Ultimate Toolkit | UI propre, code compact
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local PGui = LP:WaitForChild("PlayerGui")

-- Détruit uniquement nos propres GUIs (signature _TOOLKIT_SCRIPT)
local function destroyAllExistingUIs()
    for _, g in ipairs(PGui:GetChildren()) do
        if g:IsA("ScreenGui") and g:GetAttribute("_TOOLKIT_SCRIPT") then
            pcall(function() g:Destroy() end)
        end
    end
    task.wait(0.05)
end
destroyAllExistingUIs()

-- Constantes
local W, H = 300, 280
local BG     = Color3.fromRGB(14, 16, 22)
local ACCENT = Color3.fromRGB(110, 130, 255)
local ROW_BG = Color3.fromRGB(22, 26, 36)
local TI     = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Helpers
local function corner(r, p)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end
local function stroke(col, th, tr, p)
    local s = Instance.new("UIStroke"); s.Color = col; s.Thickness = th; s.Transparency = tr; s.Parent = p
end
local function tween(obj, props) TweenService:Create(obj, TI, props):Play() end
local function label(txt, size, col, font, parent)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = txt; l.TextSize = size; l.TextColor3 = col
    l.Font = font or Enum.Font.GothamMedium
    l.Parent = parent
    return l
end

-- GUI root
local Gui = Instance.new("ScreenGui")
Gui.Name = "ToolkitGui"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui:SetAttribute("_TOOLKIT_SCRIPT", true)
Gui.Parent = PGui

-- Conteneur principal
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(W, H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.ZIndex = 10
Main.Parent = Gui
corner(16, Main)
stroke(Color3.fromRGB(50, 60, 85), 1, 0, Main)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
Header.BorderSizePixel = 0
Header.ZIndex = 11
Header.Parent = Main
corner(16, Header)

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 36, 0, 3)
Accent.Position = UDim2.new(0, 16, 0, 0)
Accent.BackgroundColor3 = ACCENT
Accent.BorderSizePixel = 0
Accent.ZIndex = 12
Accent.Parent = Header
corner(3, Accent)

local titleLbl = label("⚡ TOOLKIT", 16, Color3.fromRGB(240, 240, 255), Enum.Font.GothamBold, Header)
titleLbl.Size = UDim2.new(1, -16, 0, 52)
titleLbl.Position = UDim2.new(0, 16, 0, 0)
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12

local subLbl = label("ESP • Teleport", 11, Color3.fromRGB(100, 110, 140), Enum.Font.Gotham, Header)
subLbl.Size = UDim2.new(1, -16, 0, 52)
subLbl.Position = UDim2.new(0, 16, 0, 22)
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 12

-- Contenu
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -64)
Content.Position = UDim2.new(0, 12, 0, 58)
Content.BackgroundTransparency = 1
Content.ZIndex = 11
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Content

-- Toggle row
local function makeToggle(icon, txt)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = ROW_BG
    row.BorderSizePixel = 0
    row.ZIndex = 11
    row.Parent = Content
    corner(12, row)

    local ico = label(icon, 20, ACCENT, Enum.Font.GothamBold, row)
    ico.Size = UDim2.fromOffset(36, 50)
    ico.Position = UDim2.fromOffset(12, 0)
    ico.ZIndex = 12

    local lbl = label(txt, 14, Color3.fromRGB(230, 230, 240), Enum.Font.GothamMedium, row)
    lbl.Size = UDim2.new(1, -120, 1, 0)
    lbl.Position = UDim2.fromOffset(54, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12

    local pill = Instance.new("TextButton")
    pill.Size = UDim2.fromOffset(48, 26)
    pill.Position = UDim2.new(1, -58, 0.5, -13)
    pill.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    pill.BorderSizePixel = 0
    pill.Text = ""
    pill.ZIndex = 12
    pill.Parent = row
    corner(13, pill)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = Color3.fromRGB(90, 100, 120)
    knob.BorderSizePixel = 0
    knob.ZIndex = 13
    knob.Parent = pill
    corner(10, knob)

    local on = false
    pill.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tween(pill, {BackgroundColor3 = ACCENT})
            tween(knob, {Position = UDim2.fromOffset(25, 3), BackgroundColor3 = Color3.fromRGB(255,255,255)})
        else
            tween(pill, {BackgroundColor3 = Color3.fromRGB(35, 40, 55)})
            tween(knob, {Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Color3.fromRGB(90,100,120)})
        end
    end)

    return pill, function() return on end
end

-- Dropdown teleport
-- Le dropList est dans Gui (ScreenGui) pour éviter tout clipping
-- Sa position est recalculée à chaque ouverture ET à chaque drag
local dropListGlobal = nil
local dropContainerGlobal = nil

local function makeDropdown()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = ROW_BG
    container.BorderSizePixel = 0
    container.ZIndex = 11
    container.Parent = Content
    corner(12, container)

    local ico = label("⚡", 20, ACCENT, Enum.Font.GothamBold, container)
    ico.Size = UDim2.fromOffset(36, 50)
    ico.Position = UDim2.fromOffset(12, 0)
    ico.ZIndex = 12

    local lbl = label("Teleport", 14, Color3.fromRGB(230, 230, 240), Enum.Font.GothamMedium, container)
    lbl.Size = UDim2.new(1, -80, 0, 50)
    lbl.Position = UDim2.fromOffset(54, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12

    local arrow = label("▼", 12, Color3.fromRGB(120, 130, 160), Enum.Font.GothamBold, container)
    arrow.Size = UDim2.fromOffset(30, 50)
    arrow.Position = UDim2.new(1, -36, 0, 0)
    arrow.ZIndex = 12

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 50)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.ZIndex = 13
    mainBtn.Parent = container

    -- ScrollingFrame pour la liste (dans Gui = pas de clipping)
    local dropList = Instance.new("ScrollingFrame")
    dropList.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    dropList.BorderSizePixel = 0
    dropList.ScrollBarThickness = 3
    dropList.ScrollBarImageColor3 = ACCENT
    dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropList.ClipsDescendants = true
    dropList.Visible = false
    dropList.ZIndex = 100
    dropList.Size = UDim2.fromOffset(0, 0)
    dropList.Parent = Gui
    corner(12, dropList)
    stroke(Color3.fromRGB(60, 75, 110), 1, 0, dropList)

    local dLayout = Instance.new("UIListLayout")
    dLayout.FillDirection = Enum.FillDirection.Vertical
    dLayout.Padding = UDim.new(0, 3)
    dLayout.Parent = dropList

    local dPad = Instance.new("UIPadding")
    dPad.PaddingTop    = UDim.new(0, 6)
    dPad.PaddingBottom = UDim.new(0, 6)
    dPad.PaddingLeft   = UDim.new(0, 6)
    dPad.PaddingRight  = UDim.new(0, 6)
    dPad.Parent = dropList

    dropListGlobal      = dropList
    dropContainerGlobal = container

    local isOpen = false

    local function getDropGeometry(h)
        h = h or 200
        local mp = Main.AbsolutePosition
        local ms = Main.AbsoluteSize
        local vp = Cam.ViewportSize
        local w  = ms.X
        local x  = mp.X
        -- Toujours en dehors de la fenêtre principale : en dessous ou au-dessus
        local yBelow = mp.Y + ms.Y + 6
        local yAbove = mp.Y - h - 6
        local y
        if yBelow + h <= vp.Y then
            y = yBelow
        elseif yAbove >= 0 then
            y = yAbove
        else
            y = yBelow -- fallback
        end
        return x, y, w
    end

    local function refreshList()
        for _, c in ipairs(dropList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local others = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(others, p) end
        end
        for _, player in ipairs(others) do
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 40)
            pBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
            pBtn.BorderSizePixel = 0
            pBtn.Text = "  👤  " .. player.Name
            pBtn.TextColor3 = Color3.fromRGB(220, 220, 235)
            pBtn.TextSize = 13
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            pBtn.AutoButtonColor = false
            pBtn.ZIndex = 101
            pBtn.Parent = dropList
            corner(8, pBtn)

            pBtn.MouseEnter:Connect(function()
                tween(pBtn, {BackgroundColor3 = Color3.fromRGB(40, 50, 72)})
            end)
            pBtn.MouseLeave:Connect(function()
                tween(pBtn, {BackgroundColor3 = Color3.fromRGB(25, 30, 42)})
            end)
            pBtn.MouseButton1Click:Connect(function()
                local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local tRoot  = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and tRoot then
                    myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 0, 4))
                end
            end)
        end
        return #others
    end

    local function closeDropdown()
        if not isOpen then return end
        isOpen = false
        local _, _, w = getDropGeometry()
        tween(arrow, {Rotation = 0})
        TweenService:Create(dropList, TI, {Size = UDim2.fromOffset(w, 0)}):Play()
        task.delay(0.25, function() if not isOpen then dropList.Visible = false end end)
    end

    local function openDropdown()
        if isOpen then return end
        isOpen = true
        local count = refreshList()
        local h = math.min(count * 46 + 12, 200)
        local x, y, w = getDropGeometry(h)
        dropList.Position = UDim2.fromOffset(x, y)
        dropList.Size     = UDim2.fromOffset(w, 0)
        dropList.Visible  = true
        tween(arrow, {Rotation = 180})
        TweenService:Create(dropList, TI, {Size = UDim2.fromOffset(w, h)}):Play()
    end

    mainBtn.MouseButton1Click:Connect(function()
        if isOpen then closeDropdown() else openDropdown() end
    end)

    -- Clic en dehors = fermeture
    UserInputService.InputBegan:Connect(function(inp)
        if not isOpen then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local mx, my = inp.Position.X, inp.Position.Y
        -- Vérifie si le clic est dans le dropList
        local dp = dropList.AbsolutePosition
        local ds = dropList.AbsoluteSize
        local inDrop = mx >= dp.X and mx <= dp.X + ds.X and my >= dp.Y and my <= dp.Y + ds.Y
        -- Vérifie si le clic est dans le mainBtn
        local cp = container.AbsolutePosition
        local cs = container.AbsoluteSize
        local inBtn = mx >= cp.X and mx <= cp.X + cs.X and my >= cp.Y and my <= cp.Y + cs.Y
        if not inDrop and not inBtn then
            closeDropdown()
        end
    end)

    Players.PlayerAdded:Connect(function()   if isOpen then refreshList() end end)
    Players.PlayerRemoving:Connect(function() if isOpen then refreshList() end end)
end

-- Construction UI
local espPill, espOn = makeToggle("📊", "ESP")

makeDropdown()

-- Bouton Gun Store
local gunBtn = Instance.new("TextButton")
gunBtn.Size = UDim2.new(1, 0, 0, 50)
gunBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
gunBtn.BorderSizePixel = 0
gunBtn.Text = ""
gunBtn.ZIndex = 11
gunBtn.Parent = Content
corner(12, gunBtn)
stroke(Color3.fromRGB(60, 75, 110), 1, 0.5, gunBtn)

local gunIco = label("🔫", 20, ACCENT, Enum.Font.GothamBold, gunBtn)
gunIco.Size = UDim2.fromOffset(36, 50)
gunIco.Position = UDim2.fromOffset(12, 0)
gunIco.ZIndex = 12

local gunLbl = label("Go to Gun Store", 14, Color3.fromRGB(230, 230, 240), Enum.Font.GothamMedium, gunBtn)
gunLbl.Size = UDim2.new(1, -60, 1, 0)
gunLbl.Position = UDim2.fromOffset(54, 0)
gunLbl.TextXAlignment = Enum.TextXAlignment.Left
gunLbl.ZIndex = 12

gunBtn.MouseEnter:Connect(function() tween(gunBtn, {BackgroundColor3 = Color3.fromRGB(35, 42, 60)}) end)
gunBtn.MouseLeave:Connect(function() tween(gunBtn, {BackgroundColor3 = Color3.fromRGB(22, 26, 36)}) end)
gunBtn.MouseButton1Click:Connect(function()
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if myRoot then
        myRoot.CFrame = CFrame.new(6590.24, 3580.35, 2276.79)
    end
end)

-- Drag
local dragging, dStart, fStart = false, Vector2.zero, Vector2.zero
Header.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dStart = Vector2.new(inp.Position.X, inp.Position.Y)
        fStart = Vector2.new(Main.AbsolutePosition.X, Main.AbsolutePosition.Y)
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if not dragging then return end
    if inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d  = Vector2.new(inp.Position.X, inp.Position.Y) - dStart
        local vp = Cam.ViewportSize
        Main.Position = UDim2.fromOffset(
            math.clamp(fStart.X + d.X, 0, vp.X - W),
            math.clamp(fStart.Y + d.Y, 0, vp.Y - H)
        )
        -- Suit le dropdown si ouvert
        if dropListGlobal and dropListGlobal.Visible and dropContainerGlobal then
            local ap = dropContainerGlobal.AbsolutePosition
            local as = dropContainerGlobal.AbsoluteSize
            dropListGlobal.Position = UDim2.fromOffset(ap.X, ap.Y + as.Y + 6)
        end
    end
end)

-- ESP
local espObjects = {}

local function playerColor(p)
    local h = 0
    for i = 1, #p.Name do h = (h + string.byte(p.Name, i)) % 360 end
    return Color3.fromHSV(h / 360, 0.75, 1)
end

local function createESP(p)
    if espObjects[p] then return end
    local col = playerColor(p)

    local function line()
        local f = Instance.new("Frame")
        f.BackgroundColor3 = col
        f.BorderSizePixel  = 0
        f.ZIndex = 5
        f.Parent = Gui
        return f
    end

    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundColor3      = Color3.fromRGB(10, 12, 18)
    nameLbl.BackgroundTransparency = 0.3
    nameLbl.TextColor3            = col
    nameLbl.TextSize              = 13
    nameLbl.Font                  = Enum.Font.GothamBold
    nameLbl.Text                  = p.Name
    nameLbl.TextStrokeTransparency = 0.5
    nameLbl.TextStrokeColor3      = Color3.fromRGB(0, 0, 0)
    nameLbl.Size                  = UDim2.fromOffset(120, 20)
    nameLbl.ZIndex = 6
    nameLbl.Parent = Gui
    corner(4, nameLbl)

    local distLbl = Instance.new("TextLabel")
    distLbl.BackgroundTransparency = 1
    distLbl.TextColor3  = Color3.fromRGB(200, 200, 210)
    distLbl.TextSize    = 11
    distLbl.Font        = Enum.Font.Gotham
    distLbl.Text        = ""
    distLbl.TextStrokeTransparency = 0.4
    distLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLbl.Size  = UDim2.fromOffset(80, 16)
    distLbl.ZIndex = 6
    distLbl.Parent = Gui

    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
    hpBg.BorderSizePixel  = 0
    hpBg.ZIndex = 5
    hpBg.Parent = Gui
    corner(3, hpBg)

    local hpBar = Instance.new("Frame")
    hpBar.BackgroundColor3 = Color3.fromRGB(70, 230, 90)
    hpBar.BorderSizePixel  = 0
    hpBar.ZIndex = 6
    hpBar.Parent = hpBg
    corner(3, hpBar)

    espObjects[p] = {t=line(), b=line(), l=line(), r=line(), name=nameLbl, dist=distLbl, hbg=hpBg, hbar=hpBar}
end

local function removeESP(p)
    local o = espObjects[p]
    if not o then return end
    for _, v in pairs(o) do pcall(function() v:Destroy() end) end
    espObjects[p] = nil
end

local function hideAll(o)
    for _, v in pairs(o) do pcall(function() v.Visible = false end) end
end

local function updateESP()
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local o = espObjects[p]
        if not o then continue end
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then hideAll(o); continue end

        local head = char:FindFirstChild("Head")
        local topW = (head and head.Position or root.Position) + Vector3.new(0, 0.7, 0)
        local botW = root.Position - Vector3.new(0, 3, 0)
        local ts, tv = Cam:WorldToViewportPoint(topW)
        local bs     = Cam:WorldToViewportPoint(botW)
        if not tv then hideAll(o); continue end

        local h  = math.abs(bs.Y - ts.Y)
        local w  = math.max(h * 0.5, 20)
        local cx = ts.X
        local x1, x2 = cx - w/2, cx + w/2
        local y1, y2 = ts.Y, bs.Y
        local T = 1.5

        o.t.Size = UDim2.fromOffset(w + T*2, T); o.t.Position = UDim2.fromOffset(x1-T, y1); o.t.Visible = true
        o.b.Size = UDim2.fromOffset(w + T*2, T); o.b.Position = UDim2.fromOffset(x1-T, y2); o.b.Visible = true
        o.l.Size = UDim2.fromOffset(T, h);       o.l.Position = UDim2.fromOffset(x1-T, y1); o.l.Visible = true
        o.r.Size = UDim2.fromOffset(T, h);       o.r.Position = UDim2.fromOffset(x2,   y1); o.r.Visible = true

        o.name.Position = UDim2.fromOffset(cx - 60, y1 - 24); o.name.Visible = true

        if myRoot then
            local dist = (root.Position - myRoot.Position).Magnitude
            o.dist.Text     = string.format("%.0fm", dist)
            o.dist.Position = UDim2.fromOffset(cx - 40, y2 + 4)
            o.dist.Visible  = true
        end

        local HP_W = 4
        local hp   = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        o.hbg.Size     = UDim2.fromOffset(HP_W, h)
        o.hbg.Position = UDim2.fromOffset(x1 - HP_W - 5, y1)
        o.hbg.Visible  = true
        o.hbar.Size     = UDim2.new(1, 0, hp, 0)
        o.hbar.Position = UDim2.new(0, 0, 1 - hp, 0)
        o.hbar.BackgroundColor3 = hp > 0.6 and Color3.fromRGB(80,230,100)
            or hp > 0.3 and Color3.fromRGB(255,200,0)
            or Color3.fromRGB(230,60,60)
        o.hbar.Visible = true
    end
end

-- Connexions ESP
Players.PlayerAdded:Connect(function(p)
    if espOn() then task.wait(0.1); createESP(p) end
end)
Players.PlayerRemoving:Connect(removeESP)

-- RenderStepped
RunService.RenderStepped:Connect(function()
    if espOn() then updateESP() end
end)

-- Toggle ESP
espPill.MouseButton1Click:Connect(function()
    task.defer(function()
        if espOn() then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then task.spawn(createESP, p) end
            end
        else
            for p in pairs(espObjects) do removeESP(p) end
        end
    end)
end)

-- Entrée animée
Main.Position = UDim2.new(0.5, -W/2, -0.5, 0)
TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
}):Play()

print("✅ Toolkit chargé")
