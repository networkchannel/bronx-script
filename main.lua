-- Ultimate Toolkit
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")

local LP  = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local PGui = LP:WaitForChild("PlayerGui")

-- ===== VARIABLES AIMBOT =====
local AIMBOT_ENABLED = false
local currentTarget = nil
local FOV_SIZE = 150  -- Réduit à 150
local MAX_DISTANCE = 150  -- Augmenté à 150m
local SMOOTHNESS = 0.1  -- Amélioré pour plus de fluidité
local aimbotLoop = nil

-- Nettoyage
for _, g in ipairs(PGui:GetChildren()) do
    if g:IsA("ScreenGui") and g:GetAttribute("_TOOLKIT_SCRIPT") then
        pcall(function() g:Destroy() end)
    end
end
task.wait(0.05)

-- Constantes
local W, H   = 320, 340
local BG     = Color3.fromRGB(14, 16, 22)
local ACCENT = Color3.fromRGB(110, 130, 255)
local ROW_BG = Color3.fromRGB(22, 26, 36)
local TAB_H  = 36
local TI     = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Helpers
local function corner(r, p) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,r); c.Parent = p end
local function stroke(col, th, tr, p) local s = Instance.new("UIStroke"); s.Color=col; s.Thickness=th; s.Transparency=tr; s.Parent=p end
local function tw(o, props) TweenService:Create(o, TI, props):Play() end
local function lbl(txt, size, col, font, parent)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1; l.Text = txt; l.TextSize = size
    l.TextColor3 = col; l.Font = font or Enum.Font.GothamMedium; l.Parent = parent
    return l
end

-- ScreenGui
local Gui = Instance.new("ScreenGui")
Gui.Name = "ToolkitGui"; Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true; Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui:SetAttribute("_TOOLKIT_SCRIPT", true); Gui.Parent = PGui

-- Fenêtre
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(W, H)
Main.Position = UDim2.new(0.5,-W/2,0.5,-H/2)
Main.BackgroundColor3 = BG; Main.BorderSizePixel = 0; Main.ZIndex = 10; Main.Parent = Gui
corner(16, Main); stroke(Color3.fromRGB(50,60,85), 1, 0, Main)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,52); Header.BackgroundColor3 = Color3.fromRGB(18,22,32)
Header.BorderSizePixel = 0; Header.ZIndex = 11; Header.Parent = Main
corner(16, Header)

local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0,36,0,3); accentBar.Position = UDim2.new(0,16,0,0)
accentBar.BackgroundColor3 = ACCENT; accentBar.BorderSizePixel = 0; accentBar.ZIndex = 12; accentBar.Parent = Header
corner(3, accentBar)

local titleL = lbl("⚡ TOOLKIT", 16, Color3.fromRGB(240,240,255), Enum.Font.GothamBold, Header)
titleL.Size = UDim2.new(1,-16,0,52); titleL.Position = UDim2.new(0,16,0,0)
titleL.TextXAlignment = Enum.TextXAlignment.Left; titleL.ZIndex = 12

-- Tabs bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,-24,0,TAB_H)
TabBar.Position = UDim2.new(0,12,0,58)
TabBar.BackgroundColor3 = Color3.fromRGB(18,22,32)
TabBar.BorderSizePixel = 0; TabBar.ZIndex = 11; TabBar.Parent = Main
corner(10, TabBar)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,0); TabLayout.Parent = TabBar

-- Content area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1,-24,1,-110)
ContentArea.Position = UDim2.new(0,12,0,104)
ContentArea.BackgroundTransparency = 1; ContentArea.ZIndex = 11; ContentArea.Parent = Main

-- Tab system
local tabs = {}
local activeTab = nil

local function makeTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25,0,1,0) -- recalculé après création de tous les onglets
    btn.BackgroundTransparency = 1
    btn.Text = icon.." "..name
    btn.TextColor3 = Color3.fromRGB(120,130,160)
    btn.TextSize = 12; btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0; btn.ZIndex = 12; btn.Parent = TabBar

    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0,0,0,2)
    underline.Position = UDim2.new(0.5,0,1,-2)
    underline.AnchorPoint = Vector2.new(0.5,0)
    underline.BackgroundColor3 = ACCENT; underline.BorderSizePixel = 0
    underline.ZIndex = 13; underline.Parent = btn
    corner(1, underline)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1; page.Visible = false
    page.ZIndex = 11; page.Parent = ContentArea

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.FillDirection = Enum.FillDirection.Vertical
    pageLayout.Padding = UDim.new(0,8)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    local tab = {btn=btn, page=page, underline=underline}
    table.insert(tabs, tab)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            t.page.Visible = false
            tw(t.btn, {TextColor3 = Color3.fromRGB(120,130,160)})
            tw(t.underline, {Size = UDim2.new(0,0,0,2)})
        end
        page.Visible = true
        activeTab = tab
        tw(btn, {TextColor3 = Color3.fromRGB(255,255,255)})
        tw(underline, {Size = UDim2.new(0.7,0,0,2)})
    end)

    return page
end

local pageCombat   = makeTab("Combat",   "👁️")
local pageMovement = makeTab("Movement", "🚀")
local pageTeleport = makeTab("Teleport", "⚡")
local pageFarm     = makeTab("Farm",     "🌿")

for _, t in ipairs(tabs) do
    t.btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
end

tabs[1].page.Visible = true
activeTab = tabs[1]
tw(tabs[1].btn, {TextColor3 = Color3.fromRGB(255,255,255)})
tabs[1].underline.Size = UDim2.new(0.7,0,0,2)

