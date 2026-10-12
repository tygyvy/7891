-- Rooms v26 完整版
local PL=game:GetService("Players")
local RS=game:GetService("RunService")
local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local DB=game:GetService("Debris")
local LT=game:GetService("Lighting")
local HS=game:GetService("HttpService")
local LP=PL.LocalPlayer
local CAM=workspace.CurrentCamera
local PG=LP:WaitForChild("PlayerGui")
print("[Rooms] v26 加载")

local CFG={a60Sp=100,a60Pa=80,a60Sd=220,a60W1=1,a60W2=2,a60Cr=6,a60Om=1.6,
 a120Sp=150,a120Pa=120,a120Sd=140,a120W1=1.5,a120W2=2.5,a120Cr=10,
 a120Rb1=5,a120Rb2=8,a120St=2,a120Om=3.5,
 s60S="rbxassetid://4903742660",s60D="rbxassetid://78206015664727",
 s120D="rbxassetid://68913572228465",s120W="rbxassetid://90460719591755",
 sJ="rbxassetid://132942725846535",sSl="rbxassetid://5153775199"}
local CRID="rbxassetid://11480603603"
local RF="Rift_v26.json"
local HT=0.6

local function np(pa,p)
 local o=Instance.new("Part")
 o.Anchored=true;o.CanCollide=false;o.TopSurface=0;o.BottomSurface=0
 if p then for k,v in pairs(p) do pcall(function() o[k]=v end) end end
 o.Parent=pa;return o
end
local function nb(pa,p)
 local b=Instance.new("TextButton")
 b.AutoButtonColor=false;b.BorderSizePixel=0;b.Font=Enum.Font.GothamBold
 if p then for k,v in pairs(p) do pcall(function() b[k]=v end) end end
 b.Parent=pa
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
 return b
end

local OL={A=LT.Ambient,OA=LT.OutdoorAmbient,F=LT.FogColor,FE=LT.FogEnd}
local oCC=Instance.new("ColorCorrectionEffect",LT)
local function omen(d,w)
 pcall(function()
  TS:Create(oCC,TweenInfo.new(d),{TintColor=w and Color3.new(1,1,1) or Color3.fromRGB(255,110,110),Saturation=w and -0.15 or 0.25,Contrast=0.15,Brightness=-0.08}):Play()
  TS:Create(LT,TweenInfo.new(d),{Ambient=w and Color3.fromRGB(35,35,35) or Color3.fromRGB(65,15,15),OutdoorAmbient=w and Color3.fromRGB(35,35,35) or Color3.fromRGB(65,15,15),FogColor=w and Color3.fromRGB(120,120,120) or Color3.fromRGB(130,30,30),FogEnd=140}):Play()
 end)
end
local function omenEnd(d)
 pcall(function()
  TS:Create(oCC,TweenInfo.new(d),{TintColor=Color3.new(1,1,1),Saturation=0,Contrast=0,Brightness=0}):Play()
  TS:Create(LT,TweenInfo.new(d),{Ambient=OL.A,OutdoorAmbient=OL.OA,FogColor=OL.F,FogEnd=OL.FE}):Play()
 end)
end

local skOn=false
local skC=CFrame.new()
local function shake(i,d)
 if skOn then return end
 skOn=true;local t=0;local c
 c=RS.RenderStepped:Connect(function(dt)
  t=t+dt
  if t>=d then skOn=false;skC=CFrame.new();c:Disconnect();return end
  local de=1-t/d
  skC=CFrame.new(Vector3.new((math.random()-.5)*2,(math.random()-.5)*2,0)*i*de)
 end)
end
RS.RenderStepped:Connect(function() if skOn then CAM.CFrame=CAM.CFrame*skC end end)

local sg=Instance.new("ScreenGui",PG)
sg.Name="RoomsUI";sg.ResetOnSpawn=false;sg.IgnoreGuiInset=true
local pn=Instance.new("Frame",sg)
pn.Size=UDim2.new(0,180,0,200)
pn.Position=UDim2.new(1,-195,1,-220)
pn.BackgroundColor3=Color3.fromRGB(20,20,24);pn.BackgroundTransparency=.1
pn.BorderSizePixel=0;pn.Active=true
Instance.new("UICorner",pn).CornerRadius=UDim.new(0,12)
local pst=Instance.new("UIStroke",pn);pst.Color=Color3.fromRGB(140,30,30);pst.Thickness=1.5
local tb=Instance.new("Frame",pn)
tb.Size=UDim2.new(1,0,0,26);tb.BackgroundTransparency=1
local ttl=Instance.new("TextLabel",tb)
ttl.Size=UDim2.new(1,-30,1,0);ttl.Position=UDim2.new(0,8,0,0)
ttl.BackgroundTransparency=1;ttl.Text="Rooms 实体";ttl.TextColor3=Color3.fromRGB(230,70,70)
ttl.Font=Enum.Font.GothamBold;ttl.TextSize=14;ttl.TextXAlignment=Enum.TextXAlignment.Left
local mB=nb(tb,{Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-26,0,2),BackgroundColor3=Color3.fromRGB(50,50,55),Text="-",TextColor3=Color3.fromRGB(220,220,220),TextSize=14})
mB.UICorner.CornerRadius=UDim.new(1,0)
local b60=nb(pn,{Size=UDim2.new(1,-20,0,32),Position=UDim2.new(0,10,0,30),BackgroundColor3=Color3.fromRGB(150,25,25),Text="召唤 A-60",TextColor3=Color3.new(1,1,1),TextSize=13})
local b120=nb(pn,{Size=UDim2.new(1,-20,0,32),Position=UDim2.new(0,10,0,68),BackgroundColor3=Color3.fromRGB(180,180,180),Text="召唤 A-120",TextColor3=Color3.fromRGB(30,30,30),TextSize=13})
local bCr=nb(pn,{Size=UDim2.new(1,-20,0,32),Position=UDim2.new(0,10,0,106),BackgroundColor3=Color3.fromRGB(55,50,90),Text="获取十字架",TextColor3=Color3.new(1,1,1),TextSize=13})
local bJr=nb(pn,{Size=UDim2.new(1,-20,0,32),Position=UDim2.new(0,10,0,144),BackgroundColor3=Color3.fromRGB(120,30,30),Text="放置裂缝",TextColor3=Color3.fromRGB(255,210,210),TextSize=13})
local mn=Instance.new("TextButton",sg)
mn.Size=UDim2.new(0,44,0,44);mn.Position=UDim2.new(1,-60,1,-60)
mn.BackgroundColor3=Color3.fromRGB(140,25,25);mn.Text="R";mn.TextColor3=Color3.new(1,1,1)
mn.Font=Enum.Font.GothamBold;mn.TextSize=13;mn.Visible=false;mn.AutoButtonColor=false
Instance.new("UICorner",mn).CornerRadius=UDim.new(1,0)
local function drag(f,h)
 local dg=false;local ds,sp
 h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true;ds=i.Position;sp=f.Position end end)
 h.InputChanged:Connect(function(i) if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-ds;f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end end)
