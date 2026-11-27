local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

local Colors = {
    ["Red"] = Color3.fromRGB(255, 0, 0),
    ["Blue"] = Color3.fromRGB(0, 150, 255),
    ["Green"] = Color3.fromRGB(0, 255, 0),
    ["Purple"] = Color3.fromRGB(180, 0, 255),
    ["Orange"] = Color3.fromRGB(255, 150, 0),
    ["White"] = Color3.fromRGB(255, 255, 255)
}
local CurrentAccent = Colors["Red"]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomLibrary"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifyFrame = Instance.new("Frame")
NotifyFrame.Name = "NotifyFrame"
NotifyFrame.Parent = ScreenGui
NotifyFrame.BackgroundTransparency = 1
NotifyFrame.Position = UDim2.new(1, -320, 1, -100)
NotifyFrame.Size = UDim2.new(0, 300, 1, 0)
NotifyFrame.AnchorPoint = Vector2.new(0, 1)

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Parent = NotifyFrame
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Position = UDim2.new(0.5, -2, 0.5, -11)
MainFrame.Size = UDim2.new(0, 497, 0, 314)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CurrentAccent
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BackgroundTransparency = 0.5
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = ""
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 5, 5)
CloseBtn.TextSize = 14

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = MainFrame
TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabsFrame.BackgroundTransparency = 0.5
TabsFrame.Position = UDim2.new(0, 10, 0, 45)
TabsFrame.Size = UDim2.new(0, 120, 1, -55)
TabsFrame.BorderSizePixel = 0

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 6)
TabsCorner.Parent = TabsFrame

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsFrame
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabsPadding = Instance.new("UIPadding")
TabsPadding.Parent = TabsFrame
TabsPadding.PaddingTop = UDim.new(0, 10)

local PagesFrame = Instance.new("Frame")
PagesFrame.Name = "PagesFrame"
PagesFrame.Parent = MainFrame
PagesFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PagesFrame.BackgroundTransparency = 0.5
PagesFrame.Position = UDim2.new(0, 140, 0, 45)
PagesFrame.Size = UDim2.new(1, -150, 1, -55)
PagesFrame.BorderSizePixel = 0

local PagesCorner = Instance.new("UICorner")
PagesCorner.CornerRadius = UDim.new(0, 6)
PagesCorner.Parent = PagesFrame

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

function Library:Notify(Configs)
    local TitleText = Configs.Title or "Notification"
    local Text = Configs.Text or ""
    local Duration = Configs.Time or 5
    
    local NotifyItem = Instance.new("Frame")
    local ItemCorner = Instance.new("UICorner")
    local ItemStroke = Instance.new("UIStroke")
    local NTitle = Instance.new("TextLabel")
    local NText = Instance.new("TextLabel")
    local NTime = Instance.new("TextLabel")
    local DeleteBtn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    
    NotifyItem.Name = "NotifyItem"
    NotifyItem.Parent = NotifyFrame
    NotifyItem.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifyItem.BackgroundTransparency = 0.2
    NotifyItem.Size = UDim2.new(1, 0, 0, 70)
    
    ItemCorner.CornerRadius = UDim.new(0, 6)
    ItemCorner.Parent = NotifyItem
    
    ItemStroke.Color = CurrentAccent
    ItemStroke.Thickness = 1
    ItemStroke.Parent = NotifyItem
    
    NTitle.Name = "NTitle"
    NTitle.Parent = NotifyItem
    NTitle.BackgroundTransparency = 1
    NTitle.Position = UDim2.new(0, 10, 0, 5)
    NTitle.Size = UDim2.new(1, -50, 0, 20)
    NTitle.Font = Enum.Font.GothamBold
    NTitle.Text = TitleText
    NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NTitle.TextSize = 14
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    NText.Name = "NText"
    NText.Parent = NotifyItem
    NText.BackgroundTransparency = 1
    NText.Position = UDim2.new(0, 10, 0, 25)
    NText.Size = UDim2.new(1, -20, 0, 20)
    NText.Font = Enum.Font.Gotham
    NText.Text = Text
    NText.TextColor3 = Color3.fromRGB(200, 200, 200)
    NText.TextSize = 12
    NText.TextXAlignment = Enum.TextXAlignment.Left
    
    NTime.Name = "NTime"
    NTime.Parent = NotifyItem
    NTime.BackgroundTransparency = 1
    NTime.Position = UDim2.new(0, 10, 1, -20)
    NTime.Size = UDim2.new(0, 100, 0, 15)
    NTime.Font = Enum.Font.Gotham
    NTime.Text = tostring(Duration) .. "s"
    NTime.TextColor3 = Color3.fromRGB(150, 150, 150)
    NTime.TextSize = 11
    NTime.TextXAlignment = Enum.TextXAlignment.Left
    
    DeleteBtn.Name = "DeleteBtn"
    DeleteBtn.Parent = NotifyItem
    DeleteBtn.BackgroundColor3 = CurrentAccent
    DeleteBtn.Position = UDim2.new(1, -30, 0, 5)
    DeleteBtn.Size = UDim2.new(0, 20, 0, 20)
    DeleteBtn.Font = Enum.Font.GothamBold
    DeleteBtn.Text = "X"
    DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DeleteBtn.TextSize = 10
    
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = DeleteBtn
    
    DeleteBtn.MouseButton1Click:Connect(function()
        NotifyItem:Destroy()
    end)
    
    task.spawn(function()
        local timeLeft = Duration
        while timeLeft > 0 do
            task.wait(1)
            timeLeft = timeLeft - 1
            if NTime then NTime.Text = tostring(timeLeft) .. "s" end
        end
        if NotifyItem then
            NotifyItem:Destroy()
        end
    end)