-- Composants UI réutilisables
local function makeToggle(parent, icon, txt, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,50); row.BackgroundColor3 = ROW_BG
    row.BorderSizePixel = 0; row.LayoutOrder = order; row.ZIndex = 12; row.Parent = parent
    corner(12, row)

    local ico = lbl(icon, 20, ACCENT, Enum.Font.GothamBold, row)
    ico.Size = UDim2.fromOffset(36,50); ico.Position = UDim2.fromOffset(12,0); ico.ZIndex = 13

    local l = lbl(txt, 13, Color3.fromRGB(230,230,240), Enum.Font.GothamMedium, row)
    l.Size = UDim2.new(1,-120,1,0); l.Position = UDim2.fromOffset(54,0)
    l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 13

    local pill = Instance.new("TextButton")
    pill.Size = UDim2.fromOffset(48,26); pill.Position = UDim2.new(1,-58,0.5,-13)
    pill.BackgroundColor3 = Color3.fromRGB(35,40,55)
    pill.BorderSizePixel = 0; pill.Text = ""; pill.ZIndex = 13; pill.Parent = row
    corner(13, pill)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20,20); knob.Position = UDim2.fromOffset(3,3)
    knob.BackgroundColor3 = Color3.fromRGB(90,100,120)
    knob.BorderSizePixel = 0; knob.ZIndex = 14; knob.Parent = pill
    corner(10, knob)

    local on = false
    pill.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tw(pill, {BackgroundColor3 = ACCENT})
            tw(knob, {Position = UDim2.fromOffset(25,3), BackgroundColor3 = Color3.fromRGB(255,255,255)})
        else
            tw(pill, {BackgroundColor3 = Color3.fromRGB(35,40,55)})
            tw(knob, {Position = UDim2.fromOffset(3,3), BackgroundColor3 = Color3.fromRGB(90,100,120)})
        end
    end)
    return pill, function() return on end
end

local function makeBtn(parent, icon, txt, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,50); btn.BackgroundColor3 = ROW_BG
    btn.BorderSizePixel = 0; btn.Text = ""; btn.LayoutOrder = order; btn.ZIndex = 12; btn.Parent = parent
    corner(12, btn)

    local ico = lbl(icon, 20, ACCENT, Enum.Font.GothamBold, btn)
    ico.Size = UDim2.fromOffset(36,50); ico.Position = UDim2.fromOffset(12,0); ico.ZIndex = 13

    local l = lbl(txt, 13, Color3.fromRGB(230,230,240), Enum.Font.GothamMedium, btn)
    l.Size = UDim2.new(1,-60,1,0); l.Position = UDim2.fromOffset(54,0)
    l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 13

    btn.MouseEnter:Connect(function() tw(btn, {BackgroundColor3 = Color3.fromRGB(32,38,54)}) end)
    btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = ROW_BG}) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function makeSlider(parent, icon, txt, order, minV, maxV, defaultV, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,62); row.BackgroundColor3 = ROW_BG
    row.BorderSizePixel = 0; row.LayoutOrder = order; row.ZIndex = 12; row.Parent = parent
    corner(12, row)

    local ico = lbl(icon, 20, ACCENT, Enum.Font.GothamBold, row)
    ico.Size = UDim2.fromOffset(36,62); ico.Position = UDim2.fromOffset(12,0); ico.ZIndex = 13

    local valTxt = string.format(txt, defaultV)
    local titleLbl = lbl(valTxt, 13, Color3.fromRGB(230,230,240), Enum.Font.GothamMedium, row)
    titleLbl.Size = UDim2.new(1,-60,0,32); titleLbl.Position = UDim2.fromOffset(54,4)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.ZIndex = 13

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1,-66,0,6); trackBg.Position = UDim2.new(0,54,0,42)
    trackBg.BackgroundColor3 = Color3.fromRGB(35,40,55)
    trackBg.BorderSizePixel = 0; trackBg.ZIndex = 13; trackBg.Parent = row
    corner(3, trackBg)

    local fill = Instance.new("Frame")
    local t0 = (defaultV - minV) / (maxV - minV)
    fill.Size = UDim2.new(t0,0,1,0); fill.BackgroundColor3 = ACCENT
    fill.BorderSizePixel = 0; fill.ZIndex = 14; fill.Parent = trackBg
    corner(3, fill)

    local handle = Instance.new("TextButton")
    handle.Size = UDim2.fromOffset(16,16); handle.Position = UDim2.new(t0,-8,0.5,-8)
    handle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    handle.BorderSizePixel = 0; handle.Text = ""; handle.ZIndex = 15; handle.Parent = trackBg
    corner(8, handle)

    local dragging = false
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local t = math.clamp((inp.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(t,0,1,0)
        handle.Position = UDim2.new(t,-8,0.5,-8)
        local val = minV + t*(maxV-minV)
        titleLbl.Text = string.format(txt, val)
        onChange(val)
    end)
end

-- ===== FONCTIONS AIMBOT =====
local function isVisible(target)
    if not LP.Character or not LP.Character:FindFirstChild("Head") then return false end
    if not target.Character or not target.Character:FindFirstChild("Head") then return false end
    
    local myHead = LP.Character.Head
    local theirHead = target.Character.Head
    local ray = Ray.new(myHead.Position, (theirHead.Position - myHead.Position))
    local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character, target.Character})
    
    return hitPart == nil
end

