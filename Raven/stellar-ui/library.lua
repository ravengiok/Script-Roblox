--[[
    STELLAR UI LIBRARY v5.0
    Enhanced Version with Minimize, Themes, and More Features
    Created by: Assistant
    Date: 2024
]]

if (game:GetService("CoreGui")):FindFirstChild("STELLAR") and (game:GetService("CoreGui")):FindFirstChild("ScreenGui") then
    (game:GetService("CoreGui")).STELLAR:Destroy();
    (game:GetService("CoreGui")).ScreenGui:Destroy();
end;

-- ======================
-- THEME CONFIGURATION
-- ======================
_G.Themes = {
    Default = {
        Primary = Color3.fromRGB(100, 100, 100),
        Dark = Color3.fromRGB(22, 22, 26),
        Third = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 200, 200)
    },
    Blue = {
        Primary = Color3.fromRGB(65, 105, 225),
        Dark = Color3.fromRGB(20, 20, 40),
        Third = Color3.fromRGB(0, 191, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 220, 255)
    },
    Purple = {
        Primary = Color3.fromRGB(147, 112, 219),
        Dark = Color3.fromRGB(30, 20, 45),
        Third = Color3.fromRGB(186, 85, 211),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(220, 200, 255)
    },
    Green = {
        Primary = Color3.fromRGB(46, 204, 113),
        Dark = Color3.fromRGB(20, 35, 25),
        Third = Color3.fromRGB(0, 255, 127),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 255, 220)
    },
    Dark = {
        Primary = Color3.fromRGB(50, 50, 50),
        Dark = Color3.fromRGB(15, 15, 15),
        Third = Color3.fromRGB(169, 169, 169),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(180, 180, 180)
    }
}

_G.CurrentTheme = "Default"
_G.Primary = _G.Themes[_G.CurrentTheme].Primary
_G.Dark = _G.Themes[_G.CurrentTheme].Dark
_G.Third = _G.Themes[_G.CurrentTheme].Third

-- ======================
-- UTILITY FUNCTIONS
-- ======================
function CreateRounded(Parent, Size)
    local Rounded = Instance.new("UICorner");
    Rounded.Name = "Rounded";
    Rounded.Parent = Parent;
    Rounded.CornerRadius = UDim.new(0, Size);
    return Rounded;
end;

function CreateStroke(Parent, Color, Thickness)
    local Stroke = Instance.new("UIStroke");
    Stroke.Parent = Parent;
    Stroke.Color = Color or Color3.fromRGB(255, 255, 255);
    Stroke.Thickness = Thickness or 1;
    Stroke.Transparency = 0.5;
    return Stroke;
end;

function CreateGradient(Parent, ColorSequence)
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence;
    Gradient.Parent = Parent;
    return Gradient;
end;

local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");

-- ======================
-- DRAGGABLE FUNCTION
-- ======================
function MakeDraggable(topbarobject, object)
    local Dragging = nil;
    local DragInput = nil;
    local DragStart = nil;
    local StartPosition = nil;
    
    local function Update(input)
        local Delta = input.Position - DragStart;
        local pos = UDim2.new(
            StartPosition.X.Scale, 
            StartPosition.X.Offset + Delta.X, 
            StartPosition.Y.Scale, 
            StartPosition.Y.Offset + Delta.Y
        );
        local Tween = TweenService:Create(object, TweenInfo.new(0.15), {
            Position = pos
        });
        Tween:Play();
    end;
    
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true;
            DragStart = input.Position;
            StartPosition = object.Position;
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false;
                end;
            end);
        end;
    end);
    
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input;
        end;
    end);
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input);
        end;
    end);
end;

-- ======================
-- MINIMIZE BUTTON UI
-- ======================
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "STELLAR_Launcher";
ScreenGui.Parent = game.CoreGui;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

local OutlineButton = Instance.new("Frame");
OutlineButton.Name = "OutlineButton";
OutlineButton.Parent = ScreenGui;
OutlineButton.ClipsDescendants = true;
OutlineButton.BackgroundColor3 = _G.Dark;
OutlineButton.BackgroundTransparency = 0.5;
OutlineButton.Position = UDim2.new(0, 10, 0, 10);
OutlineButton.Size = UDim2.new(0, 50, 0, 50);
CreateRounded(OutlineButton, 12);
CreateStroke(OutlineButton, _G.Third, 2);

local ImageButton = Instance.new("ImageButton");
ImageButton.Parent = OutlineButton;
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0);
ImageButton.Size = UDim2.new(0, 40, 0, 40);
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
ImageButton.BackgroundColor3 = _G.Dark;
ImageButton.ImageColor3 = Color3.fromRGB(250, 250, 250);
ImageButton.ImageTransparency = 0;
ImageButton.BackgroundTransparency = 0.3;
ImageButton.Image = "rbxassetid://105059922903197";
ImageButton.AutoButtonColor = false;
MakeDraggable(ImageButton, OutlineButton);
CreateRounded(ImageButton, 10);
CreateStroke(ImageButton, _G.Primary, 1);

ImageButton.MouseButton1Click:connect(function()
    local stellar = game.CoreGui:FindFirstChild("STELLAR")
    if stellar then
        stellar.Enabled = not stellar.Enabled;
        Update:Notify(stellar.Enabled and "UI Enabled" or "UI Disabled");
    end;
end);

-- ======================
-- NOTIFICATION SYSTEM
-- ======================
local NotificationFrame = Instance.new("ScreenGui");
NotificationFrame.Name = "NotificationFrame";
NotificationFrame.Parent = game.CoreGui;
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global;

local NotificationList = {};
local MaxNotifications = 5;

local function RemoveOldestNotification()
    if #NotificationList > 0 then
        local removed = table.remove(NotificationList, 1);
        removed[1]:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
            removed[1]:Destroy();
        end);
    end;
end;

local function UpdateNotificationPositions()
    for i, notification in ipairs(NotificationList) do
        notification[1]:TweenPosition(UDim2.new(0.5, 0, 0.1 + (i-1) * 0.12, 0), "Out", "Quad", 0.3, true);
    end;
end;

spawn(function()
    while wait() do
        if #NotificationList > MaxNotifications then
            RemoveOldestNotification();
        end;
    end;
end);

-- ======================
-- UPDATE MODULE
-- ======================
local Update = {};

function Update:SetTheme(themeName)
    if _G.Themes[themeName] then
        _G.CurrentTheme = themeName;
        _G.Primary = _G.Themes[themeName].Primary;
        _G.Dark = _G.Themes[themeName].Dark;
        _G.Third = _G.Themes[themeName].Third;
        return true;
    end;
    return false;
end;

function Update:Notify(desc, duration)
    duration = duration or 3;
    
    local Frame = Instance.new("Frame");
    local Image = Instance.new("ImageLabel");
    local Title = Instance.new("TextLabel");
    local Desc = Instance.new("TextLabel");
    local OutlineFrame = Instance.new("Frame");
    
    OutlineFrame.Name = "OutlineFrame";
    OutlineFrame.Parent = NotificationFrame;
    OutlineFrame.ClipsDescendants = true;
    OutlineFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    OutlineFrame.AnchorPoint = Vector2.new(0.5, 1);
    OutlineFrame.BackgroundTransparency = 0.4;
    OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0);
    OutlineFrame.Size = UDim2.new(0, 412, 0, 72);
    
    Frame.Name = "Frame";
    Frame.Parent = OutlineFrame;
    Frame.ClipsDescendants = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = _G.Dark;
    Frame.BackgroundTransparency = 0.1;
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.Size = UDim2.new(0, 400, 0, 60);
    
    Image.Name = "Icon";
    Image.Parent = Frame;
    Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Image.BackgroundTransparency = 1;
    Image.Position = UDim2.new(0, 8, 0, 8);
    Image.Size = UDim2.new(0, 45, 0, 45);
    Image.Image = "rbxassetid://105059922903197";
    
    Title.Parent = Frame;
    Title.BackgroundColor3 = _G.Primary;
    Title.BackgroundTransparency = 1;
    Title.Position = UDim2.new(0, 55, 0, 14);
    Title.Size = UDim2.new(0, 10, 0, 20);
    Title.Font = Enum.Font.GothamBold;
    Title.Text = "STELLAR";
    Title.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
    Title.TextSize = 16;
    Title.TextXAlignment = Enum.TextXAlignment.Left;
    
    Desc.Parent = Frame;
    Desc.BackgroundColor3 = _G.Primary;
    Desc.BackgroundTransparency = 1;
    Desc.Position = UDim2.new(0, 55, 0, 33);
    Desc.Size = UDim2.new(0, 10, 0, 10);
    Desc.Font = Enum.Font.GothamSemibold;
    Desc.TextTransparency = 0.3;
    Desc.Text = desc;
    Desc.TextColor3 = _G.Themes[_G.CurrentTheme].SubText;
    Desc.TextSize = 12;
    Desc.TextXAlignment = Enum.TextXAlignment.Left;
    
    CreateRounded(Frame, 10);
    CreateRounded(OutlineFrame, 12);
    CreateStroke(OutlineFrame, _G.Third, 1);
    
    -- Auto-size text
    local titleSize = game:GetService("TextService"):GetTextSize(Title.Text, Title.TextSize, Title.Font, Vector2.new(1000, 1000));
    local descSize = game:GetService("TextService"):GetTextSize(Desc.Text, Desc.TextSize, Desc.Font, Vector2.new(340, 1000));
    
    Title.Size = UDim2.new(0, titleSize.X, 0, 20);
    Desc.Size = UDim2.new(0, math.min(descSize.X, 340), 0, descSize.Y);
    
    OutlineFrame:TweenPosition(UDim2.new(0.5, 0, 0.1 + (#NotificationList) * 0.12, 0), "Out", "Quad", 0.4, true);
    table.insert(NotificationList, {OutlineFrame});
    
    -- Auto remove after duration
    spawn(function()
        wait(duration);
        for i, v in ipairs(NotificationList) do
            if v[1] == OutlineFrame then
                table.remove(NotificationList, i);
                OutlineFrame:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
                    OutlineFrame:Destroy();
                end);
                UpdateNotificationPositions();
                break;
            end;
        end;
    end);
    
    -- Click to dismiss
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            for i, v in ipairs(NotificationList) do
                if v[1] == OutlineFrame then
                    table.remove(NotificationList, i);
                    OutlineFrame:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
                        OutlineFrame:Destroy();
                    end);
                    UpdateNotificationPositions();
                    break;
                end;
            end;
        end;
    end);
