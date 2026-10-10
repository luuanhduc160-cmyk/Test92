-- Bin Hub Script Hub Loader (Fixed Crash & Auto Execute Config Save)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("BinHubExact") then
    CoreGui.BinHubExact:Destroy()
end

if Lighting:FindFirstChild("BinHubBlur") then
    Lighting.BinHubBlur:Destroy()
end

-- Config Save System
local ConfigFileName = "BinHub_Config.json"
local config = { AutoExecute = false }

pcall(function()
    if writefile and readfile and isfile and isfile(ConfigFileName) then
        config = HttpService:JSONDecode(readfile(ConfigFileName))
    end
end)

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(config))
        end
    end)
end

-- Blur Effect behind UI
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "BinHubBlur"
BlurEffect.Size = 15
BlurEffect.Parent = Lighting

-- Background Audio (ID: 78687071861074)
local HubMusic = Instance.new("Sound")
HubMusic.Name = "HubMusic"
HubMusic.SoundId = "rbxassetid://78687071861074"
HubMusic.Volume = 1
HubMusic.Looped = true
HubMusic.Parent = SoundService

local function PlayHubMusic()
    HubMusic.TimePosition = 6
    HubMusic:Play()
end

task.spawn(function()
    task.wait(0.5)
    PlayHubMusic()
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if HubMusic.IsPlaying and HubMusic.TimePosition < 0.5 and HubMusic.TimeLength > 6 then
            HubMusic.TimePosition = 6
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BinHubExact"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("CanvasGroup")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -285, 0.5, -150)
MainFrame.Size = UDim2.new(0, 570, 0, 300)
MainFrame.GroupTransparency = 0
MainFrame.ClipsDescendants = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

local targetScale = 1
local currentScale = 1

RunService.RenderStepped:Connect(function(dt)
    if math.abs(currentScale - targetScale) > 0.001 then
        currentScale = currentScale + (targetScale - currentScale) * math.clamp(dt * 20, 0, 1)
        MainScale.Scale = currentScale
    end
end)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 35, 45)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local GlowStroke = Instance.new("UIStroke")
GlowStroke.Name = "GlowEffect"
GlowStroke.Parent = MainFrame
GlowStroke.Color = Color3.fromRGB(0, 160, 255)
GlowStroke.Thickness = 3
GlowStroke.Transparency = 0.5

local glowRunning = true
task.spawn(function()
    while true do
        if glowRunning then
            local t1 = TweenService:Create(GlowStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.8, Color = Color3.fromRGB(138, 43, 226)})
            t1:Play()
            t1.Completed:Wait()
            local t2 = TweenService:Create(GlowStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.3, Color = Color3.fromRGB(0, 160, 255)})
            t2:Play()
            t2.Completed:Wait()
        else
            task.wait(0.2)
        end
    end
end)

local MainBg = Instance.new("ImageLabel")
MainBg.Parent = MainFrame
MainBg.BackgroundTransparency = 1
MainBg.Size = UDim2.new(1, 0, 1, 0)
MainBg.ImageTransparency = 0.65
MainBg.ScaleType = Enum.ScaleType.Crop

task.spawn(function()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(18343561950)
    end)
    if success and info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
        MainBg.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
    end
end)

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(0, 570, 0, 35)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 6)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Parent = TopBar
TopFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopFix.BackgroundTransparency = 0.2
TopFix.BorderSizePixel = 0
TopFix.Position = UDim2.new(0, 0, 1, -6)
TopFix.Size = UDim2.new(0, 570, 0, 6)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(0, 300, 0, 35)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Bin Hub : Script Hub"
TitleLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinBtn.Position = UDim2.new(0, 540, 0, 7)
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
MinBtn.TextSize = 14

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinBtn

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.Active = true
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 200, 0, 265)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 3
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = Sidebar
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 5)

local SidePadding = Instance.new("UIPadding")
SidePadding.Parent = Sidebar
SidePadding.PaddingTop = UDim.new(0, 8)
SidePadding.PaddingLeft = UDim.new(0, 8)
SidePadding.PaddingRight = UDim.new(0, 8)
SidePadding.PaddingBottom = UDim.new(0, 15)

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 200, 0, 35)
ContentContainer.Size = UDim2.new(0, 370, 0, 265)

local FloatBtn = Instance.new("ImageButton")
FloatBtn.Parent = ScreenGui
FloatBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FloatBtn.BackgroundTransparency = 1
FloatBtn.ImageTransparency = 1
FloatBtn.Position = UDim2.new(0, 15, 0.5, -30)
FloatBtn.Size = UDim2.new(0, 60, 0, 60)
FloatBtn.Visible = false

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 14)
FloatCorner.Parent = FloatBtn

task.spawn(function()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(83645629621104)
    end)
    if success and info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
        FloatBtn.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
    end
end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local floatDragging, floatDragStart, floatStartPos
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatDragStart = input.Position
        floatStartPos = FloatBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatDragStart
        FloatBtn.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
    end
end)

FloatBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = false
    end
end)

local closeDropdownFunc = nil

MinBtn.MouseButton1Click:Connect(function()
    if closeDropdownFunc then closeDropdownFunc() end
    
    glowRunning = false
    TweenService:Create(GlowStroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.25), {Size = 0}):Play()
    
    HubMusic:Stop()
    
    local tInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tInfo, {GroupTransparency = 1}):Play()
    task.wait(0.25)
    MainFrame.Visible = false
    MainFrame.GroupTransparency = 0
    MainStroke.Transparency = 0
    
    FloatBtn.Visible = true
    FloatBtn.BackgroundTransparency = 1
    FloatBtn.ImageTransparency = 1
    TweenService:Create(FloatBtn, tInfo, {BackgroundTransparency = 0, ImageTransparency = 0}):Play()