local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myChar = LP.Character
    
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myPos = myChar.HumanoidRootPart.Position
    local screenCenter = Cam.ViewportSize / 2
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local theirChar = player.Character
            local theirHumanoid = theirChar:FindFirstChild("Humanoid")
            local theirHead = theirChar:FindFirstChild("Head")
            
            if theirHumanoid and theirHumanoid.Health > 0 and theirHead then
                local distance3D = (myPos - theirHead.Position).Magnitude
                
                if distance3D <= MAX_DISTANCE then
                    if isVisible(player) then
                        local screenPos, onScreen = Cam:WorldToViewportPoint(theirHead.Position)
                        
                        if onScreen then
                            local distance2D = math.sqrt(
                                (screenPos.X - screenCenter.X)^2 + 
                                (screenPos.Y - screenCenter.Y)^2
                            )
                            
                            if distance2D < FOV_SIZE and distance2D < shortestDistance then
                                shortestDistance = distance2D
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function isTargetValid(player)
    if not player or not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local head = player.Character:FindFirstChild("Head")
    
    if not humanoid or humanoid.Health <= 0 or not head then return false end
    
    local screenPos, onScreen = Cam:WorldToViewportPoint(head.Position)
    if not onScreen then return false end
    
    local screenCenter = Cam.ViewportSize / 2
    local distance = math.sqrt(
        (screenPos.X - screenCenter.X)^2 + 
        (screenPos.Y - screenCenter.Y)^2
    )
    
    return distance < FOV_SIZE
end

local function startAimbot()
    if aimbotLoop then return end
    
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    
    aimbotLoop = RunService.RenderStepped:Connect(function()
        if not AIMBOT_ENABLED then return end
        
        if currentTarget and not isTargetValid(currentTarget) then
            currentTarget = nil
        end
        
        if not currentTarget then
            currentTarget = getClosestPlayerInFOV()
        end
        
        if currentTarget and currentTarget.Character then
            local head = currentTarget.Character:FindFirstChild("Head")
            if head then
                local targetCFrame = CFrame.new(Cam.CFrame.Position, head.Position)
                Cam.CFrame = Cam.CFrame:Lerp(targetCFrame, SMOOTHNESS)
            end
        end
    end)
end

local function stopAimbot()
    if aimbotLoop then
        aimbotLoop:Disconnect()
        aimbotLoop = nil
    end
    
    currentTarget = nil
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

-- Keybind K pour toggle aimbot
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.K then
        AIMBOT_ENABLED = not AIMBOT_ENABLED
        
        if AIMBOT_ENABLED then
            startAimbot()
            print("✅ AIMBOT ON")
        else
            stopAimbot()
            print("❌ AIMBOT OFF")
        end
    end
end)
-- ===== FIN FONCTIONS AIMBOT =====

-- ===== DROPDOWN TP (inline, plus joli) =====
local dropListGlobal = nil

local function makeDropdown(parent, order)
    local outerFrame = Instance.new("Frame")
    outerFrame.Size = UDim2.new(1,0,0,50)
    outerFrame.BackgroundTransparency = 1
    outerFrame.BorderSizePixel = 0
    outerFrame.LayoutOrder = order
    outerFrame.ZIndex = 12
    outerFrame.ClipsDescendants = false
    outerFrame.Parent = parent

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,50)
    container.BackgroundColor3 = ROW_BG
    container.BorderSizePixel = 0
    container.ZIndex = 12
    container.Parent = outerFrame
    corner(12, container)

    local ico = lbl("👤", 20, ACCENT, Enum.Font.GothamBold, container)
    ico.Size = UDim2.fromOffset(36,50); ico.Position = UDim2.fromOffset(12,0); ico.ZIndex = 13

    local l = lbl("Teleport to Player", 13, Color3.fromRGB(230,230,240), Enum.Font.GothamMedium, container)
    l.Size = UDim2.new(1,-80,1,0); l.Position = UDim2.fromOffset(54,0)
    l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 13

    local arrow = lbl("▼", 12, Color3.fromRGB(120,130,160), Enum.Font.GothamBold, container)
    arrow.Size = UDim2.fromOffset(30,50); arrow.Position = UDim2.new(1,-36,0,0); arrow.ZIndex = 13

    local dropList = Instance.new("ScrollingFrame")
    dropList.BackgroundColor3 = Color3.fromRGB(18,22,32)
    dropList.BorderSizePixel = 0
    dropList.ScrollBarThickness = 3
    dropList.ScrollBarImageColor3 = ACCENT
    dropList.CanvasSize = UDim2.new(0,0,0,0)
    dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropList.ClipsDescendants = true
    dropList.Visible = false
    dropList.ZIndex = 50
    dropList.Size = UDim2.new(1,0,0,0)
    dropList.Position = UDim2.new(0,0,0,56)
    dropList.Parent = outerFrame
    corner(12, dropList)
    stroke(Color3.fromRGB(60,75,110), 1, 0, dropList)
    dropListGlobal = dropList

    local dL = Instance.new("UIListLayout"); dL.Padding = UDim.new(0,3); dL.Parent = dropList
    local dP = Instance.new("UIPadding")
    dP.PaddingTop=UDim.new(0,6); dP.PaddingBottom=UDim.new(0,6)
    dP.PaddingLeft=UDim.new(0,6); dP.PaddingRight=UDim.new(0,6); dP.Parent = dropList

    local isOpen = false

    local function close()
        if not isOpen then return end
        isOpen = false
        tw(arrow, {Rotation = 0})
        TweenService:Create(dropList, TI, {Size = UDim2.new(1,0,0,0)}):Play()
        task.delay(0.25, function()
            if not isOpen then
                dropList.Visible = false
                outerFrame.Size = UDim2.new(1,0,0,50)
            end
        end)
    end

    local function refreshList()
        for _, c in ipairs(dropList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            count += 1
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1,0,0,40)
            pBtn.BackgroundColor3 = Color3.fromRGB(25,30,42)
            pBtn.BorderSizePixel = 0
            pBtn.Text = "  👤  "..p.Name
            pBtn.TextColor3 = Color3.fromRGB(220,220,235)
            pBtn.TextSize = 13
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            pBtn.AutoButtonColor = false
            pBtn.ZIndex = 51
            pBtn.Parent = dropList
            corner(8, pBtn)
            local player = p
            pBtn.MouseEnter:Connect(function() tw(pBtn, {BackgroundColor3 = Color3.fromRGB(40,50,72)}) end)
            pBtn.MouseLeave:Connect(function() tw(pBtn, {BackgroundColor3 = Color3.fromRGB(25,30,42)}) end)
            pBtn.MouseButton1Click:Connect(function()
                local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local tRoot  = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and tRoot then
                    myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0,0,4))
                end
                close()
            end)
        end
        return count
    end

    local function resizeToCount(count)
        local h = math.min(count * 46 + 12, 200)
        outerFrame.Size = UDim2.new(1,0,0,50 + 6 + h)
        TweenService:Create(dropList, TI, {Size = UDim2.new(1,0,0,h)}):Play()
    end

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1,0,0,50)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.ZIndex = 14
    mainBtn.Parent = container

    mainBtn.MouseButton1Click:Connect(function()
        if isOpen then close(); return end
        isOpen = true
        local count = refreshList()
        local h = math.min(count * 46 + 12, 200)
        outerFrame.Size = UDim2.new(1,0,0,50 + 6 + h)
        dropList.Visible = true
        tw(arrow, {Rotation = 180})
        TweenService:Create(dropList, TI, {Size = UDim2.new(1,0,0,h)}):Play()
    end)

    UserInputService.InputBegan:Connect(function(inp)
        if not isOpen then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local mx, my = inp.Position.X, inp.Position.Y
        local op = outerFrame.AbsolutePosition; local os = outerFrame.AbsoluteSize
        if not (mx >= op.X and mx <= op.X + os.X and my >= op.Y and my <= op.Y + os.Y) then
            close()
        end
    end)

    Players.PlayerAdded:Connect(function()
        if not isOpen then return end
        local count = refreshList()
        resizeToCount(count)
    end)
    Players.PlayerRemoving:Connect(function()
        task.wait()
        if not isOpen then return end
        local count = refreshList()
        if count == 0 then close() else resizeToCount(count) end
    end)