end
drag(pn,tb);drag(mn,mn)
local mSt=false
mB.MouseButton1Click:Connect(function() mSt=true;mn.Position=pn.Position;pn.Visible=false;mn.Visible=true end)
mn.MouseButton1Click:Connect(function() if not mSt then return end;mSt=false;pn.Visible=true;mn.Visible=false end)

local function mkA60(ps,dr)
 local m=Instance.new("Model")
 local cf=CFrame.lookAt(ps,ps+dr)
 local hd=np(m,{Shape=Enum.PartType.Ball,Size=Vector3.new(5.5,5.5,5),CFrame=cf,Material=Enum.Material.Neon,Color=Color3.fromRGB(215,30,30),Transparency=.25})
 local fg=np(m,{Shape=Enum.PartType.Ball,Size=Vector3.new(7.5,7.5,7.5),CFrame=cf,Material=Enum.Material.ForceField,Color=Color3.fromRGB(255,0,0),Transparency=.75})
 local eL=np(m,{Shape=Enum.PartType.Ball,Size=Vector3.new(1.7,1.5,.8),CFrame=cf*CFrame.new(-1.3,.9,-2.2),Material=Enum.Material.SmoothPlastic,Color=Color3.new(0,0,0)})
 local eR=np(m,{Shape=Enum.PartType.Ball,Size=Vector3.new(1.7,1.5,.8),CFrame=cf*CFrame.new(1.3,.9,-2.2),Material=Enum.Material.SmoothPlastic,Color=Color3.new(0,0,0)})
 local mB2=np(m,{Shape=Enum.PartType.Ball,Size=Vector3.new(4.4,2.6,.7),CFrame=cf*CFrame.new(0,-1.1,-2.1),Material=Enum.Material.SmoothPlastic,Color=Color3.new(0,0,0)})
 local mC=np(m,{Shape=Enum.PartType.Ball,Size=Vector3.new(4.6,2.2,.75),CFrame=cf*CFrame.new(0,-.15,-2.09),Material=Enum.Material.Neon,Color=Color3.fromRGB(215,30,30)})
 local li=Instance.new("PointLight",hd);li.Brightness=7;li.Range=28;li.Color=Color3.fromRGB(255,30,30)
 local at=Instance.new("Attachment",hd)
 local pe=Instance.new("ParticleEmitter",at)
 pe.Texture="rbxassetid://243660364";pe.Rate=70;pe.Lifetime=NumberRange.new(.6,1.3)
 pe.Speed=NumberRange.new(4,9);pe.SpreadAngle=Vector2.new(180,180)
 pe.Color=ColorSequence.new(Color3.fromRGB(255,20,20));pe.Size=NumberSequence.new(1,0)
 pe.Transparency=NumberSequence.new(.15,1)
 m.PrimaryPart=hd
 return{m=m,hd=hd,fg=fg,eL=eL,eR=eR,mB=mB2,mC=mC,li=li,pe=pe,t="A60"}
end