end)

FloatBtn.MouseButton1Click:Connect(function()
    BlurEffect.Size = 0
    TweenService:Create(BlurEffect, TweenInfo.new(0.25), {Size = 15}):Play()
    
    PlayHubMusic()
    
    local tInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FloatBtn, tInfo, {BackgroundTransparency = 1, ImageTransparency = 1}):Play()
    task.wait(0.25)
    FloatBtn.Visible = false
    FloatBtn.BackgroundTransparency = 0
    FloatBtn.ImageTransparency = 0
    
    MainStroke.Transparency = 0
    MainFrame.GroupTransparency = 1
    MainFrame.Visible = true
    TweenService:Create(MainFrame, tInfo, {GroupTransparency = 0}):Play()
    
    glowRunning = true
end)

local tabs = {}
local pages = {}

local function CreateTab(name, iconId)
    local index = #tabs + 1
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    TabBtn.BackgroundTransparency = 0.2
    TabBtn.Size = UDim2.new(0, 184, 0, 36)
    TabBtn.AutoButtonColor = true
    TabBtn.Text = ""
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn
    
    local textXOffset = 10
    if iconId and iconId ~= 0 then
        textXOffset = 34
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 6, 0.5, -11)
        TabIcon.Size = UDim2.new(0, 22, 0, 22)
        TabIcon.ScaleType = Enum.ScaleType.Crop
        
        local IconCorner = Instance.new("UICorner")
        IconCorner.CornerRadius = UDim.new(0, 4)
        IconCorner.Parent = TabIcon
        
        task.spawn(function()
            local success, info = pcall(function()
                return MarketplaceService:GetProductInfo(iconId)
            end)
            if success and info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
                TabIcon.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
            else
                local successDirect = pcall(function()
                    TabIcon.Image = "rbxassetid://" .. tostring(iconId)
                end)
                if not successDirect then
                    TabIcon.Image = "rbxassetid://18343561950"
                end
            end
        end)
    end
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Parent = TabBtn
    TabLabel.BackgroundTransparency = 1
    TabLabel.Position = UDim2.new(0, textXOffset, 0, 0)
    TabLabel.Size = UDim2.new(1, -textXOffset, 1, 0)
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.Text = name
    TabLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
    TabLabel.TextSize = 11
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local Indicator = Instance.new("Frame")
    Indicator.Parent = TabBtn
    Indicator.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(0, 0, 0.2, 0)
    Indicator.Size = UDim2.new(0, 3, 0.6, 0)
    Indicator.Visible = false
    
    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = Indicator
    
    local PageFrame = Instance.new("ScrollingFrame")
    PageFrame.Parent = ContentContainer
    PageFrame.Active = true
    PageFrame.BackgroundTransparency = 1
    PageFrame.BorderSizePixel = 0
    PageFrame.Size = UDim2.new(0, 370, 0, 265)
    PageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    PageFrame.ScrollBarThickness = 3
    PageFrame.Visible = false
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = PageFrame
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = PageFrame
    PagePadding.PaddingTop = UDim.new(0, 8)
    PagePadding.PaddingLeft = UDim.new(0, 8)
    PagePadding.PaddingRight = UDim.new(0, 12)
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        PageFrame.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, t in pairs(tabs) do 
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 30)}):Play()
            TweenService:Create(t.Lbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 165)}):Play()
            t.Ind.Visible = false
        end
        PageFrame.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)}):Play()
        TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        Indicator.Visible = true
    end)
    
    table.insert(tabs, {Btn = TabBtn, Lbl = TabLabel, Ind = Indicator})
    table.insert(pages, PageFrame)
    
    if index == 1 then
        PageFrame.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.Visible = true
    end
    
    return PageFrame
end

local function AddHeader(page, text)
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Parent = page
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Size = UDim2.new(0, 350, 0, 22)
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.Text = "  " .. text
    HeaderLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
    HeaderLabel.TextSize = 11
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddScriptButton(page, name, url)
    local ScriptBtn = Instance.new("TextButton")
    ScriptBtn.Parent = page
    ScriptBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    ScriptBtn.BackgroundTransparency = 0.2
    ScriptBtn.Size = UDim2.new(0, 350, 0, 38)
    ScriptBtn.Font = Enum.Font.GothamBold
    ScriptBtn.Text = "  " .. name
    ScriptBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
    ScriptBtn.TextSize = 12
    ScriptBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ScriptBtn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(38, 38, 48)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = ScriptBtn
    
    local isExecuting = false
    ScriptBtn.MouseButton1Click:Connect(function()
        if isExecuting then return end
        isExecuting = true
        
        TweenService:Create(ScriptBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 35, 20)}):Play()
        
        task.spawn(function()
            local success, result = pcall(function()
                local reqSuccess, code = pcall(function()
                    return game:HttpGet(url)
                end)
                if not reqSuccess or not code or code == "" then
                    error("Không thể kết nối mạng hoặc link không hợp lệ.")
                end
                
                local fn, loadErr = loadstring(code)
                if not fn then
                    error("Lỗi biên dịch script: " .. tostring(loadErr))
                end
                
                fn()
            end)
            
            if not success then
                warn("Script error [" .. name .. "]: " .. tostring(result))
            end
            
            task.wait(0.3)
            TweenService:Create(ScriptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
            isExecuting = false
        end)
    end)
end