end

-- ===== FOLLOW DROPDOWN =====
local followTarget     = nil
local followConn       = nil
local followActive     = false
local followDropGlobal = nil

local SHOOT_RATE = 0.01

local function makeFollowDropdown(parent, order)
    local outerFrame = Instance.new("Frame")
    outerFrame.Size = UDim2.new(1,0,0,50)
    outerFrame.BackgroundTransparency = 1
    outerFrame.BorderSizePixel = 0
    outerFrame.LayoutOrder = order
    outerFrame.ZIndex = 12
    outerFrame.ClipsDescendants = false
    outerFrame.Parent = parent

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,50)
    container.BackgroundColor3 = ROW_BG
    container.BorderSizePixel = 0
    container.ZIndex = 12
    container.Parent = outerFrame
    corner(12, container)

    local ico = lbl("🎯", 20, ACCENT, Enum.Font.GothamBold, container)
    ico.Size = UDim2.fromOffset(36,50); ico.Position = UDim2.fromOffset(12,0); ico.ZIndex = 13

    local statusLbl = lbl("Loop Kill", 13, Color3.fromRGB(230,230,240), Enum.Font.GothamMedium, container)
    statusLbl.Size = UDim2.new(1,-130,1,0); statusLbl.Position = UDim2.fromOffset(54,0)
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left; statusLbl.ZIndex = 13

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.fromOffset(36,26)
    stopBtn.Position = UDim2.new(1,-84,0.5,-13)
    stopBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
    stopBtn.BorderSizePixel = 0
    stopBtn.Text = "⛔"
    stopBtn.TextSize = 14
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
    stopBtn.Visible = false
    stopBtn.ZIndex = 20
    stopBtn.Parent = container
    corner(8, stopBtn)

    local arrow = lbl("▼", 12, Color3.fromRGB(120,130,160), Enum.Font.GothamBold, container)
    arrow.Size = UDim2.fromOffset(30,50); arrow.Position = UDim2.new(1,-36,0,0); arrow.ZIndex = 13

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1,-44,1,0)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.ZIndex = 14
    mainBtn.Parent = container

    local dropList = Instance.new("ScrollingFrame")
    dropList.BackgroundColor3 = Color3.fromRGB(18,22,32)
    dropList.BorderSizePixel = 0
    dropList.ScrollBarThickness = 3
    dropList.ScrollBarImageColor3 = ACCENT
    dropList.CanvasSize = UDim2.new(0,0,0,0)
    dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropList.ClipsDescendants = true
    dropList.Visible = false
    dropList.ZIndex = 50
    dropList.Size = UDim2.new(1,0,0,0)
    dropList.Position = UDim2.new(0,0,0,56)
    dropList.Parent = outerFrame
    corner(12, dropList)
    stroke(Color3.fromRGB(60,75,110), 1, 0, dropList)
    followDropGlobal = dropList

    local dL = Instance.new("UIListLayout"); dL.Padding = UDim.new(0,3); dL.Parent = dropList
    local dP = Instance.new("UIPadding")
    dP.PaddingTop=UDim.new(0,6); dP.PaddingBottom=UDim.new(0,6)
    dP.PaddingLeft=UDim.new(0,6); dP.PaddingRight=UDim.new(0,6); dP.Parent = dropList

    local isOpen = false

    local function close()
        if not isOpen then return end
        isOpen = false
        tw(arrow, {Rotation = 0})
        TweenService:Create(dropList, TI, {Size = UDim2.new(1,0,0,0)}):Play()
        task.delay(0.25, function()
            if not isOpen then
                dropList.Visible = false
                outerFrame.Size = UDim2.new(1,0,0,50)
            end
        end)
    end

    local function stopFollow()
        followActive = false
        if followConn then followConn:Disconnect(); followConn = nil end
        followTarget = nil
        statusLbl.Text       = "Loop Kill"
        statusLbl.TextColor3 = Color3.fromRGB(230,230,240)
        stopBtn.Visible      = false
        tw(container, {BackgroundColor3 = ROW_BG})
    end

    stopBtn.MouseButton1Click:Connect(function()
        stopFollow()
    end)

    local function startFollow(player)
        stopFollow()
        followTarget = player
        followActive = true
        statusLbl.Text       = "► "..player.Name
        statusLbl.TextColor3 = ACCENT
        stopBtn.Visible      = true
        tw(container, {BackgroundColor3 = Color3.fromRGB(20,28,46)})

        followConn = RunService.Heartbeat:Connect(function()
            if not followTarget or not followTarget.Parent then stopFollow(); return end
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local tChar  = followTarget.Character
            local tRoot  = tChar and tChar:FindFirstChild("HumanoidRootPart")
            local tHum   = tChar and tChar:FindFirstChildOfClass("Humanoid")
            if not (myRoot and tRoot) then return end
            if not tHum or tHum.Health <= 0 then stopFollow(); return end
            local dist = (myRoot.Position - tRoot.Position).Magnitude
            if dist > 1.5 then
                local targetCF = tRoot.CFrame * CFrame.new(0, 0, 1.5)
                myRoot.CFrame = CFrame.new(targetCF.Position, tRoot.Position)
            end
        end)

        task.spawn(function()
            while followActive do
                local char   = LP.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                if char and myRoot and followTarget then
                    local tool = char:FindFirstChild("Fists")
                    if not tool then
                        local bp = LP:FindFirstChild("Backpack")
                        if bp then
                            local t = bp:FindFirstChild("Fists")
                            if t then
                                local hum = char:FindFirstChildOfClass("Humanoid")
                                if hum then hum:EquipTool(t) end
                                task.wait(0.15)
                                tool = char:FindFirstChild("Fists")
                            end
                        end
                    end
                    local tChar = followTarget.Character
                    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    local tHum  = tChar and tChar:FindFirstChildOfClass("Humanoid")
                    if tool and tRoot and tHum and tHum.Health > 0 then
                        myRoot.CFrame = CFrame.new(myRoot.Position, tRoot.Position)
                        local remote = tool:FindFirstChildOfClass("RemoteEvent")
                        if remote then
                            remote:FireServer(tRoot.Position)
                        else
                            tool:Activate()
                        end
                    end
                end
                task.wait(SHOOT_RATE)
            end
        end)
    end

    local function refreshList()
        for _, c in ipairs(dropList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            count += 1
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1,0,0,40)
            pBtn.BackgroundColor3 = Color3.fromRGB(25,30,42)
            pBtn.BorderSizePixel = 0
            pBtn.Text = "  👤  "..p.Name
            pBtn.TextColor3 = Color3.fromRGB(220,220,235)
            pBtn.TextSize = 13
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            pBtn.AutoButtonColor = false
            pBtn.ZIndex = 51
            pBtn.Parent = dropList
            corner(8, pBtn)
            local player = p
            pBtn.MouseEnter:Connect(function() tw(pBtn, {BackgroundColor3 = Color3.fromRGB(40,50,72)}) end)
            pBtn.MouseLeave:Connect(function() tw(pBtn, {BackgroundColor3 = Color3.fromRGB(25,30,42)}) end)
            pBtn.MouseButton1Click:Connect(function() startFollow(player); close() end)
        end
        return count
    end

    mainBtn.MouseButton1Click:Connect(function()
        if isOpen then close(); return end
        isOpen = true
        local count = refreshList()
        local h = math.min(count * 46 + 12, 220)
        outerFrame.Size = UDim2.new(1,0,0,50 + 6 + h)
        dropList.Visible = true
        tw(arrow, {Rotation = 180})
        TweenService:Create(dropList, TI, {Size = UDim2.new(1,0,0,h)}):Play()
    end)

    UserInputService.InputBegan:Connect(function(inp)
        if not isOpen then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local mx, my = inp.Position.X, inp.Position.Y
        local op = outerFrame.AbsolutePosition; local os = outerFrame.AbsoluteSize
        if not (mx >= op.X and mx <= op.X + os.X and my >= op.Y and my <= op.Y + os.Y) then
            close()
        end
    end)

    local function resizeToCount(count)
        local h = math.min(count * 46 + 12, 220)
        outerFrame.Size = UDim2.new(1,0,0,50 + 6 + h)
        TweenService:Create(dropList, TI, {Size = UDim2.new(1,0,0,h)}):Play()
    end

    Players.PlayerAdded:Connect(function()
        if not isOpen then return end
        local count = refreshList()
        resizeToCount(count)
    end)
    Players.PlayerRemoving:Connect(function(p)
        if p == followTarget then stopFollow() end
        task.wait()
        if not isOpen then return end
        local count = refreshList()
        if count == 0 then close() else resizeToCount(count) end
    end)