local function mkA120(ps,dr)
 local m=Instance.new("Model")
 local cf=CFrame.lookAt(ps,ps+dr)
 local fc=np(m,{Size=Vector3.new(7,7,.3),CFrame=cf,Material=Enum.Material.SmoothPlastic,Color=Color3.new(1,1,1),Transparency=.05})
 local sG=Instance.new("SurfaceGui",fc)
 sG.Face=Enum.NormalId.Front;sG.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;sG.PixelsPerStud=100
 local eL=Instance.new("ImageLabel",sG)
 eL.Size=UDim2.new(.18,0,.22,0);eL.Position=UDim2.new(.33,0,.28,0)
 eL.BackgroundTransparency=1;eL.Image="rbxassetid://6031075931";eL.ImageColor3=Color3.new(0,0,0)
 local eR=Instance.new("ImageLabel",sG)
 eR.Size=UDim2.new(.18,0,.22,0);eR.Position=UDim2.new(.49,0,.28,0)
 eR.BackgroundTransparency=1;eR.Image="rbxassetid://6031075931";eR.ImageColor3=Color3.new(0,0,0)
 local mo=Instance.new("ImageLabel",sG)
 mo.Size=UDim2.new(.65,0,.18,0);mo.Position=UDim2.new(.175,0,.52,0)
 mo.BackgroundTransparency=1;mo.Image="rbxassetid://6031075931";mo.ImageColor3=Color3.new(0,0,0)
 local au=np(m,{Shape=Enum.PartType.Ball,Size=Vector3.new(11,11,11),CFrame=cf,Material=Enum.Material.ForceField,Color=Color3.new(1,1,1),Transparency=.78})
 local li=Instance.new("PointLight",fc);li.Brightness=5;li.Range=28;li.Color=Color3.new(1,1,1)
 local at=Instance.new("Attachment",fc)
 local pe=Instance.new("ParticleEmitter",at)
 pe.Texture="rbxassetid://243660364";pe.Rate=60;pe.Lifetime=NumberRange.new(.5,1.2)
 pe.Speed=NumberRange.new(2,6);pe.SpreadAngle=Vector2.new(180,180)
 pe.Color=ColorSequence.new(Color3.new(1,1,1));pe.Size=NumberSequence.new(1.8,0)
 pe.Transparency=NumberSequence.new(.2,1)
 m.PrimaryPart=fc
 return{m=m,fc=fc,au=au,li=li,pe=pe,eL=eL,eR=eR,mo=mo,t="A120",lf=tick()}
end

local function upd120(r)
 if tick()-r.lf>.08 then
  r.lf=tick()
  local n=math.random()
  if n<.25 then r.eL.Rotation=180;r.eR.Rotation=180;r.mo.Rotation=0
  elseif n<.5 then r.eL.Position=UDim2.new(.33+(math.random()-.5)*.06,0,.28,0);r.eR.Position=UDim2.new(.49+(math.random()-.5)*.06,0,.28,0)
  elseif n<.75 then r.eL.Rotation=0;r.eR.Rotation=0;r.mo.Rotation=180
  else r.eL.Rotation=0;r.eR.Rotation=0;r.mo.Rotation=0 end
 end
 local s=Vector3.new((math.random()-.5)*.4,(math.random()-.5)*.4,(math.random()-.5)*.4)
 r.fc.CFrame=r.fc.CFrame+s;r.au.CFrame=r.au.CFrame+s
end

local function updP(r,ps,dr)
 local cf=CFrame.lookAt(ps,ps+dr)
 if r.t=="A60" then
  r.hd.CFrame=cf;r.fg.CFrame=cf
  r.eL.CFrame=cf*CFrame.new(-1.3,.9,-2.2);r.eR.CFrame=cf*CFrame.new(1.3,.9,-2.2)
  r.mB.CFrame=cf*CFrame.new(0,-1.1,-2.1);r.mC.CFrame=cf*CFrame.new(0,-.15,-2.09)
 else r.fc.CFrame=cf;r.au.CFrame=cf end
end

local function hid()
 local ch=LP.Character;if not ch then return false end
 local h=ch:FindFirstChildOfClass("Humanoid");if not h then return false end
 for _,a in ipairs{"InLocker","Hiding"} do
  local ok,v=pcall(function() return h:GetAttribute(a) end);if ok and v then return true end
  ok,v=pcall(function() return ch:GetAttribute(a) end);if ok and v then return true end
 end
 if ch:FindFirstChild("InLocker") or ch:FindFirstChild("Hiding") then return true end
 local rt=ch:FindFirstChild("HumanoidRootPart");if not rt then return false end
 for _,p in ipairs(workspace:GetPartBoundsInRadius(rt.Position,15)) do
  local n=p.Name:lower()
  if n:find("locker") or n:find("closet") or n:find("wardrobe") or n:find("cabinet") then return true end
  local ok,hs=pcall(function() return p:HasTag("Locker") end)
  if ok and hs then return true end
 end
 for _,o in ipairs(workspace:GetDescendants()) do
  if o:IsA("Model") and o~=ch then
   local n=o.Name:lower()
   if n:find("locker") or n:find("closet") or n:find("wardrobe") then
    for _,d in ipairs(o:GetDescendants()) do
     if d:IsA("BasePart") then
      local rl=d.CFrame:PointToObjectSpace(rt.Position)
      if math.abs(rl.X)<d.Size.X/2+1 and math.abs(rl.Y)<d.Size.Y/2+1 and math.abs(rl.Z)<d.Size.Z/2+1 then return true end
     end
    end
   end
  end
 end
 return false
end

local rg=Instance.new("ScreenGui",PG)
rg.Name="RoomsFx";rg.ResetOnSpawn=false;rg.IgnoreGuiInset=true;rg.DisplayOrder=999
local rf=Instance.new("Frame",rg)
rf.Size=UDim2.new(1,0,1,0);rf.BackgroundColor3=Color3.fromRGB(255,0,0);rf.BackgroundTransparency=1;rf.BorderSizePixel=0
local sf=Instance.new("Frame",rg)
sf.Size=UDim2.new(1,0,1,0);sf.BackgroundColor3=Color3.fromRGB(255,250,220);sf.BackgroundTransparency=1;sf.BorderSizePixel=0;sf.ZIndex=2

local function jump(w)
 local s=Instance.new("Sound",PG);s.SoundId=CFG.sJ;s.Volume=w and 6 or 5;s:Play();DB:AddItem(s,3)
 rf.BackgroundColor3=w and Color3.new(1,1,1) or Color3.fromRGB(255,0,0);rf.BackgroundTransparency=0
 if w then shake(3,.8) end
 task.wait(1.4)
 TS:Create(rf,TweenInfo.new(.8),{BackgroundTransparency=1}):Play()
 local ch=LP.Character
 if ch then local h=ch:FindFirstChildOfClass("Humanoid");if h then h.Health=0 end end