local function AddToggle(page, name, initialState, callback)
    local state = initialState
    
    local ToggleContainer = Instance.new("TextButton")
    ToggleContainer.Parent = page
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    ToggleContainer.BackgroundTransparency = 0.2
    ToggleContainer.Size = UDim2.new(0, 350, 0, 38)
    ToggleContainer.AutoButtonColor = false
    ToggleContainer.Text = ""
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleContainer
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(38, 38, 48)
    Stroke.Thickness = 1
    Stroke.Parent = ToggleContainer
    
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleContainer
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0, 240, 1, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = "  " .. name
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Track = Instance.new("Frame")
    Track.Parent = ToggleContainer
    Track.AnchorPoint = Vector2.new(1, 0.5)
    Track.BackgroundColor3 = state and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(40, 40, 50)
    Track.Position = UDim2.new(1, -12, 0.5, 0)
    Track.Size = UDim2.new(0, 40, 0, 20)
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    
    local Knob = Instance.new("Frame")
    Knob.Parent = Track
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210)
    Knob.Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    Knob.Size = UDim2.new(0, 14, 0, 14)
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    ToggleContainer.MouseButton1Click:Connect(function()
        state = not state
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if state then
            TweenService:Create(Track, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 160, 255)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(1, -17, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Track, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Color3.fromRGB(200, 200, 210)}):Play()
        end
        pcall(function() callback(state) end)
    end)
end

local function AddInput(page, name, placeholder, callback)
    local Container = Instance.new("Frame")
    Container.Parent = page
    Container.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Container.BackgroundTransparency = 0.2
    Container.Size = UDim2.new(0, 350, 0, 38)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Container
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(38, 38, 48)
    Stroke.Thickness = 1
    Stroke.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = Container
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TextBox.Position = UDim2.new(1, -125, 0.5, -13)
    TextBox.Size = UDim2.new(0, 115, 0, 26)
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = placeholder
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 12
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = TextBox
    
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            pcall(function() callback(tonumber(TextBox.Text)) end)
        end
    end)
end

-- ================= AUTO EXECUTE SETUP =================
local function SetupAutoExecute()
    pcall(function()
        local executorQueue = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if executorQueue and config.AutoExecute then
            executorQueue([[loadstring(game:HttpGet("https://raw.githubusercontent.com/luuanhduc160-cmyk/Lapizx/refs/heads/main/Test.lua"))()]])
        end
    end)
end

-- Nếu đang bật, queue sẵn ngay từ đầu
if config.AutoExecute then
    SetupAutoExecute()
end


-- ================= TAB 1: INFO =================
local InfoTab = CreateTab("Info", 6929018183)

local PlayerCard = Instance.new("Frame")
PlayerCard.Parent = InfoTab
PlayerCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
PlayerCard.BackgroundTransparency = 0.2
PlayerCard.Size = UDim2.new(0, 350, 0, 65)

local PlayerCorner = Instance.new("UICorner")
PlayerCorner.CornerRadius = UDim.new(0, 6)
PlayerCorner.Parent = PlayerCard

local PlayerStroke = Instance.new("UIStroke")
PlayerStroke.Color = Color3.fromRGB(38, 38, 48)
PlayerStroke.Thickness = 1
PlayerStroke.Parent = PlayerCard

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = PlayerCard
AvatarImg.BackgroundTransparency = 1
AvatarImg.Position = UDim2.new(0, 10, 0.5, -22)
AvatarImg.Size = UDim2.new(0, 44, 0, 44)
AvatarImg.Image = "rbxassetid://0"

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

task.spawn(function()
    local success, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if success and thumb then
        AvatarImg.Image = thumb
    end
end)

local DisplayNameLabel = Instance.new("TextLabel")
DisplayNameLabel.Parent = PlayerCard
DisplayNameLabel.BackgroundTransparency = 1
DisplayNameLabel.Position = UDim2.new(0, 65, 0, 12)
DisplayNameLabel.Size = UDim2.new(0, 270, 0, 20)
DisplayNameLabel.Font = Enum.Font.GothamBold
DisplayNameLabel.Text = localPlayer.DisplayName
DisplayNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayNameLabel.TextSize = 13
DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Parent = PlayerCard
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Position = UDim2.new(0, 65, 0, 32)
UsernameLabel.Size = UDim2.new(0, 270, 0, 20)
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.Text = "@" .. localPlayer.Name
UsernameLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
UsernameLabel.TextSize = 11
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left

local GameCard = Instance.new("Frame")
GameCard.Parent = InfoTab
GameCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
GameCard.BackgroundTransparency = 0.2
GameCard.Size = UDim2.new(0, 350, 0, 65)

local GameCorner = Instance.new("UICorner")
GameCorner.CornerRadius = UDim.new(0, 6)
GameCorner.Parent = GameCard

local GameStroke = Instance.new("UIStroke")
GameStroke.Color = Color3.fromRGB(38, 38, 48)
GameStroke.Thickness = 1
GameStroke.Parent = GameCard

local GameImg = Instance.new("ImageLabel")
GameImg.Parent = GameCard
GameImg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
GameImg.Position = UDim2.new(0, 10, 0.5, -22)
GameImg.Size = UDim2.new(0, 44, 0, 44)
GameImg.Image = ""
GameImg.ScaleType = Enum.ScaleType.Crop

local GameImgCorner = Instance.new("UICorner")
GameImgCorner.CornerRadius = UDim.new(0, 6)
GameImgCorner.Parent = GameImg

local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Parent = GameCard
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Position = UDim2.new(0, 65, 0, 12)
GameNameLabel.Size = UDim2.new(0, 275, 0, 20)
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.Text = "Loading game name..."
GameNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GameNameLabel.TextSize = 12
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.TextTruncate = Enum.TextTruncate.AtEnd