end

-- ===== CONSTRUCTION PAR ONGLET =====

-- Onglet COMBAT
local espPill, espOn = makeToggle(pageCombat, "📊", "ESP", 1)

-- Toggle Aimbot (ordre 2)
local aimbotPill, aimbotOn = makeToggle(pageCombat, "🎯", "Aimbot [K]", 2)

-- Boucle pour synchroniser le toggle UI avec l'aimbot
RunService.RenderStepped:Connect(function()
    local shouldBeOn = aimbotOn()
    if shouldBeOn and not AIMBOT_ENABLED then
        AIMBOT_ENABLED = true
        startAimbot()
    elseif not shouldBeOn and AIMBOT_ENABLED then
        AIMBOT_ENABLED = false
        stopAimbot()
    end
end)

-- Onglet MOVEMENT
local flyConn = nil
local function startFly()
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    hum.PlatformStand = true
    local bv = Instance.new("BodyVelocity"); bv.MaxForce = Vector3.new(1e5,1e5,1e5); bv.Parent = root
    local bg = Instance.new("BodyGyro"); bg.MaxTorque = Vector3.new(1e5,1e5,1e5); bg.P = 1e4; bg.Parent = root
    flyConn = RunService.RenderStepped:Connect(function()
        if not root or not root.Parent then flyConn:Disconnect(); return end
        local cf = Cam.CFrame; local dir = Vector3.zero; local spd = 40
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Z) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * spd or Vector3.zero
        bg.CFrame = cf
    end)