end

local function sealFx()
 for _=1,2 do sf.BackgroundTransparency=0;task.wait(.07);sf.BackgroundTransparency=.55;task.wait(.07) end
 sf.BackgroundTransparency=0
 TS:Create(sf,TweenInfo.new(1.1),{BackgroundTransparency=1}):Play()
 local s=Instance.new("Sound",PG);s.SoundId=CFG.sSl;s.Volume=5;s:Play();DB:AddItem(s,4)
end

local function seal(r)
 sealFx()
 if r.pe then r.pe.Enabled=false end
 local cp=r.t=="A60" and r.hd.Position or r.fc.Position
 local gp=Vector3.new(cp.X,cp.Y-3,cp.Z)
 local cm=Instance.new("Model",workspace)
 local oR=np(cm,{Shape=Enum.PartType.Cylinder,Size=Vector3.new(.12,16,16),CFrame=CFrame.new(gp)*CFrame.Angles(0,0,math.rad(90)),Material=Enum.Material.Neon,Color=Color3.fromRGB(255,215,80),Transparency=.25})
 local iR=np(cm,{Shape=Enum.PartType.Cylinder,Size=Vector3.new(.12,8,8),CFrame=CFrame.new(gp+Vector3.new(0,.1,0))*CFrame.Angles(0,0,math.rad(90)),Material=Enum.Material.Neon,Color=Color3.fromRGB(255,215,80),Transparency=.15})
 local sp=true
 task.spawn(function()
  local t=0
  while sp and cm.Parent do
   local dt=RS.Heartbeat:Wait();t=t+dt
   oR.CFrame=CFrame.new(gp)*CFrame.Angles(0,t*2,0)*CFrame.Angles(0,0,math.rad(90))
   iR.CFrame=CFrame.new(gp+Vector3.new(0,.1,0))*CFrame.Angles(0,t*3.2,0)*CFrame.Angles(0,0,math.rad(90))
  end
 end)
 task.wait(.8)
 local gd=Color3.fromRGB(255,230,150)
 if r.t=="A60" then
  for _,o in ipairs{r.hd,r.eL,r.eR,r.mB,r.mC} do TS:Create(o,TweenInfo.new(.9),{Color=gd,Transparency=1}):Play() end
  TS:Create(r.hd,TweenInfo.new(.9),{Size=Vector3.new(.1,.1,.1)}):Play()
  TS:Create(r.fg,TweenInfo.new(.9),{Color=gd,Transparency=1,Size=Vector3.new(.1,.1,.1)}):Play()
 else
  TS:Create(r.fc,TweenInfo.new(.9),{Color=gd,Transparency=1,Size=Vector3.new(.1,.1,.1)}):Play()
  TS:Create(r.au,TweenInfo.new(.9),{Color=gd,Transparency=1,Size=Vector3.new(.1,.1,.1)}):Play()
 end
 if r.li then TS:Create(r.li,TweenInfo.new(.9),{Brightness=0,Range=0}):Play() end
 task.delay(1.2,function()
  sp=false
  for _,d in ipairs(cm:GetDescendants()) do if d:IsA("BasePart") then TS:Create(d,TweenInfo.new(.6),{Transparency=1}):Play() end end
  task.wait(.7);cm:Destroy()
 end)
 task.delay(1,function() if r.m and r.m.Parent then r.m:Destroy() end end)
end

local hasCr=false
local function mkCr()
 local t
 local ok,m=pcall(function() local o=game:GetObjects(CRID);return o and o[1] end)
 if ok and m then
  if m:IsA("Tool") then t=m
  else t=Instance.new("Tool");t.Name="Crucifix";m.Parent=t end
 end
 if not t then
  t=Instance.new("Tool");t.Name="Crucifix";t.RequiresHandle=true
  local h=Instance.new("Part",t);h.Name="Handle";h.Size=Vector3.new(.3,2,.3)
  h.BrickColor=BrickColor.new("Brown");h.Material=Enum.Material.Wood;h.CanCollide=false
  local b=Instance.new("Part",t);b.Size=Vector3.new(1.2,.3,.3)
  b.BrickColor=BrickColor.new("Brown");b.Material=Enum.Material.Wood;b.CanCollide=false
  local w=Instance.new("WeldConstraint",h);w.Part0=h;w.Part1=b
  b.CFrame=h.CFrame*CFrame.new(0,.5,0)
 end
 t.Name="Crucifix";t.CanBeDropped=false
 if not t:FindFirstChild("Handle") then local bp=t:FindFirstChildWhichIsA("BasePart");if bp then bp.Name="Handle" end end
 local h=t:FindFirstChild("Handle")
 if h then
  local old=h:FindFirstChildOfClass("PointLight");if old then old:Destroy() end
  local li=Instance.new("PointLight",h);li.Color=Color3.fromRGB(255,215,0);li.Brightness=3;li.Range=8
  local at=Instance.new("Attachment",h)
  local pe=Instance.new("ParticleEmitter",at)
  pe.Texture="rbxassetid://243660364";pe.Rate=15;pe.Lifetime=NumberRange.new(.5,1)
  pe.Speed=NumberRange.new(1,3);pe.SpreadAngle=Vector2.new(180,180)
  pe.Color=ColorSequence.new(Color3.fromRGB(255,215,0));pe.Size=NumberSequence.new(.3,0)
  pe.Transparency=NumberSequence.new(.2,1)
 end
 t.Grip=CFrame.new(0,-.5,0)
 t.Equipped:Connect(function()
  local ch=LP.Character;if not ch then return end
  local hl=Instance.new("Highlight",ch)
  hl.FillColor=Color3.fromRGB(255,215,0);hl.FillTransparency=.8;hl.OutlineColor=Color3.fromRGB(255,255,200)
  DB:AddItem(hl,1.5)
 end)
 return t
