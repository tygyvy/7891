-- ============================================================
--  Rooms 客户端脚本 v17（完整整合版）
--  A-60 + A-120 + 十字架 + 裂缝罐子 + 手机长按
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris           = game:GetService("Debris")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")

local player    = Players.LocalPlayer
local camera    = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
--  配置
-- ============================================================
local CONFIG = {
    a60_spawnDistance    = 100,
    a60_passDistance     = 80,
    a60_dashSpeed        = 220,
    a60_minReactionTime  = 1.0,
    a60_maxReactionTime  = 2.0,
    a60_contactRadius    = 6,
    a60_omenDuration     = 1.6,

    a120_spawnDistance   = 150,
    a120_passDistance    = 120,
    a120_dashSpeed       = 140,
    a120_minReactionTime = 1.5,
    a120_maxReactionTime = 2.5,
    a120_contactRadius   = 10,
    a120_minRebounds     = 5,
    a120_maxRebounds     = 8,
    a120_stationaryTime  = 2.0,
    a120_omenDuration    = 3.5,
    a120_drumMinVolume   = 0.5,
    a120_drumMaxVolume   = 8,
    a120_windDistance    = 60,
    a120_windMaxVolume   = 5,

    shakeIntensity   = 0.35,
    shakeDuration    = 0.22,
    jumpFlashTime    = 1.4,

    soundA60Static      = "rbxassetid://4903742660",
    soundA60Dash        = "rbxassetid://78206015664727",
    soundA120Drum       = "rbxassetid://68913572228465",
    soundA120Wind       = "rbxassetid://90460719591755",
    soundA120Static     = "rbxassetid://4903742660",
    soundJumpscare      = "rbxassetid://132942725846535",
    soundSeal           = "rbxassetid://5153775199",
}

local CRUCIFIX_ID = "rbxassetid://11480603603"
local RIFT_FILE = "RoomsRiftStorage_v1.json"
local RIFT_HOLD_TIME = 0.6

-- ============================================================
--  Lighting
-- ============================================================
local origLighting = {
    Ambient        = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogColor       = Lighting.FogColor,
    FogEnd         = Lighting.FogEnd,
}

local omenCC = Instance.new("ColorCorrectionEffect")
omenCC.Name = "A60_Omen"
omenCC.TintColor = Color3.fromRGB(255, 255, 255)
omenCC.Saturation = 0
omenCC.Contrast = 0
omenCC.Brightness = 0
omenCC.Parent = Lighting

local function startOmen(duration, isA120)
    local tintColor = isA120 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 110, 110)
    local ambientColor = isA120 and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(65, 15, 15)
    local fogColor = isA120 and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(130, 30, 30)

    TweenService:Create(omenCC, TweenInfo.new(duration, Enum.EasingStyle.Quad), {
        TintColor  = tintColor,
        Saturation = isA120 and -0.15 or 0.25,
        Contrast   = 0.15,
        Brightness = -0.08,
    }):Play()

    TweenService:Create(Lighting, TweenInfo.new(duration, Enum.EasingStyle.Quad), {
        Ambient        = ambientColor,
        OutdoorAmbient = ambientColor,
        FogColor       = fogColor,
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
--  主面板 UI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "A60_Panel"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 190, 0, 196)
panel.Position = UDim2.new(1, -205, 1, -215)
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
title.Text = "Rooms Entities"
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

local spawnA60Btn = Instance.new("TextButton")
spawnA60Btn.Size = UDim2.new(1, -20, 0, 32)
spawnA60Btn.Position = UDim2.new(0, 10, 0, 30)
spawnA60Btn.BackgroundColor3 = Color3.fromRGB(150, 25, 25)
spawnA60Btn.Text = "召唤 A-60"
spawnA60Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnA60Btn.Font = Enum.Font.GothamBold
spawnA60Btn.TextSize = 14
spawnA60Btn.AutoButtonColor = false
spawnA60Btn.Parent = panel

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 8)
sCorner.Parent = spawnA60Btn