end
local function stopFly()
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if root then for _, v in ipairs(root:GetChildren()) do if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end end end
        if hum then hum.PlatformStand = false end
    end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
end

local flyPill, flyOn = makeToggle(pageMovement, "🦅", "Fly  (WASD/ZQSD + Space)", 1)
flyPill.MouseButton1Click:Connect(function()
    task.defer(function() if flyOn() then startFly() else stopFly() end end)
end)
LP.CharacterAdded:Connect(function()
    if flyOn() then task.wait(0.5); startFly() end
end)

makeSlider(pageMovement, "💨", "Speed  ×%.1f", 2, 1, 10, 1, function(val)
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 16 * val end
end)

-- ===== NO CLIP =====
local noclipConn = nil
local function setNoClip(enabled)
    if enabled then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LP.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        local char = LP.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local noclipPill, noclipOn = makeToggle(pageMovement, "👻", "No Clip", 3)
noclipPill.MouseButton1Click:Connect(function()
    task.defer(function() setNoClip(noclipOn()) end)
end)
LP.CharacterAdded:Connect(function()
    if noclipOn() then task.wait(0.5); setNoClip(true) end
end)
-- ===== FIN NO CLIP =====

-- Onglet TELEPORT
makeBtn(pageTeleport, "🔫", "Go to Gun Store", 1, function()
    local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if r then r.CFrame = CFrame.new(6590.24, 3580.35, 2276.79) end
end)
makeBtn(pageTeleport, "🚗", "TP to Car", 2, function()
    local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if r then r.CFrame = CFrame.new(5626.6, 3580.4, 2309.6) end
end)
makeDropdown(pageTeleport, 3)
makeFollowDropdown(pageCombat, 3)

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
    if inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local d = Vector2.new(inp.Position.X, inp.Position.Y) - dStart
    local vp = Cam.ViewportSize
    Main.Position = UDim2.fromOffset(
        math.clamp(fStart.X + d.X, 0, vp.X - W),
        math.clamp(fStart.Y + d.Y, 0, vp.Y - H)
    )
end)

-- ESP
local espObjects = {}
local function playerColor(p)
    local h = 0
    for i = 1, #p.Name do h = (h + string.byte(p.Name, i)) % 360 end
    return Color3.fromHSV(h/360, 0.75, 1)
end
local function createESP(p)
    if espObjects[p] then return end
    local col = playerColor(p)
    local function line()
        local f = Instance.new("Frame"); f.BackgroundColor3=col; f.BorderSizePixel=0; f.ZIndex=5; f.Parent=Gui; return f
    end
    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundColor3=Color3.fromRGB(10,12,18); nameLbl.BackgroundTransparency=0.3
    nameLbl.TextColor3=col; nameLbl.TextSize=13; nameLbl.Font=Enum.Font.GothamBold
    nameLbl.Text=p.Name; nameLbl.TextStrokeTransparency=0.5; nameLbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
    nameLbl.Size=UDim2.fromOffset(120,20); nameLbl.ZIndex=6; nameLbl.Parent=Gui
    corner(4, nameLbl)
    local distLbl = Instance.new("TextLabel")
    distLbl.BackgroundTransparency=1; distLbl.TextColor3=Color3.fromRGB(200,200,210)
    distLbl.TextSize=11; distLbl.Font=Enum.Font.Gotham; distLbl.Text=""
    distLbl.TextStrokeTransparency=0.4; distLbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
    distLbl.Size=UDim2.fromOffset(80,16); distLbl.ZIndex=6; distLbl.Parent=Gui
    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3=Color3.fromRGB(15,17,22); hpBg.BorderSizePixel=0; hpBg.ZIndex=5; hpBg.Parent=Gui
    corner(3, hpBg)
    local hpBar = Instance.new("Frame")
    hpBar.BackgroundColor3=Color3.fromRGB(70,230,90); hpBar.BorderSizePixel=0; hpBar.ZIndex=6; hpBar.Parent=hpBg
    corner(3, hpBar)
    espObjects[p] = {t=line(),b=line(),l=line(),r=line(),name=nameLbl,dist=distLbl,hbg=hpBg,hbar=hpBar}
end
local function removeESP(p)
    local o = espObjects[p]; if not o then return end
    for _, v in pairs(o) do pcall(function() v:Destroy() end) end; espObjects[p] = nil