end
bCr.MouseButton1Click:Connect(function()
 if hasCr then return end
 hasCr=true;mkCr().Parent=LP.Backpack
end)
local function holdCr()
 local ch=LP.Character;if not ch then return false end
 local t=ch:FindFirstChildOfClass("Tool")
 return t and t.Name=="Crucifix"
end

local entOn=false
local curE=nil
local function stopE()
 entOn=false
 if curE then curE:Destroy();curE=nil end
 omenEnd(1.2)
end

local function spawnE(k)
 if entOn then return end
 local ch=LP.Character;if not ch then return end
 local rt=ch:FindFirstChild("HumanoidRootPart");if not rt then return end
 entOn=true
 local w=k=="A120"
 local om=w and CFG.a120Om or CFG.a60Om
 omen(om,w)
 task.spawn(function()
  task.wait(om+.1)
  if not entOn then omenEnd(1);return end
  local p0=ch:FindFirstChild("HumanoidRootPart");if not p0 then entOn=false;omenEnd(1);return end
  local pp=p0.Position
  local bd=-p0.CFrame.LookVector
  local sp=pp+bd*(w and CFG.a120Sp or CFG.a60Sp)
  sp=Vector3.new(sp.X,pp.Y+2,sp.Z)
  local fd=(pp-sp);fd=Vector3.new(fd.X,0,fd.Z).Unit
  local r
  if w then r=mkA120(sp,fd) else r=mkA60(sp,fd) end
  r.m.Parent=workspace;curE=r.m
  local dr,st2,wd
  if w then
   dr=Instance.new("Sound",r.fc);dr.SoundId=CFG.s120D;dr.Volume=.5;dr.Looped=true;dr:Play()
   st2=Instance.new("Sound",r.fc);st2.SoundId=CFG.s60S;st2.Volume=2.5;st2.Looped=true;st2:Play()
   wd=Instance.new("Sound",r.fc);wd.SoundId=CFG.s120W;wd.Volume=0;wd.Looped=true;wd:Play()
  else
   st2=Instance.new("Sound",r.hd);st2.SoundId=CFG.s60S;st2.Volume=3;st2.Looped=true;st2:Play()
  end
  local pc=w and math.random(CFG.a120Rb1,CFG.a120Rb2) or math.random(3,5)
  local pd=1
  for i=1,pc do
   if not entOn then return end
   local pr=ch:FindFirstChild("HumanoidRootPart");if not pr then stopE();return end
   shake(.35,.22)
   if w then
    local dh=Instance.new("Sound",PG);dh.SoundId=CFG.s120D;dh.Volume=5;dh:Play();DB:AddItem(dh,2)
   else
    local ds=Instance.new("Sound",PG);ds.SoundId=CFG.s60D;ds.Volume=2.5;ds:Play();DB:AddItem(ds,2)
   end
   local cp=pr.Position;local fw=pr.CFrame.LookVector
   local to=w and fw*CFG.a120Pa or (pd==1 and fw*CFG.a60Pa or -fw*CFG.a60Pa)
   local tp=cp+to+Vector3.new(0,2,0)
   local ct=false
   while entOn do
    local p2=ch:FindFirstChild("HumanoidRootPart");if not p2 then stopE();return end
    local pp2=r.t=="A60" and r.hd.Position or r.fc.Position
    local d=tp-pp2;local di=d.Magnitude
    if di<2 then break end
    local dir=d.Unit
    local dt=RS.Heartbeat:Wait()
    local sd=w and CFG.a120Sd or CFG.a60Sd
    local stp=math.min(sd*dt,di)
    local npx=pp2+dir*stp
    updP(r,npx,dir)
    if w then
     upd120(r)
     local dp=(npx-p2.Position).Magnitude
     local rng=CFG.a120Sp*1.5
     local cl=math.clamp(1-dp/rng,0,1)
     if dr and dr.Parent then dr.Volume=.5+7.5*cl end
     if wd and wd.Parent then wd.Volume=dp<60 and 5*(1-dp/60) or 0 end
    end
    if not ct then
     local dp=(npx-p2.Position).Magnitude
     local cr=w and CFG.a120Cr or CFG.a60Cr
     if dp<cr then
      ct=true
      if hid() then
      elseif holdCr() then
       local c=ch:FindFirstChild("Crucifix");if c then c:Destroy() end
       local bp=LP.Backpack:FindFirstChild("Crucifix");if bp then bp:Destroy() end
       hasCr=false;entOn=false;curE=nil
       seal(r);omenEnd(1.2);return
      else
       jump(w);stopE();return
      end
     end
    end
   end
   if not w then pd=-pd end
   if w and entOn and i<pc then
    task.wait(CFG.a120St)
    local rb=Instance.new("Sound",PG);rb.SoundId=CFG.s120D;rb.Volume=4;rb:Play();DB:AddItem(rb,2)
   end
   if i<pc and entOn then
    local mn2=w and CFG.a120W1 or CFG.a60W1
    local mx=w and CFG.a120W2 or CFG.a60W2
    task.wait(math.random()*(mx-mn2)+mn2)
   end
  end
  if entOn then
   entOn=false;task.wait(.6)
   if curE then curE:Destroy();curE=nil end
   omenEnd(1.2)
  end
 end)