local spawnA120Btn = Instance.new("TextButton")
spawnA120Btn.Size = UDim2.new(1, -20, 0, 32)
spawnA120Btn.Position = UDim2.new(0, 10, 0, 68)
spawnA120Btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
spawnA120Btn.Text = "召唤 A-120"
spawnA120Btn.TextColor3 = Color3.fromRGB(30, 30, 30)
spawnA120Btn.Font = Enum.Font.GothamBold
spawnA120Btn.TextSize = 14
spawnA120Btn.AutoButtonColor = false
spawnA120Btn.Parent = panel

local s120Corner = Instance.new("UICorner")
s120Corner.CornerRadius = UDim.new(0, 8)
s120Corner.Parent = spawnA120Btn

local crossBtn = Instance.new("TextButton")
crossBtn.Size = UDim2.new(1, -20, 0, 32)
crossBtn.Position = UDim2.new(0, 10, 0, 106)
crossBtn.BackgroundColor3 = Color3.fromRGB(55, 50, 90)
crossBtn.Text = "获取十字架"
crossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
crossBtn.Font = Enum.Font.GothamBold
crossBtn.TextSize = 14
crossBtn.AutoButtonColor = false
crossBtn.Parent = panel

local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0, 8)
cCorner.Parent = crossBtn

local riftJarBtn = Instance.new("TextButton")
riftJarBtn.Size = UDim2.new(1, -20, 0, 32)
riftJarBtn.Position = UDim2.new(0, 10, 0, 144)
riftJarBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
riftJarBtn.Text = "获取裂缝罐子"
riftJarBtn.TextColor3 = Color3.fromRGB(255, 210, 210)
riftJarBtn.Font = Enum.Font.GothamBold
riftJarBtn.TextSize = 13
riftJarBtn.AutoButtonColor = false
riftJarBtn.Parent = panel

local rjCorner = Instance.new("UICorner")
rjCorner.CornerRadius = UDim.new(0, 8)
rjCorner.Parent = riftJarBtn

local miniBall = Instance.new("TextButton")
miniBall.Size = UDim2.new(0, 44, 0, 44)
miniBall.Position = UDim2.new(1, -60, 1, -60)
miniBall.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
miniBall.Text = "Rooms"
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
pressEffect(spawnA60Btn)
pressEffect(spawnA120Btn)
pressEffect(crossBtn)
pressEffect(riftJarBtn)
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
        model = model, head = head, fog = fog, eyeL = eyeL, eyeR = eyeR,
        mouthBlack = mouthBlack, mouthCover = mouthCover, light = light, particle = pe,
        entityType = "A60"
    }
end