end;

function Update:StartLoad(message)
    message = message or "Loading..."
    
    local Loader = Instance.new("ScreenGui");
    Loader.Name = "STELLAR_Loader";
    Loader.Parent = game.CoreGui;
    Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global;
    Loader.DisplayOrder = 1000;
    
    local LoaderFrame = Instance.new("Frame");
    LoaderFrame.Name = "LoaderFrame";
    LoaderFrame.Parent = Loader;
    LoaderFrame.ClipsDescendants = true;
    LoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5);
    LoaderFrame.BackgroundTransparency = 0;
    LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    LoaderFrame.Size = UDim2.new(1.5, 0, 1.5, 0);
    LoaderFrame.BorderSizePixel = 0;
    
    local MainLoaderFrame = Instance.new("Frame");
    MainLoaderFrame.Name = "MainLoaderFrame";
    MainLoaderFrame.Parent = LoaderFrame;
    MainLoaderFrame.ClipsDescendants = true;
    MainLoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5);
    MainLoaderFrame.BackgroundTransparency = 0;
    MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    MainLoaderFrame.Size = UDim2.new(0.5, 0, 0.5, 0);
    MainLoaderFrame.BorderSizePixel = 0;
    
    local TitleLoader = Instance.new("TextLabel");
    TitleLoader.Parent = MainLoaderFrame;
    TitleLoader.Text = "STELLAR";
    TitleLoader.Font = Enum.Font.FredokaOne;
    TitleLoader.TextSize = 50;
    TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255);
    TitleLoader.BackgroundTransparency = 1;
    TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5);
    TitleLoader.Position = UDim2.new(0.5, 0, 0.3, 0);
    TitleLoader.Size = UDim2.new(0.8, 0, 0.2, 0);
    TitleLoader.TextTransparency = 0;
    
    local DescriptionLoader = Instance.new("TextLabel");
    DescriptionLoader.Parent = MainLoaderFrame;
    DescriptionLoader.Text = message;
    DescriptionLoader.Font = Enum.Font.Gotham;
    DescriptionLoader.TextSize = 15;
    DescriptionLoader.TextColor3 = Color3.fromRGB(255, 255, 255);
    DescriptionLoader.BackgroundTransparency = 1;
    DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5);
    DescriptionLoader.Position = UDim2.new(0.5, 0, 0.6, 0);
    DescriptionLoader.Size = UDim2.new(0.8, 0, 0.2, 0);
    DescriptionLoader.TextTransparency = 0;
    
    local LoadingBarBackground = Instance.new("Frame");
    LoadingBarBackground.Parent = MainLoaderFrame;
    LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
    LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5);
    LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0);
    LoadingBarBackground.Size = UDim2.new(0.7, 0, 0.05, 0);
    LoadingBarBackground.ClipsDescendants = true;
    LoadingBarBackground.BorderSizePixel = 0;
    LoadingBarBackground.ZIndex = 2;
    
    local LoadingBar = Instance.new("Frame");
    LoadingBar.Parent = LoadingBarBackground;
    LoadingBar.BackgroundColor3 = _G.Third;
    LoadingBar.Size = UDim2.new(0, 0, 1, 0);
    LoadingBar.ZIndex = 3;
    
    CreateRounded(LoadingBarBackground, 20);
    CreateRounded(LoadingBar, 20);
    
    local tweenService = game:GetService("TweenService");
    local dotCount = 0;
    local running = true;
    
    local barTweenInfoPart1 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local barTweenPart1 = tweenService:Create(LoadingBar, barTweenInfoPart1, {
        Size = UDim2.new(0.25, 0, 1, 0)
    });
    
    local barTweenInfoPart2 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local barTweenPart2 = tweenService:Create(LoadingBar, barTweenInfoPart2, {
        Size = UDim2.new(1, 0, 1, 0)
    });
    
    barTweenPart1:Play();
    
    function Update:Loaded()
        barTweenPart2:Play();
    end;
    
    barTweenPart1.Completed:Connect(function()
        running = true;
        barTweenPart2.Completed:Connect(function()
            wait(1);
            running = false;
            DescriptionLoader.Text = "Loaded!";
            wait(0.5);
            Loader:Destroy();
        end);
    end);
    
    spawn(function()
        while running do
            dotCount = (dotCount + 1) % 4;
            local dots = string.rep(".", dotCount);
            DescriptionLoader.Text = message .. dots;
            wait(0.5);
        end;
    end);
    
    return {
        Destroy = function()
            Loader:Destroy();
            running = false;
        end,
        SetMessage = function(newMsg)
            message = newMsg;
            DescriptionLoader.Text = newMsg;
        end
    };
end;

-- ======================
-- CONFIGURATION SYSTEM
-- ======================
local SettingsLib = {
    SaveSettings = true,
    LoadAnimation = true,
    Theme = "Default",
    Keybind = "RightControl",
    Notifications = true,
    Watermark = true
};

(getgenv()).LoadConfig = function()
    if readfile and writefile and isfile and isfolder then
        if not isfolder("STELLAR") then
            makefolder("STELLAR");
        end;
        if not isfolder("STELLAR/Library/") then
            makefolder("STELLAR/Library/");
        end;
        local configPath = "STELLAR/Library/" .. game.Players.LocalPlayer.Name .. ".json";
        if not isfile(configPath) then
            writefile(configPath, (game:GetService("HttpService")):JSONEncode(SettingsLib));
        else
            local success, Decode = pcall(function()
                return (game:GetService("HttpService")):JSONDecode(readfile(configPath));
            end);
            if success and Decode then
                for i, v in pairs(Decode) do
                    SettingsLib[i] = v;
                end;
                -- Apply theme
                if SettingsLib.Theme then
                    Update:SetTheme(SettingsLib.Theme);
                end;
            end;
        end;
        print("STELLAR Library Loaded!");
    else
        return warn("STELLAR: Undetected Executor - File functions not available");
    end;
end;

(getgenv()).SaveConfig = function()
    if readfile and writefile and isfile and isfolder then
        local configPath = "STELLAR/Library/" .. game.Players.LocalPlayer.Name .. ".json";
        local Array = {};
        for i, v in pairs(SettingsLib) do
            Array[i] = v;
        end;
        writefile(configPath, (game:GetService("HttpService")):JSONEncode(Array));
    else
        return warn("STELLAR: Undetected Executor - Cannot save config");
    end;
end;

(getgenv()).LoadConfig();