end
b60.MouseButton1Click:Connect(function() spawnE("A60") end)
b120.MouseButton1Click:Connect(function() spawnE("A120") end)

local hiddenFolder=Instance.new("Folder",LP)
hiddenFolder.Name="RiftHidden"

local RS2={entries={}}
local function saveR()
 if not writefile then return end
 local clean={entries={}}
 for _,e in ipairs(RS2.entries) do
  table.insert(clean.entries,{
   label=e.label,className=e.className,savedAt=e.savedAt,instance=e.instance,
  })
 end
 local ok,enc=pcall(function() return HS:JSONEncode(clean) end)
 if ok and enc then pcall(writefile,RF,enc) end
end
local function loadR()
 if not (readfile and isfile) then return end
 if not isfile(RF) then return end
 local ok,c=pcall(readfile,RF);if not ok or not c then return end
 local ok2,d=pcall(function() return HS:JSONDecode(c) end)
 if ok2 and d and type(d)=="table" then RS2=d;if type(RS2.entries)~="table" then RS2.entries={} end end
end
loadR()

local function sv(v)
 local t=typeof(v)
 if t=="Vector3" then return{__t="V3",x=v.X,y=v.Y,z=v.Z}
 elseif t=="CFrame" then return{__t="CF",c={v:GetComponents()}}
 elseif t=="Color3" then return{__t="C3",r=v.R,g=v.G,b=v.B}
 elseif t=="BrickColor" then return{__t="BC",n=v.Name}
 elseif t=="EnumItem" then return{__t="E",et=tostring(v.EnumType),n=v.Name}
 elseif t=="number" or t=="string" or t=="boolean" then return v end
 return nil
end
local function dv(d)
 if type(d)~="table" then return d end
 local t=d.__t
 if t=="V3" then return Vector3.new(d.x,d.y,d.z)
 elseif t=="CF" then return CFrame.new(unpack(d.c))
 elseif t=="C3" then return Color3.new(d.r,d.g,d.b)
 elseif t=="BC" then return BrickColor.new(d.n)
 elseif t=="E" then local ok,e=pcall(function() return Enum[d.et][d.n] end);return ok and e or nil end
 return nil
end
local PR={"Size","CFrame","Color","BrickColor","Material","Transparency","Anchored","CanCollide","Shape","Reflectance","MeshId","TextureID","Grip","RequiresHandle","CanBeDropped","Value","Name"}
local AL={"BasePart","Model","ValueBase","Attachment","ParticleEmitter","PointLight","SpotLight","SurfaceLight","SurfaceGui","BillboardGui","Sound","SpecialMesh","Trail","Beam","Highlight","Decal","Texture"}
local function can(i) for _,c in ipairs(AL) do if i:IsA(c) then return true end end return false end
local function si(i,d)
 d=d or 0;if d>6 then return nil end
 local o={ClassName=i.ClassName,Name=i.Name,Props={},Children={}}
 for _,p in ipairs(PR) do
  local ok,v=pcall(function() return i[p] end)
  if ok and v~=nil then local s=sv(v);if s~=nil then o.Props[p]=s end end
 end
 for _,c in ipairs(i:GetChildren()) do
  if can(c) then local cd=si(c,d+1);if cd then table.insert(o.Children,cd) end end
 end
 return o
end
local function di(d,pa)
 if not d or not d.ClassName then return nil end
 local ok,i=pcall(Instance.new,d.ClassName)
 if not ok or not i then return nil end
 i.Name=d.Name or d.ClassName
 for p,s in pairs(d.Props or {}) do
  local v=dv(s);if v~=nil then pcall(function() i[p]=v end) end
 end
 for _,cd in ipairs(d.Children or {}) do
  local c=di(cd,i);if c then c.Parent=i end
 end
 if pa then i.Parent=pa end
 return i
end
local function getIcon(cn)
 local m={Tool="T",Model="M",Part="P",MeshPart="P",UnionOperation="P",Accessory="A",Sound="S",PointLight="L",SpotLight="L",SurfaceLight="L",ParticleEmitter="*",Decal="D",Texture="D",Highlight="H",SurfaceGui="G",BillboardGui="G",Attachment="+",IntValue="V",StringValue="V",BoolValue="V",NumberValue="V",Trail="-",Beam="-"}
 return m[cn] or "?"
end