-- ============================================================
--  A-120 模型
-- ============================================================
local function createA120Model(pos, facingDir)
    local model = Instance.new("Model")
    model.Name = "A120"
    local headCF = CFrame.lookAt(pos, pos + facingDir)

    local face = Instance.new("Part")
    face.Name = "Face"
    face.Size = Vector3.new(7, 7, 0.3)
    face.CFrame = headCF
    face.Anchored = true
    face.CanCollide = false
    face.Material = Enum.Material.SmoothPlastic
    face.Color = Color3.fromRGB(255, 255, 255)
    face.Transparency = 0.05
    face.Parent = model

    local sGui = Instance.new("SurfaceGui")
    sGui.Face = Enum.NormalId.Front
    sGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    sGui.PixelsPerStud = 100
    sGui.Parent = face

    local eyeL = Instance.new("ImageLabel")
    eyeL.Size = UDim2.new(0.18, 0, 0.22, 0)
    eyeL.Position = UDim2.new(0.33, 0, 0.28, 0)
    eyeL.BackgroundTransparency = 1
    eyeL.Image = "rbxassetid://6031075931"
    eyeL.ImageColor3 = Color3.fromRGB(0, 0, 0)
    eyeL.Parent = sGui

    local eyeR = Instance.new("ImageLabel")
    eyeR.Size = UDim2.new(0.18, 0, 0.22, 0)
    eyeR.Position = UDim2.new(0.49, 0, 0.28, 0)
    eyeR.BackgroundTransparency = 1
    eyeR.Image = "rbxassetid://6031075931"
    eyeR.ImageColor3 = Color3.fromRGB(0, 0, 0)
    eyeR.Parent = sGui

    local mouth = Instance.new("ImageLabel")
    mouth.Size = UDim2.new(0.65, 0, 0.18, 0)
    mouth.Position = UDim2.new(0.175, 0, 0.52, 0)
    mouth.BackgroundTransparency = 1
    mouth.Image = "rbxassetid://6031075931"
    mouth.ImageColor3 = Color3.fromRGB(0, 0, 0)
    mouth.Parent = sGui

    local aura = Instance.new("Part")
    aura.Name = "Aura"
    aura.Shape = Enum.PartType.Ball
    aura.Size = Vector3.new(11, 11, 11)
    aura.CFrame = headCF
    aura.Anchored = true
    aura.CanCollide = false
    aura.Material = Enum.Material.ForceField
    aura.Color = Color3.fromRGB(255, 255, 255)
    aura.Transparency = 0.78
    aura.Parent = model

    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Range = 28
    light.Color = Color3.fromRGB(255, 255, 255)
    light.Parent = face

    local att = Instance.new("Attachment")
    att.Parent = face

    local pe = Instance.new("ParticleEmitter")
    pe.Texture = "rbxassetid://243660364"
    pe.Rate = 60
    pe.Lifetime = NumberRange.new(0.5, 1.2)
    pe.Speed = NumberRange.new(2, 6)
    pe.SpreadAngle = Vector2.new(180, 180)
    pe.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    pe.Size = NumberSequence.new(1.8, 0)
    pe.Transparency = NumberSequence.new(0.2, 1)
    pe.Parent = att

    model.PrimaryPart = face
    return {
        model = model, face = face, aura = aura, light = light, particle = pe,
        sGui = sGui, eyeL = eyeL, eyeR = eyeR, mouth = mouth,
        entityType = "A120",
        lastFaceChange = tick()
    }
end

local function updateA120Appearance(refs, dt)
    local now = tick()
    if now - refs.lastFaceChange > 0.08 then
        refs.lastFaceChange = now
        local rnd = math.random()
        if rnd < 0.25 then
            refs.eyeL.Rotation = 180
            refs.eyeR.Rotation = 180
            refs.mouth.Rotation = 0
        elseif rnd < 0.5 then
            refs.eyeL.Position = UDim2.new(0.33 + (math.random() - 0.5) * 0.06, 0, 0.28, 0)
            refs.eyeR.Position = UDim2.new(0.49 + (math.random() - 0.5) * 0.06, 0, 0.28, 0)
        elseif rnd < 0.75 then
            refs.eyeL.Rotation = 0
            refs.eyeR.Rotation = 0
            refs.mouth.Rotation = 180
        else
            refs.eyeL.Rotation = 0
            refs.eyeR.Rotation = 0
            refs.mouth.Rotation = 0
        end
    end

    local shakeOffset = Vector3.new(
        (math.random() - 0.5) * 0.4,
        (math.random() - 0.5) * 0.4,
        (math.random() - 0.5) * 0.4
    )
    refs.face.CFrame = refs.face.CFrame + shakeOffset
    refs.aura.CFrame = refs.aura.CFrame + shakeOffset
end

local function updateEntityParts(refs, newPos, dir)
    local cf = CFrame.lookAt(newPos, newPos + dir)
    if refs.entityType == "A60" then
        refs.head.CFrame = cf
        refs.fog.CFrame = cf
        refs.eyeL.CFrame = cf * CFrame.new(-1.3, 0.9, -2.2)
        refs.eyeR.CFrame = cf * CFrame.new(1.3, 0.9, -2.2)
        refs.mouthBlack.CFrame = cf * CFrame.new(0, -1.1, -2.1)
        refs.mouthCover.CFrame = cf * CFrame.new(0, -0.15, -2.09)
    elseif refs.entityType == "A120" then
        refs.face.CFrame = cf
        refs.aura.CFrame = cf
    end
end

