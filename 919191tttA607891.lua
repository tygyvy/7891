-- ============================================================
--  A-60 客户端脚本 v10
--  星光十字架 + Doors 原版封印 + 预兆红光 + Ambush 穿梭
--  放置：StarterPlayer > StarterPlayerScripts > LocalScript
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris           = game:GetService("Debris")
local Lighting         = game:GetService("Lighting")

local player    = Players.LocalPlayer
local camera    = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
--  配置
-- ============================================================
local CONFIG = {
    spawnDistance    = 100,
    passDistance     = 80,
    dashSpeed        = 220,
    minReactionTime  = 1.0,
    maxReactionTime  = 2.0,
    shakeIntensity   = 0.35,
    shakeDuration    = 0.22,
    jumpFlashTime    = 1.4,
    contactRadius    = 6,
    omenDuration     = 1.6,   -- 预兆时长

    soundStatic      = "rbxassetid://4903742660",
    soundDash        = "rbxassetid://78206015664727",
    soundJumpscare   = "rbxassetid://132942725846535",
    soundSeal        = "rbxassetid://5153775199", -- 神圣封印音
}

-- ============================================================
--  保存原始 Lighting（用于预兆恢复）
-- ============================================================
local origLighting = {
    Ambient        = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogColor       = Lighting.FogColor,
    FogEnd         = Lighting.FogEnd,
}

-- 预兆 ColorCorrection
local omenCC = Instance.new("ColorCorrectionEffect")
omenCC.Name = "A60_Omen"
omenCC.TintColor = Color3.fromRGB(255, 255, 255)
omenCC.Saturation = 0
omenCC.Contrast = 0
omenCC.Brightness = 0
omenCC.Parent = Lighting

-- ============================================================
--  预兆系统
-- ============================================================
local function startOmen(duration)
    TweenService:Create(omenCC, TweenInfo.new(duration, Enum.EasingStyle.Quad), {
        TintColor  = Color3.fromRGB(255, 110, 110),
        Saturation = 0.25,
        Contrast   = 0.15,
        Brightness = -0.08,
    }):Play()

    TweenService:Create(Lighting, TweenInfo.new(duration, Enum.EasingStyle.Quad), {
        Ambient        = Color3.fromRGB(65, 15, 15),
        OutdoorAmbient = Color3.fromRGB(90, 20, 20),
        FogColor       = Color3.fromRGB(130, 30, 30),
        FogEnd         = 140,
    }):Play()
end

local function endOmen(duration)
    TweenService:Create(omenCC, TweenInfo.new(duration, Enum.EasingStyle.Quad), {
        TintColor  = Color3.fromRGB(255, 255, 255),
        Saturation = 0,
        Contrast   = 0,
        Brightness = 0,
    }):Play()

    TweenService:Create(Lighting, TweenInfo.new(duration, Enum.EasingStyle.Quad), {
        Ambient        = origLighting.Ambient,
        OutdoorAmbient = origLighting.OutdoorAmbient,
        FogColor       = origLighting.FogColor,
        FogEnd         = origLighting.FogEnd,
    }):Play()
end

-- ============================================================
--  屏幕震动
-- ============================================================
local shakeActive = false
local shakeOffset = CFrame.new()

local function playShake(intensity, duration)
    if shakeActive then return end
    shakeActive = true
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        t = t + dt
        if t >= duration then
            shakeActive = false
            shakeOffset = CFrame.new()
            conn:Disconnect()
            return
        end
        local decay = 1 - (t / duration)
        local rnd = Vector3.new(
            (math.random() - 0.5) * 2,
            (math.random() - 0.5) * 2,
            0
        )
        shakeOffset = CFrame.new(rnd * intensity * decay)
    end)
end

RunService.RenderStepped:Connect(function()
    if shakeActive then
        camera.CFrame = camera.CFrame * shakeOffset
    end
end)

-- ============================================================
--  UI 面板
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "A60_Panel"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 190, 0, 116)
panel.Position = UDim2.new(1, -205, 1, -135)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = screenGui

local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 12)
pCorner.Parent = panel