local activeR={}
local function mkRift(pos)
 local ch=LP.Character
 local pp=ch and ch:FindFirstChild("HumanoidRootPart") and ch.HumanoidRootPart.Position
 if not pp then pp=pos+Vector3.new(0,0,10) end
 local dir=pp-pos
 dir=Vector3.new(dir.X,0,dir.Z)
 if dir.Magnitude<0.1 then dir=Vector3.new(0,0,1) end
 dir=dir.Unit
 local m=Instance.new("Model",workspace);m.Name="Rift"
 local cp=pos+Vector3.new(0,2.5,0)
 local faceCF=CFrame.lookAt(cp,cp+dir)*CFrame.Angles(0,math.rad(90),0)
 local up=Vector3.new(0,1,0)
 local tang=dir:Cross(up).Unit
 for i=1,11 do
  local ang=(i/11)*math.pi*2+(math.random()-.5)*.5
  local len=3.5+math.random()*5
  local innerR=1.6
  local midR=innerR+len/2
  local rad=(up*math.sin(ang)+tang*math.cos(ang)).Unit
  local lc=cp+rad*midR
  np(m,{Size=Vector3.new(.24,.16,len),CFrame=CFrame.lookAt(lc,lc+rad),Material=Enum.Material.Neon,Color=Color3.new(1,1,1),Transparency=.05})
 end
 local base=np(m,{Shape=Enum.PartType.Cylinder,Size=Vector3.new(.25,3.2,3.2),CFrame=faceCF,Material=Enum.Material.SmoothPlastic,Color=Color3.fromRGB(15,20,28),Transparency=.05})
 np(m,{Shape=Enum.PartType.Cylinder,Size=Vector3.new(.2,2.0,2.0),CFrame=faceCF*CFrame.new(.15,0,0),Material=Enum.Material.Neon,Color=Color3.fromRGB(100,220,255),Transparency=.1})
 np(m,{Shape=Enum.PartType.Cylinder,Size=Vector3.new(.22,1.0,1.0),CFrame=faceCF*CFrame.new(.2,0,0),Material=Enum.Material.SmoothPlastic,Color=Color3.fromRGB(15,20,28)})
 for i=1,2 do
  local a=(i-1)*math.pi+math.pi/4
  np(m,{Size=Vector3.new(.15,.55,.55),CFrame=faceCF*CFrame.new(.28,math.sin(a)*.7,math.cos(a)*.7)*CFrame.Angles(0,-a,0),Material=Enum.Material.Neon,Color=Color3.fromRGB(100,220,255)})
 end
 local li=Instance.new("PointLight",base)
 li.Color=Color3.fromRGB(200,230,255);li.Brightness=10;li.Range=28
 local at=Instance.new("Attachment",base)
 local pe=Instance.new("ParticleEmitter",at)
 pe.Texture="rbxassetid://243660364";pe.Rate=80;pe.Lifetime=NumberRange.new(.6,1.4)
 pe.Speed=NumberRange.new(2,7);pe.SpreadAngle=Vector2.new(180,180)
 pe.Color=ColorSequence.new(Color3.new(1,1,1));pe.Size=NumberSequence.new(.5,0)
 pe.Transparency=NumberSequence.new(.05,1);pe.LightEmission=1
 local data={m=m,pos=cp,core=base,faceCF=faceCF,dir=dir,iconPart=nil}
 table.insert(activeR,data)
 return data
end

local function updateRiftIcon(r,entry)
 if r.iconPart then r.iconPart:Destroy() r.iconPart=nil end
 if not entry then return end
 local icon=np(r.m,{Size=Vector3.new(.18,2.4,2.4),CFrame=r.faceCF*CFrame.new(.4,0,0),Material=Enum.Material.SmoothPlastic,Color=Color3.fromRGB(30,40,50),Transparency=.1})
 local sG=Instance.new("SurfaceGui",icon)
 sG.Face=Enum.NormalId.Right;sG.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;sG.PixelsPerStud=100
 local lb=Instance.new("TextLabel",sG)
 lb.Size=UDim2.new(1,0,1,0);lb.BackgroundTransparency=1
 lb.Text=getIcon(entry.className or "?")
 lb.TextColor3=Color3.fromRGB(100,220,255)
 lb.TextScaled=true;lb.Font=Enum.Font.GothamBold
 r.iconPart=icon
end

bJr.MouseButton1Click:Connect(function()
 local ch=LP.Character;if not ch then return end
 local rt=ch:FindFirstChild("HumanoidRootPart");if not rt then return end
 local fw=rt.CFrame.LookVector
 local pos=rt.Position+Vector3.new(fw.X,0,fw.Z).Unit*5
 local rp=RaycastParams.new()
 rp.FilterDescendantsInstances={ch,CAM}
 rp.FilterType=Enum.RaycastFilterType.Exclude
 local hit=workspace:Raycast(pos+Vector3.new(0,10,0),Vector3.new(0,-50,0),rp)
 if hit then pos=Vector3.new(pos.X,hit.Position.Y,pos.Z) end
 mkRift(pos)
 shake(.4,.2)
end)

local nearR=nil
RS.Heartbeat:Connect(function()
 local ch=LP.Character;if not ch then nearR=nil return end
 local rt=ch:FindFirstChild("HumanoidRootPart");if not rt then nearR=nil return end
 local cl,cd=nil,14
 for _,r in ipairs(activeR) do
  if r.m.Parent then
   local d=(r.pos-rt.Position).Magnitude
   if d<cd then cd=d;cl=r end
  end
 end
 nearR=cl
end)

local tip=Instance.new("TextLabel",sg)
tip.Size=UDim2.new(0,300,0,40);tip.Position=UDim2.new(.5,-150,.4,0)
tip.BackgroundColor3=Color3.fromRGB(40,10,10);tip.BackgroundTransparency=.15
tip.TextColor3=Color3.fromRGB(255,200,200);tip.Font=Enum.Font.GothamBold;tip.TextSize=14
tip.Visible=false;tip.ZIndex=200
Instance.new("UICorner",tip).CornerRadius=UDim.new(0,8)
local tipT=0
local function showTip(txt) tip.Text=txt;tip.Visible=true;tipT=tick() end
RS.Heartbeat:Connect(function() if tip.Visible and tick()-tipT>2 then tip.Visible=false end end)