end

function Library:Window(Configs)
    if Configs and Configs.Hub then
        Title.Text = (Configs.Hub.Name or "Library") .. " | " .. (Configs.Hub.By or "")
    end
    
    local WindowObj = {}
    function WindowObj:Tab(text, isFirst, icon)
    local TabBtn = Instance.new("TextButton")
    local TabCorner = Instance.new("UICorner")
    local TabIcon = Instance.new("ImageLabel")
    local TabText = Instance.new("TextLabel")
    
    TabBtn.Name = text
    TabBtn.Parent = TabsFrame
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.Size = UDim2.new(1, -20, 0, 30)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Text = ""
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 13
    
    TabCorner.CornerRadius = UDim.new(0, 4)
    TabCorner.Parent = TabBtn
    
    TabIcon.Name = "TabIcon"
    TabIcon.Parent = TabBtn
    TabIcon.BackgroundTransparency = 1
    TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
    TabIcon.Size = UDim2.new(0, 16, 0, 16)
    TabIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    TabIcon.ScaleType = Enum.ScaleType.Fit
    TabIcon.Visible = false
    
    if icon and icon ~= "" then
        if string.match(tostring(icon), "^%d+$") then
            TabIcon.Image = "rbxassetid://" .. icon
        else
            TabIcon.Image = icon
        end
        TabIcon.Visible = true
    end
    
    TabText.Name = "TabText"
    TabText.Parent = TabBtn
    TabText.BackgroundTransparency = 1
    TabText.Size = UDim2.new(1, 0, 1, 0)
    TabText.Font = Enum.Font.Gotham
    TabText.Text = text
    TabText.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabText.TextSize = 13
    TabText.TextXAlignment = Enum.TextXAlignment.Center
    
    if icon and icon ~= "" then
        TabText.Position = UDim2.new(0, 30, 0, 0)
        TabText.Size = UDim2.new(1, -20, 1, 0)
        TabText.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    local Page = Instance.new("ScrollingFrame")
    local PageLayout = Instance.new("UIListLayout")
    local PagePadding = Instance.new("UIPadding")
    
    Page.Name = text .. "Page"
    Page.Parent = PagesFrame
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = CurrentAccent
    Page.Visible = false
    
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    
    PagePadding.Parent = Page
    PagePadding.PaddingLeft = UDim.new(0, 10)
    PagePadding.PaddingRight = UDim.new(0, 10)
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingBottom = UDim.new(0, 10)
    
    local function Activate()
        for _, btn in pairs(TabsFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                local txt = btn:FindFirstChild("TabText")
                local icn = btn:FindFirstChild("TabIcon")
                if txt then txt.TextColor3 = Color3.fromRGB(200, 200, 200) end
                if icn then icn.ImageColor3 = Color3.fromRGB(200, 200, 200) end
            end
        end
        for _, pg in pairs(PagesFrame:GetChildren()) do
            if pg:IsA("ScrollingFrame") then
                pg.Visible = false
            end
        end
        
        TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
    end
    
    TabBtn.MouseButton1Click:Connect(Activate)
    
    if isFirst then
        Activate()
    end
        
        local Elements = {Page = Page}
        
        function Elements:Discord(Configs)
            local DiscordFrame = Instance.new("Frame")
            local FrameCorner = Instance.new("UICorner")
            local Icon = Instance.new("ImageLabel")
            local IconCorner = Instance.new("UICorner")
            local TitleLabel = Instance.new("TextLabel")
            local DescLabel = Instance.new("TextLabel")
            local CopyBtn = Instance.new("TextButton")
            local BtnCorner = Instance.new("UICorner")
            
            DiscordFrame.Name = "DiscordFrame"
            DiscordFrame.Parent = Page
            DiscordFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DiscordFrame.Size = UDim2.new(1, 0, 0, 80)
            
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = DiscordFrame
            
            Icon.Name = "Icon"
            Icon.Parent = DiscordFrame
            Icon.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Icon.Position = UDim2.new(0, 10, 0, 10)
            Icon.Size = UDim2.new(0, 60, 0, 60)
            Icon.Image = Configs.Image or ""
            
            IconCorner.CornerRadius = UDim.new(0, 30)
            IconCorner.Parent = Icon
            
            TitleLabel.Name = "TitleLabel"
            TitleLabel.Parent = DiscordFrame
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 80, 0, 15)
            TitleLabel.Size = UDim2.new(1, -90, 0, 20)
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = Configs.Name or "Discord Server"
            TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            DescLabel.Name = "DescLabel"
            DescLabel.Parent = DiscordFrame
            DescLabel.BackgroundTransparency = 1
            DescLabel.Position = UDim2.new(0, 80, 0, 35)
            DescLabel.Size = UDim2.new(1, -90, 0, 15)
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.Text = Configs.Link or "discord.gg/..."
            DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            DescLabel.TextSize = 12
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            CopyBtn.Name = "CopyBtn"
            CopyBtn.Parent = DiscordFrame
            CopyBtn.BackgroundColor3 = CurrentAccent
            CopyBtn.Position = UDim2.new(1, -70, 0, 25)
            CopyBtn.Size = UDim2.new(0, 60, 0, 30)
            CopyBtn.Font = Enum.Font.GothamBold
            CopyBtn.Text = "Copy"
            CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            CopyBtn.TextSize = 12
            
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = CopyBtn
            
            CopyBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(Configs.Link or "")
                    Library:Notify({
                        Title = "Copied",
                        Text = "Discord link copied to clipboard",
                        Time = 3
                    })
                end
            end)
        end
        
        function Elements:Button(text, description, callback, requiresKey)
            if type(description) == "function" then
                callback = description
                description = nil
                requiresKey = false
            end

            local ButtonFrame = Instance.new("TextButton")
            local BtnCorner = Instance.new("UICorner")
            local BtnTitle = Instance.new("TextLabel")
            local BtnDesc = Instance.new("TextLabel")
            local BtnIcon = Instance.new("ImageLabel")

            ButtonFrame.Name = (type(text) == "string" and text or "Button") .. "_Button"
            ButtonFrame.Parent = Page
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Text = ""
            ButtonFrame.Active = true
            ButtonFrame.ZIndex = 5

            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ButtonFrame

            BtnTitle.Parent = ButtonFrame
            BtnTitle.BackgroundTransparency = 1
            BtnTitle.Position = UDim2.new(0, 10, 0, 0)
            BtnTitle.Size = UDim2.new(1, -40, 1, 0)
            BtnTitle.Font = Enum.Font.Code
            BtnTitle.Text = tostring(text or "Button")
            BtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnTitle.TextSize = 13
            BtnTitle.TextXAlignment = Enum.TextXAlignment.Left
            BtnTitle.ZIndex = 6

            if description and description ~= "" then
                ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
                BtnTitle.Size = UDim2.new(1, -40, 0, 18)
                BtnTitle.Position = UDim2.new(0, 10, 0, 4)
                
                BtnDesc.Parent = ButtonFrame
                BtnDesc.BackgroundTransparency = 1
                BtnDesc.Position = UDim2.new(0, 10, 0, 22)
                BtnDesc.Size = UDim2.new(1, -40, 0, 18)
                BtnDesc.Font = Enum.Font.Code
                BtnDesc.Text = tostring(description)
                BtnDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
                BtnDesc.TextSize = 11
                BtnDesc.TextXAlignment = Enum.TextXAlignment.Left
                BtnDesc.ZIndex = 6
            end

            BtnIcon.Parent = ButtonFrame
            BtnIcon.BackgroundTransparency = 1
            BtnIcon.Position = UDim2.new(1, -26, 0.5, -8)
            BtnIcon.Size = UDim2.new(0, 16, 0, 16)
            BtnIcon.Image = "rbxassetid://7734010488"
            BtnIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            BtnIcon.Active = false
            BtnIcon.ZIndex = 6

            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(BtnIcon, TweenInfo.new(0.2), {ImageColor3 = CurrentAccent}):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                TweenService:Create(BtnIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end)

            ButtonFrame.MouseButton1Down:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, ButtonFrame.Size.Y.Offset - 2)}):Play()
            end)

            ButtonFrame.MouseButton1Up:Connect(function()
                local targetHeight = (description and description ~= "") and 45 or 32
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            end)

            local Locked = requiresKey
            local LockOverlay
            
            if requiresKey then
                LockOverlay = Instance.new("TextButton")
                LockOverlay.Size = UDim2.new(1, 0, 1, 0)
                LockOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                LockOverlay.BackgroundTransparency = 0.3
                LockOverlay.Text = ""
                LockOverlay.ZIndex = 10
                LockOverlay.Parent = ButtonFrame

                local LockCorner = Instance.new("UICorner")
                LockCorner.CornerRadius = UDim.new(0, 6)
                LockCorner.Parent = LockOverlay

                local LockImage = Instance.new("ImageLabel")
                LockImage.Size = UDim2.new(0, 20, 0, 20)
                LockImage.Position = UDim2.new(1, -30, 0.5, -10)
                LockImage.BackgroundTransparency = 1
                LockImage.Image = "rbxassetid://78672912777756"
                LockImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
                LockImage.ZIndex = 11
                LockImage.Parent = LockOverlay

                LockOverlay.MouseButton1Click:Connect(function()
                    if Locked and Elements.KeySystem then
                        Elements.KeySystem(function(Success)
                            if Success then
                                Locked = false
                                if LockOverlay then LockOverlay:Destroy() end
                            end
                        end)
                    end
                end)
            end

            ButtonFrame.Activated:Connect(function()
                if Locked then return end

                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://116902184912832"
                sound.Volume = 0.5
                sound.Parent = game:GetService("SoundService")
                sound:Play()
                sound.Ended:Connect(function()
                    sound:Destroy()
                end)

                if type(callback) == "function" then
                    task.spawn(callback)
                end
            end)
        end

        function Elements:Toggle(text, description, default, callback, requiresKey)
            if type(description) == "boolean" then
                requiresKey = callback
                callback = default
                default = description
                description = ""
            end

            default = default or false
            callback = callback or function() end
            requiresKey = requiresKey or false

            local ToggleFrame = Instance.new("TextButton")
            local TogCorner = Instance.new("UICorner")
            local TogTitle = Instance.new("TextLabel")
            local TogDesc = Instance.new("TextLabel")
            local TogBox = Instance.new("Frame")
            local TogBoxCorner = Instance.new("UICorner")
            local TogBoxStroke = Instance.new("UIStroke")
            local Check = Instance.new("Frame")
            local CheckCorner = Instance.new("UICorner")

            local toggled = default

            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 28)
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Text = ""

            TogCorner.CornerRadius = UDim.new(0, 6)
            TogCorner.Parent = ToggleFrame

            TogTitle.Parent = ToggleFrame
            TogTitle.BackgroundTransparency = 1
            TogTitle.Position = UDim2.new(0, 10, 0, 0)
            TogTitle.Size = UDim2.new(1, -60, 1, 0)
            TogTitle.Font = Enum.Font.Code
            TogTitle.Text = text
            TogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TogTitle.TextSize = 12
            TogTitle.TextXAlignment = Enum.TextXAlignment.Left

            if description and description ~= "" then
                ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
                TogTitle.Size = UDim2.new(1, -60, 0, 16)
                TogTitle.Position = UDim2.new(0, 10, 0, 4)

                TogDesc.Parent = ToggleFrame
                TogDesc.BackgroundTransparency = 1
                TogDesc.Position = UDim2.new(0, 10, 0, 20)
                TogDesc.Size = UDim2.new(1, -60, 0, 16)
                TogDesc.Font = Enum.Font.Code
                TogDesc.Text = description
                TogDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
                TogDesc.TextSize = 10
                TogDesc.TextXAlignment = Enum.TextXAlignment.Left
            end

            TogBox.Parent = ToggleFrame
            TogBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TogBox.AnchorPoint = Vector2.new(1, 0.5)
            TogBox.Position = UDim2.new(1, -10, 0.5, 0)
            TogBox.Size = UDim2.new(0, 30, 0, 16)

            TogBoxCorner.CornerRadius = UDim.new(1, 0)
            TogBoxCorner.Parent = TogBox

            TogBoxStroke.Parent = TogBox
            TogBoxStroke.Thickness = 1
            TogBoxStroke.Color = Color3.fromRGB(60, 60, 60)

            Check.Parent = TogBox
            Check.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            Check.AnchorPoint = Vector2.new(0.5, 0.5)
            Check.Position = UDim2.new(0, 9, 0.5, 0)
            Check.Size = UDim2.new(0, 11, 0, 11)

            CheckCorner.CornerRadius = UDim.new(1, 0)
            CheckCorner.Parent = Check

            if toggled then
                Check.Position = UDim2.new(0, 21, 0.5, 0)
                Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TogBox.BackgroundColor3 = CurrentAccent
                TogBoxStroke.Color = CurrentAccent
            end

            ToggleFrame.MouseEnter:Connect(function()
                TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                }):Play()
            end)

            ToggleFrame.MouseLeave:Connect(function()
                TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                }):Play()
            end)

            local Locked = requiresKey
            local LockOverlay

            if requiresKey then
                LockOverlay = Instance.new("TextButton")
                LockOverlay.Size = UDim2.new(1, 0, 1, 0)
                LockOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                LockOverlay.BackgroundTransparency = 0.3
                LockOverlay.Text = ""
                LockOverlay.ZIndex = 10
                LockOverlay.Parent = ToggleFrame

                local LockCorner = Instance.new("UICorner")
                LockCorner.CornerRadius = UDim.new(0, 6)
                LockCorner.Parent = LockOverlay

                local LockImage = Instance.new("ImageLabel")
                LockImage.Size = UDim2.new(0, 16, 0, 16)
                LockImage.Position = UDim2.new(1, -50, 0.5, -8)
                LockImage.BackgroundTransparency = 1
                LockImage.Image = "rbxassetid://78672912777756"
                LockImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
                LockImage.ZIndex = 11
                LockImage.Parent = LockOverlay

                LockOverlay.MouseButton1Click:Connect(function()
                    if Locked and Elements.KeySystem then
                        Elements.KeySystem(function(Success)
                            if Success then
                                Locked = false
                                if LockOverlay then LockOverlay:Destroy() end
                            end
                        end)
                    end
                end)
            end

            ToggleFrame.MouseButton1Click:Connect(function()
                if Locked then return end

                toggled = not toggled

                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://116902184912832"
                sound.Volume = 0.5
                sound.Parent = game:GetService("SoundService")
                sound:Play()
                sound.Ended:Connect(function()
                    sound:Destroy()
                end)

                if toggled then
                    TweenService:Create(Check, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                        Position = UDim2.new(0, 21, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()

                    TweenService:Create(TogBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = CurrentAccent
                    }):Play()

                    TweenService:Create(TogBoxStroke, TweenInfo.new(0.2), {
                        Color = CurrentAccent
                    }):Play()
                else
                    TweenService:Create(Check, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                        Position = UDim2.new(0, 9, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                    }):Play()

                    TweenService:Create(TogBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    }):Play()

                    TweenService:Create(TogBoxStroke, TweenInfo.new(0.2), {
                        Color = Color3.fromRGB(60, 60, 60)
                    }):Play()
                end
                
                pcall(callback, toggled)
            end)

            pcall(callback, toggled)
        end
        
        function Elements:Slider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            local SlideCorner = Instance.new("UICorner")
            local SlideTitle = Instance.new("TextLabel")
            local SlideValue = Instance.new("TextBox")
            local BarBG = Instance.new("Frame")
            local BarCorner = Instance.new("UICorner")
            local BarFill = Instance.new("Frame")
            local FillCorner = Instance.new("UICorner")
            local Interact = Instance.new("TextButton")

            min = min or 0
            max = max or 100
            default = default or min
            local value = default

            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)

            SlideCorner.CornerRadius = UDim.new(0, 6)
            SlideCorner.Parent = SliderFrame

            SlideTitle.Parent = SliderFrame
            SlideTitle.BackgroundTransparency = 1
            SlideTitle.Position = UDim2.new(0, 10, 0, 5)
            SlideTitle.Size = UDim2.new(1, -20, 0, 20)
            SlideTitle.Font = Enum.Font.Code
            SlideTitle.Text = text
            SlideTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SlideTitle.TextSize = 13
            SlideTitle.TextXAlignment = Enum.TextXAlignment.Left

            SlideValue.Parent = SliderFrame
            SlideValue.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            SlideValue.Position = UDim2.new(1, -45, 0, 5)
            SlideValue.Size = UDim2.new(0, 35, 0, 20)
            SlideValue.Font = Enum.Font.Code
            SlideValue.Text = tostring(value)
            SlideValue.TextColor3 = CurrentAccent
            SlideValue.TextSize = 13
            SlideValue.TextXAlignment = Enum.TextXAlignment.Center
            SlideValue.ClearTextOnFocus = false

            local SlideValueCorner = Instance.new("UICorner")
            SlideValueCorner.CornerRadius = UDim.new(0, 4)
            SlideValueCorner.Parent = SlideValue

            BarBG.Parent = SliderFrame
            BarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            BarBG.Position = UDim2.new(0, 10, 0, 30)
            BarBG.Size = UDim2.new(1, -60, 0, 6)

            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = BarBG

            BarFill.Parent = BarBG
            BarFill.BackgroundColor3 = CurrentAccent
            BarFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)

            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = BarFill

            Interact.Parent = SliderFrame
            Interact.BackgroundTransparency = 1
            Interact.Position = UDim2.new(0, 0, 0, 25)
            Interact.Size = UDim2.new(1, 0, 0, 25)
            Interact.Text = ""

            local function UpdateSlide(input)
                local SizeX = BarBG.AbsoluteSize.X
                local SlideX = BarBG.AbsolutePosition.X
                local InputX = input.Position.X
                
                local Percent = math.clamp((InputX - SlideX) / SizeX, 0, 1)
                value = math.floor(min + (max - min) * Percent)
                
                SlideValue.Text = tostring(value)
                TweenService:Create(BarFill, TweenInfo.new(0.05), {Size = UDim2.new(Percent, 0, 1, 0)}):Play()
                pcall(callback, value)
            end

            SlideValue.FocusLost:Connect(function()
                local NewValue = tonumber(SlideValue.Text)
                if NewValue then
                    value = math.clamp(NewValue, min, max)
                    SlideValue.Text = tostring(value)
                    local Percent = (value - min) / (max - min)
                    TweenService:Create(BarFill, TweenInfo.new(0.05), {Size = UDim2.new(Percent, 0, 1, 0)}):Play()
                    pcall(callback, value)
                else
                    SlideValue.Text = tostring(value)
                end
            end)

            local sliding = false

            Interact.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    TweenService:Create(SliderFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45,45,45)}):Play()
                    UpdateSlide(input)
                end
            end)

            Interact.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                    TweenService:Create(SliderFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlide(input)
                end
            end)
        end

        function Elements:MultiDropdown(Configs)
            local name = Configs.Title or "Multi-Select"
            local Options = Configs.Options or {}
            local DefaultSelected = Configs.Default or {}
            local Callback = Configs.Callback or function() end
            local isMulti = Configs.Multi
            if isMulti == nil then isMulti = true end
            local requiresKey = Configs.RequiresKey or false

            local Selected = {}
            for _, v in pairs(DefaultSelected) do Selected[v] = true end

            local Frame = Instance.new("Frame")
            local FrameCorner = Instance.new("UICorner")
            local FrameStroke = Instance.new("UIStroke")
            
            Frame.Parent = Page
            Frame.Size = UDim2.new(1, 0, 0, 25)
            Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Frame.ClipsDescendants = true

            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = Frame
            FrameStroke.Color = Color3.fromRGB(45, 45, 45)
            FrameStroke.Parent = Frame

            local click = Instance.new("TextButton")
            click.Parent = Frame
            click.Size = UDim2.new(1, 0, 0, 25)
            click.BackgroundTransparency = 1
            click.Text = ""

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = Frame
            TextLabel.Size = UDim2.new(1, -70, 0, 25)
            TextLabel.Position = UDim2.new(0, 10, 0, 0)
            TextLabel.TextSize = 12
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Text = name
            TextLabel.Font = Enum.Font.Code
            TextLabel.BackgroundTransparency = 1

            local DropIcon = Instance.new("ImageLabel")
            DropIcon.Parent = Frame
            DropIcon.Size = UDim2.new(0, 14, 0, 14)
            DropIcon.Position = UDim2.new(1, -22, 0, 5.5)
            DropIcon.BackgroundTransparency = 1
            DropIcon.Image = "rbxassetid://6031091004"
            DropIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            DropIcon.Rotation = 0

            local SearchBox = Instance.new("TextBox")
            SearchBox.Parent = Frame
            SearchBox.Size = UDim2.new(1, -20, 0, 20)
            SearchBox.Position = UDim2.new(0, 10, 0, 30)
            SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            SearchBox.PlaceholderText = "Search options..."
            SearchBox.Text = ""
            SearchBox.TextSize = 11
            SearchBox.Font = Enum.Font.Code
            SearchBox.Visible = false
            Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

            local OptionContainer = Instance.new("ScrollingFrame")
            OptionContainer.Parent = Frame
            OptionContainer.Size = UDim2.new(1, -20, 0, 90)
            OptionContainer.Position = UDim2.new(0, 10, 0, 55)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            OptionContainer.ScrollBarThickness = 2
            OptionContainer.Visible = false
            
            local Layout = Instance.new("UIListLayout", OptionContainer)
            Layout.Padding = UDim.new(0, 3)

            local function updateLayout()
                OptionContainer.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
            end
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateLayout)

            local OptionButtons = {}

            local function RefreshVisuals()
                for opt, btn in pairs(OptionButtons) do
                    btn.BackgroundColor3 = Selected[opt] and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(35, 35, 35)
                    btn.TextColor3 = Selected[opt] and Color3.fromRGB(255, 177, 24) or Color3.fromRGB(255, 255, 255)
                end
            end

            local function RefreshOptions()
                for _, btn in pairs(OptionButtons) do btn:Destroy() end
                OptionButtons = {}

                for _, option in pairs(Options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Parent = OptionContainer
                    OptBtn.Size = UDim2.new(1, 0, 0, 20)
                    OptBtn.BackgroundColor3 = Selected[option] and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(35, 35, 35)
                    OptBtn.Text = "  " .. tostring(option)
                    OptBtn.TextColor3 = Selected[option] and Color3.fromRGB(255, 177, 24) or Color3.fromRGB(255, 255, 255)
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.Font = Enum.Font.Code
                    OptBtn.TextSize = 11
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

                    OptBtn.MouseButton1Click:Connect(function()
                        if not isMulti then
                            local isAlreadySelected = Selected[option]
                            Selected = {}
                            if not isAlreadySelected then
                                Selected[option] = true
                            end
                        else
                            Selected[option] = not Selected[option]
                        end

                        RefreshVisuals()

                        local tbl = {}
                        for k, v in pairs(Selected) do if v then table.insert(tbl, k) end end
                        pcall(Callback, tbl)
                    end)

                    OptionButtons[option] = OptBtn
                end
            end

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local text = SearchBox.Text:lower()
                for opt, btn in pairs(OptionButtons) do
                    if text == "" or opt:lower():find(text) then
                        btn.Visible = true
                    else
                        btn.Visible = false
                    end
                end
            end)

            local Locked = requiresKey
            local LockOverlay

            if requiresKey then
                LockOverlay = Instance.new("TextButton")
                LockOverlay.Size = UDim2.new(1, 0, 1, 0)
                LockOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                LockOverlay.BackgroundTransparency = 0.3
                LockOverlay.Text = ""
                LockOverlay.ZIndex = 10
                LockOverlay.Parent = Frame

                local LockCorner = Instance.new("UICorner")
                LockCorner.CornerRadius = UDim.new(0, 6)
                LockCorner.Parent = LockOverlay

                local LockImage = Instance.new("ImageLabel")
                LockImage.Size = UDim2.new(0, 16, 0, 16)
                LockImage.Position = UDim2.new(1, -50, 0.5, -8)
                LockImage.BackgroundTransparency = 1
                LockImage.Image = "rbxassetid://78672912777756"
                LockImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
                LockImage.ZIndex = 11
                LockImage.Parent = LockOverlay

                LockOverlay.MouseButton1Click:Connect(function()
                    if Locked and Elements.KeySystem then
                        Elements.KeySystem(function(Success)
                            if Success then
                                Locked = false
                                if LockOverlay then LockOverlay:Destroy() end
                            end
                        end)
                    end
                end)
            end

            local open = false
            click.MouseButton1Click:Connect(function()
                if Locked then return end

                open = not open
                if open then
                    SearchBox.Visible = true
                    OptionContainer.Visible = true
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 155)}):Play()
                    TweenService:Create(DropIcon, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 25)}):Play()
                    TweenService:Create(DropIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    task.wait(0.2)
                    SearchBox.Visible = false
                    OptionContainer.Visible = false
                end
            end)

            RefreshOptions()

            return {
                GetSelected = function()
                    local tbl = {}
                    for k, v in pairs(Selected) do if v then table.insert(tbl, k) end end
                    return tbl
                end,
                Update = function(NewOptions, NewDefault)
                    Options = NewOptions or {}
                    Selected = {}
                    if NewDefault then
                        for _, v in pairs(NewDefault) do Selected[v] = true end
                    end
                    SearchBox.Text = ""
                    RefreshOptions()
                    
                    local tbl = {}
                    for k, v in pairs(Selected) do if v then table.insert(tbl, k) end end
                    pcall(Callback, tbl)
                end
            }
        end

        function Elements:State(text)
            local Lab = Instance.new("TextLabel")
            local LabCorner = Instance.new("UICorner")
            
            Lab.Parent = Page 
            Lab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Lab.Size = UDim2.new(1, 0, 0, 28)
            Lab.Font = Enum.Font.Code
            Lab.Text = text
            Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lab.TextSize = 13

            LabCorner.CornerRadius = UDim.new(0, 6)
            LabCorner.Parent = Lab
            return Lab
        end

        function Elements:Paragraph(config)
            local PFrame = Instance.new("Frame")
            local PCorner = Instance.new("UICorner")
            local PTitle = Instance.new("TextLabel")
            local PText = Instance.new("TextLabel")

            PFrame.Parent = Page
            PFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            PFrame.Size = UDim2.new(1, 0, 0, 52)

            PCorner.CornerRadius = UDim.new(0, 6)
            PCorner.Parent = PFrame

            PTitle.Parent = PFrame
            PTitle.BackgroundTransparency = 1
            PTitle.Position = UDim2.new(0, 10, 0, 5)
            PTitle.Size = UDim2.new(1, -20, 0, 18)
            PTitle.Font = Enum.Font.Code
            PTitle.Text = config.Title or "Paragraph"
            PTitle.TextColor3 = CurrentAccent
            PTitle.TextSize = 13
            PTitle.TextXAlignment = Enum.TextXAlignment.Left

            PText.Parent = PFrame
            PText.BackgroundTransparency = 1
            PText.Position = UDim2.new(0, 10, 0, 23)
            PText.Size = UDim2.new(1, -20, 0, 24)
            PText.Font = Enum.Font.Code
            PText.Text = config.Text or ""
            PText.TextColor3 = Color3.fromRGB(150, 150, 150)
            PText.TextSize = 12
            PText.TextXAlignment = Enum.TextXAlignment.Left
            PText.TextWrapped = true
        end
        
        function Elements:Label(text)
            local Seperator = Instance.new("Frame")
            local Sep1 = Instance.new("Frame")
            local Sep2 = Instance.new("TextLabel")
            local Sep3 = Instance.new("Frame")
            
            Seperator.Parent = Page
            Seperator.BackgroundTransparency = 1
            Seperator.Size = UDim2.new(1, 0, 0, 20)
            
            Sep1.Parent = Seperator
            Sep1.BackgroundColor3 = CurrentAccent
            Sep1.BorderSizePixel = 0
            Sep1.Position = UDim2.new(0, 0, 0, 10)
            Sep1.Size = UDim2.new(0, 80, 0, 1)
            
            Sep2.Parent = Seperator
            Sep2.BackgroundTransparency = 1
            Sep2.Position = UDim2.new(0.5, -50, 0, 0)
            Sep2.Size = UDim2.new(0, 100, 0, 20)
            Sep2.Font = Enum.Font.Code
            Sep2.Text = text
            Sep2.TextColor3 = Color3.fromRGB(150, 150, 150)
            Sep2.TextSize = 13
            
            Sep3.Parent = Seperator
            Sep3.BackgroundColor3 = CurrentAccent
            Sep3.BorderSizePixel = 0
            Sep3.Position = UDim2.new(1, -80, 0, 10)
            Sep3.Size = UDim2.new(0, 80, 0, 1)
        end
        
        return Elements
    end
    
    return WindowObj
end

local ToggleBtn = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local ToggleStroke = Instance.new("UIStroke")
local ToggleGradient = Instance.new("UIGradient")

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleBtn.Position = UDim2.new(0.100000001, -53, 0.100000001, -1)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.Text = ""
ToggleBtn.TextColor3 = CurrentAccent
ToggleBtn.TextSize = 20
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local Icon = Instance.new("ImageLabel")
Icon.Parent = ToggleBtn
Icon.Size = UDim2.new(0, 30, 0, 30)
Icon.Position = UDim2.new(0.5, -15, 0.5, -15)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://10723346959"
Icon.ScaleType = Enum.ScaleType.Fit

ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

ToggleStroke.Parent = ToggleBtn
ToggleStroke.Thickness = 2
ToggleStroke.Color = CurrentAccent
ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ToggleGradient.Parent = ToggleStroke
ToggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 5, 5)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 5, 5))
})
ToggleGradient.Rotation = 45

MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local isOpen = false
local fullSize = UDim2.new(0, 497, 0, 314)

ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = fullSize}):Play()
        TweenService:Create(MainStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        closeTween:Play()
        closeTween.Completed:Wait()
        MainFrame.Visible = false
    end
end)