-- ======================
-- WINDOW CREATION
-- ======================
function Update:Window(Config)
    assert(Config.SubTitle, "STELLAR: SubTitle is required (v5)");
    
    local WindowConfig = {
        Size = Config.Size or UDim2.new(0, 600, 0, 450),
        TabWidth = Config.TabWidth or 150,
        Theme = Config.Theme or "Default"
    };
    
    -- Apply window theme
    if WindowConfig.Theme ~= _G.CurrentTheme then
        Update:SetTheme(WindowConfig.Theme);
    end;
    
    local osfunc = {};
    local uihide = false;
    local abc = false;
    local currentpage = "";
    local keybind = Config.Keybind or Enum.KeyCode.RightControl;
    local yoo = string.gsub(tostring(keybind), "Enum.KeyCode.", "");
    
    -- Create main UI
    local STELLAR = Instance.new("ScreenGui");
    STELLAR.Name = "STELLAR";
    STELLAR.Parent = game.CoreGui;
    STELLAR.DisplayOrder = 999;
    
    local OutlineMain = Instance.new("Frame");
    OutlineMain.Name = "OutlineMain";
    OutlineMain.Parent = STELLAR;
    OutlineMain.ClipsDescendants = true;
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5);
    OutlineMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    OutlineMain.BackgroundTransparency = 0.4;
    OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0);
    OutlineMain.Size = UDim2.new(0, 0, 0, 0);
    CreateRounded(OutlineMain, 15);
    CreateStroke(OutlineMain, _G.Third, 2);
    
    local Main = Instance.new("Frame");
    Main.Name = "Main";
    Main.Parent = OutlineMain;
    Main.ClipsDescendants = true;
    Main.AnchorPoint = Vector2.new(0.5, 0.5);
    Main.BackgroundColor3 = _G.Dark;
    Main.BackgroundTransparency = 0;
    Main.Position = UDim2.new(0.5, 0, 0.5, 0);
    Main.Size = WindowConfig.Size;
    
    OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Quad", 0.4, true);
    CreateRounded(Main, 12);
    
    -- ======================
    -- TOP BAR WITH MINIMIZE
    -- ======================
    local Top = Instance.new("Frame");
    Top.Name = "Top";
    Top.Parent = Main;
    Top.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
    Top.Size = UDim2.new(1, 0, 0, 40);
    Top.BackgroundTransparency = 0.3;
    CreateRounded(Top, 5);
    
    local NameHub = Instance.new("TextLabel");
    NameHub.Name = "NameHub";
    NameHub.Parent = Top;
    NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    NameHub.BackgroundTransparency = 1;
    NameHub.RichText = true;
    NameHub.Position = UDim2.new(0, 15, 0.5, 0);
    NameHub.AnchorPoint = Vector2.new(0, 0.5);
    NameHub.Size = UDim2.new(0, 1, 0, 25);
    NameHub.Font = Enum.Font.GothamBold;
    NameHub.Text = "STELLAR";
    NameHub.TextSize = 20;
    NameHub.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
    NameHub.TextXAlignment = Enum.TextXAlignment.Left;
    
    local nameHubSize = (game:GetService("TextService")):GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge));
    NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 25);
    
    local SubTitle = Instance.new("TextLabel");
    SubTitle.Name = "SubTitle";
    SubTitle.Parent = NameHub;
    SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    SubTitle.BackgroundTransparency = 1;
    SubTitle.Position = UDim2.new(0, nameHubSize.X + 8, 0.5, 0);
    SubTitle.Size = UDim2.new(0, 1, 0, 20);
    SubTitle.Font = Enum.Font.Cartoon;
    SubTitle.AnchorPoint = Vector2.new(0, 0.5);
    SubTitle.Text = Config.SubTitle;
    SubTitle.TextSize = 15;
    SubTitle.TextColor3 = _G.Themes[_G.CurrentTheme].SubText;
    
    local SubTitleSize = (game:GetService("TextService")):GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge));
    SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 25);
    
    -- TOP BAR BUTTONS (Right to Left: Close, Resize, Minimize, Settings)
    local CloseButton = Instance.new("ImageButton");
    CloseButton.Name = "CloseButton";
    CloseButton.Parent = Top;
    CloseButton.BackgroundColor3 = _G.Primary;
    CloseButton.BackgroundTransparency = 0.8;
    CloseButton.AnchorPoint = Vector2.new(1, 0.5);
    CloseButton.Position = UDim2.new(1, -15, 0.5, 0);
    CloseButton.Size = UDim2.new(0, 20, 0, 20);
    CloseButton.Image = "rbxassetid://10747384394";
    CloseButton.ImageTransparency = 0;
    CloseButton.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
    CreateRounded(CloseButton, 3);
    
    local ResizeButton = Instance.new("ImageButton");
    ResizeButton.Name = "ResizeButton";
    ResizeButton.Parent = Top;
    ResizeButton.BackgroundColor3 = _G.Primary;
    ResizeButton.BackgroundTransparency = 0.8;
    ResizeButton.AnchorPoint = Vector2.new(1, 0.5);
    ResizeButton.Position = UDim2.new(1, -50, 0.5, 0);
    ResizeButton.Size = UDim2.new(0, 20, 0, 20);
    ResizeButton.Image = "rbxassetid://10734886735";
    ResizeButton.ImageTransparency = 0;
    ResizeButton.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
    CreateRounded(ResizeButton, 3);
    
    -- MINIMIZE BUTTON
    local MinimizeButton = Instance.new("ImageButton");
    MinimizeButton.Name = "MinimizeButton";
    MinimizeButton.Parent = Top;
    MinimizeButton.BackgroundColor3 = _G.Primary;
    MinimizeButton.BackgroundTransparency = 0.8;
    MinimizeButton.AnchorPoint = Vector2.new(1, 0.5);
    MinimizeButton.Position = UDim2.new(1, -85, 0.5, 0);
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20);
    MinimizeButton.Image = "rbxassetid://10709790644";
    MinimizeButton.ImageTransparency = 0;
    MinimizeButton.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
    CreateRounded(MinimizeButton, 3);
    
    local SettingsButton = Instance.new("ImageButton");
    SettingsButton.Name = "SettingsButton";
    SettingsButton.Parent = Top;
    SettingsButton.BackgroundColor3 = _G.Primary;
    SettingsButton.BackgroundTransparency = 0.8;
    SettingsButton.AnchorPoint = Vector2.new(1, 0.5);
    SettingsButton.Position = UDim2.new(1, -120, 0.5, 0);
    SettingsButton.Size = UDim2.new(0, 20, 0, 20);
    SettingsButton.Image = "rbxassetid://10734950020";
    SettingsButton.ImageTransparency = 0;
    SettingsButton.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
    CreateRounded(SettingsButton, 3);
    
    -- ======================
    -- MINIMIZE FUNCTIONALITY
    -- ======================
    local isMinimized = false;
    local originalSize = WindowConfig.Size;
    local originalOutlineSize = OutlineMain.Size;
    
    MinimizeButton.MouseButton1Click:connect(function()
        isMinimized = not isMinimized;
        
        if isMinimized then
            -- Minimize: Keep only top bar visible
            MinimizeButton.Image = "rbxassetid://10709790948"; -- Restore icon
            for _, child in pairs(Main:GetChildren()) do
                if child.Name ~= "Top" then
                    child.Visible = false;
                end;
            end;
            
            local minimizedHeight = 55; -- Height when minimized
            OutlineMain:TweenSize(
                UDim2.new(0, originalOutlineSize.X.Offset, 0, minimizedHeight),
                "Out", "Quad", 0.3, true
            );
            Main:TweenSize(
                UDim2.new(1, 0, 0, 40),
                "Out", "Quad", 0.3, true
            );
            
            Update:Notify("Window minimized");
        else
            -- Restore: Show all content
            MinimizeButton.Image = "rbxassetid://10709790644"; -- Minimize icon
            for _, child in pairs(Main:GetChildren()) do
                child.Visible = true;
            end;
            
            OutlineMain:TweenSize(
                UDim2.new(0, originalOutlineSize.X.Offset, 0, originalOutlineSize.Y.Offset),
                "Out", "Quad", 0.3, true
            );
            Main:TweenSize(
                UDim2.new(0, originalSize.X.Offset, 0, originalSize.Y.Offset),
                "Out", "Quad", 0.3, true
            );
            
            Update:Notify("Window restored");
        end;
    end);
    
    -- ======================
    -- OTHER BUTTON FUNCTIONS
    -- ======================
    CloseButton.MouseButton1Click:connect(function()
        STELLAR.Enabled = not STELLAR.Enabled;
        Update:Notify(STELLAR.Enabled and "UI Enabled" or "UI Disabled");
    end);
    
    SettingsButton.MouseButton1Click:connect(function()
        BackgroundSettings.Visible = true;
    end);
    
    -- ======================
    -- SETTINGS MENU
    -- ======================
    local BackgroundSettings = Instance.new("Frame");
    BackgroundSettings.Name = "BackgroundSettings";
    BackgroundSettings.Parent = OutlineMain;
    BackgroundSettings.ClipsDescendants = true;
    BackgroundSettings.Active = true;
    BackgroundSettings.AnchorPoint = Vector2.new(0, 0);
    BackgroundSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
    BackgroundSettings.BackgroundTransparency = 0.3;
    BackgroundSettings.Position = UDim2.new(0, 0, 0, 0);
    BackgroundSettings.Size = UDim2.new(1, 0, 1, 0);
    BackgroundSettings.Visible = false;
    CreateRounded(BackgroundSettings, 15);
    
    local SettingsFrame = Instance.new("Frame");
    SettingsFrame.Name = "SettingsFrame";
    SettingsFrame.Parent = BackgroundSettings;
    SettingsFrame.ClipsDescendants = true;
    SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    SettingsFrame.BackgroundColor3 = _G.Dark;
    SettingsFrame.BackgroundTransparency = 0;
    SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    SettingsFrame.Size = UDim2.new(0.7, 0, 0.7, 0);
    CreateRounded(SettingsFrame, 15);
    
    local CloseSettings = Instance.new("ImageButton");
    CloseSettings.Name = "CloseSettings";
    CloseSettings.Parent = SettingsFrame;
    CloseSettings.BackgroundColor3 = _G.Primary;
    CloseSettings.BackgroundTransparency = 0.8;
    CloseSettings.AnchorPoint = Vector2.new(1, 0);
    CloseSettings.Position = UDim2.new(1, -20, 0, 15);
    CloseSettings.Size = UDim2.new(0, 20, 0, 20);
    CloseSettings.Image = "rbxassetid://10747384394";
    CloseSettings.ImageTransparency = 0;
    CloseSettings.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
    CreateRounded(CloseSettings, 3);
    
    CloseSettings.MouseButton1Click:connect(function()
        BackgroundSettings.Visible = false;
    end);
    
    local TitleSettings = Instance.new("TextLabel");
    TitleSettings.Name = "TitleSettings";
    TitleSettings.Parent = SettingsFrame;
    TitleSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TitleSettings.BackgroundTransparency = 1;
    TitleSettings.Position = UDim2.new(0, 20, 0, 15);
    TitleSettings.Size = UDim2.new(1, 0, 0, 20);
    TitleSettings.Font = Enum.Font.GothamBold;
    TitleSettings.AnchorPoint = Vector2.new(0, 0);
    TitleSettings.Text = "Library Settings";
    TitleSettings.TextSize = 20;
    TitleSettings.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
    TitleSettings.TextXAlignment = Enum.TextXAlignment.Left;
    
    local SettingsMenuList = Instance.new("Frame");
    SettingsMenuList.Name = "SettingsMenuList";
    SettingsMenuList.Parent = SettingsFrame;
    SettingsMenuList.ClipsDescendants = true;
    SettingsMenuList.AnchorPoint = Vector2.new(0, 0);
    SettingsMenuList.BackgroundColor3 = _G.Dark;
    SettingsMenuList.BackgroundTransparency = 1;
    SettingsMenuList.Position = UDim2.new(0, 0, 0, 50);
    SettingsMenuList.Size = UDim2.new(1, 0, 1, -70);
    CreateRounded(SettingsMenuList, 15);
    
    local ScrollSettings = Instance.new("ScrollingFrame");
    ScrollSettings.Name = "ScrollSettings";
    ScrollSettings.Parent = SettingsMenuList;
    ScrollSettings.Active = true;
    ScrollSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
    ScrollSettings.Position = UDim2.new(0, 0, 0, 0);
    ScrollSettings.BackgroundTransparency = 1;
    ScrollSettings.Size = UDim2.new(1, 0, 1, 0);
    ScrollSettings.ScrollBarThickness = 3;
    ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y;
    CreateRounded(SettingsMenuList, 5);
    
    local SettingsListLayout = Instance.new("UIListLayout");
    SettingsListLayout.Name = "SettingsListLayout";
    SettingsListLayout.Parent = ScrollSettings;
    SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    SettingsListLayout.Padding = UDim.new(0, 8);
    
    local PaddingScroll = Instance.new("UIPadding");
    PaddingScroll.Name = "PaddingScroll";
    PaddingScroll.Parent = ScrollSettings;
    PaddingScroll.PaddingLeft = UDim.new(0, 15);
    PaddingScroll.PaddingRight = UDim.new(0, 15);
    PaddingScroll.PaddingTop = UDim.new(0, 10);
    
    -- ======================
    -- SETTINGS COMPONENTS
    -- ======================
    local function CreateCheckbox(title, state, callback)
        local checked = state or false;
        local Background = Instance.new("Frame");
        Background.Name = "Background";
        Background.Parent = ScrollSettings;
        Background.ClipsDescendants = true;
        Background.BackgroundColor3 = _G.Dark;
        Background.BackgroundTransparency = 1;
        Background.Size = UDim2.new(1, 0, 0, 25);
        
        local Title = Instance.new("TextLabel");
        Title.Name = "Title";
        Title.Parent = Background;
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Title.BackgroundTransparency = 1;
        Title.Position = UDim2.new(0, 60, 0.5, 0);
        Title.Size = UDim2.new(1, -60, 0, 20);
        Title.Font = Enum.Font.Code;
        Title.AnchorPoint = Vector2.new(0, 0.5);
        Title.Text = title or "";
        Title.TextSize = 15;
        Title.TextColor3 = _G.Themes[_G.CurrentTheme].SubText;
        Title.TextXAlignment = Enum.TextXAlignment.Left;
        
        local Checkbox = Instance.new("ImageButton");
        Checkbox.Name = "Checkbox";
        Checkbox.Parent = Background;
        Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
        Checkbox.BackgroundTransparency = 0.3;
        Checkbox.AnchorPoint = Vector2.new(0, 0.5);
        Checkbox.Position = UDim2.new(0, 30, 0.5, 0);
        Checkbox.Size = UDim2.new(0, 20, 0, 20);
        Checkbox.Image = "rbxassetid://10709790644";
        Checkbox.ImageTransparency = 1;
        Checkbox.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
        CreateRounded(Checkbox, 5);
        
        Checkbox.MouseButton1Click:Connect(function()
            checked = not checked;
            if checked then
                Checkbox.ImageTransparency = 0;
                Checkbox.BackgroundColor3 = _G.Third;
            else
                Checkbox.ImageTransparency = 1;
                Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
            end;
            pcall(callback, checked);
        end);
        
        if checked then
            Checkbox.ImageTransparency = 0;
            Checkbox.BackgroundColor3 = _G.Third;
        else
            Checkbox.ImageTransparency = 1;
            Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
        end;
        pcall(callback, checked);
    end;
    
    local function CreateButton(title, callback)
        local Background = Instance.new("Frame");
        Background.Name = "Background";
        Background.Parent = ScrollSettings;
        Background.ClipsDescendants = true;
        Background.BackgroundColor3 = _G.Dark;
        Background.BackgroundTransparency = 1;
        Background.Size = UDim2.new(1, 0, 0, 35);
        
        local Button = Instance.new("TextButton");
        Button.Name = "Button";
        Button.Parent = Background;
        Button.BackgroundColor3 = _G.Third;
        Button.BackgroundTransparency = 0;
        Button.Size = UDim2.new(0.8, 0, 0, 35);
        Button.Font = Enum.Font.Code;
        Button.Text = title or "Button";
        Button.AnchorPoint = Vector2.new(0.5, 0);
        Button.Position = UDim2.new(0.5, 0, 0, 0);
        Button.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
        Button.TextSize = 15;
        Button.AutoButtonColor = false;
        
        Button.MouseButton1Click:Connect(function()
            callback();
        end);
        
        CreateRounded(Button, 5);
    end;
    
    local function CreateDropdown(title, options, default, callback)
        local Background = Instance.new("Frame");
        Background.Name = "Background";
        Background.Parent = ScrollSettings;
        Background.ClipsDescendants = true;
        Background.BackgroundColor3 = _G.Dark;
        Background.BackgroundTransparency = 1;
        Background.Size = UDim2.new(1, 0, 0, 40);
        
        local Title = Instance.new("TextLabel");
        Title.Name = "Title";
        Title.Parent = Background;
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Title.BackgroundTransparency = 1;
        Title.Position = UDim2.new(0, 15, 0.5, 0);
        Title.Size = UDim2.new(0.5, -20, 0, 20);
        Title.Font = Enum.Font.Code;
        Title.AnchorPoint = Vector2.new(0, 0.5);
        Title.Text = title or "";
        Title.TextSize = 15;
        Title.TextColor3 = _G.Themes[_G.CurrentTheme].SubText;
        Title.TextXAlignment = Enum.TextXAlignment.Left;
        
        local Dropdown = Instance.new("TextButton");
        Dropdown.Name = "Dropdown";
        Dropdown.Parent = Background;
        Dropdown.BackgroundColor3 = _G.Primary;
        Dropdown.BackgroundTransparency = 0.3;
        Dropdown.AnchorPoint = Vector2.new(1, 0.5);
        Dropdown.Position = UDim2.new(1, -15, 0.5, 0);
        Dropdown.Size = UDim2.new(0.4, 0, 0, 30);
        Dropdown.Font = Enum.Font.Gotham;
        Dropdown.Text = default or "Select";
        Dropdown.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
        Dropdown.TextSize = 13;
        Dropdown.AutoButtonColor = false;
        
        CreateRounded(Dropdown, 5);
        
        local DropdownFrame = Instance.new("Frame");
        DropdownFrame.Name = "DropdownFrame";
        DropdownFrame.Parent = Background;
        DropdownFrame.BackgroundColor3 = _G.Dark;
        DropdownFrame.BackgroundTransparency = 0;
        DropdownFrame.Visible = false;
        DropdownFrame.Position = UDim2.new(0.6, 0, 1, 5);
        DropdownFrame.Size = UDim2.new(0.4, 0, 0, 0);
        DropdownFrame.ClipsDescendants = true;
        CreateRounded(DropdownFrame, 5);
        
        local DropdownList = Instance.new("UIListLayout");
        DropdownList.Parent = DropdownFrame;
        DropdownList.SortOrder = Enum.SortOrder.LayoutOrder;
        
        local isOpen = false;
        
        local function toggleDropdown()
            isOpen = not isOpen;
            if isOpen then
                DropdownFrame.Visible = true;
                DropdownFrame:TweenSize(
                    UDim2.new(0.4, 0, 0, math.min(#options * 30, 150)),
                    "Out", "Quad", 0.3, true
                );
            else
                DropdownFrame:TweenSize(
                    UDim2.new(0.4, 0, 0, 0),
                    "Out", "Quad", 0.3, true,
                    function()
                        DropdownFrame.Visible = false;
                    end
                );
            end;
        end;
        
        Dropdown.MouseButton1Click:Connect(toggleDropdown);
        
        for _, option in pairs(options) do
            local OptionButton = Instance.new("TextButton");
            OptionButton.Name = "Option";
            OptionButton.Parent = DropdownFrame;
            OptionButton.BackgroundColor3 = _G.Primary;
            OptionButton.BackgroundTransparency = 0.5;
            OptionButton.Size = UDim2.new(1, 0, 0, 30);
            OptionButton.Font = Enum.Font.Gotham;
            OptionButton.Text = option;
            OptionButton.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            OptionButton.TextSize = 13;
            OptionButton.AutoButtonColor = false;
            
            OptionButton.MouseButton1Click:Connect(function()
                Dropdown.Text = option;
                pcall(callback, option);
                toggleDropdown();
            end);
            
            CreateRounded(OptionButton, 0);
        end;
        
        return {
            Set = function(value)
                Dropdown.Text = value;
                pcall(callback, value);
            end
        };
    end;
    
    -- Add settings options
    CreateCheckbox("Save Settings", SettingsLib.SaveSettings, function(state)
        SettingsLib.SaveSettings = state;
        (getgenv()).SaveConfig();
    end);
    
    CreateCheckbox("Loading Animation", SettingsLib.LoadAnimation, function(state)
        SettingsLib.LoadAnimation = state;
        (getgenv()).SaveConfig();
    end);
    
    CreateCheckbox("Show Notifications", SettingsLib.Notifications, function(state)
        SettingsLib.Notifications = state;
        (getgenv()).SaveConfig();
    end);
    
    CreateCheckbox("Show Watermark", SettingsLib.Watermark, function(state)
        SettingsLib.Watermark = state;
        (getgenv()).SaveConfig();
        ScreenGui.Enabled = state;
    end);
    
    local themeDropdown = CreateDropdown("Theme", {"Default", "Blue", "Purple", "Green", "Dark"}, 
        SettingsLib.Theme, function(selected)
            SettingsLib.Theme = selected;
            Update:SetTheme(selected);
            (getgenv()).SaveConfig();
            Update:Notify("Theme changed to: " .. selected);
        end);
    
    CreateButton("Reset Config", function()
        if isfolder("STELLAR") then
            delfolder("STELLAR");
        end;
        Update:Notify("Config has been reset!");
        (getgenv()).LoadConfig();
    end);
    
    CreateButton("Save Settings", function()
        (getgenv()).SaveConfig();
        Update:Notify("Settings saved!");
    end);
    
    -- ======================
    -- TAB SYSTEM
    -- ======================
    local Tab = Instance.new("Frame");
    Tab.Name = "Tab";
    Tab.Parent = Main;
    Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
    Tab.Position = UDim2.new(0, 8, 0, Top.Size.Y.Offset);
    Tab.BackgroundTransparency = 0.8;
    Tab.Size = UDim2.new(0, WindowConfig.TabWidth, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 8);
    
    local ScrollTab = Instance.new("ScrollingFrame");
    ScrollTab.Name = "ScrollTab";
    ScrollTab.Parent = Tab;
    ScrollTab.Active = true;
    ScrollTab.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
    ScrollTab.Position = UDim2.new(0, 0, 0, 0);
    ScrollTab.BackgroundTransparency = 1;
    ScrollTab.Size = UDim2.new(1, 0, 1, 0);
    ScrollTab.ScrollBarThickness = 0;
    ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y;
    CreateRounded(Tab, 5);
    
    local TabListLayout = Instance.new("UIListLayout");
    TabListLayout.Name = "TabListLayout";
    TabListLayout.Parent = ScrollTab;
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    TabListLayout.Padding = UDim.new(0, 2);
    
    local PPD = Instance.new("UIPadding");
    PPD.Name = "PPD";
    PPD.Parent = ScrollTab;
    PPD.PaddingLeft = UDim.new(0, 5);
    PPD.PaddingRight = UDim.new(0, 5);
    PPD.PaddingTop = UDim.new(0, 5);
    
    local Page = Instance.new("Frame");
    Page.Name = "Page";
    Page.Parent = Main;
    Page.BackgroundColor3 = _G.Dark;
    Page.Position = UDim2.new(0, Tab.Size.X.Offset + 18, 0, Top.Size.Y.Offset);
    Page.Size = UDim2.new(Config.Size.X.Scale, Config.Size.X.Offset - Tab.Size.X.Offset - 25, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 8);
    Page.BackgroundTransparency = 1;
    CreateRounded(Page, 3);
    
    local MainPage = Instance.new("Frame");
    MainPage.Name = "MainPage";
    MainPage.Parent = Page;
    MainPage.ClipsDescendants = true;
    MainPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    MainPage.BackgroundTransparency = 1;
    MainPage.Size = UDim2.new(1, 0, 1, 0);
    
    local PageList = Instance.new("Folder");
    PageList.Name = "PageList";
    PageList.Parent = MainPage;
    
    local UIPageLayout = Instance.new("UIPageLayout");
    UIPageLayout.Parent = PageList;
    UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIPageLayout.EasingDirection = Enum.EasingDirection.InOut;
    UIPageLayout.EasingStyle = Enum.EasingStyle.Quad;
    UIPageLayout.FillDirection = Enum.FillDirection.Vertical;
    UIPageLayout.Padding = UDim.new(0, 10);
    UIPageLayout.TweenTime = 0.3;
    UIPageLayout.GamepadInputEnabled = false;
    UIPageLayout.ScrollWheelInputEnabled = false;
    UIPageLayout.TouchInputEnabled = false;
    
    -- ======================
    -- WINDOW CONTROLS
    -- ======================
    MakeDraggable(Top, OutlineMain);
    
    -- Drag resize handle
    local DragButton = Instance.new("Frame");
    DragButton.Name = "DragButton";
    DragButton.Parent = Main;
    DragButton.Position = UDim2.new(1, -10, 1, -10);
    DragButton.AnchorPoint = Vector2.new(1, 1);
    DragButton.Size = UDim2.new(0, 15, 0, 15);
    DragButton.BackgroundColor3 = _G.Third;
    DragButton.BackgroundTransparency = 0.5;
    DragButton.ZIndex = 10;
    CreateRounded(DragButton, 99);
    
    local Dragging = false;
    DragButton.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true;
        end;
    end);
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false;
        end;
    end);
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local newWidth = math.clamp(Input.Position.X - Main.AbsolutePosition.X, WindowConfig.Size.X.Offset, 1000);
            local newHeight = math.clamp(Input.Position.Y - Main.AbsolutePosition.Y, WindowConfig.Size.Y.Offset, 800);
            
            OutlineMain.Size = UDim2.new(0, newWidth + 15, 0, newHeight + 15);
            Main.Size = UDim2.new(0, newWidth, 0, newHeight);
            
            -- Update page and tab sizes
            Page.Size = UDim2.new(0, newWidth - Tab.Size.X.Offset - 25, 0, newHeight - Top.Size.Y.Offset - 10);
            Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 0, newHeight - Top.Size.Y.Offset - 10);
        end;
    end);
    
    -- Resize button functionality
    local defaultSize = true;
    ResizeButton.MouseButton1Click:Connect(function()
        if defaultSize then
            defaultSize = false;
            OutlineMain:TweenPosition(UDim2.new(0.5, 0, 0.45, 0), "Out", "Quad", 0.2, true);
            Main:TweenSize(UDim2.new(1, -20, 1, -20), "Out", "Quad", 0.4, true, function()
                Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 25, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
                Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
            end);
            OutlineMain:TweenSize(UDim2.new(1, -10, 1, -10), "Out", "Quad", 0.4, true);
            ResizeButton.Image = "rbxassetid://10734895698";
            Update:Notify("Fullscreen mode enabled");
        else
            defaultSize = true;
            Main:TweenSize(UDim2.new(0, originalSize.X.Offset, 0, originalSize.Y.Offset), "Out", "Quad", 0.4, true, function()
                Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 25, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
                Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
            end);
            OutlineMain:TweenSize(UDim2.new(0, originalOutlineSize.X.Offset, 0, originalOutlineSize.Y.Offset), "Out", "Quad", 0.4, true);
            ResizeButton.Image = "rbxassetid://10734886735";
            Update:Notify("Default size restored");
        end;
    end);
    
    -- Keyboard shortcuts
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            STELLAR.Enabled = not STELLAR.Enabled;
            Update:Notify(STELLAR.Enabled and "UI Enabled" or "UI Disabled");
        elseif input.KeyCode == Enum.KeyCode.RightShift then
            isMinimized = not isMinimized;
            MinimizeButton.MouseButton1Click:Fire();
        end;
    end);
    
    -- ======================
    -- TAB CREATION FUNCTION
    -- ======================
    local uitab = {};
    
    function uitab:Tab(text, img)
        local TabButton = Instance.new("TextButton");
        TabButton.Parent = ScrollTab;
        TabButton.Name = text .. "Unique";
        TabButton.Text = "";
        TabButton.BackgroundColor3 = _G.Primary;
        TabButton.BackgroundTransparency = 0.9;
        TabButton.Size = UDim2.new(1, 0, 0, 35);
        TabButton.Font = Enum.Font.Nunito;
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        TabButton.TextSize = 12;
        TabButton.TextTransparency = 0.9;
        
        local SelectedTab = Instance.new("Frame");
        SelectedTab.Name = "SelectedTab";
        SelectedTab.Parent = TabButton;
        SelectedTab.BackgroundColor3 = _G.Third;
        SelectedTab.BackgroundTransparency = 0;
        SelectedTab.Size = UDim2.new(0, 3, 0, 0);
        SelectedTab.Position = UDim2.new(0, 0, 0.5, 0);
        SelectedTab.AnchorPoint = Vector2.new(0, 0.5);
        CreateRounded(SelectedTab, 100);
        
        local Title = Instance.new("TextLabel");
        Title.Parent = TabButton;
        Title.Name = "Title";
        Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
        Title.BackgroundTransparency = 1;
        Title.Position = UDim2.new(0, 30, 0.5, 0);
        Title.Size = UDim2.new(0, 100, 0, 30);
        Title.Font = Enum.Font.Roboto;
        Title.Text = text;
        Title.AnchorPoint = Vector2.new(0, 0.5);
        Title.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
        Title.TextTransparency = 0.4;
        Title.TextSize = 14;
        Title.TextXAlignment = Enum.TextXAlignment.Left;
        
        local IDK = Instance.new("ImageLabel");
        IDK.Name = "IDK";
        IDK.Parent = TabButton;
        IDK.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        IDK.BackgroundTransparency = 1;
        IDK.ImageTransparency = 0.3;
        IDK.Position = UDim2.new(0, 7, 0.5, 0);
        IDK.Size = UDim2.new(0, 15, 0, 15);
        IDK.AnchorPoint = Vector2.new(0, 0.5);
        IDK.Image = img or "rbxassetid://10734904596";
        
        CreateRounded(TabButton, 6);
        
        local MainFramePage = Instance.new("ScrollingFrame");
        MainFramePage.Name = text .. "_Page";
        MainFramePage.Parent = PageList;
        MainFramePage.Active = true;
        MainFramePage.BackgroundColor3 = _G.Dark;
        MainFramePage.Position = UDim2.new(0, 0, 0, 0);
        MainFramePage.BackgroundTransparency = 1;
        MainFramePage.Size = UDim2.new(1, 0, 1, 0);
        MainFramePage.ScrollBarThickness = 3;
        MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y;
        
        local UIPadding = Instance.new("UIPadding");
        UIPadding.Parent = MainFramePage;
        UIPadding.PaddingLeft = UDim.new(0, 10);
        UIPadding.PaddingRight = UDim.new(0, 10);
        UIPadding.PaddingTop = UDim.new(0, 10);
        UIPadding.PaddingBottom = UDim.new(0, 10);
        
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Parent = MainFramePage;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Padding = UDim.new(0, 8);
        
        -- Tab selection
        TabButton.MouseButton1Click:Connect(function()
            for i, v in next, ScrollTab:GetChildren() do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.9
                    }):Play();
                    TweenService:Create(v.SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 3, 0, 0)
                    }):Play();
                    TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 0.4
                    }):Play();
                    TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0.4
                    }):Play();
                end;
            end;
            
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.7
            }):Play();
            TweenService:Create(SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 3, 0, 15)
            }):Play();
            TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0
            }):Play();
            TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0
            }):Play();
            
            for i, v in next, PageList:GetChildren() do
                currentpage = string.gsub(TabButton.Name, "Unique", "") .. "_Page";
                if v.Name == currentpage then
                    UIPageLayout:JumpTo(v);
                end;
            end;
        end);
        
        -- First tab selection
        if abc == false then
            for i, v in next, ScrollTab:GetChildren() do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.9
                    }):Play();
                    TweenService:Create(v.SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 3, 0, 15)
                    }):Play();
                    TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 0.4
                    }):Play();
                    TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0.4
                    }):Play();
                end;
            end;
            
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.7
            }):Play();
            TweenService:Create(SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 3, 0, 15)
            }):Play();
            TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0
            }):Play();
            TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0
            }):Play();
            
            UIPageLayout:JumpToIndex(1);
            abc = true;
        end;
        
        -- Auto canvas size
        RunService.Stepped:Connect(function()
            pcall(function()
                MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20);
                ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10);
                ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y + 20);
            end);
        end);
        
        -- ======================
        -- ELEMENT FUNCTIONS
        -- ======================
        local main = {};
        
        function main:Button(text, callback)
            local ButtonFrame = Instance.new("Frame");
            ButtonFrame.Name = "Button";
            ButtonFrame.Parent = MainFramePage;
            ButtonFrame.BackgroundColor3 = _G.Primary;
            ButtonFrame.BackgroundTransparency = 0.8;
            ButtonFrame.Size = UDim2.new(1, 0, 0, 36);
            CreateRounded(ButtonFrame, 5);
            CreateStroke(ButtonFrame, _G.Third, 1);
            
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Parent = ButtonFrame;
            TextLabel.BackgroundColor3 = _G.Primary;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.AnchorPoint = Vector2.new(0, 0.5);
            TextLabel.Position = UDim2.new(0, 15, 0.5, 0);
            TextLabel.Size = UDim2.new(0.8, 0, 1, 0);
            TextLabel.Font = Enum.Font.Cartoon;
            TextLabel.RichText = true;
            TextLabel.Text = text;
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
            TextLabel.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            TextLabel.TextSize = 15;
            TextLabel.ClipsDescendants = true;
            
            local ArrowRight = Instance.new("ImageLabel");
            ArrowRight.Name = "ArrowRight";
            ArrowRight.Parent = ButtonFrame;
            ArrowRight.BackgroundColor3 = _G.Primary;
            ArrowRight.BackgroundTransparency = 1;
            ArrowRight.AnchorPoint = Vector2.new(1, 0.5);
            ArrowRight.Position = UDim2.new(1, -15, 0.5, 0);
            ArrowRight.Size = UDim2.new(0, 15, 0, 15);
            ArrowRight.Image = "rbxassetid://10709768347";
            ArrowRight.ImageTransparency = 0;
            ArrowRight.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
            
            local ClickButton = Instance.new("TextButton");
            ClickButton.Parent = ButtonFrame;
            ClickButton.BackgroundTransparency = 1;
            ClickButton.Size = UDim2.new(1, 0, 1, 0);
            ClickButton.Text = "";
            ClickButton.AutoButtonColor = false;
            
            local isHovering = false;
            
            ClickButton.MouseEnter:Connect(function()
                isHovering = true;
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.6
                }):Play();
            end);
            
            ClickButton.MouseLeave:Connect(function()
                isHovering = false;
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.8
                }):Play();
            end);
            
            ClickButton.MouseButton1Click:Connect(function()
                if callback then
                    callback();
                end;
            end);
            
            return {
                SetText = function(newText)
                    TextLabel.Text = newText;
                end,
                SetCallback = function(newCallback)
                    callback = newCallback;
                end
            };
        end;
        
        function main:Toggle(text, config, desc, callback)
            config = config or false;
            local toggled = config;
            
            local ToggleFrame = Instance.new("Frame");
            ToggleFrame.Name = "Toggle";
            ToggleFrame.Parent = MainFramePage;
            ToggleFrame.BackgroundColor3 = _G.Primary;
            ToggleFrame.BackgroundTransparency = 0.8;
            ToggleFrame.Size = UDim2.new(1, 0, 0, desc and 46 or 36);
            CreateRounded(ToggleFrame, 5);
            CreateStroke(ToggleFrame, _G.Third, 1);
            
            local Title = Instance.new("TextLabel");
            Title.Parent = ToggleFrame;
            Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
            Title.BackgroundTransparency = 1;
            Title.Size = UDim2.new(0.7, -15, 0, desc and 25 or 35);
            Title.Font = Enum.Font.Cartoon;
            Title.Text = text;
            Title.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            Title.TextSize = 15;
            Title.TextXAlignment = Enum.TextXAlignment.Left;
            Title.AnchorPoint = Vector2.new(0, 0.5);
            Title.Position = UDim2.new(0, 15, desc and 0.3 or 0.5, 0);
            
            local DescLabel
            if desc then
                DescLabel = Instance.new("TextLabel");
                DescLabel.Parent = ToggleFrame;
                DescLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                DescLabel.BackgroundTransparency = 1;
                DescLabel.Position = UDim2.new(0, 15, 0, 25);
                DescLabel.Size = UDim2.new(0.7, -15, 0, 16);
                DescLabel.Font = Enum.Font.Gotham;
                DescLabel.Text = desc;
                DescLabel.TextColor3 = _G.Themes[_G.CurrentTheme].SubText;
                DescLabel.TextSize = 10;
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left;
            end;
            
            local ToggleButton = Instance.new("Frame");
            ToggleButton.Name = "ToggleButton";
            ToggleButton.Parent = ToggleFrame;
            ToggleButton.BackgroundColor3 = _G.Dark;
            ToggleButton.BackgroundTransparency = 0.3;
            ToggleButton.Position = UDim2.new(1, -10, 0.5, 0);
            ToggleButton.Size = UDim2.new(0, 35, 0, 20);
            ToggleButton.AnchorPoint = Vector2.new(1, 0.5);
            CreateRounded(ToggleButton, 10);
            
            local Circle = Instance.new("Frame");
            Circle.Parent = ToggleButton;
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            Circle.BackgroundTransparency = 0;
            Circle.Position = UDim2.new(0, 3, 0.5, 0);
            Circle.Size = UDim2.new(0, 14, 0, 14);
            Circle.AnchorPoint = Vector2.new(0, 0.5);
            CreateRounded(Circle, 10);
            
            local ClickButton = Instance.new("TextButton");
            ClickButton.Parent = ToggleFrame;
            ClickButton.BackgroundTransparency = 1;
            ClickButton.Size = UDim2.new(1, 0, 1, 0);
            ClickButton.Text = "";
            ClickButton.AutoButtonColor = false;
            
            local function updateToggle()
                if toggled then
                    Circle:TweenPosition(UDim2.new(0, 17, 0.5, 0), "Out", "Sine", 0.2, true);
                    TweenService:Create(ToggleButton, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = _G.Third,
                        BackgroundTransparency = 0
                    }):Play();
                else
                    Circle:TweenPosition(UDim2.new(0, 4, 0.5, 0), "Out", "Sine", 0.2, true);
                    TweenService:Create(ToggleButton, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = _G.Dark,
                        BackgroundTransparency = 0.3
                    }):Play();
                end;
                if callback then
                    pcall(callback, toggled);
                end;
            end;
            
            ClickButton.MouseButton1Click:Connect(function()
                toggled = not toggled;
                updateToggle();
            end);
            
            -- Initial state
            updateToggle();
            
            return {
                Set = function(state)
                    toggled = state;
                    updateToggle();
                end,
                Get = function()
                    return toggled;
                end
            };
        end;
        
        function main:Slider(text, min, max, set, callback)
            local SliderFrame = Instance.new("Frame");
            SliderFrame.Name = "Slider";
            SliderFrame.Parent = MainFramePage;
            SliderFrame.BackgroundColor3 = _G.Primary;
            SliderFrame.BackgroundTransparency = 0.8;
            SliderFrame.Size = UDim2.new(1, 0, 0, 50);
            CreateRounded(SliderFrame, 5);
            CreateStroke(SliderFrame, _G.Third, 1);
            
            local Title = Instance.new("TextLabel");
            Title.Parent = SliderFrame;
            Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
            Title.BackgroundTransparency = 1;
            Title.Position = UDim2.new(0, 15, 0, 10);
            Title.Size = UDim2.new(0.7, -15, 0, 20);
            Title.Font = Enum.Font.Cartoon;
            Title.Text = text;
            Title.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            Title.TextSize = 15;
            Title.TextXAlignment = Enum.TextXAlignment.Left;
            
            local ValueText = Instance.new("TextLabel");
            ValueText.Parent = SliderFrame;
            ValueText.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
            ValueText.BackgroundTransparency = 1;
            ValueText.Position = UDim2.new(1, -15, 0, 10);
            ValueText.Size = UDim2.new(0.2, 0, 0, 20);
            ValueText.Font = Enum.Font.GothamMedium;
            ValueText.Text = tostring(set);
            ValueText.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            ValueText.TextSize = 14;
            ValueText.TextXAlignment = Enum.TextXAlignment.Right;
            ValueText.AnchorPoint = Vector2.new(1, 0);
            
            local SliderBar = Instance.new("Frame");
            SliderBar.Parent = SliderFrame;
            SliderBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
            SliderBar.BackgroundTransparency = 0.8;
            SliderBar.Position = UDim2.new(0, 15, 0, 35);
            SliderBar.Size = UDim2.new(1, -30, 0, 4);
            CreateRounded(SliderBar, 2);
            
            local SliderFill = Instance.new("Frame");
            SliderFill.Parent = SliderBar;
            SliderFill.BackgroundColor3 = _G.Third;
            SliderFill.BackgroundTransparency = 0;
            SliderFill.Size = UDim2.new((set - min) / (max - min), 0, 1, 0);
            CreateRounded(SliderFill, 2);
            
            local SliderButton = Instance.new("TextButton");
            SliderButton.Parent = SliderBar;
            SliderButton.BackgroundTransparency = 1;
            SliderButton.Size = UDim2.new(1, 0, 1, 0);
            SliderButton.Text = "";
            SliderButton.AutoButtonColor = false;
            
            local Circle = Instance.new("Frame");
            Circle.Parent = SliderFill;
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            Circle.BackgroundTransparency = 0;
            Circle.Position = UDim2.new(1, 0, 0.5, 0);
            Circle.Size = UDim2.new(0, 12, 0, 12);
            Circle.AnchorPoint = Vector2.new(0.5, 0.5);
            CreateRounded(Circle, 6);
            
            local isDragging = false;
            local currentValue = set;
            
            local function updateSlider(value)
                currentValue = math.clamp(value, min, max);
                local percentage = (currentValue - min) / (max - min);
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0);
                ValueText.Text = tostring(math.floor(currentValue));
                if callback then
                    pcall(callback, currentValue);
                end;
            end;
            
            SliderButton.MouseButton1Down:Connect(function()
                isDragging = true;
            end);
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false;
                end;
            end);
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relativeX = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X;
                    local value = min + (relativeX * (max - min));
                    updateSlider(value);
                end;
            end);
            
            -- Initial value
            updateSlider(set);
            
            return {
                Set = function(value)
                    updateSlider(value);
                end,
                Get = function()
                    return currentValue;
                end
            };
        end;
        
        function main:Dropdown(text, options, default, callback)
            local DropdownFrame = Instance.new("Frame");
            DropdownFrame.Name = "Dropdown";
            DropdownFrame.Parent = MainFramePage;
            DropdownFrame.BackgroundColor3 = _G.Primary;
            DropdownFrame.BackgroundTransparency = 0.8;
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40);
            CreateRounded(DropdownFrame, 5);
            CreateStroke(DropdownFrame, _G.Third, 1);
            
            local Title = Instance.new("TextLabel");
            Title.Parent = DropdownFrame;
            Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
            Title.BackgroundTransparency = 1;
            Title.Position = UDim2.new(0, 15, 0.5, 0);
            Title.Size = UDim2.new(0.5, -15, 0, 20);
            Title.Font = Enum.Font.Cartoon;
            Title.Text = text;
            Title.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            Title.TextSize = 15;
            Title.TextXAlignment = Enum.TextXAlignment.Left;
            Title.AnchorPoint = Vector2.new(0, 0.5);
            
            local SelectedText = Instance.new("TextLabel");
            SelectedText.Parent = DropdownFrame;
            SelectedText.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
            SelectedText.BackgroundTransparency = 0;
            SelectedText.Position = UDim2.new(1, -10, 0.5, 0);
            SelectedText.Size = UDim2.new(0.4, 0, 0, 30);
            SelectedText.Font = Enum.Font.GothamMedium;
            SelectedText.Text = default or "Select...";
            SelectedText.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            SelectedText.TextSize = 13;
            SelectedText.TextXAlignment = Enum.TextXAlignment.Left;
            SelectedText.AnchorPoint = Vector2.new(1, 0.5);
            SelectedText.ClipsDescendants = true;
            CreateRounded(SelectedText, 5);
            
            local Arrow = Instance.new("ImageLabel");
            Arrow.Parent = SelectedText;
            Arrow.BackgroundTransparency = 1;
            Arrow.Position = UDim2.new(1, -25, 0.5, 0);
            Arrow.Size = UDim2.new(0, 20, 0, 20);
            Arrow.Image = "rbxassetid://10709790948";
            Arrow.ImageColor3 = _G.Themes[_G.CurrentTheme].Text;
            Arrow.AnchorPoint = Vector2.new(1, 0.5);
            
            local OptionsFrame = Instance.new("ScrollingFrame");
            OptionsFrame.Parent = DropdownFrame;
            OptionsFrame.BackgroundColor3 = _G.Dark;
            OptionsFrame.BackgroundTransparency = 0;
            OptionsFrame.Position = UDim2.new(0, 0, 1, 5);
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0);
            OptionsFrame.Visible = false;
            OptionsFrame.ScrollBarThickness = 3;
            OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
            CreateRounded(OptionsFrame, 5);
            
            local OptionsList = Instance.new("UIListLayout");
            OptionsList.Parent = OptionsFrame;
            OptionsList.SortOrder = Enum.SortOrder.LayoutOrder;
            OptionsList.Padding = UDim.new(0, 2);
            
            local isOpen = false;
            local selectedOption = default;
            
            local function toggleDropdown()
                isOpen = not isOpen;
                if isOpen then
                    OptionsFrame.Visible = true;
                    OptionsFrame:TweenSize(
                        UDim2.new(1, 0, 0, math.min(#options * 32, 160)),
                        "Out", "Quad", 0.3, true
                    );
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {
                        Rotation = 180
                    }):Play();
                else
                    OptionsFrame:TweenSize(
                        UDim2.new(1, 0, 0, 0),
                        "Out", "Quad", 0.3, true,
                        function()
                            OptionsFrame.Visible = false;
                        end
                    );
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {
                        Rotation = 0
                    }):Play();
                end;
            end;
            
            SelectedText.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggleDropdown();
                end;
            end);
            
            local function createOption(optionText)
                local OptionButton = Instance.new("TextButton");
                OptionButton.Parent = OptionsFrame;
                OptionButton.BackgroundColor3 = _G.Primary;
                OptionButton.BackgroundTransparency = 0.7;
                OptionButton.Size = UDim2.new(1, 0, 0, 30);
                OptionButton.Font = Enum.Font.Gotham;
                OptionButton.Text = optionText;
                OptionButton.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
                OptionButton.TextSize = 13;
                OptionButton.AutoButtonColor = false;
                CreateRounded(OptionButton, 3);
                
                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = optionText;
                    SelectedText.Text = optionText;
                    if callback then
                        pcall(callback, optionText);
                    end;
                    toggleDropdown();
                end);
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.5
                    }):Play();
                end);
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.7
                    }):Play();
                end);
            end;
            
            for _, option in pairs(options) do
                createOption(option);
            end;
            
            RunService.Stepped:Connect(function()
                OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsList.AbsoluteContentSize.Y);
            end);
            
            local dropdownAPI = {};
            
            function dropdownAPI:Add(option)
                table.insert(options, option);
                createOption(option);
            end;
            
            function dropdownAPI:Remove(option)
                for i, opt in pairs(options) do
                    if opt == option then
                        table.remove(options, i);
                        break;
                    end;
                end;
                for _, child in pairs(OptionsFrame:GetChildren()) do
                    if child:IsA("TextButton") and child.Text == option then
                        child:Destroy();
                        break;
                    end;
                end;
            end;
            
            function dropdownAPI:Clear()
                options = {};
                for _, child in pairs(OptionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy();
                    end;
                end;
                selectedOption = nil;
                SelectedText.Text = "Select...";
            end;
            
            function dropdownAPI:Set(option)
                selectedOption = option;
                SelectedText.Text = option;
                if callback then
                    pcall(callback, option);
                end;
            end;
            
            function dropdownAPI:Get()
                return selectedOption;
            end;
            
            return dropdownAPI;
        end;
        
        function main:Textbox(text, placeholder, callback)
            local TextboxFrame = Instance.new("Frame");
            TextboxFrame.Name = "Textbox";
            TextboxFrame.Parent = MainFramePage;
            TextboxFrame.BackgroundColor3 = _G.Primary;
            TextboxFrame.BackgroundTransparency = 0.8;
            TextboxFrame.Size = UDim2.new(1, 0, 0, 40);
            CreateRounded(TextboxFrame, 5);
            CreateStroke(TextboxFrame, _G.Third, 1);
            
            local Title = Instance.new("TextLabel");
            Title.Parent = TextboxFrame;
            Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
            Title.BackgroundTransparency = 1;
            Title.Position = UDim2.new(0, 15, 0.5, 0);
            Title.Size = UDim2.new(0.4, -15, 0, 20);
            Title.Font = Enum.Font.Cartoon;
            Title.Text = text;
            Title.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            Title.TextSize = 15;
            Title.TextXAlignment = Enum.TextXAlignment.Left;
            Title.AnchorPoint = Vector2.new(0, 0.5);
            
            local InputBox = Instance.new("TextBox");
            InputBox.Parent = TextboxFrame;
            InputBox.BackgroundColor3 = _G.Dark;
            InputBox.BackgroundTransparency = 0.3;
            InputBox.Position = UDim2.new(0.4, 0, 0.5, 0);
            InputBox.Size = UDim2.new(0.6, -25, 0, 30);
            InputBox.Font = Enum.Font.Gotham;
            InputBox.PlaceholderText = placeholder or "Type here...";
            InputBox.Text = "";
            InputBox.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            InputBox.TextSize = 13;
            InputBox.AnchorPoint = Vector2.new(0, 0.5);
            CreateRounded(InputBox, 5);
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    pcall(callback, InputBox.Text);
                end;
            end);
            
            return {
                SetText = function(text)
                    InputBox.Text = text;
                end,
                GetText = function()
                    return InputBox.Text;
                end,
                Clear = function()
                    InputBox.Text = "";
                end
            };
        end;
        
        function main:Label(text)
            local LabelFrame = Instance.new("Frame");
            LabelFrame.Name = "Label";
            LabelFrame.Parent = MainFramePage;
            LabelFrame.BackgroundColor3 = _G.Primary;
            LabelFrame.BackgroundTransparency = 1;
            LabelFrame.Size = UDim2.new(1, 0, 0, 30);
            
            local LabelText = Instance.new("TextLabel");
            LabelText.Parent = LabelFrame;
            LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            LabelText.BackgroundTransparency = 1;
            LabelText.Size = UDim2.new(1, -30, 1, 0);
            LabelText.Font = Enum.Font.Nunito;
            LabelText.Position = UDim2.new(0, 30, 0.5, 0);
            LabelText.AnchorPoint = Vector2.new(0, 0.5);
            LabelText.TextColor3 = _G.Themes[_G.CurrentTheme].SubText;
            LabelText.TextSize = 15;
            LabelText.Text = text;
            LabelText.TextXAlignment = Enum.TextXAlignment.Left;
            
            local Icon = Instance.new("ImageLabel");
            Icon.Name = "Icon";
            Icon.Parent = LabelFrame;
            Icon.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
            Icon.BackgroundTransparency = 1;
            Icon.ImageTransparency = 0;
            Icon.Position = UDim2.new(0, 10, 0.5, 0);
            Icon.Size = UDim2.new(0, 14, 0, 14);
            Icon.AnchorPoint = Vector2.new(0, 0.5);
            Icon.Image = "rbxassetid://10723415903";
            Icon.ImageColor3 = _G.Themes[_G.CurrentTheme].SubText;
            
            local labelAPI = {};
            
            function labelAPI:Set(newText)
                LabelText.Text = newText;
            end;
            
            function labelAPI:SetColor(color)
                LabelText.TextColor3 = color;
            end;
            
            return labelAPI;
        end;
        
        function main:Seperator(text)
            local SeperatorFrame = Instance.new("Frame");
            SeperatorFrame.Name = "Seperator";
            SeperatorFrame.Parent = MainFramePage;
            SeperatorFrame.BackgroundColor3 = _G.Primary;
            SeperatorFrame.BackgroundTransparency = 1;
            SeperatorFrame.Size = UDim2.new(1, 0, 0, 25);
            
            local LeftLine = Instance.new("Frame");
            LeftLine.Name = "LeftLine";
            LeftLine.Parent = SeperatorFrame;
            LeftLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            LeftLine.BackgroundTransparency = 0;
            LeftLine.AnchorPoint = Vector2.new(0, 0.5);
            LeftLine.Position = UDim2.new(0, 0, 0.5, 0);
            LeftLine.Size = UDim2.new(0.15, 0, 0, 1);
            LeftLine.BorderSizePixel = 0;
            
            local Gradient1 = CreateGradient(LeftLine, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Dark),
                ColorSequenceKeypoint.new(0.4, _G.Primary),
                ColorSequenceKeypoint.new(0.6, _G.Primary),
                ColorSequenceKeypoint.new(1, _G.Dark)
            }));
            Gradient1.Rotation = 90;
            
            local CenterText = Instance.new("TextLabel");
            CenterText.Name = "CenterText";
            CenterText.Parent = SeperatorFrame;
            CenterText.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            CenterText.BackgroundTransparency = 1;
            CenterText.AnchorPoint = Vector2.new(0.5, 0.5);
            CenterText.Position = UDim2.new(0.5, 0, 0.5, 0);
            CenterText.Size = UDim2.new(1, 0, 0, 25);
            CenterText.Font = Enum.Font.GothamBold;
            CenterText.Text = text;
            CenterText.TextColor3 = _G.Themes[_G.CurrentTheme].Text;
            CenterText.TextSize = 14;
            
            local RightLine = Instance.new("Frame");
            RightLine.Name = "RightLine";
            RightLine.Parent = SeperatorFrame;
            RightLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            RightLine.BackgroundTransparency = 0;
            RightLine.AnchorPoint = Vector2.new(1, 0.5);
            RightLine.Position = UDim2.new(1, 0, 0.5, 0);
            RightLine.Size = UDim2.new(0.15, 0, 0, 1);
            RightLine.BorderSizePixel = 0;
            
            local Gradient2 = CreateGradient(RightLine, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Dark),
                ColorSequenceKeypoint.new(0.4, _G.Primary),
                ColorSequenceKeypoint.new(0.6, _G.Primary),
                ColorSequenceKeypoint.new(1, _G.Dark)
            }));
            Gradient2.Rotation = 90;
        end;
        
        function main:Line()
            local LineFrame = Instance.new("Frame");
            LineFrame.Name = "Line";
            LineFrame.Parent = MainFramePage;
            LineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            LineFrame.BackgroundTransparency = 1;
            LineFrame.Size = UDim2.new(1, 0, 0, 20);
            
            local Line = Instance.new("Frame");
            Line.Parent = LineFrame;
            Line.BackgroundColor3 = Color3.new(125, 125, 125);
            Line.BorderSizePixel = 0;
            Line.Position = UDim2.new(0, 0, 0, 10);
            Line.Size = UDim2.new(1, 0, 0, 1);
            
            local Gradient = CreateGradient(Line, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Dark),
                ColorSequenceKeypoint.new(0.4, _G.Primary),
                ColorSequenceKeypoint.new(0.5, _G.Primary),
                ColorSequenceKeypoint.new(0.6, _G.Primary),
                ColorSequenceKeypoint.new(1, _G.Dark)
            }));
        end;
        
        return main;
    end;
    
    return uitab;
end;

-- ======================
-- INITIALIZATION
-- ======================
Update:Notify("STELLAR UI Library v5.0 Loaded!");
Update:Notify("Press Insert to toggle UI | RightShift to minimize");

if SettingsLib.LoadAnimation then
    local loader = Update:StartLoad("Initializing STELLAR UI...");
    wait(2);
    Update:Loaded();
end;

return Update;