-- ============================================================
--  柜子检测
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
--  跳杀红屏 + 封印闪光
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

local scareImg = Instance.new("ImageLabel")
scareImg.Size = UDim2.new(1, 0, 1, 0)
scareImg.BackgroundTransparency = 1
scareImg.Image = ""
scareImg.ImageTransparency = 1
scareImg.ZIndex = 3
scareImg.Parent = redGui

local sealFrame = Instance.new("Frame")
sealFrame.Size = UDim2.new(1, 0, 1, 0)
sealFrame.BackgroundColor3 = Color3.fromRGB(255, 250, 220)
sealFrame.BackgroundTransparency = 1
sealFrame.BorderSizePixel = 0
sealFrame.ZIndex = 2
sealFrame.Parent = redGui

local function triggerJumpscareA120()
    local s = Instance.new("Sound")
    s.SoundId = CONFIG.soundJumpscare
    s.Volume = 6
    s.Parent = playerGui
    s:Play()
    Debris:AddItem(s, 3)

    redFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    redFrame.BackgroundTransparency = 0
    scareImg.Image = "rbxassetid://13319996052"
    scareImg.ImageTransparency = 0

    playShake(3.0, 0.8)

    task.wait(CONFIG.jumpFlashTime)

    TweenService:Create(redFrame, TweenInfo.new(0.8),
        {BackgroundTransparency = 1}):Play()
    TweenService:Create(scareImg, TweenInfo.new(0.8),
        {ImageTransparency = 1}):Play()

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end
end

local function triggerJumpscareA60()
    local s = Instance.new("Sound")
    s.SoundId = CONFIG.soundJumpscare
    s.Volume = 5
    s.Parent = playerGui
    s:Play()
    Debris:AddItem(s, 3)

    redFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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

local function triggerSealFlash()
    for _ = 1, 2 do
        sealFrame.BackgroundTransparency = 0
        task.wait(0.07)
        sealFrame.BackgroundTransparency = 0.55
        task.wait(0.07)
    end
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
--  封印阵法
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

local function sealEntity(refs)
    triggerSealFlash()

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
                            Brightness = 3, Range = 8
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

    local centerPos = refs.entityType == "A60" and refs.head.Position or refs.face.Position
    local groundPos = Vector3.new(centerPos.X, centerPos.Y - 3, centerPos.Z)
    local sealModel, stopSpin = createSealCircle(groundPos)

    local targetPos = groundPos + Vector3.new(0, 4, 0)
    local startPos = centerPos
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
            updateEntityParts(refs, newPos, dir)
        end
    end)

    local sealAtt = Instance.new("Attachment")
    sealAtt.Parent = refs.entityType == "A60" and refs.head or refs.face
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
    flashLight.Parent = refs.entityType == "A60" and refs.head or refs.face

    task.wait(pullDuration)

    TweenService:Create(flashLight, TweenInfo.new(1),
        {Brightness = 0, Range = 5}):Play()

    local gold = Color3.fromRGB(255, 230, 150)

    if refs.entityType == "A60" then
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
    elseif refs.entityType == "A120" then
        refs.eyeL.Rotation = 180
        refs.eyeR.Rotation = 180
        refs.mouth.Rotation = 0
        TweenService:Create(refs.face, TweenInfo.new(0.9),
            {Color = gold, Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
        TweenService:Create(refs.aura, TweenInfo.new(0.9),
            {Color = gold, Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
    end

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
--  十字架 Tool
-- ============================================================
local function buildCrucifixTool()
    local tool

    local ok, model = pcall(function()
        local objs = game:GetObjects(CRUCIFIX_ID)
        return objs and objs[1]
    end)

    if ok and model then
        if model:IsA("Tool") then
            tool = model
        else
            tool = Instance.new("Tool")
            tool.Name = "Crucifix"
            model.Parent = tool
        end
    else
        tool = Instance.new("Tool")
        tool.Name = "Crucifix"
        tool.RequiresHandle = true

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.3, 2, 0.3)
        handle.BrickColor = BrickColor.new("Brown")
        handle.Material = Enum.Material.Wood
        handle.CanCollide = false
        handle.Parent = tool

        local bar = Instance.new("Part")
        bar.Name = "Bar"
        bar.Size = Vector3.new(1.2, 0.3, 0.3)
        bar.BrickColor = BrickColor.new("Brown")
        bar.Material = Enum.Material.Wood
        bar.CanCollide = false
        bar.Parent = tool

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = bar
        weld.Parent = handle
        bar.CFrame = handle.CFrame * CFrame.new(0, 0.5, 0)
    end

    tool.Name = "Crucifix"
    tool.CanBeDropped = false
    tool.RequiresHandle = true

    if not tool:FindFirstChild("Handle") then
        local basePart = tool:FindFirstChildWhichIsA("BasePart")
        if basePart then
            basePart.Name = "Handle"
        end
    end

    local handle = tool:FindFirstChild("Handle")
    if handle then
        local oldLight = handle:FindFirstChildOfClass("PointLight")
        if oldLight then oldLight:Destroy() end

        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 215, 0)
        light.Brightness = 3
        light.Range = 8
        light.Parent = handle

        local att = Instance.new("Attachment")
        att.Name = "CrucifixGlow"
        att.Parent = handle

        local pe = Instance.new("ParticleEmitter")
        pe.Texture = "rbxassetid://243660364"
        pe.Rate = 15
        pe.Lifetime = NumberRange.new(0.5, 1)
        pe.Speed = NumberRange.new(1, 3)
        pe.SpreadAngle = Vector2.new(180, 180)
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))
        pe.Size = NumberSequence.new(0.3, 0)
        pe.Transparency = NumberSequence.new(0.2, 1)
        pe.Parent = att
    end

    tool.Grip = CFrame.new(0, -0.5, 0)

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