local pStroke = Instance.new("UIStroke")
pStroke.Color = Color3.fromRGB(140, 30, 30)
pStroke.Thickness = 1.5
pStroke.Transparency = 0.2
pStroke.Parent = panel

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 26)
topBar.BackgroundTransparency = 1
topBar.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "A-60"
title.TextColor3 = Color3.fromRGB(230, 70, 70)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
minimizeBtn.Position = UDim2.new(1, -26, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = topBar

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(1, 0)
mCorner.Parent = minimizeBtn

local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(1, -20, 0, 32)
spawnBtn.Position = UDim2.new(0, 10, 0, 30)
spawnBtn.BackgroundColor3 = Color3.fromRGB(150, 25, 25)
spawnBtn.Text = "召唤 A-60"
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 14
spawnBtn.AutoButtonColor = false
spawnBtn.Parent = panel

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 8)
sCorner.Parent = spawnBtn

local crossBtn = Instance.new("TextButton")
crossBtn.Size = UDim2.new(1, -20, 0, 32)
crossBtn.Position = UDim2.new(0, 10, 0, 68)
crossBtn.BackgroundColor3 = Color3.fromRGB(55, 50, 90)
crossBtn.Text = "✝ 获取十字架"
crossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
crossBtn.Font = Enum.Font.GothamBold
crossBtn.TextSize = 14
crossBtn.AutoButtonColor = false
crossBtn.Parent = panel

local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0, 8)
cCorner.Parent = crossBtn

local miniBall = Instance.new("TextButton")
miniBall.Size = UDim2.new(0, 44, 0, 44)
miniBall.Position = UDim2.new(1, -60, 1, -60)
miniBall.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
miniBall.Text = "A60"
miniBall.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBall.Font = Enum.Font.GothamBold
miniBall.TextSize = 13
miniBall.Visible = false
miniBall.AutoButtonColor = false
miniBall.Parent = screenGui

local bCorner = Instance.new("UICorner")
bCorner.CornerRadius = UDim.new(1, 0)
bCorner.Parent = miniBall

-- ============================================================
--  拖动
-- ============================================================
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(panel, topBar)
makeDraggable(miniBall, miniBall)

-- ============================================================
--  折叠 / 展开
-- ============================================================
local minimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = true
    miniBall.Position = panel.Position
    panel.Visible = false
    miniBall.Visible = true
end)

miniBall.MouseButton1Click:Connect(function()
    if not minimized then return end
    minimized = false
    panel.Visible = true
    miniBall.Visible = false
end)

local function pressEffect(btn)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08),
            {BackgroundTransparency = 0.3}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12),
            {BackgroundTransparency = 0}):Play()
    end)
end
pressEffect(spawnBtn)
pressEffect(crossBtn)
pressEffect(minimizeBtn)