local hb=Instance.new("Frame",sg)
hb.Size=UDim2.new(0,90,0,90);hb.Position=UDim2.new(.5,-45,.68,0)
hb.BackgroundColor3=Color3.fromRGB(15,15,15);hb.BackgroundTransparency=.35
hb.BorderSizePixel=0;hb.Visible=false;hb.ZIndex=60
Instance.new("UICorner",hb).CornerRadius=UDim.new(1,0)
local hbs=Instance.new("UIStroke",hb);hbs.Color=Color3.fromRGB(100,220,255);hbs.Thickness=2;hbs.Transparency=.3
local hbI=Instance.new("TextLabel",hb)
hbI.Size=UDim2.new(1,0,1,0);hbI.BackgroundTransparency=1
hbI.Text="O";hbI.TextColor3=Color3.fromRGB(180,240,255);hbI.TextScaled=true;hbI.Font=Enum.Font.GothamBold;hbI.ZIndex=61
local hbL=Instance.new("TextLabel",hb)
hbL.Size=UDim2.new(0,120,0,22);hbL.Position=UDim2.new(.5,-60,1,6)
hbL.BackgroundTransparency=1;hbL.Text="按住"
hbL.TextColor3=Color3.fromRGB(180,240,255);hbL.TextScaled=true;hbL.Font=Enum.Font.GothamBold;hbL.ZIndex=61
local hpr=Instance.new("Frame",hb)
hpr.Size=UDim2.new(1,6,1,6);hpr.Position=UDim2.new(0,-3,0,-3)
hpr.BackgroundTransparency=1;hpr.ZIndex=59
Instance.new("UICorner",hpr).CornerRadius=UDim.new(1,0)
local hprs=Instance.new("UIStroke",hpr);hprs.Color=Color3.fromRGB(100,220,255);hprs.Thickness=4;hprs.Transparency=1

local hold=false;local hSt=0;local hTrig=false
local function beginH()
 if hTrig or not nearR then return end
 hold=true;hSt=tick();hTrig=false
end
local function cancelH()
 hold=false;hSt=0;hTrig=false
 hprs.Transparency=1;hb.BackgroundColor3=Color3.fromRGB(15,15,15)
end
local function doCompleteH()
 if hTrig then return end
 hTrig=true;hold=false
 hprs.Transparency=0;hb.BackgroundColor3=Color3.fromRGB(20,60,90)
 task.delay(.15,function()
  cancelH()
  if not nearR then return end
  local r=nearR
  local ch=LP.Character;if not ch then return end
  local held=ch:FindFirstChildOfClass("Tool")
  if held then
   local data=si(held)
   if not data then showTip("存入失败");return end
   local entry={
    label=held.Name,className=held.ClassName,
    savedAt=os.date("%m/%d %H:%M"),instance=data,
    liveRef=held,
   }
   table.insert(RS2.entries,entry)
   saveR()
   held.Parent=hiddenFolder
   updateRiftIcon(r,entry)
   showTip("已存入："..held.Name)
  else
   if #RS2.entries==0 then showTip("裂缝是空的");return end
   local e=RS2.entries[1]
   local inst
   if e.liveRef and e.liveRef.Parent then
    inst=e.liveRef
    if inst:IsA("Tool") then
     inst.Parent=LP.Backpack
    else
     inst.Parent=workspace
    end
   else
    local ok,test=pcall(Instance.new,e.className)
    if not ok or not test then showTip("该物品在当前游戏中不存在："..e.className);return end
    test:Destroy()
    inst=di(e.instance,nil)
    if not inst then showTip("无法生成："..e.className);return end
    if inst:IsA("Tool") then
     inst.Parent=LP.Backpack
    elseif inst:IsA("BasePart") then
     inst.Parent=workspace
     local rt=ch:FindFirstChild("HumanoidRootPart")
     if rt then
      pcall(function() inst.Anchored=false end)
      pcall(function() inst.CFrame=CFrame.new(rt.Position+rt.CFrame.LookVector*4+Vector3.new(0,2,0)) end)
     end
    elseif inst:IsA("Model") then
     inst.Parent=workspace
     local rt=ch:FindFirstChild("HumanoidRootPart")
     if rt then
      local targetPos=rt.Position+rt.CFrame.LookVector*4+Vector3.new(0,2,0)
      local curPivot=inst:GetPivot()
      local delta=CFrame.new(targetPos)*curPivot:Inverse()
      for _,d in ipairs(inst:GetDescendants()) do
       if d:IsA("BasePart") then
        d.CFrame=delta*d.CFrame
       end
      end
     end
    else
     inst.Parent=LP.Backpack
    end
   end
   table.remove(RS2.entries,1)
   saveR()
   updateRiftIcon(r,RS2.entries[1])
   showTip("已取出："..e.label)
  end
 end)
end
hb.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then beginH() end
end)
hb.InputEnded:Connect(function(i)
 if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) and hold and not hTrig then cancelH() end
end)
hb.MouseLeave:Connect(function() if hold then cancelH() end end)
UIS.InputEnded:Connect(function(i)
 if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) and hold and not hTrig then cancelH() end
end)
RS.Heartbeat:Connect(function()
 if not nearR then hb.Visible=false;if hold then cancelH() end
 else hb.Visible=true end
 if hold and nearR then
  local p=math.clamp((tick()-hSt)/HT,0,1)
  hprs.Transparency=1-p
  hb.BackgroundColor3=Color3.fromRGB(15+5*p,15+45*p,15+75*p)
  if p>=1 then doCompleteH() end
 end
end)

LP.CharacterAdded:Connect(function()
 task.wait(1)
 if hasCr and not LP.Backpack:FindFirstChild("Crucifix") and not LP.Character:FindFirstChild("Crucifix") then
  mkCr().Parent=LP.Backpack
 end
end)

print("[Rooms] v26 加载完成")