local function isHoldingCrucifix()
    local char = player.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name == "Crucifix"
end

-- ============================================================
--  实体主逻辑
-- ============================================================
local entityActive = false
local currentEntity = nil
local currentEntityType = nil

local function stopEntity()
    entityActive = false
    if currentEntity then
        currentEntity:Destroy()
        currentEntity = nil
    end
    currentEntityType = nil
    endOmen(1.2)
end

local function spawnEntity(entityType)
    if entityActive then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    entityActive = true
    currentEntityType = entityType

    local isA120 = entityType == "A120"
    local omenDuration = isA120 and CONFIG.a120_omenDuration or CONFIG.a60_omenDuration

    startOmen(omenDuration, isA120)

    task.spawn(function()
        task.wait(omenDuration + 0.1)

        if not entityActive then
            endOmen(1.0)
            return
        end

        local pr0 = char:FindFirstChild("HumanoidRootPart")
        if not pr0 then
            entityActive = false
            endOmen(1.0)
            return
        end

        local playerPos = pr0.Position
        local backDir = -pr0.CFrame.LookVector
        local spawnPos = playerPos + backDir * (isA120 and CONFIG.a120_spawnDistance or CONFIG.a60_spawnDistance)
        spawnPos = Vector3.new(spawnPos.X, playerPos.Y + 2, spawnPos.Z)

        local facingDir = (playerPos - spawnPos)
        facingDir = Vector3.new(facingDir.X, 0, facingDir.Z).Unit

        local refs
        if isA120 then
            refs = createA120Model(spawnPos, facingDir)
        else
            refs = createA60Model(spawnPos, facingDir)
        end
        refs.model.Parent = workspace
        currentEntity = refs.model

        local drumSound, staticSound, windSound

        if isA120 then
            drumSound = Instance.new("Sound")
            drumSound.SoundId = CONFIG.soundA120Drum
            drumSound.Volume = CONFIG.a120_drumMinVolume
            drumSound.Looped = true
            drumSound.Parent = refs.face
            drumSound:Play()

            staticSound = Instance.new("Sound")
            staticSound.SoundId = CONFIG.soundA120Static
            staticSound.Volume = 2.5
            staticSound.Looped = true
            staticSound.Parent = refs.face
            staticSound:Play()

            windSound = Instance.new("Sound")
            windSound.SoundId = CONFIG.soundA120Wind
            windSound.Volume = 0
            windSound.Looped = true
            windSound.Parent = refs.face
            windSound:Play()
        else
            staticSound = Instance.new("Sound")
            staticSound.SoundId = CONFIG.soundA60Static
            staticSound.Volume = 3
            staticSound.Looped = true
            staticSound.Parent = refs.head
            staticSound:Play()
        end

        local passCount = isA120 and math.random(CONFIG.a120_minRebounds, CONFIG.a120_maxRebounds) or math.random(3, 5)
        local passDir = 1

        for i = 1, passCount do
            if not entityActive then return end

            local pr = char:FindFirstChild("HumanoidRootPart")
            if not pr then stopEntity(); return end

            playShake(CONFIG.shakeIntensity, CONFIG.shakeDuration)

            if isA120 then
                local drumHit = Instance.new("Sound")
                drumHit.SoundId = CONFIG.soundA120Drum
                drumHit.Volume = 5
                drumHit.Parent = playerGui
                drumHit:Play()
                Debris:AddItem(drumHit, 2)
            else
                local dashSound = Instance.new("Sound")
                dashSound.SoundId = CONFIG.soundA60Dash
                dashSound.Volume = 2.5
                dashSound.Parent = playerGui
                dashSound:Play()
                Debris:AddItem(dashSound, 2)
            end

            local currentPlayerPos = pr.Position
            local forwardDir = pr.CFrame.LookVector

            local targetOffset
            if isA120 then
                targetOffset = forwardDir * CONFIG.a120_passDistance
            else
                if passDir == 1 then
                    targetOffset = forwardDir * CONFIG.a60_passDistance
                else
                    targetOffset = -forwardDir * CONFIG.a60_passDistance
                end
            end
            local targetPos = currentPlayerPos + targetOffset + Vector3.new(0, 2, 0)

            local contactTriggered = false

            while entityActive do
                local pr2 = char:FindFirstChild("HumanoidRootPart")
                if not pr2 then stopEntity(); return end

                local currentPos = refs.entityType == "A60" and refs.head.Position or refs.face.Position
                local delta = targetPos - currentPos
                local dist = delta.Magnitude

                if dist < 2 then break end

                local dir = delta.Unit
                local dt = RunService.Heartbeat:Wait()
                local speed = isA120 and CONFIG.a120_dashSpeed or CONFIG.a60_dashSpeed
                local step = math.min(speed * dt, dist)
                local newPos = currentPos + dir * step

                updateEntityParts(refs, newPos, dir)

                if isA120 then
                    updateA120Appearance(refs, dt)

                    local distToPlayer = (newPos - pr2.Position).Magnitude
                    local range = CONFIG.a120_spawnDistance * 1.5
                    local closeness = math.clamp(1 - (distToPlayer / range), 0, 1)
                    local drumVolume = CONFIG.a120_drumMinVolume
                        + (CONFIG.a120_drumMaxVolume - CONFIG.a120_drumMinVolume) * closeness
                    if drumSound and drumSound.Parent then
                        drumSound.Volume = drumVolume
                    end

                    if windSound and windSound.Parent then
                        if distToPlayer < CONFIG.a120_windDistance then
                            local windCloseness = 1 - (distToPlayer / CONFIG.a120_windDistance)
                            windSound.Volume = CONFIG.a120_windMaxVolume * windCloseness
                        else
                            windSound.Volume = 0
                        end
                    end
                end

                if not contactTriggered then
                    local distToPlayer = (newPos - pr2.Position).Magnitude
                    local contactRadius = isA120 and CONFIG.a120_contactRadius or CONFIG.a60_contactRadius
                    if distToPlayer < contactRadius then
                        contactTriggered = true

                        if isHidden() then
                        elseif isHoldingCrucifix() then
                            local c = char:FindFirstChild("Crucifix")
                            if c then c:Destroy() end
                            local bpC = player.Backpack:FindFirstChild("Crucifix")
                            if bpC then bpC:Destroy() end
                            hasCrucifix = false

                            entityActive = false
                            currentEntity = nil
                            sealEntity(refs)
                            endOmen(1.2)
                            return
                        else
                            if isA120 then
                                triggerJumpscareA120()
                            else
                                triggerJumpscareA60()
                            end
                            stopEntity()
                            return
                        end
                    end
                end
            end

            if not isA120 then
                passDir = -passDir
            end

            if isA120 and entityActive and i < passCount then
                task.wait(CONFIG.a120_stationaryTime)

                local reboundSound = Instance.new("Sound")
                reboundSound.SoundId = CONFIG.soundA120Drum
                reboundSound.Volume = 4
                reboundSound.Parent = playerGui
                reboundSound:Play()
                Debris:AddItem(reboundSound, 2)
            end

            if i < passCount and entityActive then
                local minTime = isA120 and CONFIG.a120_minReactionTime or CONFIG.a60_minReactionTime
                local maxTime = isA120 and CONFIG.a120_maxReactionTime or CONFIG.a60_maxReactionTime
                task.wait(math.random() * (maxTime - minTime) + minTime)
            end
        end

        if entityActive then
            entityActive = false
            task.wait(0.6)
            if currentEntity then
                currentEntity:Destroy()
                currentEntity = nil
            end
            endOmen(1.2)
        end
    end)