-- ============================================================
--  A-60 模型
-- ============================================================
local function createA60Model(pos, facingDir)
    local model = Instance.new("Model")
    model.Name = "A60"

    local headCF = CFrame.lookAt(pos, pos + facingDir)

    local head = Instance.new("Part")
    head.Name = "Head"
    head.Shape = Enum.PartType.Ball
    head.Size = Vector3.new(5.5, 5.5, 5)
    head.CFrame = headCF
    head.Anchored = true
    head.CanCollide = false
    head.Material = Enum.Material.Neon
    head.Color = Color3.fromRGB(215, 30, 30)
    head.Transparency = 0.25
    head.Parent = model

    local fog = Instance.new("Part")
    fog.Name = "Fog"
    fog.Shape = Enum.PartType.Ball
    fog.Size = Vector3.new(7.5, 7.5, 7.5)
    fog.CFrame = headCF
    fog.Anchored = true
    fog.CanCollide = false
    fog.Material = Enum.Material.ForceField
    fog.Color = Color3.fromRGB(255, 0, 0)
    fog.Transparency = 0.75
    fog.Parent = model

    local eyeL = Instance.new("Part")
    eyeL.Name = "EyeL"
    eyeL.Shape = Enum.PartType.Ball
    eyeL.Size = Vector3.new(1.7, 1.5, 0.8)
    eyeL.CFrame = headCF * CFrame.new(-1.3, 0.9, -2.2)
    eyeL.Anchored = true
    eyeL.CanCollide = false
    eyeL.Material = Enum.Material.SmoothPlastic
    eyeL.Color = Color3.fromRGB(0, 0, 0)
    eyeL.Parent = model

    local eyeR = Instance.new("Part")
    eyeR.Name = "EyeR"
    eyeR.Shape = Enum.PartType.Ball
    eyeR.Size = Vector3.new(1.7, 1.5, 0.8)
    eyeR.CFrame = headCF * CFrame.new(1.3, 0.9, -2.2)
    eyeR.Anchored = true
    eyeR.CanCollide = false
    eyeR.Material = Enum.Material.SmoothPlastic
    eyeR.Color = Color3.fromRGB(0, 0, 0)
    eyeR.Parent = model

    local mouthBlack = Instance.new("Part")
    mouthBlack.Name = "MouthBlack"
    mouthBlack.Shape = Enum.PartType.Ball
    mouthBlack.Size = Vector3.new(4.4, 2.6, 0.7)
    mouthBlack.CFrame = headCF * CFrame.new(0, -1.1, -2.1)
    mouthBlack.Anchored = true
    mouthBlack.CanCollide = false
    mouthBlack.Material = Enum.Material.SmoothPlastic
    mouthBlack.Color = Color3.fromRGB(0, 0, 0)
    mouthBlack.Parent = model

    local mouthCover = Instance.new("Part")
    mouthCover.Name = "MouthCover"
    mouthCover.Shape = Enum.PartType.Ball
    mouthCover.Size = Vector3.new(4.6, 2.2, 0.75)
    mouthCover.CFrame = headCF * CFrame.new(0, -0.15, -2.09)
    mouthCover.Anchored = true
    mouthCover.CanCollide = false
    mouthCover.Material = Enum.Material.Neon
    mouthCover.Color = Color3.fromRGB(215, 30, 30)
    mouthCover.Parent = model

    local light = Instance.new("PointLight")
    light.Brightness = 7
    light.Range = 28
    light.Color = Color3.fromRGB(255, 30, 30)
    light.Parent = head

    local att = Instance.new("Attachment")
    att.Parent = head

    local pe = Instance.new("ParticleEmitter")
    pe.Texture = "rbxassetid://243660364"
    pe.Rate = 70
    pe.Lifetime = NumberRange.new(0.6, 1.3)
    pe.Speed = NumberRange.new(4, 9)
    pe.SpreadAngle = Vector2.new(180, 180)
    pe.Color = ColorSequence.new(Color3.fromRGB(255, 20, 20))
    pe.Size = NumberSequence.new(1, 0)
    pe.Transparency = NumberSequence.new(0.15, 1)
    pe.Parent = att

    model.PrimaryPart = head
    return {
        model = model,
        head = head,
        fog = fog,
        eyeL = eyeL,
        eyeR = eyeR,
        mouthBlack = mouthBlack,
        mouthCover = mouthCover,
        light = light,
        particle = pe,
    }
end

local function updateA60Parts(refs, newPos, dir)
    local cf = CFrame.lookAt(newPos, newPos + dir)
    refs.head.CFrame = cf
    refs.fog.CFrame = cf
    refs.eyeL.CFrame = cf * CFrame.new(-1.3, 0.9, -2.2)
    refs.eyeR.CFrame = cf * CFrame.new(1.3, 0.9, -2.2)
    refs.mouthBlack.CFrame = cf * CFrame.new(0, -1.1, -2.1)
    refs.mouthCover.CFrame = cf * CFrame.new(0, -0.15, -2.09)
end

-- ============================================================
--  柜子检测（8 种方式）
-- ============================================================
local function isHidden()
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    local ok1, v1 = pcall(function() return humanoid:GetAttribute("InLocker") end)
    if ok1 and v1 then return true end

    local ok2, v2 = pcall(function() return humanoid:GetAttribute("Hiding") end)
    if ok2 and v2 then return true end

    local ok3, v3 = pcall(function() return char:GetAttribute("InLocker") end)
    if ok3 and v3 then return true end

    if char:FindFirstChild("InLocker") or char:FindFirstChild("Hiding") then
        return true
    end

    local okTag1 = pcall(function()
        if char:HasTag("InLocker") or char:HasTag("Hiding") then
            error("hidden")
        end
    end)
    if not okTag1 then return true end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local parts = workspace:GetPartBoundsInRadius(root.Position, 15)
    for _, p in ipairs(parts) do
        local n = p.Name:lower()
        if n:find("locker") or n:find("closet")
            or n:find("wardrobe") or n:find("cabinet") then
            return true
        end
        local okTag2, has = pcall(function() return p:HasTag("Locker") end)
        if okTag2 and has then return true end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= char then
            local n = obj.Name:lower()
            if n:find("locker") or n:find("closet") or n:find("wardrobe") then
                for _, d in ipairs(obj:GetDescendants()) do
                    if d:IsA("BasePart") then
                        local rel = d.CFrame:PointToObjectSpace(root.Position)
                        if math.abs(rel.X) < d.Size.X/2 + 1
                            and math.abs(rel.Y) < d.Size.Y/2 + 1
                            and math.abs(rel.Z) < d.Size.Z/2 + 1 then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