local PlaceIdLabel = Instance.new("TextLabel")
PlaceIdLabel.Parent = GameCard
PlaceIdLabel.BackgroundTransparency = 1
PlaceIdLabel.Position = UDim2.new(0, 65, 0, 32)
PlaceIdLabel.Size = UDim2.new(0, 275, 0, 20)
PlaceIdLabel.Font = Enum.Font.Gotham
PlaceIdLabel.Text = "Place ID: " .. tostring(game.PlaceId)
PlaceIdLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
PlaceIdLabel.TextSize = 11
PlaceIdLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success and info then
        GameNameLabel.Text = info.Name or "Unknown Game"
        if info.IconImageAssetId and info.IconImageAssetId ~= 0 then
            GameImg.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
        end
    else
        GameNameLabel.Text = "Roblox Game"
    end
end)

local ExecCard = Instance.new("Frame")
ExecCard.Parent = InfoTab
ExecCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
ExecCard.BackgroundTransparency = 0.2
ExecCard.Size = UDim2.new(0, 350, 0, 75)

local ExecCorner = Instance.new("UICorner")
ExecCorner.CornerRadius = UDim.new(0, 6)
ExecCorner.Parent = ExecCard

local ExecStroke = Instance.new("UIStroke")
ExecStroke.Color = Color3.fromRGB(38, 38, 48)
ExecStroke.Thickness = 1
ExecStroke.Parent = ExecCard

local ExecTitleLabel = Instance.new("TextLabel")
ExecTitleLabel.Parent = ExecCard
ExecTitleLabel.BackgroundTransparency = 1
ExecTitleLabel.Position = UDim2.new(0, 12, 0, 8)
ExecTitleLabel.Size = UDim2.new(0, 320, 0, 18)
ExecTitleLabel.Font = Enum.Font.GothamBold
ExecTitleLabel.Text = "Executor Info"
ExecTitleLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
ExecTitleLabel.TextSize = 12
ExecTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local execName, execVer = "Unknown Executor", "v1.0"
pcall(function()
    if identifyexecutor then
        execName, execVer = identifyexecutor()
    end
end)

local ExecNameLabel = Instance.new("TextLabel")
ExecNameLabel.Parent = ExecCard
ExecNameLabel.BackgroundTransparency = 1
ExecNameLabel.Position = UDim2.new(0, 12, 0, 28)
ExecNameLabel.Size = UDim2.new(0, 320, 0, 18)
ExecNameLabel.Font = Enum.Font.GothamMedium
ExecNameLabel.Text = "Executor: " .. tostring(execName) .. " (" .. tostring(execVer) .. ")"
ExecNameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
ExecNameLabel.TextSize = 11
ExecNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local ExecStatusLabel = Instance.new("TextLabel")
ExecStatusLabel.Parent = ExecCard
ExecStatusLabel.BackgroundTransparency = 1
ExecStatusLabel.Position = UDim2.new(0, 12, 0, 48)
ExecStatusLabel.Size = UDim2.new(0, 320, 0, 18)
ExecStatusLabel.Font = Enum.Font.Gotham
ExecStatusLabel.Text = "Status: Active"
ExecStatusLabel.TextColor3 = Color3.fromRGB(40, 200, 100)
ExecStatusLabel.TextSize = 11
ExecStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Thêm phần Auto Execute Settings ở Tab Info
AddHeader(InfoTab, "AUTO EXECUTE SETTINGS")
AddToggle(InfoTab, "Auto Execute (Hop / Rejoin / Game)", config.AutoExecute, function(state)
    config.AutoExecute = state
    SaveConfig()
    if state then
        SetupAutoExecute()
    end
end)


-- ================= TAB 2: UNIVERSAL =================
local UniversalTab = CreateTab("Universal", 104193181208689)

AddHeader(UniversalTab, "SERVER MANAGEMENT")

local function HopServer()
    SetupAutoExecute()
    local servers = {}
    local req = pcall(function()
        servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if req and servers and servers.data then
        for _, s in pairs(servers.data) do
            if type(s) == "table" and s.maxPlayers and s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, localPlayer)
                end)
                task.wait(1)
            end
        end
    end
    pcall(function()
        TeleportService:Teleport(game.PlaceId, localPlayer)
    end)
end

local function HopSmallServer()
    SetupAutoExecute()
    local servers = {}
    local req = pcall(function()
        servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if req and servers and servers.data then
        table.sort(servers.data, function(a, b)
            return a.playing < b.playing
        end)
        for _, s in pairs(servers.data) do
            if type(s) == "table" and s.maxPlayers and s.playing and s.playing > 0 and s.playing < s.maxPlayers and s.id ~= game.JobId then
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, localPlayer)
                end)
                task.wait(1)
            end
        end
    end
    HopServer()
end

AddScriptButton(UniversalTab, "Hop Server", "")
for _, v in pairs(UniversalTab:GetChildren()) do
    if v:IsA("TextButton") and v.Text:find("Hop Server") then
        v.MouseButton1Click:Connect(function()
            HopServer()
        end)
    end
end

AddScriptButton(UniversalTab, "Hop Small Server", "")
for _, v in pairs(UniversalTab:GetChildren()) do
    if v:IsA("TextButton") and v.Text:find("Hop Small Server") then
        v.MouseButton1Click:Connect(function()
            HopSmallServer()
        end)
    end
end

local autoHopEnabled = false
AddToggle(UniversalTab, "Auto Server Hop (19 mins)", false, function(state)
    autoHopEnabled = state
    if autoHopEnabled then
        task.spawn(function()
            while autoHopEnabled do
                task.wait(19 * 60)
                if autoHopEnabled then
                    HopServer()
                end
            end
        end)
    end
end)