end
local function hideAll(o)
    for _, v in pairs(o) do pcall(function() v.Visible = false end) end
end
local function updateESP()
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local o = espObjects[p]; if not o then continue end
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then hideAll(o); continue end
        local head = char:FindFirstChild("Head")
        local topW = (head and head.Position or root.Position) + Vector3.new(0,0.7,0)
        local ts, tv = Cam:WorldToViewportPoint(topW)
        local bs     = Cam:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
        if not tv then hideAll(o); continue end
        local h = math.abs(bs.Y - ts.Y); local w = math.max(h*0.5,20)
        local cx = ts.X; local x1,x2,y1,y2 = cx-w/2,cx+w/2,ts.Y,bs.Y; local T = 1.5
        o.t.Size=UDim2.fromOffset(w+T*2,T); o.t.Position=UDim2.fromOffset(x1-T,y1); o.t.Visible=true
        o.b.Size=UDim2.fromOffset(w+T*2,T); o.b.Position=UDim2.fromOffset(x1-T,y2); o.b.Visible=true
        o.l.Size=UDim2.fromOffset(T,h);     o.l.Position=UDim2.fromOffset(x1-T,y1); o.l.Visible=true
        o.r.Size=UDim2.fromOffset(T,h);     o.r.Position=UDim2.fromOffset(x2,y1);   o.r.Visible=true
        o.name.Position=UDim2.fromOffset(cx-60,y1-24); o.name.Visible=true
        if myRoot then
            local dist = (root.Position-myRoot.Position).Magnitude
            o.dist.Text=string.format("%.0fm",dist); o.dist.Position=UDim2.fromOffset(cx-40,y2+4); o.dist.Visible=true
        end
        local hp = math.clamp(hum.Health/hum.MaxHealth,0,1)
        o.hbg.Size=UDim2.fromOffset(4,h); o.hbg.Position=UDim2.fromOffset(x1-9,y1); o.hbg.Visible=true
        o.hbar.Size=UDim2.new(1,0,hp,0); o.hbar.Position=UDim2.new(0,0,1-hp,0)
        o.hbar.BackgroundColor3 = hp>0.6 and Color3.fromRGB(80,230,100) or hp>0.3 and Color3.fromRGB(255,200,0) or Color3.fromRGB(230,60,60)
        o.hbar.Visible=true
    end
end

Players.PlayerAdded:Connect(function(p) if espOn() then task.wait(0.1); createESP(p) end end)
Players.PlayerRemoving:Connect(removeESP)
RunService.RenderStepped:Connect(function()
    if espOn() then updateESP() end
end)
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

-- ===== ONGLET FARM =====

-- Variables du farm
local DISTANCE_ACHAT  = -2
local DISTANCE_CUISSON = -1
local DISTANCE_VENTE  = -2
local farmActive = false

local function getFarmRoot()
    local char = LP.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getSpecificPotato()
    local mots = {"patate", "pomme", "potato"}
    local char = LP.Character
    local backpack = LP:FindFirstChild("Backpack")
    local function check(container)
        if not container then return nil end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local nom = string.lower(item.Name)
                for _, mot in ipairs(mots) do
                    if string.find(nom, mot) then return item end
                end
            end
        end
        return nil
    end
    return check(backpack) or check(char)
end

local function getStoves()
    local stoves = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and string.find(string.lower(obj.Parent.Name), "cook") then
            table.insert(stoves, obj)
        end
    end
    return stoves
end

local function farmTeleportTo(prompt, distance)
    local root = getFarmRoot()
    if not root then return end
    root.CFrame = prompt.Parent.CFrame * CFrame.new(0, 1, distance)
    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(
        prompt.Parent.Position.X, root.Position.Y, prompt.Parent.Position.Z))
    task.wait(0.5)
end

local function farmHoldPrompt(prompt)
    if not farmActive then return end
    Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, prompt.Parent.Position)
    local origLOS  = prompt.RequiresLineOfSight
    local origDist = prompt.MaxActivationDistance
    prompt.RequiresLineOfSight = false
    prompt.MaxActivationDistance = 50
    task.wait(0.1)
    prompt:InputHoldBegin()
    task.wait(prompt.HoldDuration + 0.2)
    prompt:InputHoldEnd()
    prompt.RequiresLineOfSight = origLOS
    prompt.MaxActivationDistance = origDist
end