-- ============================================================
--  跳杀 + 封印闪光
-- ============================================================
local redGui = Instance.new("ScreenGui")
redGui.Name = "A60_Red"
redGui.ResetOnSpawn = false
redGui.IgnoreGuiInset = true
redGui.DisplayOrder = 999
redGui.Parent = playerGui

local redFrame = Instance.new("Frame")
redFrame.Size = UDim2.new(1, 0, 1, 0)
redFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
redFrame.BackgroundTransparency = 1
redFrame.BorderSizePixel = 0
redFrame.Parent = redGui

local sealFrame = Instance.new("Frame")
sealFrame.Size = UDim2.new(1, 0, 1, 0)
sealFrame.BackgroundColor3 = Color3.fromRGB(255, 250, 220)
sealFrame.BackgroundTransparency = 1
sealFrame.BorderSizePixel = 0
sealFrame.ZIndex = 2
sealFrame.Parent = redGui

local function triggerJumpscare()
    local s = Instance.new("Sound")
    s.SoundId = CONFIG.soundJumpscare
    s.Volume = 5
    s.Parent = playerGui
    s:Play()
    Debris:AddItem(s, 3)

    redFrame.BackgroundTransparency = 0
    task.wait(CONFIG.jumpFlashTime)
    TweenService:Create(redFrame, TweenInfo.new(0.8),
        {BackgroundTransparency = 1}):Play()

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end
end

-- Doors 原版封印闪光：双击金光 → 全屏泛白
local function triggerSealFlash()
    -- 双击
    for _ = 1, 2 do
        sealFrame.BackgroundTransparency = 0
        task.wait(0.07)
        sealFrame.BackgroundTransparency = 0.55
        task.wait(0.07)
    end
    -- 泛白淡化
    sealFrame.BackgroundTransparency = 0
    TweenService:Create(sealFrame, TweenInfo.new(1.1, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 1}):Play()

    local s = Instance.new("Sound")
    s.SoundId = CONFIG.soundSeal
    s.Volume = 5
    s.Parent = playerGui
    s:Play()
    Debris:AddItem(s, 4)
end