AddHeader(UniversalTab, "UNIVERSAL SCRIPTS")
AddScriptButton(UniversalTab, "Aim Lock", "https://pastefy.app/YiGY38uo/raw")
AddScriptButton(UniversalTab, "Fly GUI V4", "https://rawscripts.net/raw/Universal-Script-Fly-Gui-V4-28125")
AddScriptButton(UniversalTab, "Set Teleport", "https://raw.githubusercontent.com/parasopsays/Saved-Teleport/refs/heads/main/Ggs.txt")
AddScriptButton(UniversalTab, "Emotes GUI", "https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua")
AddScriptButton(UniversalTab, "Tiger Hub", "https://raw.githubusercontent.com/BalintTheDevXBack/Universal/refs/heads/main/TigerXHubV4")
AddScriptButton(UniversalTab, "Auto Clicker", "https://rawscripts.net/raw/Universal-Script-Auto-clicker-38704")
AddScriptButton(UniversalTab, "Anti AFK", "https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk")
AddScriptButton(UniversalTab, "Boost FPS / Fix Lag", "https://raw.githubusercontent.com/TIKTOK-BOYCHOIGAME/PH-ICH-U/refs/heads/main/FIXLAGV2.BOYCHOIGAME")
AddScriptButton(UniversalTab, "Lapiz Hub", "https://raw.githubusercontent.com/luuanhduc160-cmyk/Lapi/refs/heads/main/Lapiz.lua")
AddScriptButton(UniversalTab, "Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")

AddHeader(UniversalTab, "LOCAL FEATURES")

AddToggle(UniversalTab, "Infinite Jump", false, function(state)
    _G.InfJump = state
end)
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

AddToggle(UniversalTab, "Noclip", false, function(state)
    _G.Noclip = state
end)
RunService.Stepped:Connect(function()
    if _G.Noclip and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local cframeMultEnabled = false
local cframeMultValue = 2
AddToggle(UniversalTab, "CFrame Speed (Mult)", false, function(state)
    cframeMultEnabled = state
end)
AddInput(UniversalTab, "CFrame Mult Value", "Enter mult value...", function(val)
    if val then cframeMultValue = val end
end)
RunService.RenderStepped:Connect(function(dt)
    if cframeMultEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = localPlayer.Character.HumanoidRootPart
        if hum and hum.MoveDirection.Magnitude > 0 then
            local speed = hum.WalkSpeed * cframeMultValue
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speed * dt)
        end
    end
end)

AddToggle(UniversalTab, "ESP Player (Rainbow)", false, function(state)
    _G.ESPPlayer = state
    if not _G.ESPPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("ESPPlayer_HL")
                if hl then hl:Destroy() end
                local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if head then
                    local bb = head:FindFirstChild("ESPPlayer_BB")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end)
