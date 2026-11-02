-- 播放音效部分
local soundId = "rbxassetid://88457346646245"
local Workspace = game:GetService("Workspace")

local sound = Instance.new("Sound")
sound.SoundId = soundId
sound.Looped = false
sound.Volume = 0.5
sound.Parent = Workspace

sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)

task.delay(10, function()
    if sound and sound.Parent and not sound.IsPlaying then
        sound:Destroy()
    end
end)

-- WindUI加载
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    wait()
    LocalPlayer = Players.LocalPlayer
end

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Speed = 1
local sudu = nil
local tpwalkingspeed = false
local spinVelocity = nil
local autoInteract = false
local autoInteractThread = nil
local InfJ = false
local InfJConnection = nil
local fastInteractConnection = nil

-- 获取设备类型
local function getDeviceType()
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        if UserInputService.KeyboardEnabled then
            return "平板"
        else
            return "手机"
        end
    else
        return "电脑"
    end
end

local deviceType = getDeviceType()
local uiSize, uiPosition

if deviceType == "手机" then
    uiSize = UDim2.fromOffset(400, 240)
elseif deviceType == "平板" then
    uiSize = UDim2.fromOffset(450, 350)
else
    uiSize = UDim2.fromOffset(600, 500)
end
uiPosition = UDim2.new(0.5, 0, 0.5, 0)

WindUI.TransparencyValue = 0.15

WindUI:AddTheme({
    Name = "CyberBlue",
    Accent = "#18181b",
    Dialog = "#18181b",
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#000000",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#00f7ff"
})

WindUI:SetTheme("CyberBlue")

local playerName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName

WindUI:Notify({
    Title = "迪脚本通知",
    Content = "迪脚本v2加载完成",
    Duration = 2
})

WindUI:Notify({
    Title = "迪脚本通知",
    Content = "V2是新做的，后面会增加服务器功能和自制功能",
    Duration = 2
})

-- 创建主窗口
local XiaoDi = WindUI:CreateWindow({
    Title = "迪脚本 v2服务器功能",
    Icon = "rbxassetid://124019880670946",
    Author = "主作者：小迪",
    Folder = "迪脚本",
    Size = uiSize,
    Position = uiPosition,
    Theme = "CyberBlue",
    Background = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#1a1a1a"), Transparency = 0 },
        ["50"] = { Color = Color3.fromHex("#2c3e50"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 }
    }, { Rotation = 150 }),
    Transparent = true,
    HideSearchBar = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Username = playerName,
        DisplayName = displayName,
        UserId = LocalPlayer.UserId,
        ThumbnailType = "AvatarBust",
        Callback = function()
            WindUI:Notify({
                Title = "用户信息",
                Content = "玩家:" .. LocalPlayer.Name,
                Duration = 3
            })
        end
    },
    SideBarWidth = deviceType == "手机" and 150 or 180,
    ScrollBarEnabled = true,
    CornerRadius = UDim.new(0, 14),
    DropShadow = true
})