-- ============================================================
--  封印阵法（保留）
-- ============================================================
local function createSealCircle(position)
    local sealModel = Instance.new("Model")
    sealModel.Name = "A60_SealCircle"

    local outerRing = Instance.new("Part")
    outerRing.Shape = Enum.PartType.Cylinder
    outerRing.Size = Vector3.new(0.12, 16, 16)
    outerRing.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
    outerRing.Anchored = true
    outerRing.CanCollide = false
    outerRing.Material = Enum.Material.Neon
    outerRing.Color = Color3.fromRGB(255, 215, 80)
    outerRing.Transparency = 0.25
    outerRing.Parent = sealModel

    local midRing = Instance.new("Part")
    midRing.Shape = Enum.PartType.Cylinder
    midRing.Size = Vector3.new(0.12, 12, 12)
    midRing.CFrame = CFrame.new(position + Vector3.new(0, 0.05, 0)) * CFrame.Angles(0, 0, math.rad(90))
    midRing.Anchored = true
    midRing.CanCollide = false
    midRing.Material = Enum.Material.Neon
    midRing.Color = Color3.fromRGB(255, 240, 150)
    midRing.Transparency = 0.2
    midRing.Parent = sealModel

    local innerRing = Instance.new("Part")
    innerRing.Shape = Enum.PartType.Cylinder
    innerRing.Size = Vector3.new(0.12, 8, 8)
    innerRing.CFrame = CFrame.new(position + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, 0, math.rad(90))
    innerRing.Anchored = true
    innerRing.CanCollide = false
    innerRing.Material = Enum.Material.Neon
    innerRing.Color = Color3.fromRGB(255, 215, 80)
    innerRing.Transparency = 0.15
    innerRing.Parent = sealModel

    local runes = {}
    for i = 1, 8 do
        local angle = (i / 8) * math.pi * 2
        local x = math.cos(angle) * 7
        local z = math.sin(angle) * 7
        local rune = Instance.new("Part")
        rune.Shape = Enum.PartType.Ball
        rune.Size = Vector3.new(0.9, 0.9, 0.9)
        rune.Position = position + Vector3.new(x, 0.2, z)
        rune.Anchored = true
        rune.CanCollide = false
        rune.Material = Enum.Material.Neon
        rune.Color = Color3.fromRGB(255, 240, 150)
        rune.Transparency = 0.1
        rune.Parent = sealModel
        table.insert(runes, rune)
    end

    local pillar = Instance.new("Part")
    pillar.Size = Vector3.new(7, 40, 7)
    pillar.Position = position + Vector3.new(0, 20, 0)
    pillar.Anchored = true
    pillar.CanCollide = false
    pillar.Material = Enum.Material.ForceField
    pillar.Color = Color3.fromRGB(255, 230, 130)
    pillar.Transparency = 0.75
    pillar.Parent = sealModel

    local corePillar = Instance.new("Part")
    corePillar.Size = Vector3.new(2.5, 40, 2.5)
    corePillar.Position = position + Vector3.new(0, 20, 0)
    corePillar.Anchored = true
    corePillar.CanCollide = false
    corePillar.Material = Enum.Material.Neon
    corePillar.Color = Color3.fromRGB(255, 255, 220)
    corePillar.Transparency = 0.5
    corePillar.Parent = sealModel

    local coreAtt = Instance.new("Attachment")
    coreAtt.Parent = corePillar
    local coreParticle = Instance.new("ParticleEmitter")
    coreParticle.Texture = "rbxassetid://243660364"
    coreParticle.Rate = 120
    coreParticle.Lifetime = NumberRange.new(0.6, 1.2)
    coreParticle.Speed = NumberRange.new(15, 30)
    coreParticle.SpreadAngle = Vector2.new(15, 15)
    coreParticle.Color = ColorSequence.new(Color3.fromRGB(255, 240, 150))
    coreParticle.Size = NumberSequence.new(0.8, 0)
    coreParticle.Transparency = NumberSequence.new(0.1, 1)
    coreParticle.LightEmission = 1
    coreParticle.Parent = coreAtt

    local spinning = true
    task.spawn(function()
        local t = 0
        while spinning and sealModel.Parent do
            local dt = RunService.Heartbeat:Wait()
            t = t + dt
            outerRing.CFrame = CFrame.new(position)
                * CFrame.Angles(0, t * 2, 0)
                * CFrame.Angles(0, 0, math.rad(90))
            midRing.CFrame = CFrame.new(position + Vector3.new(0, 0.05, 0))
                * CFrame.Angles(0, -t * 2.5, 0)
                * CFrame.Angles(0, 0, math.rad(90))
            innerRing.CFrame = CFrame.new(position + Vector3.new(0, 0.1, 0))
                * CFrame.Angles(0, t * 3.2, 0)
                * CFrame.Angles(0, 0, math.rad(90))

            for idx, rune in ipairs(runes) do
                local angle = (idx / 8) * math.pi * 2 + t * 1.5
                local x = math.cos(angle) * 7
                local z = math.sin(angle) * 7
                rune.Position = position + Vector3.new(x, 0.2 + math.sin(t * 4 + idx) * 0.3, z)
            end
        end
    end)

    return sealModel, function() spinning = false end
end