task.spawn(function()
    while true do
        local rainbowColor = Color3.fromHSV((tick() % 5) / 5, 1, 1)
        if _G.ESPPlayer then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    local char = p.Character
                    local hl = char:FindFirstChild("ESPPlayer_HL")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ESPPlayer_HL"
                        hl.Adornee = char
                        hl.Parent = char
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0
                    end
                    hl.FillColor = rainbowColor
                    hl.OutlineColor = rainbowColor
                    
                    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if head then
                        local bb = head:FindFirstChild("ESPPlayer_BB")
                        local dist = 0
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            dist = math.floor((head.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        end
                        if not bb then
                            bb = Instance.new("BillboardGui")
                            bb.Name = "ESPPlayer_BB"
                            bb.Size = UDim2.new(0, 120, 0, 40)
                            bb.StudsOffset = Vector3.new(0, 2.5, 0)
                            bb.AlwaysOnTop = true
                            bb.Parent = head
                            
                            local txt = Instance.new("TextLabel")
                            txt.Name = "Text"
                            txt.Parent = bb
                            txt.BackgroundTransparency = 1
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.Font = Enum.Font.GothamBold
                            txt.TextSize = 13
                            txt.TextStrokeTransparency = 0
                        end
                        local txt = bb:FindFirstChild("Text")
                        if txt then
                            txt.Text = "[" .. p.Name .. "] [" .. dist .. "m]"
                            txt.TextColor3 = rainbowColor
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

AddToggle(UniversalTab, "ESP NPC (Rainbow)", false, function(state)
    _G.ESPNPC = state
    if not _G.ESPNPC then
        for _, model in pairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
                local isPlayer = Players:GetPlayerFromCharacter(model)
                if not isPlayer then
                    local hl = model:FindFirstChild("ESPNPC_HL")
                    if hl then hl:Destroy() end
                    local head = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
                    if head then
                        local bb = head:FindFirstChild("ESPNPC_BB")
                        if bb then bb:Destroy() end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while true do
        local rainbowColor = Color3.fromHSV((tick() % 5) / 5, 1, 1)
        if _G.ESPNPC then
            for _, model in pairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
                    local isPlayer = Players:GetPlayerFromCharacter(model)
                    if not isPlayer and model ~= localPlayer.Character then
                        local hl = model:FindFirstChild("ESPNPC_HL")
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "ESPNPC_HL"
                            hl.Adornee = model
                            hl.Parent = model
                            hl.FillTransparency = 0.5
                            hl.OutlineTransparency = 0
                        end
                        hl.FillColor = rainbowColor
                        hl.OutlineColor = rainbowColor
                        
                        local head = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
                        if head then
                            local bb = head:FindFirstChild("ESPNPC_BB")
                            local dist = 0
                            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                dist = math.floor((head.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            end
                            if not bb then
                                bb = Instance.new("BillboardGui")
                                bb.Name = "ESPNPC_BB"
                                bb.Size = UDim2.new(0, 120, 0, 40)
                                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                                bb.AlwaysOnTop = true
                                bb.Parent = head
                                
                                local txt = Instance.new("TextLabel")
                                txt.Name = "Text"
                                txt.Parent = bb
                                txt.BackgroundTransparency = 1
                                txt.Size = UDim2.new(1, 0, 1, 0)
                                txt.Font = Enum.Font.GothamBold
                                txt.TextSize = 13
                                txt.TextStrokeTransparency = 0
                            end
                            local txt = bb:FindFirstChild("Text")
                            if txt then
                                txt.Text = "[" .. model.Name .. "] [" .. dist .. "m]"
                                txt.TextColor3 = rainbowColor
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)


-- ================= TAB 3: UI SCALE (1 - 10) =================
local ScaleTab = CreateTab("UI Scale", 6516141723)

AddHeader(ScaleTab, "UI SCALE SETTINGS")

local ScaleContainer = Instance.new("Frame")
ScaleContainer.Parent = ScaleTab
ScaleContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
ScaleContainer.BackgroundTransparency = 0.2
ScaleContainer.Size = UDim2.new(0, 350, 0, 38)

local ScaleCorner = Instance.new("UICorner")
ScaleCorner.CornerRadius = UDim.new(0, 6)
ScaleCorner.Parent = ScaleContainer

local ScaleStroke = Instance.new("UIStroke")
ScaleStroke.Color = Color3.fromRGB(38, 38, 48)
ScaleStroke.Thickness = 1
ScaleStroke.Parent = ScaleContainer

local ScaleLabel = Instance.new("TextLabel")
ScaleLabel.Parent = ScaleContainer
ScaleLabel.BackgroundTransparency = 1
ScaleLabel.Position = UDim2.new(0, 10, 0, 0)
ScaleLabel.Size = UDim2.new(0, 150, 1, 0)
ScaleLabel.Font = Enum.Font.GothamBold
ScaleLabel.Text = "  UI Preset Size"
ScaleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
ScaleLabel.TextSize = 12
ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left

local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Parent = ScaleContainer
DropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DropdownBtn.Position = UDim2.new(1, -125, 0.5, -13)
DropdownBtn.Size = UDim2.new(0, 115, 0, 26)
DropdownBtn.Font = Enum.Font.GothamBold
DropdownBtn.Text = "  Medium v"
DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBtn.TextSize = 11
DropdownBtn.AutoButtonColor = true

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 4)
DropdownCorner.Parent = DropdownBtn

local DropdownList = Instance.new("Frame")
DropdownList.Parent = ScreenGui
DropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
DropdownList.BorderSizePixel = 0
DropdownList.Size = UDim2.new(0, 115, 0, 90)
DropdownList.Visible = false
DropdownList.ZIndex = 100

local DropdownListCorner = Instance.new("UICorner")
DropdownListCorner.CornerRadius = UDim.new(0, 6)
DropdownListCorner.Parent = DropdownList

local DropdownListStroke = Instance.new("UIStroke")
DropdownListStroke.Color = Color3.fromRGB(50, 50, 65)
DropdownListStroke.Thickness = 1
DropdownListStroke.Parent = DropdownList

local DropdownListLayout = Instance.new("UIListLayout")
DropdownListLayout.Parent = DropdownList
DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder

closeDropdownFunc = function()
    DropdownList.Visible = false
end

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then
        local absPos = DropdownBtn.AbsolutePosition
        DropdownList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + DropdownBtn.AbsoluteSize.Y + 4)
    end
end)

local function CreateDropdownOption(name, scaleVal)
    local OptBtn = Instance.new("TextButton")
    OptBtn.Parent = DropdownList
    OptBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    OptBtn.BackgroundTransparency = 0.5
    OptBtn.Size = UDim2.new(1, 0, 0, 30)
    OptBtn.Font = Enum.Font.GothamMedium
    OptBtn.Text = "  " .. name
    OptBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
    OptBtn.TextSize = 11
    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
    OptBtn.ZIndex = 101

    OptBtn.MouseButton1Click:Connect(function()
        DropdownBtn.Text = "  " .. name .. " v"
        DropdownList.Visible = false
        targetScale = scaleVal
    end)
end

CreateDropdownOption("Small", 0.7)
CreateDropdownOption("Medium", 1.0)
CreateDropdownOption("Large", 1.4)

local SliderContainer = Instance.new("Frame")
SliderContainer.Parent = ScaleTab
SliderContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
SliderContainer.BackgroundTransparency = 0.2
SliderContainer.Size = UDim2.new(0, 350, 0, 50)

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = SliderContainer

local SliderStroke = Instance.new("UIStroke")
SliderStroke.Color = Color3.fromRGB(38, 38, 48)
SliderStroke.Thickness = 1
SliderStroke.Parent = SliderContainer

local SliderTitle = Instance.new("TextLabel")
SliderTitle.Parent = SliderContainer
SliderTitle.BackgroundTransparency = 1
SliderTitle.Position = UDim2.new(0, 10, 0, 6)
SliderTitle.Size = UDim2.new(0, 220, 0, 18)
SliderTitle.Font = Enum.Font.GothamBold
SliderTitle.Text = "  UI Scale Slider (1 - 10)"
SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
SliderTitle.TextSize = 12
SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

local SliderValueLabel = Instance.new("TextLabel")
SliderValueLabel.Parent = SliderContainer
SliderValueLabel.BackgroundTransparency = 1
SliderValueLabel.Position = UDim2.new(1, -60, 0, 6)
SliderValueLabel.Size = UDim2.new(0, 50, 0, 18)
SliderValueLabel.Font = Enum.Font.GothamBold
SliderValueLabel.Text = "5"
SliderValueLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
SliderValueLabel.TextSize = 12
SliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right

local SliderTrack = Instance.new("Frame")
SliderTrack.Parent = SliderContainer
SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SliderTrack.BorderSizePixel = 0
SliderTrack.Position = UDim2.new(0, 12, 0, 32)
SliderTrack.Size = UDim2.new(0, 326, 0, 6)

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderTrack
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Size = UDim2.new(0.444, 0, 1, 0)

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local SliderKnob = Instance.new("Frame")
SliderKnob.Parent = SliderTrack
SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.Position = UDim2.new(0.444, 0, 0.5, 0)
SliderKnob.Size = UDim2.new(0, 14, 0, 14)

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = SliderKnob

local draggingSlider = false
SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackSize = SliderTrack.AbsoluteSize.X
        local mouseX = input.Position.X
        local percent = math.clamp((mouseX - trackPos) / trackSize, 0, 1)
        
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
        
        local val = math.floor(1 + percent * 9 + 0.5)
        SliderValueLabel.Text = tostring(val)
        
        targetScale = 0.5 + (val - 1) * (1.3 / 9)
    end
end)


-- ================= TAB 4: ALL =================
local MainTab = CreateTab("All", 92648272637932)
AddScriptButton(MainTab, "Boblo Script Hub", "https://bobloscript.com/hub/bobloscript-hub.lua")
AddScriptButton(MainTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")
AddScriptButton(MainTab, "Zero Hub", "https://raw.githubusercontent.com/gather1231-source/Freemium/refs/heads/main/FreemiumLoader")
AddScriptButton(MainTab, "Foxname Hub", "https://foxname.top/loader")
AddScriptButton(MainTab, "OMG Hub [Key System]", "https://raw.githubusercontent.com/OmgHub/omghub/main/loader.lua")

-- ================= TAB: RANDOM FRAM GAME =================
local FramTab = CreateTab("Random Fram Game", 2772610559)
AddScriptButton(FramTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: ANIME ZERO =================
local AnimeZeroTab = CreateTab("Anime Zero", 114574503491412)
AddScriptButton(AnimeZeroTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")
AddScriptButton(AnimeZeroTab, "Zero Hub", "https://raw.githubusercontent.com/gather1231-source/Freemium/refs/heads/main/FreemiumLoader")

-- ================= TAB: FISHING MASTER =================
local FishingMasterTab = CreateTab("Fishing Master", 99925503388128)
AddScriptButton(FishingMasterTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")
AddScriptButton(FishingMasterTab, "Zero Hub", "https://raw.githubusercontent.com/gather1231-source/Freemium/refs/heads/main/FreemiumLoader")

-- ================= TAB: ANIME DICE =================
local AnimeDiceTab = CreateTab("Anime Dice", 113290951185459)
AddScriptButton(AnimeDiceTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: BREAK AND STEAL AN EGG =================
local BreakAndStealAnEggTab = CreateTab("Break and Steal an egg", 114326934417838)
AddScriptButton(BreakAndStealAnEggTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: +1 STONE SKIPPING =================
local StoneSkippingTab = CreateTab("+1 Stone Skipping", 111543903102439)
AddScriptButton(StoneSkippingTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: STEAL AN EGG =================
local StealAnEggTab = CreateTab("Steal An Egg", 107778070777162)
AddScriptButton(StealAnEggTab, "Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")
AddScriptButton(StealAnEggTab, "Kira Hub", "https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/KiraHub_Steal_An_Egg.lua")
AddScriptButton(StealAnEggTab, "Cloth Hub", "https://raw.githubusercontent.com/ClouthubOnTop/Loader/main/main.lua")
AddScriptButton(StealAnEggTab, "Foxname Hub", "https://foxname.top/loader")
AddScriptButton(StealAnEggTab, "Neva Hub", "https://raw.githubusercontent.com/VEZ2/NEVAHUB/main/2")
AddScriptButton(StealAnEggTab, "Yokudo Hub", "https://raw.githubusercontent.com/betdoyvaka/stealanegg/main/Loader.lua")

-- ================= TAB 5: FORSAKEN =================
local ForsakenTab = CreateTab("Forsaken", 83645629621104)
AddScriptButton(ForsakenTab, "Forsaken Plus", "https://scriptblox.com/raw/Forsaken-Plus-216770")

-- ================= TAB 6: BROOKHAVEN =================
local BrookhavenTab = CreateTab("Brookhaven", 920587237)
AddScriptButton(BrookhavenTab, "Brookhaven Drip Hub", "https://scriptblox.com/raw/Brookhaven-RP-Drip-Client-Open-Source-75145")

-- ================= TAB 7: ANIMAL =================
local AnimalTab = CreateTab("Animal Hospital", 78515283254292)
AddScriptButton(AnimalTab, "Mini Hub", "https://raw.githubusercontent.com/MinityD/roblox-utils/refs/heads/main/animal%20hospital.lua")

-- ================= TAB 8: EVADE =================
local EvadeTab = CreateTab("Evade", 9872472334)
AddScriptButton(EvadeTab, "Evade [ Easy Key System]", "https://scriptblox.com/raw/Evade-Auto-farms-Speed-bypass-fly-troll-others-and-26-Features-53926")

-- ================= TAB 9: SLAP BATTLES =================
local SlapBattlesTab = CreateTab("Slap Battles", 6403373529)
AddScriptButton(SlapBattlesTab, "Slap aura", "https://raw.githubusercontent.com/Yuna-ux/Slap-battles/refs/heads/main/Slap_aura.lua")

-- ================= OTHER GAME TABS =================
local BloxFruitTab = CreateTab("Blox Fruit", 2753915549)
AddScriptButton(BloxFruitTab, "Blox Fruit: 67 Hub", "https://raw.githubusercontent.com/67HubDev/all/refs/heads/main/67hub.vn.lua")
AddScriptButton(BloxFruitTab, "Blox Fruit: Redz Hub", "https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua")

local MemeSeaTab = CreateTab("Meme Sea", 10260193230)
AddScriptButton(MemeSeaTab, "Meme Sea (Redz)", "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")

local JJSTab = CreateTab("Jujutsu Shenanigans", 9391468976)
AddScriptButton(JJSTab, "JJS: TBO Hub", "https://scriptblox.com/raw/LUCKY-COWARD-Jujutsu-Shenanigans-JJS-TBO-Real-135944")
AddScriptButton(JJSTab, "JJS: Niggas Hub [Key System]", "https://api.jnkie.com/api/v1/luascripts/public/b7315589ba3b7854c382eeb676a81db2be0007dc1b449c60236e38c6cc1ee3b7/download")

local TSBTab = CreateTab("The Strongest Battlegrounds", 10449761463)
AddScriptButton(TSBTab, "TSB: Good Tech Script", "https://scriptblox.com/raw/The-Strongest-Battlegrounds-GOOD-TECH-SCRIPT-102534")
AddScriptButton(TSBTab, "TSB: Suiryu Farm [Key System]", "https://gitlab.com/zkay404-group/ProjectYielding/-/raw/main/ZKSuryuFarm")
AddScriptButton(TSBTab, "TSB: Genos Farm [Key System]", "https://gitlab.com/zkay404-group/ProjectYielding/-/raw/main/ZKGenosFarm")

-- ================= TAB: 99 NIGHTS =================
local Nights99Tab = CreateTab("99 Nights", 79546208627805)
AddScriptButton(Nights99Tab, "99 Nights: Foxname AutoFarm", "https://foxname.top/autofarm")

-- ================= TAB: FTAP =================
local FTAPTab = CreateTab("FTAP", 6961824067)
AddScriptButton(FTAPTab, "FTAP Admin Watch", "https://raw.githubusercontent.com/Bruhiscrazy/codespaces-blank/refs/heads/main/FTAPadminwatch.lua")

-- ================= TAB: GTD =================
local GTDTab = CreateTab("GTD", 108533757090220)
AddScriptButton(GTDTab, "Ash Hub", "https://raw.githubusercontent.com/couldntBeT/Main/refs/heads/main/Main.lua")


-- ================= NEW TABS & SCRIPTS =================
local HeavyweightFishingTab = CreateTab("Heavyweight Fishing", 90920025162454)
AddScriptButton(HeavyweightFishingTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

local HussValleyTab = CreateTab("Huss Valley", 107535308163741)
AddScriptButton(HussValleyTab, "Huss Valley Script", "https://raw.githubusercontent.com/bobloscript/scripts/refs/heads/main/HussValley")

local BlueLockFramTab = CreateTab("Blue Lock Fram", 132767904294856)
AddScriptButton(BlueLockFramTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

local BlueLockRivalTab = CreateTab("Blue Lock Rival", 18668065416)
AddScriptButton(BlueLockRivalTab, "Blue Lock Rivals GUI", "https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/refs/heads/main/Blue%20Lock%20Rivals%20GUI")

local Slayers2Tab = CreateTab("Slayers 2", 16205713724)
AddScriptButton(Slayers2Tab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

local RideAPetTab = CreateTab("Ride A Pet", 124216119978534)
AddScriptButton(RideAPetTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

local LastStopTab = CreateTab("Last Stop", 85967844112283)
AddScriptButton(LastStopTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

local LootToForgeTab = CreateTab("+1 Loot to Forge", 118805555015549)
AddScriptButton(LootToForgeTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: STRENGTH FOR EGGS =================
local StrengthForEggsTab = CreateTab("+1 Strength For Eggs", 98610101874791)
AddScriptButton(StrengthForEggsTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: SWING FOR EGG =================
local SwingForEggTab = CreateTab("+1 Swing For Egg", 109203247742910)
AddScriptButton(SwingForEggTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: BUILD AN ANT EMPIRE =================
local BuildAnAntEmpireTab = CreateTab("Build An Ant Empire", 78490532994307)
AddScriptButton(BuildAnAntEmpireTab, "Ouroboros [280+ game supported]", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")

-- ================= TAB: BALL VS BALL =================
local BallVsBallTab = CreateTab("Ball vs Ball", 96510596525082)
AddScriptButton(BallVsBallTab, "Slopix Hub", "https://raw.githubusercontent.com/TrustyCoding/slopix-hub/main/loader.lua")

-- ================= TAB: UNTITLED BOXING GAME =================
local UntitledBoxingGameTab = CreateTab("Untitled Boxing Game", 13621938427)
AddScriptButton(UntitledBoxingGameTab, "Untitled Boxing Game Loader", "https://api.luarmor.net/files/v4/loaders/683781a8d14f817d6e4196e8d5e925.lua")

-- ================= TAB: KING LEGACY =================
local KingLegacyTab = CreateTab("King Legacy", 4520749081)
AddScriptButton(KingLegacyTab, "King Legacy Mainfarm", "https://raw.githubusercontent.com/spectrumxx/mainfarm/refs/heads/main/loader.lua")