end

spawnA60Btn.MouseButton1Click:Connect(function() spawnEntity("A60") end)
spawnA120Btn.MouseButton1Click:Connect(function() spawnEntity("A120") end)

-- ============================================================
--  裂缝罐子系统
-- ============================================================
local riftStorage = { entries = {} }

local function saveRiftStorage()
    if not writefile then return end
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(riftStorage)
    end)
    if ok and encoded then
        pcall(writefile, RIFT_FILE, encoded)
    end
end

local function loadRiftStorage()
    if not (readfile and isfile) then return end
    if not isfile(RIFT_FILE) then return end
    local ok, content = pcall(readfile, RIFT_FILE)
    if not ok or not content then return end
    local ok2, decoded = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if ok2 and decoded and type(decoded) == "table" then
        riftStorage = decoded
        if type(riftStorage.entries) ~= "table" then
            riftStorage.entries = {}
        end
    end
end

loadRiftStorage()

local function serializeValue(v)
    local t = typeof(v)
    if t == "Vector3" then
        return {__t = "Vector3", x = v.X, y = v.Y, z = v.Z}
    elseif t == "CFrame" then
        return {__t = "CFrame", c = {v:GetComponents()}}
    elseif t == "Color3" then
        return {__t = "Color3", r = v.R, g = v.G, b = v.B}
    elseif t == "BrickColor" then
        return {__t = "BrickColor", n = v.Name}
    elseif t == "EnumItem" then
        return {__t = "Enum", enumType = tostring(v.EnumType), name = v.Name}
    elseif t == "UDim2" then
        return {__t = "UDim2", xs = v.X.Scale, xo = v.X.Offset, ys = v.Y.Scale, yo = v.Y.Offset}
    elseif t == "number" or t == "string" or t == "boolean" then
        return v
    end
    return nil
end

local function deserializeValue(d)
    if type(d) ~= "table" then return d end
    local t = d.__t
    if t == "Vector3" then
        return Vector3.new(d.x, d.y, d.z)
    elseif t == "CFrame" then
        return CFrame.new(unpack(d.c))
    elseif t == "Color3" then
        return Color3.new(d.r, d.g, d.b)
    elseif t == "BrickColor" then
        return BrickColor.new(d.n)
    elseif t == "Enum" then
        local ok, e = pcall(function() return Enum[d.enumType][d.name] end)
        return ok and e or nil
    elseif t == "UDim2" then
        return UDim2.new(d.xs, d.xo, d.ys, d.yo)
    end
    return nil
end

local SERIALIZE_PROPS = {
    "Size", "CFrame", "Color", "BrickColor", "Material", "Transparency",
    "Anchored", "CanCollide", "CanQuery", "CanTouch", "Shape",
    "