-- ============================================================
--  封印 A-60（Doors 原版效果 + 阵法）
-- ============================================================
local function sealA60(refs)
    -- 全屏金光双击
    triggerSealFlash()

    -- 十字架爆发金光
    local char = player.Character
    if char then
        local tool = char:FindFirstChild("Crucifix")
        if tool then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                local light = handle:FindFirstChildOfClass("PointLight")
                if light then
                    TweenService:Create(light, TweenInfo.new(0.3), {
                        Brightness = 60, Range = 60
                    }):Play()
                    task.delay(0.9, function()
                        TweenService:Create(light, TweenInfo.new(0.6), {
                            Brightness = 5, Range = 12
                        }):Play()
                    end)
                end

                local bAtt = Instance.new("Attachment")
                bAtt.Parent = handle
                local burst = Instance.new("ParticleEmitter")
                burst.Texture = "rbxassetid://243660364"
                burst.Rate = 0
                burst.Lifetime = NumberRange.new(0.6, 1.3)
                burst.Speed = NumberRange.new(20, 40)
                burst.SpreadAngle = Vector2.new(180, 180)
                burst.Color = ColorSequence.new(Color3.fromRGB(255, 240, 150))
                burst.Size = NumberSequence.new(1.5, 0)
                burst.Transparency = NumberSequence.new(0, 1)
                burst.LightEmission = 1
                burst.Parent = bAtt
                burst:Emit(150)
            end
        end
    end

    if refs.particle then refs.particle.Enabled = false end

    -- 阵法
    local centerPos = refs.head.Position
    local groundPos = Vector3.new(centerPos.X, centerPos.Y - 3, centerPos.Z)
    local sealModel, stopSpin = createSealCircle(groundPos)

    -- A-60 被拉入阵法
    local targetPos = groundPos + Vector3.new(0, 4, 0)
    local startPos = refs.head.Position
    local startTime = tick()
    local pullDuration = 0.8

    task.spawn(function()
        while tick() - startTime < pullDuration do
            RunService.Heartbeat:Wait()
            local alpha = math.min((tick() - startTime) / pullDuration, 1)
            local newPos = startPos:Lerp(targetPos, alpha)
            local dir = (targetPos - startPos)
            if dir.Magnitude < 0.1 then
                dir = Vector3.new(0, 0, -1)
            else
                dir = dir.Unit
            end
            updateA60Parts(refs, newPos, dir)
        end
    end)

    -- A-60 身上金色爆发
    local sealAtt = Instance.new("Attachment")
    sealAtt.Parent = refs.head
    local burst = Instance.new("ParticleEmitter")
    burst.Texture = "rbxassetid://243660364"
    burst.Rate = 0
    burst.Lifetime = NumberRange.new(0.6, 1.2)
    burst.Speed = NumberRange.new(15, 25)
    burst.SpreadAngle = Vector2.new(180, 180)
    burst.Color = ColorSequence.new(Color3.fromRGB(255, 230, 150))
    burst.Size = NumberSequence.new(1, 0)
    burst.Transparency = NumberSequence.new(0.1, 1)
    burst.LightEmission = 1
    burst.Parent = sealAtt
    burst:Emit(100)

    local flashLight = Instance.new("PointLight")
    flashLight.Color = Color3.fromRGB(255, 230, 150)
    flashLight.Brightness = 12
    flashLight.Range = 40
    flashLight.Parent = refs.head

    task.wait(pullDuration)

    TweenService:Create(flashLight, TweenInfo.new(1),
        {Brightness = 0, Range = 5}):Play()

    local gold = Color3.fromRGB(255, 230, 150)
    TweenService:Create(refs.head, TweenInfo.new(0.9),
        {Color = gold, Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
    TweenService:Create(refs.eyeL, TweenInfo.new(0.9),
        {Color = gold, Transparency = 1}):Play()
    TweenService:Create(refs.eyeR, TweenInfo.new(0.9),
        {Color = gold, Transparency = 1}):Play()
    TweenService:Create(refs.mouthBlack, TweenInfo.new(0.9),
        {Color = gold, Transparency = 1}):Play()
    TweenService:Create(refs.mouthCover, TweenInfo.new(0.9),
        {Color = gold, Transparency = 1}):Play()
    TweenService:Create(refs.fog, TweenInfo.new(0.9),
        {Color = gold, Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
    if refs.light then
        TweenService:Create(refs.light, TweenInfo.new(0.9),
            {Brightness = 0, Range = 0}):Play()
    end

    task.delay(1.2, function()
        stopSpin()
        for _, d in ipairs(sealModel:GetDescendants()) do
            if d:IsA("BasePart") then
                TweenService:Create(d, TweenInfo.new(0.6),
                    {Transparency = 1}):Play()
            end
        end
        task.wait(0.7)
        sealModel:Destroy()
    end)

    task.delay(1.0, function()
        if refs.model and refs.model.Parent then
            refs.model:Destroy()
        end
    end)
end

-- ============================================================
--  星光十字架 Tool（完整模型）
-- ============================================================
local function buildCrucifixTool()
    local tool = Instance.new("Tool")
    tool.Name = "Crucifix"
    tool.RequiresHandle = true
    tool.CanBeDropped = false

    -- 竖杆
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.35, 2.6, 0.35)
    handle.Color = Color3.fromRGB(88, 52, 24)
    handle.Material = Enum.Material.Wood
    handle.CanCollide = false
    handle.Parent = tool

    -- 横杆
    local bar = Instance.new("Part")
    bar.Name = "Bar"
    bar.Size = Vector3.new(1.7, 0.35, 0.35)
    bar.Color = Color3.fromRGB(88, 52, 24)
    bar.Material = Enum.Material.Wood
    bar.CanCollide = false
    bar.Parent = tool

    local weldBar = Instance.new("WeldConstraint")
    weldBar.Part0 = handle
    weldBar.Part1 = bar
    weldBar.Parent = handle
    bar.CFrame = handle.CFrame * CFrame.new(0, 0.6, 0)

    -- 4 个金色端点球
    local endpoints = {
        Vector3.new(0, 1.3, 0),
        Vector3.new(0, -1.3, 0),
        Vector3.new(-0.85, 0.6, 0),
        Vector3.new(0.85, 0.6, 0),
    }
    for i, off in ipairs(endpoints) do
        local ball = Instance.new("Part")
        ball.Name = "Endpoint" .. i
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(0.45, 0.45, 0.45)
        ball.Color = Color3.fromRGB(255, 215, 100)
        ball.Material = Enum.Material.Neon
        ball.CanCollide = false
        ball.Transparency = 0.05
        ball.Parent = tool
        ball.CFrame = handle.CFrame * CFrame.new(off)
        local w = Instance.new("WeldConstraint")
        w.Part0 = handle
        w.Part1 = ball
        w.Parent = handle
    end

    -- 中心金星
    local star = Instance.new("Part")
    star.Name = "Star"
    star.Shape = Enum.PartType.Ball
    star.Size = Vector3.new(0.75, 0.75, 0.75)
    star.Color = Color3.fromRGB(255, 240, 160)
    star.Material = Enum.Material.Neon
    star.CanCollide = false
    star.Parent = tool
    star.CFrame = handle.CFrame * CFrame.new(0, 0.6, -0.3)
    local wStar = Instance.new("WeldConstraint")
    wStar.Part0 = handle
    wStar.Part1 = star
    wStar.Parent = handle

    -- 金色光环
    local halo = Instance.new("Part")
    halo.Name = "Halo"
    halo.Shape = Enum.PartType.Ball
    halo.Size = Vector3.new(1.7, 1.7, 1.7)
    halo.Color = Color3.fromRGB(255, 230, 130)
    halo.Material = Enum.Material.ForceField
    halo.Transparency = 0.7
    halo.CanCollide = false
    halo.Parent = tool
    halo.CFrame = handle.CFrame * CFrame.new(0, 0.6, 0)
    local wHalo = Instance.new("WeldConstraint")
    wHalo.Part0 = handle
    wHalo.Part1 = halo
    wHalo.Parent = handle

    -- 光
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 220, 130)
    light.Brightness = 5
    light.Range = 12
    light.Parent = handle

    -- 粒子
    local att = Instance.new("Attachment")
    att.Parent = handle
    local pe = Instance.new("ParticleEmitter")
    pe.Texture = "rbxassetid://243660364"
    pe.Rate = 25
    pe.Lifetime = NumberRange.new(0.6, 1.2)
    pe.Speed = NumberRange.new(2, 5)
    pe.SpreadAngle = Vector2.new(180, 180)
    pe.Color = ColorSequence.new(Color3.fromRGB(255, 220, 130))
    pe.Size = NumberSequence.new(0.4, 0)
    pe.Transparency = NumberSequence.new(0.2, 1)
    pe.LightEmission = 1
    pe.Parent = att

    tool.Grip = CFrame.new(0, -0.3, -1.3) * CFrame.Angles(math.rad(-20), 0, 0)

    return tool
end

local hasCrucifix = false

local function bindCrucifixEvents(tool)
    tool.Equipped:Connect(function()
        local char = player.Character
        if not char then return end
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255, 215, 0)
        hl.FillTransparency = 0.8
        hl.OutlineColor = Color3.fromRGB(255, 255, 200)
        hl.Parent = char
        Debris:AddItem(hl, 1.5)
    end)
end

local function giveCrucifix()
    if hasCrucifix then return end
    hasCrucifix = true
    local tool = buildCrucifixTool()
    bindCrucifixEvents(tool)
    tool.Parent = player.Backpack
end

crossBtn.MouseButton1Click:Connect(giveCrucifix)

-- ============================================================
--  手持十字架判定
-- ============================================================
local function isHoldingCrucifix()
    local char = player.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name == "Crucifix"
end

-- ============================================================
--  A-60 主逻辑
-- ============================================================
local a60Active  = false
local currentA60 = nil

local function stopA60()
    a60Active = false
    if currentA60 then
        currentA60:Destroy()
        currentA60 = nil
    end
    endOmen(1.2)
end

local function spawnA60()
    if a60Active then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    a60Active = true

    -- ============ 预兆 ============
    startOmen(CONFIG.omenDuration)

    task.spawn(function()
        -- 等待预兆
        task.wait(CONFIG.omenDuration + 0.1)

        if not a60Active then
            endOmen(1.0)
            return
        end

        local pr0 = char:FindFirstChild("HumanoidRootPart")
        if not pr0 then
            a60Active = false
            endOmen(1.0)
            return
        end

        -- ============ 生成 A-60 ============
        local playerPos = pr0.Position
        local backDir = -pr0.CFrame.LookVector
        local spawnPos = playerPos + backDir * CONFIG.spawnDistance
        spawnPos = Vector3.new(spawnPos.X, playerPos.Y + 2, spawnPos.Z)

        local facingDir = (playerPos - spawnPos)
        facingDir = Vector3.new(facingDir.X, 0, facingDir.Z).Unit

        local refs = createA60Model(spawnPos, facingDir)
        refs.model.Parent = workspace
        currentA60 = refs.model

        local staticSound = Instance.new("Sound")
        staticSound.SoundId = CONFIG.soundStatic
        staticSound.Volume = 3
        staticSound.Looped = true
        staticSound.Parent = refs.head
        staticSound:Play()

        local passCount = math.random(3, 5)
        local passDir = 1

        for i = 1, passCount do
            if not a60Active then return end

            local pr = char:FindFirstChild("HumanoidRootPart")
            if not pr then stopA60(); return end

            playShake(CONFIG.shakeIntensity, CONFIG.shakeDuration)

            local dashSound = Instance.new("Sound")
            dashSound.SoundId = CONFIG.soundDash
            dashSound.Volume = 2.5
            dashSound.Parent = playerGui
            dashSound:Play()
            Debris:AddItem(dashSound, 2)

            local currentPlayerPos = pr.Position
            local forwardDir = pr.CFrame.LookVector

            local targetOffset
            if passDir == 1 then
                targetOffset = forwardDir * CONFIG.passDistance
            else
                targetOffset = -forwardDir * CONFIG.passDistance
            end
            local targetPos = currentPlayerPos + targetOffset + Vector3.new(0, 2, 0)

            local contactTriggered = false

            while a60Active do
                local pr2 = char:FindFirstChild("HumanoidRootPart")
                if not pr2 then stopA60(); return end

                local currentPos = refs.head.Position
                local delta = targetPos - currentPos
                local dist = delta.Magnitude

                if dist < 2 then break end

                local dir = delta.Unit
                local dt = RunService.Heartbeat:Wait()
                local step = math.min(CONFIG.dashSpeed * dt, dist)
                local newPos = currentPos + dir * step

                updateA60Parts(refs, newPos, dir)

                if not contactTriggered then
                    local distToPlayer = (newPos - pr2.Position).Magnitude
                    if distToPlayer < CONFIG.contactRadius then
                        contactTriggered = true

                        if isHidden() then
                            -- 安全
                        elseif isHoldingCrucifix() then
                            -- 封印
                            local c = char:FindFirstChild("Crucifix")
                            if c then c:Destroy() end
                            local bpC = player.Backpack:FindFirstChild("Crucifix")
                            if bpC then bpC:Destroy() end
                            hasCrucifix = false

                            a60Active = false
                            currentA60 = nil
                            sealA60(refs)
                            endOmen(1.2)
                            return
                        else
                            triggerJumpscare()
                            stopA60()
                            return
                        end
                    end
                end
            end

            passDir = -passDir

            if i < passCount and a60Active then
                task.wait(
                    math.random() * (CONFIG.maxReactionTime - CONFIG.minReactionTime)
                    + CONFIG.minReactionTime
                )
            end
        end

        if a60Active then
            a60Active = false
            task.wait(0.6)
            if currentA60 then
                currentA60:Destroy()
                currentA60 = nil
            end
            endOmen(1.2)
        end
    end)
end

spawnBtn.MouseButton1Click:Connect(spawnA60)

-- ============================================================
--  重生自动给十字架
-- ============================================================
player.CharacterAdded:Connect(function()
    task.wait(1)
    if hasCrucifix
        and not player.Backpack:FindFirstChild("Crucifix")
        and not player.Character:FindFirstChild("Crucifix")
    then
        local tool = buildCrucifixTool()
        bindCrucifixEvents(tool)
        tool.Parent = player.Backpack
    end
end)

print("[A-60] 客户端脚本 v10 已加载（星光十字架 + Doors 封印 + 预兆）")