-- 主题切换按钮
XiaoDi:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "CyberBlue" and "Dark" or "CyberBlue")
    WindUI:Notify({
        Title = "提示",
        Content = "当前主题: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

XiaoDi:EditOpenButton({
    Title = "打开迪脚本v2",
    Icon = "rbxassetid://124019880670946",
})

XiaoDi:SetToggleKey(Enum.KeyCode.N)

-- 创建区域
local FengYu = {
    us = XiaoDi:Section({ Title = "脚本信息", Opened = false, Icon = "user"}),
    Practical = XiaoDi:Section({ Title = "死铁轨功能", Opened = true, Icon = "swords"}), -- 修改为打开状态
    Player = XiaoDi:Section({ Title = "玩家功能", Opened = true, Icon = "circle-user-round"}),
    Teleport = XiaoDi:Section({ Title = "传送功能", Opened = true, Icon = "plane-takeoff"}),
    Collect = XiaoDi:Section({ Title = "收集功能", Opened = true, Icon = "shopping-bag"}),
    ESP = XiaoDi:Section({ Title = "透视功能", Opened = true, Icon = "eye"}),
    Attack = XiaoDi:Section({ Title = "攻击功能", Opened = true, Icon = "target"}),
    Fly = XiaoDi:Section({ Title = "飞行功能", Opened = true, Icon = "bird"}),
}

-- 创建标签
local Feng = {
    Aut = FengYu.us:Tab({ Title = "公告", Icon = "info"}),
    player = FengYu.us:Tab({ Title = "玩家信息", Icon = "info"}),
    me = FengYu.us:Tab({ Title = "作者信息", Icon = "info"}),
    
    -- 攻击功能
    Melee = FengYu.Attack:Tab({ Title = "近战", Icon = "sword"}),
    Gun = FengYu.Attack:Tab({ Title = "枪械", Icon = "gun"}),
    Health = FengYu.Attack:Tab({ Title = "治疗", Icon = "heart"}),
    Aimbot = FengYu.Attack:Tab({ Title = "自瞄", Icon = "crosshair"}),
    
    -- 玩家功能
    PlayerFeatures = FengYu.Player:Tab({ Title = "功能", Icon = "user"}),
    
    -- 飞行功能
    Flight = FengYu.Fly:Tab({ Title = "飞行", Icon = "bird"}),
    
    -- 传送功能
    TeleportTab = FengYu.Teleport:Tab({ Title = "传送", Icon = "map-pin"}),
    
    -- 收集功能
    CollectTab = FengYu.Collect:Tab({ Title = "收集", Icon = "package"}),
    
    -- 透视功能
    ESPItems = FengYu.ESP:Tab({ Title = "物品", Icon = "box"}),
    ESPPlayers = FengYu.ESP:Tab({ Title = "玩家", Icon = "users"}),
    ESPEnemies = FengYu.ESP:Tab({ Title = "僵尸", Icon = "skull"}),
}

-- 公告标签
Feng.Aut:Code({
    Code = [[
欢迎大家游玩迪脚本
制作团队已将大部分的脚本修改
以方便大家游玩
如果你对我们的脚本感兴趣就来加入我们的群吧
如果你有脚本群也帮我们宣传
谢谢了]],
})

-- 玩家信息标签
Feng.player:Paragraph({
    Title = "玩家",
    Desc = "迪脚本用户: " .. LocalPlayer.Name .. "欢迎游玩",
    Image = "user",
    ImageSize = 12
})

Feng.player:Paragraph({
    Title = "设备",
    Desc = "你的设备: " .. deviceType,
    Image = "gamepad",
    ImageSize = 12
})

Feng.player:Paragraph({
    Title = "监控",
    Desc = "你的注入器: " .. identifyexecutor(),
    Image = "syringe",
    ImageSize = 12
})

-- 作者信息标签
Feng.me:Paragraph({
    Title = "主脚本作者",
    Desc = "小迪",
    Image = "rbxassetid://124019880670946",
    ImageSize = 50,
    Buttons = {
        {
            Title = "复制QQ号",
            Variant = "Primary",
            Callback = function()
                setclipboard("3954952871")
            end,
            Icon = "folder",
        },
        {
            Title = "复制QQ群",
            Variant = "Primary",
            Callback = function()
                setclipboard("908685870")
            end,
            Icon = "folder",
        },
    }
})

Feng.me:Paragraph({
    Title = "👤程序病毒",
    Desc = "风御 X",
    Image = "rbxassetid://96338123345158",
    ImageSize = 50,
    Buttons = {
        {
            Title = "复制QQ号",
            Variant = "Primary",
            Callback = function()
                setclipboard("1926190957")
            end,
            Icon = "info",
        },
        {
            Title = "复制QQ群",
            Variant = "Primary",
            Callback = function()
                setclipboard("群")
            end,
            Icon = "info",
        },
    }
})

-- =============== 从第一个脚本导入的功能 ===============
-- 全局变量
ENV = getfenv and getfenv() or {}
ENV.Service = {}
ENV.Service.TweenService = game:GetService("TweenService")
ENV.Service.PathfindingService = game:GetService("PathfindingService")
ENV.Service.ReplicatedStorage = game:GetService("ReplicatedStorage")
ENV.Service.Lighting = game:GetService("Lighting")
ENV.Service.RunService = game:GetService("RunService")
ENV.Service.UserInputService = game:GetService("UserInputService")
ENV.Service.ProximityPromptService = game:GetService("ProximityPromptService")
ENV.Service.Players = game:GetService("Players")
ENV.Service.CoreGui = game:GetService("CoreGui")
ENV.Toggle = {}

-- 工具函数
function Distance(pos)
    if game.Players.LocalPlayer.Character.HumanoidRootPart then
        return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
    end
end

-- =============== 攻击功能 ===============
-- 近战功能
Feng.Melee:Toggle({
    Title = "近战光环",
    Desc = '自动用已装备的武器攻击',
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        ENV.Toggle.Melee_Aura = state
    end
})

spawn(function()
    while task.wait() do
        if not ENV.Toggle.Melee_Aura then
            continue
        end
        local Tool
        for _, v in game.Players.LocalPlayer.Character:GetChildren() do
            if v:IsA("Tool") then
                Tool = v
                break
            end
        end
        local args = {
            Tool,
            workspace:GetServerTimeNow(),
            Vector3.new(-0.7861623167991638, -0.24257400631904602, -0.5684248208999634)
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("RemoteEvent"):WaitForChild("SwingMelee"):FireServer(unpack(args))
    end
end)

-- 枪械功能
Feng.Gun:Toggle({
    Title = "枪械光环",
    Desc = '自动用已装备的武器攻击',
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        ENV.Toggle.Gun_Aura = state
    end
})

Feng.Gun:Toggle({
    Title = "自动换弹",
    Desc = '自动用已装备的武器换弹',
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        ENV.Toggle.Auto_ReloadAmmo = state
    end
})

spawn(function()
    while task.wait() do
        if not ENV.Toggle.Gun_Aura then
            continue
        end
        local DistanceGunAura = math.huge
        local ModsTargetShotHead = nil
        local ModsTargetShotHumanoid = nil
        for i, v in workspace:GetDescendants() do
            if
                v:IsA("Model")
                and v:FindFirstChild("HumanoidRootPart")
                and v:FindFirstChild("Humanoid")
                and v:FindFirstChild("Head")
                and not game.Players:GetPlayerFromCharacter(v)
                and not v.Name:find("Soldier")
            then
                local DistanceGun = (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.HumanoidRootPart.Position).Magnitude
                if DistanceGun < DistanceGunAura and DistanceGun < 150 then
                    if v.Humanoid.Health > 0 then
                        ModsTargetShotHead = v.Head
                        ModsTargetShotHumanoid = v.Humanoid
                        CharacterMods = V
                        DistanceGunAura = DistanceGun
                    end
                end
            end
        end
        if ModsTargetShotHead and ModsTargetShotHumanoid then
            _G.ModsShotgun = {}
            ShotNow = { 14, 8, 2, 5, 11, 17 }
            for i, v in game.Players.LocalPlayer.Character:GetChildren() do
                if v:FindFirstChild("ClientWeaponState") and v.ClientWeaponState:FindFirstChild("CurrentAmmo") then
                    if v.ClientWeaponState.CurrentAmmo.Value ~= 0 then
                        if v.Name == "Shotgun" or v.Name == "Sawed-Off Shotgun" then
                            for i, v in ShotNow do
                                _G.ModsShotgun[v] = ModsTargetShotHumanoid
                            end
                        else
                            _G.ModsShotgun["2"] = ModsTargetShotHumanoid
                        end
                        game.ReplicatedStorage.Remotes.Weapon.Shoot:FireServer(workspace:GetServerTimeNow(), v, ModsTargetShotHead.CFrame, _G.ModsShotgun)
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do
        if not ENV.Toggle.Auto_ReloadAmmo then
            continue
        end
        for _, v in game.Players.LocalPlayer.Character:GetChildren() do
            if v:FindFirstChild("ClientWeaponState") and v.ClientWeaponState:FindFirstChild("CurrentAmmo") then
                game.ReplicatedStorage.Remotes.Weapon.Reload:FireServer(game.Workspace:GetServerTimeNow(), v)
            end
        end
    end
end)

-- 治疗功能
local Attack_Slider_1 = Feng.Health:Slider({
    Title = "生命低于<50>时使用绷带",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 50,
    },
    Callback = function(value)
        Feng.Health:UpdateControl("Attack_Slider_1", `生命低于<{tostring(value)}>时使用绷带`)
        ENV.Toggle.BandageUseHealth = tonumber(value)
    end
})

Feng.Health:Toggle({
    Title = "自动使用<绷带>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        ENV.Toggle.AutoUseBandage = state
    end
})
ENV.Toggle.BandageUseHealth = 50

spawn(function()
    while task.wait() do
        if not ENV.Toggle.AutoUseBandage then
            continue
        end
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health < ENV.Toggle.BandageUseHealth then
            if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bandage") then
                game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bandage").Use:FireServer()
            end
        end
    end
end)

-- =============== 玩家功能 ===============
local T1 = {}
Feng.PlayerFeatures:Toggle({
    Title = "秒互动",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        for _,v in workspace:GetDescendants() do
            if v:IsA("ProximityPrompt") then
                if state then
                    T1[v:GetFullName()] = v.HoldDuration
                    v.HoldDuration = 0
                else
                    v.HoldDuration = T1[v:GetFullName()]
                end
            end
        end
    end
})

local fullBrightEnabled1 = false
local autoNightLoop 

local function applyFullBright1()
    if not fullBrightEnabled1 then return end

    local hour = game.Lighting:GetMinutesAfterMidnight() / 60
    local isNight = (hour >= 18 or hour < 6)

    if isNight then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
        game.Lighting.Brightness = 10
        game.Lighting.GlobalShadows = false
    else
        game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = true
    end
end

local function enableAutoFullBright()
    if autoNightLoop then autoNightLoop:Disconnect() end
    applyFullBright1()
    autoNightLoop = game.Lighting:GetPropertyChangedSignal("ClockTime"):Connect(applyFullBright1)
end

local function disableFullBright()
    if autoNightLoop then
        autoNightLoop:Disconnect()
        autoNightLoop = nil
    end
    game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    game.Lighting.Brightness = 1
    game.Lighting.GlobalShadows = true
end

Feng.PlayerFeatures:Toggle({
    Title = "永远白天",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        fullBrightEnabled1 = state
        if fullBrightEnabled1 then
            enableAutoFullBright()
        else
            disableFullBright()
        end
    end
})

Feng.PlayerFeatures:Toggle({
    Title = "穿墙",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        ENV.Toggle.Noclip = state
    end
})

spawn(function()
    while task.wait() do
        if not ENV.Toggle.Noclip then
            continue
        end
        for _, v in game.Players.LocalPlayer.Character:GetChildren() do
            if v:IsA("BasePart") then
                v.CanCollide = not ENV.Toggle.Noclip
            end
        end
    end
end)

-- =============== 飞行功能 ===============
local flying = false
local flyBodyVelocity = nil
local flyBodyGyro = nil
local targetPart = nil
local flyConnection = nil
local FLY_SPEED = 1
ENV.Toggle.FlySpeed = 40
ENV.Toggle.Fly = false
ENV.Toggle.FlyToggle = false

-- 飞行控制变量
local flyMoveDirection = Vector3.new(0, 0, 0)
local flyTouchInput = nil
local flyTouchStartPos = nil
local flyJoystickEnabled = false

-- 开始飞行函数（支持手机控制）
function startFlying(part)
    if flying then 
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if flyBodyGyro then
            flyBodyGyro:Destroy()
            flyBodyGyro = nil
        end
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        flying = false
        targetPart = nil
        return false
    end
    
    if part then
        targetPart = part
    else
        if LocalPlayer.Character then
            targetPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        end
    end
    
    if not targetPart then
        return false
    end
    
    flying = true
    
    -- 创建物理控制器
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = targetPart
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    flyBodyGyro.P = 1000
    flyBodyGyro.D = 50
    flyBodyGyro.Parent = targetPart
    
    -- 飞行控制循环
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying or not targetPart or not targetPart.Parent then
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
            flying = false
            targetPart = nil
            return
        end
        
        -- 设置朝向
        flyBodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- 键盘输入控制（电脑端）
        local UserInputService = game:GetService("UserInputService")
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Vector3.new(0, 0, -FLY_SPEED)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection + Vector3.new(0, 0, FLY_SPEED)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection + Vector3.new(-FLY_SPEED, 0, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Vector3.new(FLY_SPEED, 0, 0)
        end
        
        -- 手机端触摸控制
        if deviceType == "手机" or deviceType == "平板" then
            if flyMoveDirection.Magnitude > 0 then
                moveDirection = moveDirection + flyMoveDirection
            end
        end
        
        -- 应用移动
        if moveDirection.Magnitude > 0 then
            moveDirection = workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveDirection)
            flyBodyVelocity.Velocity = moveDirection * ENV.Toggle.FlySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- 为手机端添加触摸控制
    if deviceType == "手机" or deviceType == "平板" then
        flyJoystickEnabled = true
        
        -- 清除现有的触摸输入
        if flyTouchInput then
            flyTouchInput:Disconnect()
            flyTouchInput = nil
        end
        
        flyTouchInput = UserInputService.TouchMoved:Connect(function(touch, processed)
            if not flying or processed then return end
            
            if touch then
                local viewportSize = workspace.CurrentCamera.ViewportSize
                local touchPos = touch.Position
                
                -- 将屏幕中心作为原点
                local screenCenter = viewportSize / 2
                local delta = (touchPos - screenCenter)
                
                -- 转换为飞行方向（归一化处理）
                local direction = Vector2.new(delta.X / screenCenter.X, delta.Y / screenCenter.Y)
                
                -- 设置移动方向
                flyMoveDirection = Vector3.new(
                    direction.X * FLY_SPEED,
                    0,
                    -direction.Y * FLY_SPEED
                )
            end
        end)
        
        -- 触摸结束重置方向
        UserInputService.TouchEnded:Connect(function(touch, processed)
            if not flying or processed then return end
            flyMoveDirection = Vector3.new(0, 0, 0)
        end)
    end
    
    return true
end

-- 停止飞行函数
function stopFlying()
    flying = false
    
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyTouchInput then
        flyTouchInput:Disconnect()
        flyTouchInput = nil
    end
    
    flyMoveDirection = Vector3.new(0, 0, 0)
    flyJoystickEnabled = false
    targetPart = nil
end

-- 飞行UI控件
local V5 = nil
Feng.Flight:Button({
    Title = "检测炮台",
    Callback = function()
        local N1 = 0
        local DistanceGunAura = math.huge
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v:FindFirstChild("VehicleSeat") and v.Name == "MaximGun" then
                local DistanceGun = (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.VehicleSeat.Position).Magnitude
                if DistanceGun < DistanceGunAura and DistanceGun < 200 then
                    DistanceGunAura = DistanceGun
                    N1 = N1 + 1
                    V5 = v
                end
            end
        end
        if V5 ~= nil then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = V5.VehicleSeat.CFrame
            V5.VehicleSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
            WindUI:Notify({
                Title = "飞行功能",
                Content = "已找到并坐上炮台",
                Duration = 3,
                Icon = "check",
            })
        else
            WindUI:Notify({
                Title = "飞行功能",
                Content = "未找到附近的炮台",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

Feng.Flight:Slider({
    Title = "飞行速度",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 40,
    },
    Callback = function(value)
        ENV.Toggle.FlySpeed = value
    end
})

Feng.Flight:Toggle({
    Title = "启动飞行",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Fly = state
    end
})

-- 飞行控制提示（手机端）
if deviceType == "手机" or deviceType == "平板" then
    Feng.Flight:Paragraph({
        Title = "手机控制说明",
        Desc = "触摸屏幕中心区域控制飞行方向\n触摸位置偏离中心越远，飞行速度越快",
        Image = "smartphone",
        ImageSize = 20
    })
end

spawn(function()
    while task.wait() do
        if not ENV.Toggle.Fly then
            ENV.Toggle.FlyToggle = false
            stopFlying()
            continue
        end
        if game.Players.LocalPlayer.Character.Humanoid.Sit then
            if not ENV.Toggle.FlyToggle then
                startFlying(V5 and V5.VehicleSeat)
                ENV.Toggle.FlyToggle = true
            end
        else
            ENV.Toggle.FlyToggle = false
            stopFlying()
        end
    end
end)

-- =============== 传送功能 ===============
local Teleport_Locations = {
    ["出生点"] = CFrame.new(56.6396217, 3.24999976, 29936.3516),
    ["10 KM"] = CFrame.new(-160.576843, 2.99617577, 19913.252),
    ["20 KM"] = CFrame.new(-556.92572, 2.98922157, 9956.79883),
    ["30 KM"] = CFrame.new(-569.779663, 2.99999976, 47.5958443),
    ["40 KM"] = CFrame.new(-184.494064, 3.14674306, -9899.91797),
    ["50 KM"] = CFrame.new(55.228714, 3.19885039, -19842.3789),
    ["60 KM"] = CFrame.new(-199.620743, 3.14927387, -29733.9453),
    ["70 KM"] = CFrame.new(-577.781921, 3.49909163, -39654.2148),
}

local function findClosestVehicleSeat(position)
    local closestSeat = nil
    local minDistance = math.huge

    for _, seat in game:GetService("Workspace"):GetDescendants() do
        if seat:IsA("VehicleSeat") then
            local distance = (position - seat.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closestSeat = seat
            end
        end
    end
    return closestSeat
end

local function teleportToLocation(locationName)
    local Player = game.Players.LocalPlayer
    if not Player.Character then
        Player.CharacterAdded:Wait()
    end
    local Character = Player.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local HRP = Character.HumanoidRootPart
        local HUM = Character:FindFirstChildOfClass("Humanoid")
        
        local originalWalkSpeed = HUM.WalkSpeed
        HUM.WalkSpeed = 0
        HRP.CFrame = Teleport_Locations[locationName]
        HRP.Anchored = true

        task.wait(2)

        local fseat = findClosestVehicleSeat(HRP.Position)
    
        if fseat then
            HRP.CFrame = fseat.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.15)
            HRP.Anchored = false
            task.wait(0.5)
            fseat:Sit(HUM)
        else
            HRP.Anchored = false
        end
        
        task.wait(1)
        HUM.WalkSpeed = originalWalkSpeed
        
        WindUI:Notify({
            Title = "传送成功",
            Content = "已传送到: " .. locationName,
            Duration = 3,
            Icon = "check",
        })
    end
end

local dropdownValues = {}
for locationName, _ in Teleport_Locations do
    table.insert(dropdownValues, locationName)
end
table.sort(dropdownValues)

local selectedLocation
Feng.TeleportTab:Dropdown({
    Title = "选择站点",
    Values = dropdownValues,
    Multi = false,
    Callback = function(option)
        selectedLocation = option
    end
})

Feng.TeleportTab:Button({
    Title = "传送",
    Callback = function()
        if selectedLocation then
            teleportToLocation(selectedLocation)
        else
            WindUI:Notify({
                Title = "传送错误",
                Content = "请先选择传送站点",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

Feng.TeleportTab:Button({
    Title = "传送到<火车>",
    Callback = function()
        local Teleport_Locations = {
            CFrame.new(56.6396217, 3.24999976, 29936.3516),
            CFrame.new(-160.576843, 2.99617577, 19913.252),
            CFrame.new(-556.92572, 2.98922157, 9956.79883),
            CFrame.new(-569.779663, 2.99999976, 47.5958443),
            CFrame.new(-184.494064, 3.14674306, -9899.91797),
            CFrame.new(55.228714, 3.19885039, -19842.3789),
            CFrame.new(-199.620743, 3.14927387, -29733.9453),
            CFrame.new(-577.781921, 3.49909163, -39654.2148),
            CFrame.new(-119.191032, 2.99993872, -49050.3789),
        }
        local N1 = 0
        for _,v1 in Teleport_Locations do
            if N1 == 1 then
                break
            end
            for _, v in workspace:GetDescendants() do
                if v:IsA("Model") and v.Name == "ConductorSeat" then
                    local VehicleSeat = v:FindFirstChild("VehicleSeat")
                    if VehicleSeat then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
                        v.VehicleSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                        N1 = 1
                        break
                    end
                end
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart:PivotTo(v1)
            task.wait(0.3)
        end
    end
})

Feng.TeleportTab:Button({
    Title = "传送到<特斯拉实验室>",
    Callback = function()
        local Player = game.Players.LocalPlayer
        if not Player.Character then
            Player.CharacterAdded:Wait()
        end
        local Character = Player.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local HRP = Character.HumanoidRootPart
            local HUM = Character:FindFirstChildOfClass("Humanoid")

            local originalWalkSpeed = HUM.WalkSpeed
            HUM.WalkSpeed = 0

            local Generator = workspace:WaitForChild("TeslaLab"):WaitForChild("Generator")
            local modelPosition = Generator:GetPivot().Position
            HRP:PivotTo(CFrame.new(modelPosition + Vector3.new(0, 5, 0)))
            HRP.Anchored = true

            task.wait(2)

            local RuntimeItems = workspace:WaitForChild("RuntimeItems")
            local function findClosestAvailableSeat()
                local closestSeat = nil
                local minDistance = math.huge
                local playerPos = HRP.Position

                for _, chair in RuntimeItems:GetChildren() do
                    if chair:IsA("Model") and chair.Name == "Chair" then
                        local seat = chair:FindFirstChild("Seat")
                        if seat and seat:IsA("Seat") and seat.Occupant == nil then
                            local seatPos = seat.Position
                            local distance = (seatPos - playerPos).Magnitude
                            if distance < minDistance then
                                minDistance = distance
                                closestSeat = seat
                            end
                        end
                    end
                end
                return closestSeat
            end

            local seat = findClosestAvailableSeat()
            if seat then
                HRP.Anchored = true
                HRP:PivotTo(seat.CFrame + Vector3.new(0, 3, 0))

                task.delay(0.15, function()
                    if HRP and HRP.Anchored then
                        HRP.Anchored = false
                    end
                end)

                task.delay(0.1, function()
                    if HRP and HRP.Anchored then
                        HRP.Anchored = false
                    end
                end)

                task.wait(0.5)
                seat:Sit(HUM)
            else
                HRP.Anchored = false
            end

            task.wait(1)
            HUM.WalkSpeed = originalWalkSpeed
        end
    end
})

Feng.TeleportTab:Button({
    Title = "传送到<军营>",
    Callback = function()
        local kmTarget = CFrame.new(-119.19103240966797, 2.999938726425171, -49050.37890625)
        for i = 1, 50 do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame:Lerp(kmTarget, i/50)
            if workspace:FindFirstChild("FortConstitution") then
                if workspace.FortConstitution:FindFirstChild("Cannon") then
                    if workspace.FortConstitution:FindFirstChild("Cannon"):FindFirstChild("VehicleSeat") then
                        local Seat = workspace:FindFirstChild("FortConstitution"):FindFirstChild("Cannon"):FindFirstChild("VehicleSeat")
                        game.Players.LocalPlayer.Character.HumanoidRootPart:PivotTo(Seat.CFrame)
                        Seat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                        break
                    end
                end
            end
            task.wait(0.4)
        end
    end
})

-- =============== 收集功能 ===============
local Remotes = ENV.Service.ReplicatedStorage:WaitForChild("Remotes")
local ToolRemote = Remotes and Remotes:WaitForChild("Tool")

Feng.CollectTab:Toggle({
    Title = "自动收集附近<钱>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Moneybag = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<蛇油>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Snake_Oil = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<绷带>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Bandage = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<圣水>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Holy_Water = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<燃烧瓶>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Molotov = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<枪>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Gun = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<子弹>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Ammo = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<债券>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Bond = state
    end
})

Feng.CollectTab:Toggle({
    Title = "自动收集附近<护甲>",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.Armor = state
    end
})

-- 自动收集功能
spawn(function()
    while task.wait() do
        if not ENV.Toggle.Armor then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name:match("Armor") then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Object"):WaitForChild("EquipObject"):FireServer(v)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do
        if not ENV.Toggle.Moneybag then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name == "Moneybag" and v:FindFirstChild("MoneyBag") and v.MoneyBag:FindFirstChild("CollectPrompt") then
                if Distance(v.MoneyBag.Position) <= 50 then
                    v.MoneyBag.CollectPrompt.HoldDuration = 0
                    fireproximityprompt(v.MoneyBag.CollectPrompt)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do 
        if not ENV.Toggle.Snake_Oil then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name == "Snake Oil" then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart and Distance(BasePart.Position) <= 20 then
                    ToolRemote.PickUpTool:FireServer(v)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do 
        if not ENV.Toggle.Bandage then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name == "Bandage" then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart and Distance(BasePart.Position) <= 20 then
                    ToolRemote.PickUpTool:FireServer(v)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do 
        if not ENV.Toggle.Holy_Water then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name == "Holy Water" then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart and Distance(BasePart.Position) <= 20 then
                    ToolRemote.PickUpTool:FireServer(v)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do 
        if not ENV.Toggle.Molotov then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name == "Molotov" then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart and Distance(BasePart.Position) <= 20 then
                    ToolRemote.PickUpTool:FireServer(v)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do 
        if not ENV.Toggle.Gun then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v:FindFirstChild("ServerWeaponState") then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart and Distance(BasePart.Position) <= 20 then
                    ToolRemote.PickUpTool:FireServer(v)
                end
            elseif v:FindFirstChild("ObjectInfo") then
                for _, m in v.ObjectInfo:GetChildren() do
                    if m.Name == "TextLabel" and m.Text == "Gun" then
                        local BasePart = v:FindFirstChildWhichIsA("BasePart")
                        if BasePart and Distance(BasePart.Position) <= 20 then
                            ToolRemote.PickUpTool:FireServer(v)
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do 
        if not ENV.Toggle.Ammo then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name:match("Ammo") or v.Name:match("Shells") then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart and Distance(BasePart.Position) <= 20 then
                    game:GetService("ReplicatedStorage").Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do 
        if not ENV.Toggle.Bond then
            continue
        end
        for _, v in workspace.RuntimeItems:GetChildren() do
            if v.Name:match("Bond") then
                local BasePart = v:FindFirstChildWhichIsA("BasePart")
                if BasePart and Distance(BasePart.Position) <= 20 then
                    game:GetService("ReplicatedStorage").Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                end
            end
        end
    end
end)

-- =============== 透视功能 ===============
-- 物品名称映射表
local ItemNameMap = {
    ["Moneybag"] = "钱袋",
    ["Snake Oil"] = "蛇油",
    ["Bandage"] = "绷带",
    ["Holy Water"] = "圣水",
    ["Molotov"] = "燃烧瓶",
    ["Bond"] = "债券",
    ["Armor"] = "护甲",
    ["Shotgun"] = "霰弹枪",
    ["Sawed-Off Shotgun"] = "短管霰弹枪",
    ["Revolver"] = "左轮手枪",
    ["Rifle"] = "步枪",
    ["Pistol"] = "手枪",
    ["Ammo"] = "子弹",
    ["Shells"] = "霰弹",
    ["MaximGun"] = "马克沁机枪",
    ["Maxim Gun"] = "马克沁机枪",
    ["Chair"] = "椅子",
    ["Cannon"] = "大炮",
    ["GoldBar"] = "金条",
    ["Gold Bar"] = "金条",
    ["Gold"] = "黄金",
    ["Newspaper"] = "报纸",
    ["Model_Runner"] = "僵尸",
    ["Model"] = "模型",
    ["Runner"] = "跑者",
}

local function GetItemChineseName(itemName)
    if not itemName or itemName == "" then
        return "未知物品"
    end
    
    itemName = tostring(itemName):match("^%s*(.-)%s*$")
    
    if ItemNameMap[itemName] then
        return ItemNameMap[itemName]
    end
    
    local lowerName = itemName:lower()
    
    for engName, chnName in pairs(ItemNameMap) do
        if lowerName == engName:lower() then
            return chnName
        end
    end
    
    if lowerName:find("newspaper") then
        return "报纸"
    elseif lowerName:find("gold") then
        if lowerName:find("bar") then
            return "金条"
        else
            return "黄金"
        end
    elseif lowerName:find("money") then
        return "钱袋"
    elseif lowerName:find("snake") and lowerName:find("oil") then
        return "蛇油"
    elseif lowerName:find("bandage") then
        return "绷带"
    elseif lowerName:find("holy") and lowerName:find("water") then
        return "圣水"
    elseif lowerName:find("molotov") then
        return "燃烧瓶"
    elseif lowerName:find("bond") then
        return "债券"
    elseif lowerName:find("armor") then
        return "护甲"
    elseif lowerName:find("shotgun") then
        if lowerName:find("sawed") or lowerName:find("off") then
            return "短管霰弹枪"
        else
            return "霰弹枪"
        end
    elseif lowerName:find("revolver") then
        return "左轮手枪"
    elseif lowerName:find("rifle") then
        return "步枪"
    elseif lowerName:find("pistol") then
        return "手枪"
    elseif lowerName:find("ammo") then
        return "子弹"
    elseif lowerName:find("shells") then
        return "霰弹"
    elseif lowerName:find("maxim") then
        return "马克沁机枪"
    elseif lowerName:find("runner") then
        return "跑者"
    elseif lowerName:find("model") then
        return "模型"
    elseif lowerName:find("gun") then
        return "枪"
    elseif lowerName:find("chair") then
        return "椅子"
    elseif lowerName:find("cannon") then
        return "大炮"
    end
    
    return itemName
end

-- ESP变量和函数
local ESPHandles = {}
local ESPColor = Color3.fromRGB(255, 0, 0)

local function CreateItemESP(object)
    if not object or not object.PrimaryPart then return end
    if ESPHandles[object] then return end 
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = object.PrimaryPart
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = object
    
    local frame = Instance.new("Frame")
    frame.Name = "ESP_Frame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.new(1, 1, 1)
    frame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ESP_Text"
    local chineseName = GetItemChineseName(object.Name)
    textLabel.Text = chineseName
    textLabel.Size = UDim2.new(1, -4, 1, -4)
    textLabel.Position = UDim2.new(0, 2, 0, 2)
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 12
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextWrapped = false
    textLabel.TextScaled = false
    textLabel.Parent = billboard
    
    ESPHandles[object] = {Billboard = billboard}
end

local function AddESPForPlayer(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or player == ENV.Service.Players.LocalPlayer then return end
    if player.Character:FindFirstChild("ESPFrame") then return end
    
    local character = player.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    local espFrame = Instance.new("BillboardGui")
    espFrame.Parent = character
    espFrame.Adornee = humanoidRootPart
    espFrame.Size = UDim2.new(0, 100, 0, 40)
    espFrame.StudsOffset = Vector3.new(0, 3, 0)
    espFrame.AlwaysOnTop = true
    espFrame.Name = "ESPFrame"
    
    local frame = Instance.new("Frame")
    frame.Parent = espFrame
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local healthText = Instance.new("TextLabel")
    healthText.Parent = frame
    healthText.Size = UDim2.new(1, 0, 0.3, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextSize = 10
    healthText.Text = "生命: " .. math.floor(humanoid.Health)
    
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        healthText.Text = "生命: " .. math.floor(humanoid.Health)
    end)
end

local function AddESPForEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") then return end
    if enemy:FindFirstChild("ESPFrame") then return end
    
    local character = enemy
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid then return end
    
    local espFrame = Instance.new("BillboardGui")
    espFrame.Parent = character
    espFrame.Adornee = humanoidRootPart
    espFrame.Size = UDim2.new(0, 100, 0, 40)
    espFrame.StudsOffset = Vector3.new(0, 3, 0)
    espFrame.AlwaysOnTop = true
    espFrame.Name = "ESPFrame"
    
    local frame = Instance.new("Frame")
    frame.Parent = espFrame
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local healthText = Instance.new("TextLabel")
    healthText.Parent = frame
    healthText.Size = UDim2.new(1, 0, 0.3, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = ESPColor
    healthText.TextSize = 10
    healthText.Text = "生命: " .. math.floor(humanoid.Health)
    
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        healthText.Text = "生命: " .. math.floor(humanoid.Health)
    end)
end

local function ClearESP()
    for obj, handles in pairs(ESPHandles) do
        if handles.Billboard then handles.Billboard:Destroy() end
        ESPHandles[obj] = nil
    end
end

local function UpdateESP()
    if not ENV.Toggle.ESPItems then return end
    
    for obj, handles in pairs(ESPHandles) do
        if not obj or not obj.Parent then
            if handles.Billboard then handles.Billboard:Destroy() end
            ESPHandles[obj] = nil
        end
    end
    
    local runtimeItems = workspace:FindFirstChild("RuntimeItems")
    if runtimeItems then
        for _, item in ipairs(runtimeItems:GetDescendants()) do
            if item:IsA("Model") and item.PrimaryPart and not ESPHandles[item] then
                CreateItemESP(item)
            end
        end
    end
end

local function RemoveESPFromObject(object)
    if object and object:FindFirstChild("ESPFrame") then
        object.ESPFrame:Destroy()
    end
end

-- ESP开关
Feng.ESPItems:Toggle({
    Title = "透视物品",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.ESPItems = state
        if not state then
            ClearESP()
        end
    end
})

Feng.ESPPlayers:Toggle({
    Title = "透视玩家",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.ESPPlayers = state
        if not state then
            for _, player in pairs(ENV.Service.Players:GetPlayers()) do
                if player ~= ENV.Service.Players.LocalPlayer and player.Character then
                    RemoveESPFromObject(player.Character)
                end
            end
        end
    end
})

Feng.ESPEnemies:Toggle({
    Title = "透视僵尸",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        ENV.Toggle.ESPZombies = state
        if not state then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not ENV.Service.Players:GetPlayerFromCharacter(obj) then
                    RemoveESPFromObject(obj)
                end
            end
        end
    end
})

-- ESP更新循环
spawn(function()
    while task.wait(0.5) do
        if ENV.Toggle.ESPItems then
            UpdateESP()
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        if ENV.Toggle.ESPPlayers then
            for _, player in pairs(ENV.Service.Players:GetPlayers()) do
                if player ~= ENV.Service.Players.LocalPlayer and player.Character and not player.Character:FindFirstChild("ESPFrame") then
                    AddESPForPlayer(player)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        if ENV.Toggle.ESPZombies then
            for _, enemy in pairs(workspace:GetDescendants()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and not ENV.Service.Players:GetPlayerFromCharacter(enemy) and not enemy:FindFirstChild("ESPFrame") then
                    AddESPForEnemy(enemy)
                end
            end
        end
    end
end)

-- ESP清理
ENV.Service.Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        RemoveESPFromObject(player.Character)
    end
end)

workspace.DescendantRemoving:Connect(function(descendant)
    if descendant:IsA("Model") and ESPHandles[descendant] then
        local handles = ESPHandles[descendant]
        if handles.Billboard then handles.Billboard:Destroy() end
        ESPHandles[descendant] = nil
    end
end)

-- =============== 自瞄功能 ===============
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotFOV = 100

local function getClosestEnemy()
    local closest = nil
    local maxDist = aimbotFOV
    local camera = workspace.CurrentCamera
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
            if not ENV.Service.Players:GetPlayerFromCharacter(obj) then
                local humanoid = obj:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local head = obj:FindFirstChild("Head")
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                        
                        if dist < maxDist then
                            maxDist = dist
                            closest = obj
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

Feng.Aimbot:Toggle({
    Title = "启用自瞄",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        aimbotEnabled = state
        aimbotTarget = nil
    end
})

Feng.Aimbot:Slider({
    Title = "自瞄FOV",
    Step = 1,
    Value = {
        Min = 10,
        Max = 500,
        Default = 100,
    },
    Callback = function(value)
        aimbotFOV = value
    end
})

-- 自瞄循环
spawn(function()
    while task.wait() do
        if aimbotEnabled then
            aimbotTarget = getClosestEnemy()
            
            if aimbotTarget and aimbotTarget:FindFirstChild("Head") then
                local camera = workspace.CurrentCamera
                local targetPos = aimbotTarget.Head.Position
                
                -- 简单的瞄准逻辑（可根据需要调整）
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            end
        else
            aimbotTarget = nil
        end
    end
end)

-- 脚本初始化完成提示
task.wait(1)
WindUI:Notify({
    Title = "迪脚本v2",
    Content = "所有功能已加载完成！",
    Duration = 3,
    Icon = "check"
})