local function runFarmCycle()
    local ok, err = pcall(function()
        local root = getFarmRoot()
        if not root then return end

        -- Récupère les prompts à chaque cycle (au cas où le workspace change)
        local potatoPrompt = workspace:FindFirstChild("GUNS") and
            workspace.GUNS:FindFirstChild("Potato") and
            workspace.GUNS.Potato:FindFirstChild("Prompt") and
            workspace.GUNS.Potato.Prompt:FindFirstChildOfClass("ProximityPrompt")
        local sellPrompt = workspace:FindFirstChild("Sell") and
            workspace.Sell:FindFirstChildOfClass("ProximityPrompt")
        if not potatoPrompt or not sellPrompt then
            warn("[Farm] Prompts introuvables dans le workspace.")
            return
        end

        -- 1. ACHAT
        if not farmActive then return end
        farmTeleportTo(potatoPrompt, DISTANCE_ACHAT)
        if not farmActive then return end
        farmHoldPrompt(potatoPrompt)

        -- 2. ATTENTE patate crue
        if not farmActive then return end
        local rawPotato = nil
        for i = 1, 10 do
            if not farmActive then return end
            task.wait(0.5)
            rawPotato = getSpecificPotato()
            if rawPotato then break end
        end
        if not rawPotato then warn("[Farm] Patate crue non reçue."); return end
        rawPotato.Parent = LP.Character

        -- 3. CUISSON
        if not farmActive then return end
        local cookedSuccess = false
        local stoves = getStoves()
        for _, stovePrompt in ipairs(stoves) do
            if not farmActive then return end
            farmTeleportTo(stovePrompt, DISTANCE_CUISSON)
            if not farmActive then return end
            root = getFarmRoot()
            if root then root.Anchored = true end
            farmHoldPrompt(stovePrompt)
            task.wait(1.5)
            if rawPotato.Parent ~= LP.Character and rawPotato.Parent ~= LP:FindFirstChild("Backpack") then
                cookedSuccess = true
                break
            else
                rawPotato.Parent = LP.Character
                if root then root.Anchored = false end
            end
        end
        if not cookedSuccess then
            if root then root.Anchored = false end
            warn("[Farm] Impossible de cuire.")
            return
        end

        -- 4. ATTENTE patate cuite
        if not farmActive then
            if root then root.Anchored = false end
            return
        end
        local cookedPotato = nil
        local timer = 0
        while not cookedPotato do
            if not farmActive then
                if root then root.Anchored = false end
                return
            end
            task.wait(0.5); timer += 0.5
            if timer > 9 then cookedPotato = getSpecificPotato() end
            if timer > 30 then
                if root then root.Anchored = false end
                warn("[Farm] Timeout cuisson.")
                return
            end
        end
        cookedPotato.Parent = LP.Character
        if root then root.Anchored = false end

        -- 5. VENTE
        if not farmActive then return end
        farmTeleportTo(sellPrompt, DISTANCE_VENTE)
        if not farmActive then return end
        farmHoldPrompt(sellPrompt)
    end)
    if not ok then warn("[Farm] Erreur cycle : " .. tostring(err)) end
end

-- Toggle Farm UI avec label de statut
local farmRow = Instance.new("Frame")
farmRow.Size = UDim2.new(1,0,0,50); farmRow.BackgroundColor3 = ROW_BG
farmRow.BorderSizePixel = 0; farmRow.LayoutOrder = 1; farmRow.ZIndex = 12; farmRow.Parent = pageFarm
corner(12, farmRow)

local farmIco = lbl("🥔", 20, ACCENT, Enum.Font.GothamBold, farmRow)
farmIco.Size = UDim2.fromOffset(36,50); farmIco.Position = UDim2.fromOffset(12,0); farmIco.ZIndex = 13

local farmLbl = lbl("Auto Farm Potato", 13, Color3.fromRGB(230,230,240), Enum.Font.GothamMedium, farmRow)
farmLbl.Size = UDim2.new(1,-120,1,0); farmLbl.Position = UDim2.fromOffset(54,0)
farmLbl.TextXAlignment = Enum.TextXAlignment.Left; farmLbl.ZIndex = 13

local farmPill = Instance.new("TextButton")
farmPill.Size = UDim2.fromOffset(48,26); farmPill.Position = UDim2.new(1,-58,0.5,-13)
farmPill.BackgroundColor3 = Color3.fromRGB(35,40,55)
farmPill.BorderSizePixel = 0; farmPill.Text = ""; farmPill.ZIndex = 13; farmPill.Parent = farmRow
corner(13, farmPill)

local farmKnob = Instance.new("Frame")
farmKnob.Size = UDim2.fromOffset(20,20); farmKnob.Position = UDim2.fromOffset(3,3)
farmKnob.BackgroundColor3 = Color3.fromRGB(90,100,120)
farmKnob.BorderSizePixel = 0; farmKnob.ZIndex = 14; farmKnob.Parent = farmPill
corner(10, farmKnob)

-- Label statut sous le toggle
local farmStatus = lbl("En attente...", 11, Color3.fromRGB(100,110,140), Enum.Font.Gotham, pageFarm)
farmStatus.Size = UDim2.new(1,0,0,20); farmStatus.LayoutOrder = 2
farmStatus.TextXAlignment = Enum.TextXAlignment.Center; farmStatus.ZIndex = 12

farmPill.MouseButton1Click:Connect(function()
    farmActive = not farmActive
    if farmActive then
        tw(farmPill, {BackgroundColor3 = Color3.fromRGB(80, 200, 80)})
        tw(farmKnob, {Position = UDim2.fromOffset(25,3), BackgroundColor3 = Color3.fromRGB(255,255,255)})
        farmLbl.TextColor3 = Color3.fromRGB(100,255,100)
        -- Boucle farm dans un thread séparé
        task.spawn(function()
            while farmActive do
                farmStatus.Text = "🔄 Cycle en cours..."
                runFarmCycle()
                if farmActive then
                    farmStatus.Text = "✅ Cycle terminé ! Relance..."
                    task.wait(0.5)
                end
            end
            farmStatus.Text = "⏹ Arrêté."
        end)
    else
        tw(farmPill, {BackgroundColor3 = Color3.fromRGB(35,40,55)})
        tw(farmKnob, {Position = UDim2.fromOffset(3,3), BackgroundColor3 = Color3.fromRGB(90,100,120)})
        farmLbl.TextColor3 = Color3.fromRGB(230,230,240)
        -- Débloque le perso si anchored
        local root = getFarmRoot()
        if root then root.Anchored = false end
    end
end)
-- ===== FIN FARM =====

-- Entrée animée
Main.Position = UDim2.new(0.5,-W/2,-0.5,0)
TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5,-W/2,0.5,-H/2)
}):Play()

print("✅ Toolkit chargé")
