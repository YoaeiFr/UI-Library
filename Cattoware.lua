local Library = { 
	Flags = { }, 
	Items = { } 
}

Library.Theme = {
    FontSize = 15,
    TitleSize = 20,
    Font = Enum.Font.Code,
    BackGround = "rbxassetid://5553946656",
    TileSize = 90,
    BackGroundColor = Color3.fromRGB(40, 20, 20),
    TabsTextColor = Color3.fromRGB(240, 240, 240),
    BorderColor = Color3.fromRGB(60, 60, 60),
    AccentColor = Color3.fromRGB(255, 0, 0),
    SecondAccentColor = Color3.fromRGB(16, 31, 78),
    OutlineColor = Color3.fromRGB(60, 60, 60),
    SecondOutlineColor = Color3.fromRGB(0, 0, 0),
    SectionColor = Color3.fromRGB(30, 30, 30),
    TopTextColor = Color3.fromRGB(255, 255, 255),
    TopHeight = 50,
    TopColor = Color3.fromRGB(30, 30, 30),
    SecondTopColor = Color3.fromRGB(30, 30, 30),
    ButtonColor = Color3.fromRGB(49, 49, 49),
    SecondButtonColor = Color3.fromRGB(39, 39, 39),
    ItemsColor = Color3.fromRGB(200, 200, 200),
    SecondItemsColor = Color3.fromRGB(210, 210, 210)
}

function Library:CreateWindow(Name, Size, HideButton)
    local Window = { }

    Window.Name = Name or ""
    Window.Size = UDim2.fromOffset(Size.X, Size.Y) or UDim2.fromOffset(492, 598)
    Window.HideButton = HideButton or Enum.KeyCode.RightShift
    Window.Theme = Library.Theme

    function Window:UpdateTheme(Theme)
        Instance.new("BindableEvent"):Fire(Theme or Library.Theme)
        Window.Theme = (Theme or Library.Theme)
    end

    Window.Main = Instance.new("ScreenGui", game:GetService("CoreGui"))
    Window.Main.Name = Name
    Window.Main.DisplayOrder = 15

    if getgenv().UILib then
        getgenv().UILib:Remove()
    end

    getgenv().UILib = Window.Main

    local Dragging, DragInput, DragStart, StartPos
    game:GetService("UserInputService").InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Window.Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    local DragStart = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = Window.Frame.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end

    local DragEnd = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end

    Window.Frame = Instance.new("TextButton", Window.Main)
    Window.Frame.Name = "Main"
    Window.Frame.Position = UDim2.fromScale(0.5, 0.5)
    Window.Frame.BorderSizePixel = 0
    Window.Frame.Size = Window.Size
    Window.Frame.AutoButtonColor = false
    Window.Frame.Text = ""
    Window.Frame.BackgroundColor3 = Window.Theme.BackGroundColor
    Window.Frame.AnchorPoint = Vector2.new(0.5, 0.5)

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.Frame.BackgroundColor3 = Theme.BackGroundColor
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(key)
        if key.KeyCode == Window.HideButton then
            Window.Frame.Visible = not Window.Frame.Visible
        end
    end)

    local function CheckIfGuyInFront(Pos)
        local Objects = game:GetService("CoreGui"):GetGuiObjectsAtPosition(Pos.X, Pos.Y)
        for i,v in pairs(Objects) do 
            if not string.find(v:GetFullName(), Window.Name) then 
                table.remove(Objects, i)
            end 
        end
        return (#Objects ~= 0 and Objects[1].AbsolutePosition ~= Pos)
    end

    Window.BlackOutline = Instance.new("Frame", Window.Frame)
    Window.BlackOutline.Name = "OutLine"
    Window.BlackOutline.ZIndex = 1
    Window.BlackOutline.Size = Window.Size + UDim2.fromOffset(2, 2)
    Window.BlackOutline.BorderSizePixel = 0
    Window.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
    Window.BlackOutline.Position = UDim2.fromOffset(-1, -1)

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
    end)

    Window.Outline = Instance.new("Frame", Window.Frame)
    Window.Outline.Name = "OutLine"
    Window.Outline.ZIndex = 0
    Window.Outline.Size = Window.Size + UDim2.fromOffset(4, 4)
    Window.Outline.BorderSizePixel = 0
    Window.Outline.BackgroundColor3 = Window.Theme.OutlineColor
    Window.Outline.Position = UDim2.fromOffset(-2, -2)

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.Outline.BackgroundColor3 = Theme.OutlineColor
    end)

    Window.BlackOutline2 = Instance.new("Frame", Window.Frame)
    Window.BlackOutline2.Name = "OutLine"
    Window.BlackOutline2.ZIndex = -1
    Window.BlackOutline2.Size = Window.Size + UDim2.fromOffset(6, 6)
    Window.BlackOutline2.BorderSizePixel = 0
    Window.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
    Window.BlackOutline2.Position = UDim2.fromOffset(-3, -3)

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
    end)

    Window.TopBar = Instance.new("Frame", Window.Frame)
    Window.TopBar.Name = "Top"
    Window.TopBar.Size = UDim2.fromOffset(Window.Size.X.Offset, Window.Theme.TopHeight)
    Window.TopBar.BorderSizePixel = 0
    Window.TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Window.TopBar.InputBegan:Connect(DragStart)
    Window.TopBar.InputChanged:Connect(DragEnd)

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.TopBar.Size = UDim2.fromOffset(Window.Size.X.Offset, Theme.TopHeight)
    end)

    Window.TopGradient = Instance.new("UIGradient", Window.TopBar)
    Window.TopGradient.Rotation = 90
    Window.TopGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Window.Theme.TopColor), ColorSequenceKeypoint.new(1.00, Window.Theme.SecondTopColor) })
    
    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.TopGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Theme.TopColor), ColorSequenceKeypoint.new(1.00, Theme.SecondTopColor) })
    end)

    Window.NameLabel = Instance.new("TextLabel", Window.TopBar)
    Window.NameLabel.TextColor3 = Window.Theme.TopTextColor
    Window.NameLabel.Text = Window.Name
    Window.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    Window.NameLabel.Font = Window.Theme.Font
    Window.NameLabel.Name = "Title"
    Window.NameLabel.Position = UDim2.fromOffset(4, -2)
    Window.NameLabel.BackgroundTransparency = 1
    Window.NameLabel.Size = UDim2.fromOffset(190, Window.TopBar.AbsoluteSize.Y / 2 - 2)
    Window.NameLabel.TextSize = Window.Theme.TitleSize

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.NameLabel.TextColor3 = Theme.TopTextColor
        Window.NameLabel.Font = Theme.Font
        Window.NameLabel.TextSize = Theme.TitleSize
    end)

    Window.Line2 = Instance.new("Frame", Window.TopBar)
    Window.Line2.Name = "Line"
    Window.Line2.Position = UDim2.fromOffset(0, Window.TopBar.AbsoluteSize.Y / 2.1)
    Window.Line2.Size = UDim2.fromOffset(Window.Size.X.Offset, 1)
    Window.Line2.BorderSizePixel = 0
    Window.Line2.BackgroundColor3 = Window.Theme.AccentColor

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.Line2.BackgroundColor3 = Theme.AccentColor
    end)

    Window.TabList = Instance.new("Frame", Window.TopBar)
    Window.TabList.Name = "TabList"
    Window.TabList.BackgroundTransparency = 1
    Window.TabList.Position = UDim2.fromOffset(0, Window.TopBar.AbsoluteSize.Y / 2 + 1)
    Window.TabList.Size = UDim2.fromOffset(Window.Size.X.Offset, Window.TopBar.AbsoluteSize.Y / 2)
    Window.TabList.BorderSizePixel = 0
    Window.TabList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    Window.TabList.InputBegan:Connect(DragStart)
    Window.TabList.InputChanged:Connect(DragEnd)

    Window.BlackLine = Instance.new("Frame", Window.Frame)
    Window.BlackLine.Name = "BlackLine"
    Window.BlackLine.Size = UDim2.fromOffset(Window.Size.X.Offset, 1)
    Window.BlackLine.BorderSizePixel = 0
    Window.BlackLine.ZIndex = 9
    Window.BlackLine.BackgroundColor3 = Window.Theme.SecondOutlineColor
    Window.BlackLine.Position = UDim2.fromOffset(0, Window.TopBar.AbsoluteSize.Y)

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.BlackLine.BackgroundColor3 = Theme.SecondOutlineColor
    end)

    Window.BackgroundImage = Instance.new("ImageLabel", Window.Frame)
    Window.BackgroundImage.Name = "BackGround"
    Window.BackgroundImage.BorderSizePixel = 0
    Window.BackgroundImage.ScaleType = Enum.ScaleType.Tile
    Window.BackgroundImage.Position = Window.BlackLine.Position + UDim2.fromOffset(0, 1)
    Window.BackgroundImage.Size = UDim2.fromOffset(Window.Size.X.Offset, Window.Size.Y.Offset - Window.TopBar.AbsoluteSize.Y - 1)
    Window.BackgroundImage.Image = Window.Theme.BackGround or ""
    Window.BackgroundImage.ImageTransparency = Window.BackgroundImage.Image ~= "" and 0 or 1
    Window.BackgroundImage.ImageColor3 = Color3.new() 
    Window.BackgroundImage.BackgroundColor3 = Window.Theme.BackGroundColor
    Window.BackgroundImage.TileSize = UDim2.new(0, Window.Theme.TileSize, 0, Window.Theme.TileSize)

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.BackgroundImage.Image = Theme.BackGround or ""
        Window.BackgroundImage.ImageTransparency = Window.BackgroundImage.Image ~= "" and 0 or 1
        Window.BackgroundImage.BackgroundColor3 = Theme.BackGroundColor
        Window.BackgroundImage.TileSize = UDim2.new(0, Theme.TileSize, 0, Theme.TileSize)
    end)

    Window.Line = Instance.new("Frame", Window.Frame)
    Window.Line.Name = "Line"
    Window.Line.Position = UDim2.fromOffset(0, 0)
    Window.Line.Size = UDim2.fromOffset(60, 1)
    Window.Line.BorderSizePixel = 0
    Window.Line.BackgroundColor3 = Window.Theme.AccentColor

    Instance.new("BindableEvent").Event:Connect(function(Theme)
        Window.Line.BackgroundColor3 = Theme.AccentColor
    end)

    Window.ListLayout = Instance.new("UIListLayout", Window.TabList)
    Window.ListLayout.FillDirection = Enum.FillDirection.Horizontal
    Window.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    Window.OpenedColorPickers = { }
    Window.Tabs = { }

    function Window:CreateTab(Name)
        local Tab = { }
        Tab.Name = Name or ""

        local Size = game:GetService("TextService"):GetTextSize(Tab.Name, Window.Theme.FontSize, Window.Theme.Font, Vector2.new(200,300))

        Tab.TabButton = Instance.new("TextButton", Window.TabList)
        Tab.TabButton.TextColor3 = Window.Theme.TabsTextColor
        Tab.TabButton.Text = Tab.Name
        Tab.TabButton.AutoButtonColor = false
        Tab.TabButton.Font = Window.Theme.Font
        Tab.TabButton.TextYAlignment = Enum.TextYAlignment.Center
        Tab.TabButton.BackgroundTransparency = 1
        Tab.TabButton.BorderSizePixel = 0
        Tab.TabButton.Size = UDim2.fromOffset(Size.X + 15, Window.TabList.AbsoluteSize.Y - 1)
        Tab.TabButton.Name = Tab.Name
        Tab.TabButton.TextSize = Window.Theme.FontSize
        
        Instance.new("BindableEvent").Event:Connect(function(Theme)
            local Size = game:GetService("TextService"):GetTextSize(Tab.Name, Theme.FontSize, Theme.Font, Vector2.new(200,300))
            Tab.TabButton.TextColor3 = Tab.TabButton.Name == "SelectedTab" and Theme.AccentColor or Theme.TabsTextColor
            Tab.TabButton.Font = Theme.Font
            Tab.TabButton.Size = UDim2.fromOffset(Size.X + 15, Window.TabList.AbsoluteSize.Y - 1)
            Tab.TabButton.TextSize = Theme.FontSize
        end)

        Tab.Left = Instance.new("ScrollingFrame", Window.Frame) 
        Tab.Left.Name = "leftside"
        Tab.Left.BorderSizePixel = 0
        Tab.Left.Size = UDim2.fromOffset(Window.Size.X.Offset / 2, Window.Size.Y.Offset - (Window.TopBar.AbsoluteSize.Y + 1))
        Tab.Left.BackgroundTransparency = 1
        Tab.Left.Visible = false
        Tab.Left.ScrollBarThickness = 0
        Tab.Left.ScrollingDirection = "Y"
        Tab.Left.Position = Window.BlackLine.Position + UDim2.fromOffset(0, 1)

        Tab.LeftListLayout = Instance.new("UIListLayout", Tab.Left)
        Tab.LeftListLayout.FillDirection = Enum.FillDirection.Vertical
        Tab.LeftListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        Tab.LeftListLayout.Padding = UDim.new(0, 12)

        Tab.LeftListPadding = Instance.new("UIPadding", Tab.Left)
        Tab.LeftListPadding.PaddingTop = UDim.new(0, 12)
        Tab.LeftListPadding.PaddingLeft = UDim.new(0, 12)
        Tab.LeftListPadding.PaddingRight = UDim.new(0, 12)

        Tab.Right = Instance.new("ScrollingFrame", Window.Frame) 
        Tab.Right.Name = "rightside"
        Tab.Right.ScrollBarThickness = 0
        Tab.Right.ScrollingDirection = "Y"
        Tab.Right.Visible = false
        Tab.Right.BorderSizePixel = 0
        Tab.Right.Size = UDim2.fromOffset(Window.Size.X.Offset / 2, Window.Size.Y.Offset - (Window.TopBar.AbsoluteSize.Y + 1))
        Tab.Right.BackgroundTransparency = 1
        Tab.Right.Position = Tab.Left.Position + UDim2.fromOffset(Tab.Left.AbsoluteSize.X, 0)

        Tab.RightListLayout = Instance.new("UIListLayout", Tab.Right)
        Tab.RightListLayout.FillDirection = Enum.FillDirection.Vertical
        Tab.RightListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        Tab.RightListLayout.Padding = UDim.new(0, 12)

        Tab.RightListPadding = Instance.new("UIPadding", Tab.Right)
        Tab.RightListPadding.PaddingTop = UDim.new(0, 12)
        Tab.RightListPadding.PaddingLeft = UDim.new(0, 6)
        Tab.RightListPadding.PaddingRight = UDim.new(0, 12)

        local block = false
        function Tab:SelectTab()
            repeat 
                wait()
            until block == false

            block = true
            for i,v in pairs(Window.Tabs) do
                if v ~= Tab then
                    v.TabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                    v.TabButton.Name = "Tab"
                    v.Left.Visible = false
                    v.Right.Visible = false
                end
            end

            Tab.TabButton.TextColor3 = Window.Theme.AccentColor
            Tab.TabButton.Name = "SelectedTab"
            Tab.Right.Visible = true
            Tab.Left.Visible = true
            Window.Line:TweenSizeAndPosition(UDim2.fromOffset(Size.X + 15, 1), UDim2.new(0, (Tab.TabButton.AbsolutePosition.X - Window.Frame.AbsolutePosition.X), 0, 0) + (Window.BlackLine.Position - UDim2.fromOffset(0, 1)), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15)
            wait(0.2)
            block = false
        end
    
        if #Window.Tabs == 0 then
            Tab:SelectTab()
        end

        Tab.TabButton.MouseButton1Down:Connect(function()
            Tab:SelectTab()
        end)

        Tab.SectorsLeft = { }
        Tab.SectorsRight = { }

        function Tab:CreateSector(Name,side)
            local sector = { }
            sector.Name = Name or ""
            sector.side = side:lower() or "left"
            
            sector.Main = Instance.new("Frame", sector.side == "left" and Tab.Left or Tab.Right) 
            sector.Main.Name = sector.Name:gsub(" ", "") .. "Sector"
            sector.Main.BorderSizePixel = 0
            sector.Main.ZIndex = 4
            sector.Main.Size = UDim2.fromOffset(Window.Size.X.Offset / 2 - 17, 20)
            sector.Main.BackgroundColor3 = Window.Theme.SectionColor
            Instance.new("BindableEvent").Event:Connect(function(Theme)
                sector.Main.BackgroundColor3 = Theme.SectionColor
            end)

            sector.Line = Instance.new("Frame", sector.Main)
            sector.Line.Name = "Line"
            sector.Line.ZIndex = 4
            sector.Line.Size = UDim2.fromOffset(sector.Main.Size.X.Offset + 4, 1)
            sector.Line.BorderSizePixel = 0
            sector.Line.Position = UDim2.fromOffset(-2, -2)
            sector.Line.BackgroundColor3 = Window.Theme.AccentColor
            Instance.new("BindableEvent").Event:Connect(function(Theme)
                sector.Line.BackgroundColor3 = Theme.AccentColor
            end)

            sector.BlackOutline = Instance.new("Frame", sector.Main)
            sector.BlackOutline.Name = "OutLine"
            sector.BlackOutline.ZIndex = 3
            sector.BlackOutline.Size = sector.Main.Size + UDim2.fromOffset(2, 2)
            sector.BlackOutline.BorderSizePixel = 0
            sector.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
            sector.BlackOutline.Position = UDim2.fromOffset(-1, -1)
            sector.Main:GetPropertyChangedSignal("Size"):Connect(function()
                sector.BlackOutline.Size = sector.Main.Size + UDim2.fromOffset(2, 2)
            end)
            Instance.new("BindableEvent").Event:Connect(function(Theme)
                sector.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
            end)


            sector.Outline = Instance.new("Frame", sector.Main)
            sector.Outline.Name = "OutLine"
            sector.Outline.ZIndex = 2
            sector.Outline.Size = sector.Main.Size + UDim2.fromOffset(4, 4)
            sector.Outline.BorderSizePixel = 0
            sector.Outline.BackgroundColor3 = Window.Theme.OutlineColor
            sector.Outline.Position = UDim2.fromOffset(-2, -2)
            sector.Main:GetPropertyChangedSignal("Size"):Connect(function()
                sector.Outline.Size = sector.Main.Size + UDim2.fromOffset(4, 4)
            end)
            Instance.new("BindableEvent").Event:Connect(function(Theme)
                sector.Outline.BackgroundColor3 = Theme.OutlineColor
            end)

            sector.BlackOutline2 = Instance.new("Frame", sector.Main)
            sector.BlackOutline2.Name = "OutLine"
            sector.BlackOutline2.ZIndex = 1
            sector.BlackOutline2.Size = sector.Main.Size + UDim2.fromOffset(6, 6)
            sector.BlackOutline2.BorderSizePixel = 0
            sector.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
            sector.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
            sector.Main:GetPropertyChangedSignal("Size"):Connect(function()
                sector.BlackOutline2.Size = sector.Main.Size + UDim2.fromOffset(6, 6)
            end)
            Instance.new("BindableEvent").Event:Connect(function(Theme)
                sector.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
            end)

            local Size = game:GetService("TextService"):GetTextSize(sector.Name, 15, Window.Theme.Font, Vector2.new(2000, 2000))
            sector.Label = Instance.new("TextLabel", sector.Main)
            sector.Label.AnchorPoint = Vector2.new(0,0.5)
            sector.Label.Position = UDim2.fromOffset(12, -1)
            sector.Label.Size = UDim2.fromOffset(math.clamp(game:GetService("TextService"):GetTextSize(sector.Name, 15, Window.Theme.Font, Vector2.new(200,300)).X + 13, 0, sector.Main.Size.X.Offset), Size.Y)
            sector.Label.BackgroundTransparency = 1
            sector.Label.BorderSizePixel = 0
            sector.Label.ZIndex = 6
            sector.Label.Text = sector.Name
            sector.Label.TextColor3 = Color3.new(1,1,2552/255)
            sector.Label.TextStrokeTransparency = 1
            sector.Label.Font = Window.Theme.Font
            sector.Label.TextSize = 15
            Instance.new("BindableEvent").Event:Connect(function(Theme)
                local Size = game:GetService("TextService"):GetTextSize(sector.Name, 15, Theme.Font, Vector2.new(2000, 2000))
                sector.Label.Size = UDim2.fromOffset(math.clamp(game:GetService("TextService"):GetTextSize(sector.Name, 15, Theme.Font, Vector2.new(200,300)).X + 13, 0, sector.Main.Size.X.Offset), Size.Y)
                sector.Label.Font = Theme.Font
            end)

            sector.LabelBackFrame = Instance.new("Frame", sector.Main)
            sector.LabelBackFrame.Name = "labelframe"
            sector.LabelBackFrame.ZIndex = 5
            sector.LabelBackFrame.Size = UDim2.fromOffset(sector.Label.Size.X.Offset, 10)
            sector.LabelBackFrame.BorderSizePixel = 0
            sector.LabelBackFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            sector.LabelBackFrame.Position = UDim2.fromOffset(sector.Label.Position.X.Offset, sector.BlackOutline2.Position.Y.Offset)

            sector.Items = Instance.new("Frame", sector.Main) 
            sector.Items.Name = "Items"
            sector.Items.ZIndex = 2
            sector.Items.BackgroundTransparency = 1
            sector.Items.Size = UDim2.fromOffset(170, 140)
            sector.Items.AutomaticSize = Enum.AutomaticSize.Y
            sector.Items.BorderSizePixel = 0

            sector.ListLayout = Instance.new("UIListLayout", sector.Items)
            sector.ListLayout.FillDirection = Enum.FillDirection.Vertical
            sector.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sector.ListLayout.Padding = UDim.new(0, 12)

            sector.ListPadding = Instance.new("UIPadding", sector.Items)
            sector.ListPadding.PaddingTop = UDim.new(0, 15)
            sector.ListPadding.PaddingLeft = UDim.new(0, 6)
            sector.ListPadding.PaddingRight = UDim.new(0, 6)

            table.insert(sector.side:lower() == "left" and Tab.SectorsLeft or Tab.SectorsRight, sector)

            function sector:FixSize()
                sector.Main.Size = UDim2.fromOffset(Window.Size.X.Offset / 2 - 17, sector.ListLayout.AbsoluteContentSize.Y + 22)
                local sizeleft, sizeright = 0, 0
                for i,v in pairs(Tab.SectorsLeft) do
                    sizeleft = sizeleft + v.Main.AbsoluteSize.Y
                end
                for i,v in pairs(Tab.SectorsRight) do
                    sizeright = sizeright + v.Main.AbsoluteSize.Y
                end

                Tab.Left.CanvasSize = UDim2.fromOffset(Tab.Left.AbsoluteSize.X, sizeleft + ((#Tab.SectorsLeft - 1) * Tab.LeftListPadding.PaddingTop.Offset) + 20)
                Tab.Right.CanvasSize = UDim2.fromOffset(Tab.Right.AbsoluteSize.X, sizeright + ((#Tab.SectorsRight - 1) * Tab.RightListPadding.PaddingTop.Offset) + 20)
            end

            function sector:AddButton(text, callback)
                local button = { }
                button.text = text or ""
                button.callback = callback or function() end

                button.Main = Instance.new("TextButton", sector.Items)
                button.Main.BorderSizePixel = 0
                button.Main.Text = ""
                button.Main.AutoButtonColor = false
                button.Main.Name = "button"
                button.Main.ZIndex = 5
                button.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 14)
                button.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                button.Gradient = Instance.new("UIGradient", button.Main)
                button.Gradient.Rotation = 90
                button.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Window.Theme.ButtonColor), ColorSequenceKeypoint.new(1.00, Window.Theme.SecondButtonColor) })
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    button.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Theme.ButtonColor), ColorSequenceKeypoint.new(1.00, Theme.SecondButtonColor) })
                end)

                button.BlackOutline2 = Instance.new("Frame", button.Main)
                button.BlackOutline2.Name = "BlackLine"
                button.BlackOutline2.ZIndex = 4
                button.BlackOutline2.Size = button.Main.Size + UDim2.fromOffset(6, 6)
                button.BlackOutline2.BorderSizePixel = 0
                button.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                button.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    button.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                button.Outline = Instance.new("Frame", button.Main)
                button.Outline.Name = "BlackLine"
                button.Outline.ZIndex = 4
                button.Outline.Size = button.Main.Size + UDim2.fromOffset(4, 4)
                button.Outline.BorderSizePixel = 0
                button.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                button.Outline.Position = UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    button.Outline.BackgroundColor3 = Theme.OutlineColor
                end)

                button.BlackOutline = Instance.new("Frame", button.Main)
                button.BlackOutline.Name = "BlackLine"
                button.BlackOutline.ZIndex = 4
                button.BlackOutline.Size = button.Main.Size + UDim2.fromOffset(2, 2)
                button.BlackOutline.BorderSizePixel = 0
                button.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                button.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    button.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                button.Label = Instance.new("TextLabel", button.Main)
                button.Label.Name = "Label"
                button.Label.BackgroundTransparency = 1
                button.Label.Position = UDim2.new(0, -1, 0, 0)
                button.Label.ZIndex = 5
                button.Label.Size = button.Main.Size
                button.Label.Font = Window.Theme.Font
                button.Label.Text = button.text
                button.Label.TextColor3 = Window.Theme.SecondItemsColor
                button.Label.TextSize = 15
                button.Label.TextStrokeTransparency = 1
                button.Label.TextXAlignment = Enum.TextXAlignment.Center
                button.Main.MouseButton1Down:Connect(button.callback)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    button.Label.Font = Theme.Font
                    button.Label.TextColor3 = Theme.ItemsColor
                end)

                button.BlackOutline2.MouseEnter:Connect(function()
                    button.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                end)

                button.BlackOutline2.MouseLeave:Connect(function()
                    button.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                end)

                sector:FixSize()
                return button
            end

            function sector:AddLabel(text)
                local label = { }

                label.Main = Instance.new("TextLabel", sector.Items)
                label.Main.Name = "Label"
                label.Main.BackgroundTransparency = 1
                label.Main.Position = UDim2.new(0, -1, 0, 0)
                label.Main.ZIndex = 4
                label.Main.AutomaticSize = Enum.AutomaticSize.XY
                label.Main.Font = Window.Theme.Font
                label.Main.Text = text
                label.Main.TextColor3 = Window.Theme.ItemsColor
                label.Main.TextSize = 15
                label.Main.TextStrokeTransparency = 1
                label.Main.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    label.Main.Font = Theme.Font
                    label.Main.TextColor3 = Theme.ItemsColor
                end)

                function label:Set(value)
                    label.Main.Text = value
                end

                sector:FixSize()
                return label
            end
            
            function sector:AddToggle(text, default, callback, flag)
                local toggle = { }
                toggle.text = text or ""
                toggle.default = default or false
                toggle.callback = callback or function(value) end
                toggle.flag = flag or text or ""
                
                toggle.value = toggle.default

                toggle.Main = Instance.new("TextButton", sector.Items)
                toggle.Main.Name = "toggle"
                toggle.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggle.Main.BorderColor3 = Window.Theme.OutlineColor
                toggle.Main.BorderSizePixel = 0
                toggle.Main.Size = UDim2.fromOffset(8, 8)
                toggle.Main.AutoButtonColor = false
                toggle.Main.ZIndex = 5
                toggle.Main.Font = Enum.Font.SourceSans
                toggle.Main.Text = ""
                toggle.Main.TextColor3 = Color3.fromRGB(0, 0, 0)
                toggle.Main.TextSize = 15
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    toggle.Main.BorderColor3 = Theme.OutlineColor
                end)

                toggle.BlackOutline2 = Instance.new("Frame", toggle.Main)
                toggle.BlackOutline2.Name = "BlackLine"
                toggle.BlackOutline2.ZIndex = 4
                toggle.BlackOutline2.Size = toggle.Main.Size + UDim2.fromOffset(6, 6)
                toggle.BlackOutline2.BorderSizePixel = 0
                toggle.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                toggle.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    toggle.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                end)
                
                toggle.Outline = Instance.new("Frame", toggle.Main)
                toggle.Outline.Name = "BlackLine"
                toggle.Outline.ZIndex = 4
                toggle.Outline.Size = toggle.Main.Size + UDim2.fromOffset(4, 4)
                toggle.Outline.BorderSizePixel = 0
                toggle.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                toggle.Outline.Position = UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    toggle.Outline.BackgroundColor3 = Theme.OutlineColor
                end)

                toggle.BlackOutline = Instance.new("Frame", toggle.Main)
                toggle.BlackOutline.Name = "BlackLine"
                toggle.BlackOutline.ZIndex = 4
                toggle.BlackOutline.Size = toggle.Main.Size + UDim2.fromOffset(2, 2)
                toggle.BlackOutline.BorderSizePixel = 0
                toggle.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                toggle.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    toggle.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                toggle.Gradient = Instance.new("UIGradient", toggle.Main)
                toggle.Gradient.Rotation = (22.5 * 13)
                toggle.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 30)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(45, 45, 45)) })

                toggle.Label = Instance.new("TextButton", toggle.Main)
                toggle.Label.Name = "Label"
                toggle.Label.AutoButtonColor = false
                toggle.Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggle.Label.BackgroundTransparency = 1
                toggle.Label.Position = UDim2.fromOffset(toggle.Main.AbsoluteSize.X + 10, -2)
                toggle.Label.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 71, toggle.BlackOutline.Size.Y.Offset)
                toggle.Label.Font = Window.Theme.Font
                toggle.Label.ZIndex = 5
                toggle.Label.Text = toggle.text
                toggle.Label.TextColor3 = Window.Theme.ItemsColor
                toggle.Label.TextSize = 15
                toggle.Label.TextStrokeTransparency = 1
                toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    toggle.Label.Font = Theme.Font
                    toggle.Label.TextColor3 = toggle.value and Window.Theme.SecondItemsColor or Theme.ItemsColor
                end)

                toggle.CheckedFrame = Instance.new("Frame", toggle.Main)
                toggle.CheckedFrame.ZIndex = 5
                toggle.CheckedFrame.BorderSizePixel = 0
                toggle.CheckedFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Color3.fromRGB(204, 0, 102)
                toggle.CheckedFrame.Size = toggle.Main.Size

                toggle.Gradient2 = Instance.new("UIGradient", toggle.CheckedFrame)
                toggle.Gradient2.Rotation = (22.5 * 13)
                toggle.Gradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Window.Theme.SecondAccentColor), ColorSequenceKeypoint.new(1.00, Window.Theme.AccentColor) })
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    toggle.Gradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Theme.SecondAccentColor), ColorSequenceKeypoint.new(1.00, Theme.AccentColor) })
                end)

                toggle.Items = Instance.new("Frame", toggle.Main)
                toggle.Items.Name = "\n"
                toggle.Items.ZIndex = 4
                toggle.Items.Size = UDim2.fromOffset(60, toggle.BlackOutline.AbsoluteSize.Y)
                toggle.Items.BorderSizePixel = 0
                toggle.Items.BackgroundTransparency = 1
                toggle.Items.BackgroundColor3 = Color3.new(0, 0, 0)
                toggle.Items.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 71, 0)

                toggle.ListLayout = Instance.new("UIListLayout", toggle.Items)
                toggle.ListLayout.FillDirection = Enum.FillDirection.Horizontal
                toggle.ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                toggle.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                toggle.ListLayout.Padding = UDim.new(0.04, 6)

                if toggle.flag and toggle.flag ~= "" then
                    Library.Flags[toggle.flag] = toggle.default or false
                end

                function toggle:Set(value) 
                    if value then
                        toggle.Label.TextColor3 = Window.Theme.SecondItemsColor
                    else
                        toggle.Label.TextColor3 = Window.Theme.ItemsColor
                    end

                    toggle.value = value
                    toggle.CheckedFrame.Visible = value
                    if toggle.flag and toggle.flag ~= "" then
                        Library.Flags[toggle.flag] = toggle.value
                    end
                    pcall(toggle.callback, value)
                end
                function toggle:Get() 
                    return toggle.value
                end
                toggle:Set(toggle.default)

                function toggle:AddKeybind(default, flag)
                    local keybind = { }

                    keybind.default = default or "None"
                    keybind.value = keybind.default
                    keybind.flag = flag or ( (toggle.text or "") .. tostring(#toggle.Items:GetChildren()))

                    local shorter_keycodes = {
                        ["LeftShift"] = "LSHIFT",
                        ["RightShift"] = "RSHIFT",
                        ["LeftControl"] = "LCTRL",
                        ["RightControl"] = "RCTRL",
                        ["LeftAlt"] = "LALT",
                        ["RightAlt"] = "RALT"
                    }

                    local text = keybind.default == "None" and "[None]" or "[" .. (shorter_keycodes[keybind.default.Name] or keybind.default.Name) .. "]"
                    local Size = game:GetService("TextService"):GetTextSize(text, 15, Window.Theme.Font, Vector2.new(2000, 2000))

                    keybind.Main = Instance.new("TextButton", toggle.Items)
                    keybind.Main.Name = "keybind"
                    keybind.Main.BackgroundTransparency = 1
                    keybind.Main.BorderSizePixel = 0
                    keybind.Main.ZIndex = 5
                    keybind.Main.Size = UDim2.fromOffset(Size.X + 2, Size.Y - 7)
                    keybind.Main.Text = text
                    keybind.Main.Font = Window.Theme.Font
                    keybind.Main.TextColor3 = Color3.fromRGB(136, 136, 136)
                    keybind.Main.TextSize = 15
                    keybind.Main.TextXAlignment = Enum.TextXAlignment.Right
                    keybind.Main.MouseButton1Down:Connect(function()
                        keybind.Main.Text = "[...]"
                        keybind.Main.TextColor3 = Window.Theme.AccentColor
                    end)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        keybind.Main.Font = Theme.Font
                        if keybind.Main.Text == "[...]" then
                            keybind.Main.TextColor3 = Theme.AccentColor
                        else
                            keybind.Main.TextColor3 = Color3.fromRGB(136, 136, 136)
                        end
                    end)

                    if keybind.flag and keybind.flag ~= "" then
                        Library.Flags[keybind.flag] = keybind.default
                    end
                    function keybind:Set(key)
                        if key == "None" then
                            keybind.Main.Text = "[" .. key .. "]"
                            keybind.value = key
                            if keybind.flag and keybind.flag ~= "" then
                                Library.Flags[keybind.flag] = key
                            end
                        end
                        keybind.Main.Text = "[" .. (shorter_keycodes[key.Name] or key.Name) .. "]"
                        keybind.value = key
                        if keybind.flag and keybind.flag ~= "" then
                            Library.Flags[keybind.flag] = keybind.value
                        end
                    end

                    function keybind:Get()
                        return keybind.value
                    end

                    game:GetService("UserInputService").InputBegan:Connect(function(Input, gameProcessed)
                        if not gameProcessed then
                            if keybind.Main.Text == "[...]" then
                                keybind.Main.TextColor3 = Color3.fromRGB(136, 136, 136)
                                if Input.UserInputType == Enum.UserInputType.Keyboard then
                                    keybind:Set(Input.KeyCode)
                                else
                                    keybind:Set("None")
                                end
                            else
                                if keybind.value ~= "None" and Input.KeyCode == keybind.value then
                                    toggle:Set(not toggle.CheckedFrame.Visible)
                                end
                            end
                        end
                    end)

                    table.insert(Library.Items, keybind)
                    return keybind
                end

                function toggle:AddDropdown(Items, default, multichoice, callback, flag)
                    local dropdown = { }

                    dropdown.defaultitems = Items or { }
                    dropdown.default = default
                    dropdown.callback = callback or function() end
                    dropdown.multichoice = multichoice or false
                    dropdown.values = { }
                    dropdown.flag = flag or ( (toggle.text or "") .. tostring(#(sector.Items:GetChildren())) .. "a")
    
                    dropdown.Main = Instance.new("TextButton", sector.Items)
                    dropdown.Main.Name = "dropdown"
                    dropdown.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.Main.BorderSizePixel = 0
                    dropdown.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 16)
                    dropdown.Main.Position = UDim2.fromOffset(0, 0)
                    dropdown.Main.ZIndex = 5
                    dropdown.Main.AutoButtonColor = false
                    dropdown.Main.Font = Window.Theme.Font
                    dropdown.Main.Text = ""
                    dropdown.Main.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.Main.TextSize = 15
                    dropdown.Main.TextXAlignment = Enum.TextXAlignment.Left
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.Main.Font = Theme.Font
                    end)
    
                    dropdown.Gradient = Instance.new("UIGradient", dropdown.Main)
                    dropdown.Gradient.Rotation = 90
                    dropdown.Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(49, 49, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))}
    
                    dropdown.SelectedLabel = Instance.new("TextLabel", dropdown.Main)
                    dropdown.SelectedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.SelectedLabel.BackgroundTransparency = 1
                    dropdown.SelectedLabel.Position = UDim2.fromOffset(5, 2)
                    dropdown.SelectedLabel.Size = UDim2.fromOffset(130, 13)
                    dropdown.SelectedLabel.Font = Window.Theme.Font
                    dropdown.SelectedLabel.Text = toggle.text
                    dropdown.SelectedLabel.ZIndex = 5
                    dropdown.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.SelectedLabel.TextSize = 15
                    dropdown.SelectedLabel.TextStrokeTransparency = 1
                    dropdown.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.SelectedLabel.Font = Theme.Font
                    end)  

                    dropdown.Nav = Instance.new("ImageButton", dropdown.Main)
                    dropdown.Nav.Name = "navigation"
                    dropdown.Nav.BackgroundTransparency = 1
                    dropdown.Nav.LayoutOrder = 10
                    dropdown.Nav.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 26, 5)
                    dropdown.Nav.Rotation = 90
                    dropdown.Nav.ZIndex = 5
                    dropdown.Nav.Size = UDim2.fromOffset(8, 8)
                    dropdown.Nav.Image = "rbxassetid://4918373417"
                    dropdown.Nav.ImageColor3 = Color3.fromRGB(210, 210, 210)
    
                    dropdown.BlackOutline2 = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutline2.Name = "BlackLine"
                    dropdown.BlackOutline2.ZIndex = 4
                    dropdown.BlackOutline2.Size = dropdown.Main.Size + UDim2.fromOffset(6, 6)
                    dropdown.BlackOutline2.BorderSizePixel = 0
                    dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    dropdown.Outline = Instance.new("Frame", dropdown.Main)
                    dropdown.Outline.Name = "BlackLine"
                    dropdown.Outline.ZIndex = 4
                    dropdown.Outline.Size = dropdown.Main.Size + UDim2.fromOffset(4, 4)
                    dropdown.Outline.BorderSizePixel = 0
                    dropdown.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                    dropdown.Outline.Position = UDim2.fromOffset(-2, -2)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.Outline.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    dropdown.BlackOutline = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutline.Name = "blackline444"
                    dropdown.BlackOutline.ZIndex = 4
                    dropdown.BlackOutline.Size = dropdown.Main.Size + UDim2.fromOffset(2, 2)
                    dropdown.BlackOutline.BorderSizePixel = 0
                    dropdown.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    dropdown.ItemsFrame = Instance.new("ScrollingFrame", dropdown.Main)
                    dropdown.ItemsFrame.Name = "itemsframe"
                    dropdown.ItemsFrame.BorderSizePixel = 0
                    dropdown.ItemsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    dropdown.ItemsFrame.Position = UDim2.fromOffset(0, dropdown.Main.Size.Y.Offset + 8)
                    dropdown.ItemsFrame.ScrollBarThickness = 2
                    dropdown.ItemsFrame.ZIndex = 8
                    dropdown.ItemsFrame.ScrollingDirection = "Y"
                    dropdown.ItemsFrame.Visible = false
                    dropdown.ItemsFrame.Size = UDim2.new(0, 0, 0, 0)
                    dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.Main.AbsoluteSize.X, 0)
    
                    dropdown.ListLayout = Instance.new("UIListLayout", dropdown.ItemsFrame)
                    dropdown.ListLayout.FillDirection = Enum.FillDirection.Vertical
                    dropdown.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
                    dropdown.ListPadding = Instance.new("UIPadding", dropdown.ItemsFrame)
                    dropdown.ListPadding.PaddingTop = UDim.new(0, 2)
                    dropdown.ListPadding.PaddingBottom = UDim.new(0, 2)
                    dropdown.ListPadding.PaddingLeft = UDim.new(0, 2)
                    dropdown.ListPadding.PaddingRight = UDim.new(0, 2)
    
                    dropdown.BlackOutline2Items = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutline2Items.Name = "blackline3"
                    dropdown.BlackOutline2Items.ZIndex = 7
                    dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                    dropdown.BlackOutline2Items.BorderSizePixel = 0
                    dropdown.BlackOutline2Items.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutline2Items.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-3, -3)
                    dropdown.BlackOutline2Items.Visible = false
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutline2Items.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
                    
                    dropdown.OutlineItems = Instance.new("Frame", dropdown.Main)
                    dropdown.OutlineItems.Name = "blackline8"
                    dropdown.OutlineItems.ZIndex = 7
                    dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                    dropdown.OutlineItems.BorderSizePixel = 0
                    dropdown.OutlineItems.BackgroundColor3 = Window.Theme.OutlineColor
                    dropdown.OutlineItems.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-2, -2)
                    dropdown.OutlineItems.Visible = false
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.OutlineItems.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    dropdown.BlackOutlineItems = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutlineItems.Name = "blackline3"
                    dropdown.BlackOutlineItems.ZIndex = 7
                    dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(-2, -2)
                    dropdown.BlackOutlineItems.BorderSizePixel = 0
                    dropdown.BlackOutlineItems.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutlineItems.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-1, -1)
                    dropdown.BlackOutlineItems.Visible = false
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutlineItems.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    dropdown.IgnoreBackButtons = Instance.new("TextButton", dropdown.Main)
                    dropdown.IgnoreBackButtons.BackgroundTransparency = 1
                    dropdown.IgnoreBackButtons.BorderSizePixel = 0
                    dropdown.IgnoreBackButtons.Position = UDim2.fromOffset(0, dropdown.Main.Size.Y.Offset + 8)
                    dropdown.IgnoreBackButtons.Size = UDim2.new(0, 0, 0, 0)
                    dropdown.IgnoreBackButtons.ZIndex = 7
                    dropdown.IgnoreBackButtons.Text = ""
                    dropdown.IgnoreBackButtons.Visible = false
                    dropdown.IgnoreBackButtons.AutoButtonColor = false

                    if dropdown.flag and dropdown.flag ~= "" then
                        Library.Flags[dropdown.flag] = dropdown.multichoice and { dropdown.default or dropdown.defaultitems[1] or "" } or (dropdown.default or dropdown.defaultitems[1] or "")
                    end

                    function dropdown:isSelected(item)
                        for i, v in pairs(dropdown.values) do
                            if v == item then
                                return true
                            end
                        end
                        return false
                    end
    
                    function dropdown:updateText(text)
                        if #text >= 27 then
                            text = text:sub(1, 25) .. ".."
                        end
                        dropdown.SelectedLabel.Text = text
                    end
    
                    dropdown.Changed = Instance.new("BindableEvent")
                    function dropdown:Set(value)
                        if type(value) == "table" then
                            dropdown.values = value
                            dropdown:updateText(table.concat(value, ", "))
                            pcall(dropdown.callback, value)
                        else
                            dropdown:updateText(value)
                            dropdown.values = { value }
                            pcall(dropdown.callback, value)
                        end
                        
                        dropdown.Changed:Fire(value)
                        if dropdown.flag and dropdown.flag ~= "" then
                            Library.Flags[dropdown.flag] = dropdown.multichoice and dropdown.values or dropdown.values[1]
                        end
                    end
    
                    function dropdown:Get()
                        return dropdown.multichoice and dropdown.values or dropdown.values[1]
                    end
    
                    dropdown.Items = { }
                    function dropdown:Add(v)
                        local Item = Instance.new("TextButton", dropdown.ItemsFrame)
                        Item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Item.BorderSizePixel = 0
                        Item.Position = UDim2.fromOffset(0, 0)
                        Item.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset - 4, 20)
                        Item.ZIndex = 9
                        Item.Text = v
                        Item.Name = v
                        Item.AutoButtonColor = false
                        Item.Font = Window.Theme.Font
                        Item.TextSize = 15
                        Item.TextXAlignment = Enum.TextXAlignment.Left
                        Item.TextStrokeTransparency = 1
                        dropdown.ItemsFrame.CanvasSize = dropdown.ItemsFrame.CanvasSize + UDim2.fromOffset(0, Item.AbsoluteSize.Y)
    
                        Item.MouseButton1Down:Connect(function()
                            if dropdown.multichoice then
                                if dropdown:isSelected(v) then
                                    for i2, v2 in pairs(dropdown.values) do
                                        if v2 == v then
                                            table.remove(dropdown.values, i2)
                                        end
                                    end
                                    dropdown:Set(dropdown.values)
                                else
                                    table.insert(dropdown.values, v)
                                    dropdown:Set(dropdown.values)
                                end
    
                                return
                            else
                                dropdown.Nav.Rotation = 90
                                dropdown.ItemsFrame.Visible = false
                                dropdown.ItemsFrame.Active = false
                                dropdown.OutlineItems.Visible = false
                                dropdown.BlackOutlineItems.Visible = false
                                dropdown.BlackOutline2Items.Visible = false
                                dropdown.IgnoreBackButtons.Visible = false
                                dropdown.IgnoreBackButtons.Active = false
                            end
    
                            dropdown:Set(v)
                            return
                        end)
    
                        game:GetService("RunService").RenderStepped:Connect(function()
                            if dropdown.multichoice and dropdown:isSelected(v) or dropdown.values[1] == v then
                                Item.BackgroundColor3 = Color3.fromRGB(64, 64, 64)
                                Item.TextColor3 = Window.Theme.AccentColor
                                Item.Text = " " .. v
                            else
                                Item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                                Item.Text = v
                            end
                        end)
    
                        table.insert(dropdown.Items, v)
                        dropdown.ItemsFrame.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset, math.clamp(#dropdown.Items * Item.AbsoluteSize.Y, 20, 156) + 4)
                        dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.ItemsFrame.AbsoluteSize.X, (#dropdown.Items * Item.AbsoluteSize.Y) + 4)
    
                        dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                        dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(2, 2)
                        dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                        dropdown.IgnoreBackButtons.Size = dropdown.ItemsFrame.Size
                    end
    
                    function dropdown:Remove(value)
                        local item = dropdown.ItemsFrame:FindFirstChild(value)
                        if item then
                            for i,v in pairs(dropdown.Items) do
                                if v == value then
                                    table.remove(dropdown.Items, i)
                                end
                            end
    
                            dropdown.ItemsFrame.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset, math.clamp(#dropdown.Items * item.AbsoluteSize.Y, 20, 156) + 4)
                            dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.ItemsFrame.AbsoluteSize.X, (#dropdown.Items * item.AbsoluteSize.Y) + 4)
        
                            dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(2, 2)
                            dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                            dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                            dropdown.IgnoreBackButtons.Size = dropdown.ItemsFrame.Size
    
                            item:Remove()
                        end
                    end 
    
                    for i,v in pairs(dropdown.defaultitems) do
                        dropdown:Add(v)
                    end
    
                    if dropdown.default then
                        dropdown:Set(dropdown.default)
                    end
    
                    local MouseButton1Down = function()
                        if dropdown.Nav.Rotation == 90 then
                            game:GetService("TweenService"):Create(dropdown.Nav, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { Rotation = -90 }):Play()
                            if dropdown.Items and #dropdown.Items ~= 0 then
                                dropdown.ItemsFrame.ScrollingEnabled = true
                                sector.Main.Parent.ScrollingEnabled = false
                                dropdown.ItemsFrame.Visible = true
                                dropdown.ItemsFrame.Active = true
                                dropdown.IgnoreBackButtons.Visible = true
                                dropdown.IgnoreBackButtons.Active = true
                                dropdown.OutlineItems.Visible = true
                                dropdown.BlackOutlineItems.Visible = true
                                dropdown.BlackOutline2Items.Visible = true
                            end
                        else
                            game:GetService("TweenService"):Create(dropdown.Nav, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { Rotation = 90 }):Play()
                            dropdown.ItemsFrame.ScrollingEnabled = false
                            sector.Main.Parent.ScrollingEnabled = true
                            dropdown.ItemsFrame.Visible = false
                            dropdown.ItemsFrame.Active = false
                            dropdown.IgnoreBackButtons.Visible = false
                            dropdown.IgnoreBackButtons.Active = false
                            dropdown.OutlineItems.Visible = false
                            dropdown.BlackOutlineItems.Visible = false
                            dropdown.BlackOutline2Items.Visible = false
                        end
                    end
    
                    dropdown.Main.MouseButton1Down:Connect(MouseButton1Down)
                    dropdown.Nav.MouseButton1Down:Connect(MouseButton1Down)
    
                    dropdown.BlackOutline2.MouseEnter:Connect(function()
                        dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                    end)
                    dropdown.BlackOutline2.MouseLeave:Connect(function()
                        dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    end)
    
                    sector:FixSize()
                    table.insert(Library.Items, dropdown)
                    return dropdown
                end

                function toggle:AddTextbox(default, callback, flag)
                    local textbox = { }
                    textbox.callback = callback or function() end
                    textbox.default = default
                    textbox.value = ""
                    textbox.flag = flag or ( (toggle.text or "") .. tostring(#(sector.Items:GetChildren())) .. "a")
    
                    textbox.Holder = Instance.new("Frame", sector.Items)
                    textbox.Holder.Name = "holder"
                    textbox.Holder.ZIndex = 5
                    textbox.Holder.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 14)
                    textbox.Holder.BorderSizePixel = 0
                    textbox.Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
                    textbox.Gradient = Instance.new("UIGradient", textbox.Holder)
                    textbox.Gradient.Rotation = 90
                    textbox.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(49, 49, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39)) })
    
                    textbox.Main = Instance.new("TextBox", textbox.Holder)
                    textbox.Main.PlaceholderText = ""
                    textbox.Main.Text = ""
                    textbox.Main.BackgroundTransparency = 1
                    textbox.Main.Font = Window.Theme.Font
                    textbox.Main.Name = "textbox"
                    textbox.Main.MultiLine = false
                    textbox.Main.ClearTextOnFocus = false
                    textbox.Main.ZIndex = 5
                    textbox.Main.TextScaled = true
                    textbox.Main.Size = textbox.Holder.Size
                    textbox.Main.TextSize = 15
                    textbox.Main.TextColor3 = Color3.fromRGB(255, 255, 255)
                    textbox.Main.BorderSizePixel = 0
                    textbox.Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    textbox.Main.TextXAlignment = Enum.TextXAlignment.Left
    
                    if textbox.flag and textbox.flag ~= "" then
                        Library.Flags[textbox.flag] = textbox.default or ""
                    end

                    function textbox:Set(text)
                        textbox.value = text
                        textbox.Main.Text = text
                        if textbox.flag and textbox.flag ~= "" then
                            Library.Flags[textbox.flag] = text
                        end
                        pcall(textbox.callback, text)
                    end
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        textbox.Main.Font = Theme.Font
                    end)
    
                    function textbox:Get()
                        return textbox.value
                    end
    
                    if textbox.default then 
                        textbox:Set(textbox.default)
                    end
    
                    textbox.Main.FocusLost:Connect(function()
                        textbox:Set(textbox.Main.Text)
                    end)
    
                    textbox.BlackOutline2 = Instance.new("Frame", textbox.Main)
                    textbox.BlackOutline2.Name = "BlackLine"
                    textbox.BlackOutline2.ZIndex = 4
                    textbox.BlackOutline2.Size = textbox.Main.Size + UDim2.fromOffset(6, 6)
                    textbox.BlackOutline2.BorderSizePixel = 0
                    textbox.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    textbox.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        textbox.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
                    
                    textbox.Outline = Instance.new("Frame", textbox.Main)
                    textbox.Outline.Name = "BlackLine"
                    textbox.Outline.ZIndex = 4
                    textbox.Outline.Size = textbox.Main.Size + UDim2.fromOffset(4, 4)
                    textbox.Outline.BorderSizePixel = 0
                    textbox.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                    textbox.Outline.Position = UDim2.fromOffset(-2, -2)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        textbox.Outline.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    textbox.BlackOutline = Instance.new("Frame", textbox.Main)
                    textbox.BlackOutline.Name = "BlackLine"
                    textbox.BlackOutline.ZIndex = 4
                    textbox.BlackOutline.Size = textbox.Main.Size + UDim2.fromOffset(2, 2)
                    textbox.BlackOutline.BorderSizePixel = 0
                    textbox.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    textbox.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        textbox.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    textbox.BlackOutline2.MouseEnter:Connect(function()
                        textbox.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                    end)
                    textbox.BlackOutline2.MouseLeave:Connect(function()
                        textbox.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    end)
    
                    sector:FixSize()
                    table.insert(Library.Items, textbox)
                    return textbox
                end

                function toggle:AddColorpicker(default, callback, flag)
                    local colorpicker = { }

                    colorpicker.callback = callback or function() end
                    colorpicker.default = default or Color3.fromRGB(255, 255, 255)
                    colorpicker.value = colorpicker.default
                    colorpicker.flag = flag or ( (toggle.text or "") .. tostring(#toggle.Items:GetChildren()))

                    colorpicker.Main = Instance.new("Frame", toggle.Items)
                    colorpicker.Main.ZIndex = 6
                    colorpicker.Main.BorderSizePixel = 0
                    colorpicker.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    colorpicker.Main.Size = UDim2.fromOffset(16, 10)

                    colorpicker.Gradient = Instance.new("UIGradient", colorpicker.Main)
                    colorpicker.Gradient.Rotation = 90

                    local clr = Color3.new(math.clamp(colorpicker.value.R / 1.7, 0, 1), math.clamp(colorpicker.value.G / 1.7, 0, 1), math.clamp(colorpicker.value.B / 1.7, 0, 1))
                    colorpicker.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, colorpicker.value), ColorSequenceKeypoint.new(1.00, clr) })

                    colorpicker.BlackOutline2 = Instance.new("Frame", colorpicker.Main)
                    colorpicker.BlackOutline2.Name = "BlackLine"
                    colorpicker.BlackOutline2.ZIndex = 4
                    colorpicker.BlackOutline2.Size = colorpicker.Main.Size + UDim2.fromOffset(6, 6)
                    colorpicker.BlackOutline2.BorderSizePixel = 0
                    colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    colorpicker.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        if Window.OpenedColorPickers[colorpicker.MainPicker] then
                            colorpicker.BlackOutline2.BackgroundColor3 = Theme.AccentColor
                        else
                            colorpicker.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                        end
                    end)
                    
                    colorpicker.Outline = Instance.new("Frame", colorpicker.Main)
                    colorpicker.Outline.Name = "BlackLine"
                    colorpicker.Outline.ZIndex = 4
                    colorpicker.Outline.Size = colorpicker.Main.Size + UDim2.fromOffset(4, 4)
                    colorpicker.Outline.BorderSizePixel = 0
                    colorpicker.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                    colorpicker.Outline.Position = UDim2.fromOffset(-2, -2)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        colorpicker.Outline.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    colorpicker.BlackOutline = Instance.new("Frame", colorpicker.Main)
                    colorpicker.BlackOutline.Name = "BlackLine"
                    colorpicker.BlackOutline.ZIndex = 4
                    colorpicker.BlackOutline.Size = colorpicker.Main.Size + UDim2.fromOffset(2, 2)
                    colorpicker.BlackOutline.BorderSizePixel = 0
                    colorpicker.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    colorpicker.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        colorpicker.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                    end)

                    colorpicker.BlackOutline2.MouseEnter:Connect(function()
                        colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                    end)

                    colorpicker.BlackOutline2.MouseLeave:Connect(function()
                        if not Window.OpenedColorPickers[colorpicker.MainPicker] then
                            colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                        end
                    end)

                    colorpicker.MainPicker = Instance.new("TextButton", colorpicker.Main)
                    colorpicker.MainPicker.Name = "picker"
                    colorpicker.MainPicker.ZIndex = 100
                    colorpicker.MainPicker.Visible = false
                    colorpicker.MainPicker.AutoButtonColor = false
                    colorpicker.MainPicker.Text = ""
                    Window.OpenedColorPickers[colorpicker.MainPicker] = false
                    colorpicker.MainPicker.Size = UDim2.fromOffset(180, 196)
                    colorpicker.MainPicker.BorderSizePixel = 0
                    colorpicker.MainPicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    colorpicker.MainPicker.Rotation = 0.000000000000001
                    colorpicker.MainPicker.Position = UDim2.fromOffset(-colorpicker.MainPicker.AbsoluteSize.X + colorpicker.Main.AbsoluteSize.X, 17)

                    colorpicker.BlackOutline3 = Instance.new("Frame", colorpicker.MainPicker)
                    colorpicker.BlackOutline3.Name = "BlackLine"
                    colorpicker.BlackOutline3.ZIndex = 98
                    colorpicker.BlackOutline3.Size = colorpicker.MainPicker.Size + UDim2.fromOffset(6, 6)
                    colorpicker.BlackOutline3.BorderSizePixel = 0
                    colorpicker.BlackOutline3.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    colorpicker.BlackOutline3.Position = UDim2.fromOffset(-3, -3)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        colorpicker.BlackOutline3.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
                    
                    colorpicker.Outline2 = Instance.new("Frame", colorpicker.MainPicker)
                    colorpicker.Outline2.Name = "BlackLine"
                    colorpicker.Outline2.ZIndex = 98
                    colorpicker.Outline2.Size = colorpicker.MainPicker.Size + UDim2.fromOffset(4, 4)
                    colorpicker.Outline2.BorderSizePixel = 0
                    colorpicker.Outline2.BackgroundColor3 = Window.Theme.OutlineColor
                    colorpicker.Outline2.Position = UDim2.fromOffset(-2, -2)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        colorpicker.Outline2.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    colorpicker.BlackOutline3 = Instance.new("Frame", colorpicker.MainPicker)
                    colorpicker.BlackOutline3.Name = "BlackLine"
                    colorpicker.BlackOutline3.ZIndex = 98
                    colorpicker.BlackOutline3.Size = colorpicker.MainPicker.Size + UDim2.fromOffset(2, 2)
                    colorpicker.BlackOutline3.BorderSizePixel = 0
                    colorpicker.BlackOutline3.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    colorpicker.BlackOutline3.Position = UDim2.fromOffset(-1, -1)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        colorpicker.BlackOutline3.BackgroundColor3 = Theme.SecondOutlineColor
                    end)

                    colorpicker.hue = Instance.new("ImageLabel", colorpicker.MainPicker)
                    colorpicker.hue.ZIndex = 101
                    colorpicker.hue.Position = UDim2.new(0,3,0,3)
                    colorpicker.hue.Size = UDim2.new(0,172,0,172)
                    colorpicker.hue.Image = "rbxassetid://4155801252"
                    colorpicker.hue.ScaleType = Enum.ScaleType.Stretch
                    colorpicker.hue.BackgroundColor3 = Color3.new(1,0,0)
                    colorpicker.hue.BorderColor3 = Window.Theme.SecondOutlineColor
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        colorpicker.hue.BorderColor3 = Theme.SecondOutlineColor
                    end)

                    colorpicker.hueselectorpointer = Instance.new("ImageLabel", colorpicker.MainPicker)
                    colorpicker.hueselectorpointer.ZIndex = 101
                    colorpicker.hueselectorpointer.BackgroundTransparency = 1
                    colorpicker.hueselectorpointer.BorderSizePixel = 0
                    colorpicker.hueselectorpointer.Position = UDim2.new(0, 0, 0, 0)
                    colorpicker.hueselectorpointer.Size = UDim2.new(0, 7, 0, 7)
                    colorpicker.hueselectorpointer.Image = "rbxassetid://6885856475"

                    colorpicker.selector = Instance.new("TextLabel", colorpicker.MainPicker)
                    colorpicker.selector.ZIndex = 100
                    colorpicker.selector.Position = UDim2.new(0,3,0,181)
                    colorpicker.selector.Size = UDim2.new(0,173,0,10)
                    colorpicker.selector.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    colorpicker.selector.BorderColor3 = Window.Theme.SecondOutlineColor
                    colorpicker.selector.Text = ""
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        colorpicker.selector.BorderColor3 = Theme.SecondOutlineColor
                    end)
        
                    colorpicker.gradient = Instance.new("UIGradient", colorpicker.selector)
                    colorpicker.gradient.Color = ColorSequence.new({ 
                        ColorSequenceKeypoint.new(0, Color3.new(1,0,0)), 
                        ColorSequenceKeypoint.new(0.17, Color3.new(1,0,1)), 
                        ColorSequenceKeypoint.new(0.33,Color3.new(0,0,1)), 
                        ColorSequenceKeypoint.new(0.5,Color3.new(0,1,1)), 
                        ColorSequenceKeypoint.new(0.67, Color3.new(0,1,0)), 
                        ColorSequenceKeypoint.new(0.83, Color3.new(1,1,0)), 
                        ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
                    })

                    colorpicker.pointer = Instance.new("Frame", colorpicker.selector)
                    colorpicker.pointer.ZIndex = 101
                    colorpicker.pointer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    colorpicker.pointer.Position = UDim2.new(0,0,0,0)
                    colorpicker.pointer.Size = UDim2.new(0,2,0,10)
                    colorpicker.pointer.BorderColor3 = Color3.fromRGB(255, 255, 255)

                    if colorpicker.flag and colorpicker.flag ~= "" then
                        Library.Flags[colorpicker.flag] = colorpicker.default
                    end

                    function colorpicker:RefreshHue()
                        local x = (game:GetService("Players").LocalPlayer:GetMouse().X - colorpicker.hue.AbsolutePosition.X) / colorpicker.hue.AbsoluteSize.X
                        local y = (game:GetService("Players").LocalPlayer:GetMouse().Y - colorpicker.hue.AbsolutePosition.Y) / colorpicker.hue.AbsoluteSize.Y
                        colorpicker.hueselectorpointer:TweenPosition(UDim2.new(math.clamp(x * colorpicker.hue.AbsoluteSize.X, 0.5, 0.952 * colorpicker.hue.AbsoluteSize.X) / colorpicker.hue.AbsoluteSize.X, 0, math.clamp(y * colorpicker.hue.AbsoluteSize.Y, 0.5, 0.885 * colorpicker.hue.AbsoluteSize.Y) / colorpicker.hue.AbsoluteSize.Y, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.05)
                        colorpicker:Set(Color3.fromHSV(colorpicker.color, math.clamp(x * colorpicker.hue.AbsoluteSize.X, 0.5, 1 * colorpicker.hue.AbsoluteSize.X) / colorpicker.hue.AbsoluteSize.X, 1 - (math.clamp(y * colorpicker.hue.AbsoluteSize.Y, 0.5, 1 * colorpicker.hue.AbsoluteSize.Y) / colorpicker.hue.AbsoluteSize.Y)))
                    end

                    function colorpicker:RefreshSelector()
                        local pos = math.clamp((game:GetService("Players").LocalPlayer:GetMouse().X - colorpicker.hue.AbsolutePosition.X) / colorpicker.hue.AbsoluteSize.X, 0, 1)
                        colorpicker.color = 1 - pos
                        colorpicker.pointer:TweenPosition(UDim2.new(pos, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.05)
                        colorpicker.hue.BackgroundColor3 = Color3.fromHSV(1 - pos, 1, 1)

                        local x = (colorpicker.hueselectorpointer.AbsolutePosition.X - colorpicker.hue.AbsolutePosition.X) / colorpicker.hue.AbsoluteSize.X
                        local y = (colorpicker.hueselectorpointer.AbsolutePosition.Y - colorpicker.hue.AbsolutePosition.Y) / colorpicker.hue.AbsoluteSize.Y
                        colorpicker:Set(Color3.fromHSV(colorpicker.color, math.clamp(x * colorpicker.hue.AbsoluteSize.X, 0.5, 1 * colorpicker.hue.AbsoluteSize.X) / colorpicker.hue.AbsoluteSize.X, 1 - (math.clamp(y * colorpicker.hue.AbsoluteSize.Y, 0.5, 1 * colorpicker.hue.AbsoluteSize.Y) / colorpicker.hue.AbsoluteSize.Y)))
                    end

                    function colorpicker:Set(value)
                        local color = Color3.new(math.clamp(value.r, 0, 1), math.clamp(value.g, 0, 1), math.clamp(value.b, 0, 1))
                        colorpicker.value = color
                        if colorpicker.flag and colorpicker.flag ~= "" then
                            Library.Flags[colorpicker.flag] = color
                        end
                        local clr = Color3.new(math.clamp(color.R / 1.7, 0, 1), math.clamp(color.G / 1.7, 0, 1), math.clamp(color.B / 1.7, 0, 1))
                        colorpicker.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, color), ColorSequenceKeypoint.new(1.00, clr) })
                        pcall(colorpicker.callback, color)
                    end

                    function colorpicker:Get(value)
                        return colorpicker.value
                    end
                    colorpicker:Set(colorpicker.default)

                    local dragging_selector = false
                    local dragging_hue = false

                    colorpicker.selector.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging_selector = true
                            colorpicker:RefreshSelector()
                        end
                    end)
    
                    colorpicker.selector.InputEnded:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging_selector = false
                            colorpicker:RefreshSelector()
                        end
                    end)

                    colorpicker.hue.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging_hue = true
                            colorpicker:RefreshHue()
                        end
                    end)
    
                    colorpicker.hue.InputEnded:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging_hue = false
                            colorpicker:RefreshHue()
                        end
                    end)
    
                    game:GetService("UserInputService").InputChanged:Connect(function(Input)
                        if dragging_selector and Input.UserInputType == Enum.UserInputType.MouseMovement then
                            colorpicker:RefreshSelector()
                        end
                        if dragging_hue and Input.UserInputType == Enum.UserInputType.MouseMovement then
                            colorpicker:RefreshHue()
                        end
                    end)

                    local inputBegan = function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            for i,v in pairs(Window.OpenedColorPickers) do
                                if v and i ~= colorpicker.MainPicker then
                                    i.Visible = false
                                    Window.OpenedColorPickers[i] = false
                                end
                            end

                            colorpicker.MainPicker.Visible = not colorpicker.MainPicker.Visible
                            Window.OpenedColorPickers[colorpicker.MainPicker] = colorpicker.MainPicker.Visible
                            if Window.OpenedColorPickers[colorpicker.MainPicker] then
                                colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                            else
                                colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                            end
                        end
                    end

                    colorpicker.Main.InputBegan:Connect(inputBegan)
                    colorpicker.Outline.InputBegan:Connect(inputBegan)
                    colorpicker.BlackOutline2.InputBegan:Connect(inputBegan)
                    table.insert(Library.Items, colorpicker)
                    return colorpicker
                end

                function toggle:AddSlider(min, default, max, decimals, callback, flag)
                    local slider = { }
                    slider.text = text or ""
                    slider.callback = callback or function(value) end
                    slider.min = min or 0
                    slider.max = max or 100
                    slider.decimals = decimals or 1
                    slider.default = default or slider.min
                    slider.flag = flag or ( (toggle.text or "") .. tostring(#toggle.Items:GetChildren()))
    
                    slider.value = slider.default
                    local Dragging = false
    
                    slider.Main = Instance.new("TextButton", sector.Items)
                    slider.Main.Name = "slider"
                    slider.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    slider.Main.Position = UDim2.fromOffset(0, 0)
                    slider.Main.BorderSizePixel = 0
                    slider.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 12)
                    slider.Main.AutoButtonColor = false
                    slider.Main.Text = ""
                    slider.Main.ZIndex = 7

                    slider.InputLabel = Instance.new("TextLabel", slider.Main)
                    slider.InputLabel.BackgroundTransparency = 1
                    slider.InputLabel.Size = slider.Main.Size
                    slider.InputLabel.Font = Window.Theme.Font
                    slider.InputLabel.Text = "0"
                    slider.InputLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
                    slider.InputLabel.Position = slider.Main.Position
                    slider.InputLabel.Selectable = false
                    slider.InputLabel.TextSize = 15
                    slider.InputLabel.ZIndex = 9
                    slider.InputLabel.TextStrokeTransparency = 1
                    slider.InputLabel.TextXAlignment = Enum.TextXAlignment.Center
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        slider.InputLabel.Font = Theme.Font
                        slider.InputLabel.TextColor3 = Theme.ItemsColor
                    end)
    
                    slider.BlackOutline2 = Instance.new("Frame", slider.Main)
                    slider.BlackOutline2.Name = "BlackLine"
                    slider.BlackOutline2.ZIndex = 4
                    slider.BlackOutline2.Size = slider.Main.Size + UDim2.fromOffset(6, 6)
                    slider.BlackOutline2.BorderSizePixel = 0
                    slider.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    slider.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        slider.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
                    
                    slider.Outline = Instance.new("Frame", slider.Main)
                    slider.Outline.Name = "BlackLine"
                    slider.Outline.ZIndex = 4
                    slider.Outline.Size = slider.Main.Size + UDim2.fromOffset(4, 4)
                    slider.Outline.BorderSizePixel = 0
                    slider.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                    slider.Outline.Position = UDim2.fromOffset(-2, -2)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        slider.Outline.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    slider.BlackOutline = Instance.new("Frame", slider.Main)
                    slider.BlackOutline.Name = "BlackLine"
                    slider.BlackOutline.ZIndex = 4
                    slider.BlackOutline.Size = slider.Main.Size + UDim2.fromOffset(2, 2)
                    slider.BlackOutline.BorderSizePixel = 0
                    slider.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    slider.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        slider.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    slider.Gradient = Instance.new("UIGradient", slider.Main)
                    slider.Gradient.Rotation = 90
                    slider.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(49, 49, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(41, 41, 41)) })
    
                    slider.SlideBar = Instance.new("Frame", slider.Main)
                    slider.SlideBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255) --Color3.fromRGB(204, 0, 102)
                    slider.SlideBar.ZIndex = 8
                    slider.SlideBar.BorderSizePixel = 0
                    slider.SlideBar.Size = UDim2.fromOffset(0, slider.Main.Size.Y.Offset)
    
                    slider.Gradient2 = Instance.new("UIGradient", slider.SlideBar)
                    slider.Gradient2.Rotation = 90
                    slider.Gradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Window.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Window.Theme.SecondAccentColor) })
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        slider.Gradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Theme.SecondAccentColor) })
                    end)
    
                    slider.BlackOutline2.MouseEnter:Connect(function()
                        slider.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                    end)
                    slider.BlackOutline2.MouseLeave:Connect(function()
                        slider.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    end)
    
                    if slider.flag and slider.flag ~= "" then
                        Library.Flags[slider.flag] = slider.default or slider.min or 0
                    end

                    function slider:Get()
                        return slider.value
                    end
    
                    function slider:Set(value)
                        slider.value = math.clamp(math.round(value * slider.decimals) / slider.decimals, slider.min, slider.max)
                        local percent = 1 - ((slider.max - slider.value) / (slider.max - slider.min))
                        if slider.flag and slider.flag ~= "" then
                            Library.Flags[slider.flag] = slider.value
                        end
                        slider.SlideBar:TweenSize(UDim2.fromOffset(percent * slider.Main.AbsoluteSize.X, slider.Main.AbsoluteSize.Y), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.05)
                        slider.InputLabel.Text = slider.value
                        pcall(slider.callback, slider.value)
                    end
                    slider:Set(slider.default)
    
                    function slider:Refresh()
                        local mousePos = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(game:GetService("Players").LocalPlayer:GetMouse().Hit.p)
                        local percent = math.clamp(mousePos.X - slider.SlideBar.AbsolutePosition.X, 0, slider.Main.AbsoluteSize.X) / slider.Main.AbsoluteSize.X
                        local value = math.floor((slider.min + (slider.max - slider.min) * percent) * slider.decimals) / slider.decimals
                        value = math.clamp(value, slider.min, slider.max)
                        slider:Set(value)
                    end
    
                    slider.SlideBar.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = true
                            slider:Refresh()
                        end
                    end)
    
                    slider.SlideBar.InputEnded:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                        end
                    end)
    
                    slider.Main.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = true
                            slider:Refresh()
                        end
                    end)
    
                    slider.Main.InputEnded:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                        end
                    end)
    
                    game:GetService("UserInputService").InputChanged:Connect(function(Input)
                        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                            slider:Refresh()
                        end
                    end)
    
                    sector:FixSize()
                    table.insert(Library.Items, slider)
                    return slider
                end

                toggle.Main.MouseButton1Down:Connect(function()
                    toggle:Set(not toggle.CheckedFrame.Visible)
                end)
                toggle.Label.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        toggle:Set(not toggle.CheckedFrame.Visible)
                    end
                end)

                local MouseEnter = function()
                    toggle.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                end
                local MouseLeave = function()
                    toggle.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                end

                toggle.Label.MouseEnter:Connect(MouseEnter)
                toggle.Label.MouseLeave:Connect(MouseLeave)
                toggle.BlackOutline2.MouseEnter:Connect(MouseEnter)
                toggle.BlackOutline2.MouseLeave:Connect(MouseLeave)

                sector:FixSize()
                table.insert(Library.Items, toggle)
                return toggle
            end

            function sector:AddTextbox(text, default, callback, flag)
                local textbox = { }
                textbox.text = text or ""
                textbox.callback = callback or function() end
                textbox.default = default
                textbox.value = ""
                textbox.flag = flag or text or ""

                textbox.Label = Instance.new("TextButton", sector.Items)
                textbox.Label.Name = "Label"
                textbox.Label.AutoButtonColor = false
                textbox.Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textbox.Label.BackgroundTransparency = 1
                textbox.Label.Position = UDim2.fromOffset(sector.Main.Size.X.Offset, 0)
                textbox.Label.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 0)
                textbox.Label.Font = Window.Theme.Font
                textbox.Label.ZIndex = 5
                textbox.Label.Text = textbox.text
                textbox.Label.TextColor3 = Window.Theme.ItemsColor
                textbox.Label.TextSize = 15
                textbox.Label.TextStrokeTransparency = 1
                textbox.Label.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    textbox.Label.Font = Theme.Font
                end)

                textbox.Holder = Instance.new("Frame", sector.Items)
                textbox.Holder.Name = "holder"
                textbox.Holder.ZIndex = 5
                textbox.Holder.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 14)
                textbox.Holder.BorderSizePixel = 0
                textbox.Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                textbox.Gradient = Instance.new("UIGradient", textbox.Holder)
                textbox.Gradient.Rotation = 90
                textbox.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(49, 49, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39)) })

                textbox.Main = Instance.new("TextBox", textbox.Holder)
                textbox.Main.PlaceholderText = textbox.text
                textbox.Main.PlaceholderColor3 = Color3.fromRGB(190, 190, 190)
                textbox.Main.Text = ""
                textbox.Main.BackgroundTransparency = 1
                textbox.Main.Font = Window.Theme.Font
                textbox.Main.Name = "textbox"
                textbox.Main.MultiLine = false
                textbox.Main.ClearTextOnFocus = false
                textbox.Main.ZIndex = 5
                textbox.Main.TextScaled = true
                textbox.Main.Size = textbox.Holder.Size
                textbox.Main.TextSize = 15
                textbox.Main.TextColor3 = Color3.fromRGB(255, 255, 255)
                textbox.Main.BorderSizePixel = 0
                textbox.Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                textbox.Main.TextXAlignment = Enum.TextXAlignment.Left

                if textbox.flag and textbox.flag ~= "" then
                    Library.Flags[textbox.flag] = textbox.default or ""
                end

                function textbox:Set(text)
                    textbox.value = text
                    textbox.Main.Text = text
                    if textbox.flag and textbox.flag ~= "" then
                        Library.Flags[textbox.flag] = text
                    end
                    pcall(textbox.callback, text)
                end
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    textbox.Main.Font = Theme.Font
                end)

                function textbox:Get()
                    return textbox.value
                end

                if textbox.default then 
                    textbox:Set(textbox.default)
                end

                textbox.Main.FocusLost:Connect(function()
                    textbox:Set(textbox.Main.Text)
                end)

                textbox.BlackOutline2 = Instance.new("Frame", textbox.Main)
                textbox.BlackOutline2.Name = "BlackLine"
                textbox.BlackOutline2.ZIndex = 4
                textbox.BlackOutline2.Size = textbox.Main.Size + UDim2.fromOffset(6, 6)
                textbox.BlackOutline2.BorderSizePixel = 0
                textbox.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                textbox.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    textbox.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                end)
                
                textbox.Outline = Instance.new("Frame", textbox.Main)
                textbox.Outline.Name = "BlackLine"
                textbox.Outline.ZIndex = 4
                textbox.Outline.Size = textbox.Main.Size + UDim2.fromOffset(4, 4)
                textbox.Outline.BorderSizePixel = 0
                textbox.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                textbox.Outline.Position = UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    textbox.Outline.BackgroundColor3 = Theme.OutlineColor
                end)

                textbox.BlackOutline = Instance.new("Frame", textbox.Main)
                textbox.BlackOutline.Name = "BlackLine"
                textbox.BlackOutline.ZIndex = 4
                textbox.BlackOutline.Size = textbox.Main.Size + UDim2.fromOffset(2, 2)
                textbox.BlackOutline.BorderSizePixel = 0
                textbox.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                textbox.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    textbox.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                textbox.BlackOutline2.MouseEnter:Connect(function()
                    textbox.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                end)
                textbox.BlackOutline2.MouseLeave:Connect(function()
                    textbox.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                end)

                sector:FixSize()
                table.insert(Library.Items, textbox)
                return textbox
            end
            
            function sector:AddSlider(text, min, default, max, decimals, callback, flag)
                local slider = { }
                slider.text = text or ""
                slider.callback = callback or function(value) end
                slider.min = min or 0
                slider.max = max or 100
                slider.decimals = decimals or 1
                slider.default = default or slider.min
                slider.flag = flag or text or ""

                slider.value = slider.default
                local Dragging = false

                slider.MainBack = Instance.new("Frame", sector.Items)
                slider.MainBack.Name = "MainBack"
                slider.MainBack.ZIndex = 7
                slider.MainBack.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 25)
                slider.MainBack.BorderSizePixel = 0
                slider.MainBack.BackgroundTransparency = 1

                slider.Label = Instance.new("TextLabel", slider.MainBack)
                slider.Label.BackgroundTransparency = 1
                slider.Label.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 6)
                slider.Label.Font = Window.Theme.Font
                slider.Label.Text = slider.text .. ":"
                slider.Label.TextColor3 = Window.Theme.ItemsColor
                slider.Label.Position = UDim2.fromOffset(0, 0)
                slider.Label.TextSize = 15
                slider.Label.ZIndex = 4
                slider.Label.TextStrokeTransparency = 1
                slider.Label.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    slider.Label.Font = Theme.Font
                    slider.Label.TextColor3 = Theme.ItemsColor
                end)

                local Size = game:GetService("TextService"):GetTextSize(slider.Label.Text, slider.Label.TextSize, slider.Label.Font, Vector2.new(200,300))
                slider.InputLabel = Instance.new("TextBox", slider.MainBack)
                slider.InputLabel.BackgroundTransparency = 1
                slider.InputLabel.ClearTextOnFocus = false
                slider.InputLabel.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - Size.X - 15, 12)
                slider.InputLabel.Font = Window.Theme.Font
                slider.InputLabel.Text = "0"
                slider.InputLabel.TextColor3 = Window.Theme.ItemsColor
                slider.InputLabel.Position = UDim2.fromOffset(Size.X + 3, -3)
                slider.InputLabel.TextSize = 15
                slider.InputLabel.ZIndex = 4
                slider.InputLabel.TextStrokeTransparency = 1
                slider.InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    slider.InputLabel.Font = Theme.Font
                    slider.InputLabel.TextColor3 = Theme.ItemsColor

                    local Size = game:GetService("TextService"):GetTextSize(slider.Label.Text, slider.Label.TextSize, slider.Label.Font, Vector2.new(200,300))
                    slider.InputLabel.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - Size.X - 15, 12)
                end)

                slider.Main = Instance.new("TextButton", slider.MainBack)
                slider.Main.Name = "slider"
                slider.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                slider.Main.Position = UDim2.fromOffset(0, 15)
                slider.Main.BorderSizePixel = 0
                slider.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 12)
                slider.Main.AutoButtonColor = false
                slider.Main.Text = ""
                slider.Main.ZIndex = 5

                slider.BlackOutline2 = Instance.new("Frame", slider.Main)
                slider.BlackOutline2.Name = "BlackLine"
                slider.BlackOutline2.ZIndex = 4
                slider.BlackOutline2.Size = slider.Main.Size + UDim2.fromOffset(6, 6)
                slider.BlackOutline2.BorderSizePixel = 0
                slider.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                slider.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    slider.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                end)
                
                slider.Outline = Instance.new("Frame", slider.Main)
                slider.Outline.Name = "BlackLine"
                slider.Outline.ZIndex = 4
                slider.Outline.Size = slider.Main.Size + UDim2.fromOffset(4, 4)
                slider.Outline.BorderSizePixel = 0
                slider.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                slider.Outline.Position = UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    slider.Outline.BackgroundColor3 = Theme.OutlineColor
                end)

                slider.BlackOutline = Instance.new("Frame", slider.Main)
                slider.BlackOutline.Name = "BlackLine"
                slider.BlackOutline.ZIndex = 4
                slider.BlackOutline.Size = slider.Main.Size + UDim2.fromOffset(2, 2)
                slider.BlackOutline.BorderSizePixel = 0
                slider.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                slider.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    slider.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                slider.Gradient = Instance.new("UIGradient", slider.Main)
                slider.Gradient.Rotation = 90
                slider.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(49, 49, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(41, 41, 41)) })

                slider.SlideBar = Instance.new("Frame", slider.Main)
                slider.SlideBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255) --Color3.fromRGB(204, 0, 102)
                slider.SlideBar.ZIndex = 5
                slider.SlideBar.BorderSizePixel = 0
                slider.SlideBar.Size = UDim2.fromOffset(0, slider.Main.Size.Y.Offset)

                slider.Gradient2 = Instance.new("UIGradient", slider.SlideBar)
                slider.Gradient2.Rotation = 90
                slider.Gradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Window.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Window.Theme.SecondAccentColor) })
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    slider.Gradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Theme.SecondAccentColor) })
                end)

                slider.BlackOutline2.MouseEnter:Connect(function()
                    slider.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                end)
                slider.BlackOutline2.MouseLeave:Connect(function()
                    slider.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                end)

                if slider.flag and slider.flag ~= "" then
                    Library.Flags[slider.flag] = slider.default or slider.min or 0
                end

                function slider:Get()
                    return slider.value
                end

                function slider:Set(value)
                    slider.value = math.clamp(math.round(value * slider.decimals) / slider.decimals, slider.min, slider.max)
                    local percent = 1 - ((slider.max - slider.value) / (slider.max - slider.min))
                    if slider.flag and slider.flag ~= "" then
                        Library.Flags[slider.flag] = slider.value
                    end
                    slider.SlideBar:TweenSize(UDim2.fromOffset(percent * slider.Main.AbsoluteSize.X, slider.Main.AbsoluteSize.Y), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.05)
					slider.InputLabel.Text = slider.value
					pcall(slider.callback, slider.value)
				end
                slider:Set(slider.default)

                slider.InputLabel.FocusLost:Connect(function(Return)
                    if not Return then 
                        return 
                    end
                    if (slider.InputLabel.Text:match("^%d+$")) then
                        slider:Set(tonumber(slider.InputLabel.Text))
                    else
                        slider.InputLabel.Text = tostring(slider.value)
                    end
                end)

                function slider:Refresh()
                    local mousePos = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(game:GetService("Players").LocalPlayer:GetMouse().Hit.p)
                    local percent = math.clamp(mousePos.X - slider.SlideBar.AbsolutePosition.X, 0, slider.Main.AbsoluteSize.X) / slider.Main.AbsoluteSize.X
                    local value = math.floor((slider.min + (slider.max - slider.min) * percent) * slider.decimals) / slider.decimals
                    value = math.clamp(value, slider.min, slider.max)
                    slider:Set(value)
                end

                slider.SlideBar.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                        slider:Refresh()
                    end
                end)

                slider.SlideBar.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)

                slider.Main.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                        slider:Refresh()
                    end
                end)

                slider.Main.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)

				game:GetService("UserInputService").InputChanged:Connect(function(Input)
					if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        slider:Refresh()
					end
				end)

                sector:FixSize()
                table.insert(Library.Items, slider)
                return slider
            end

            function sector:AddColorpicker(text, default, callback, flag)
                local colorpicker = { }

                colorpicker.text = text or ""
                colorpicker.callback = callback or function() end
                colorpicker.default = default or Color3.fromRGB(255, 255, 255)
                colorpicker.value = colorpicker.default
                colorpicker.flag = flag or text or ""

                colorpicker.Label = Instance.new("TextLabel", sector.Items)
                colorpicker.Label.BackgroundTransparency = 1
                colorpicker.Label.Size = UDim2.fromOffset(156, 10)
                colorpicker.Label.ZIndex = 4
                colorpicker.Label.Font = Window.Theme.Font
                colorpicker.Label.Text = colorpicker.text
                colorpicker.Label.TextColor3 = Window.Theme.ItemsColor
                colorpicker.Label.TextSize = 15
                colorpicker.Label.TextStrokeTransparency = 1
                colorpicker.Label.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.Label.Font = Theme.Font
                    colorpicker.Label.TextColor3 = Theme.ItemsColor
                end)

                colorpicker.Main = Instance.new("Frame", colorpicker.Label)
                colorpicker.Main.ZIndex = 6
                colorpicker.Main.BorderSizePixel = 0
                colorpicker.Main.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 29, 0)
                colorpicker.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                colorpicker.Main.Size = UDim2.fromOffset(16, 10)

                colorpicker.Gradient = Instance.new("UIGradient", colorpicker.Main)
                colorpicker.Gradient.Rotation = 90

                local clr = Color3.new(math.clamp(colorpicker.value.R / 1.7, 0, 1), math.clamp(colorpicker.value.G / 1.7, 0, 1), math.clamp(colorpicker.value.B / 1.7, 0, 1))
                colorpicker.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, colorpicker.value), ColorSequenceKeypoint.new(1.00, clr) })

                colorpicker.BlackOutline2 = Instance.new("Frame", colorpicker.Main)
                colorpicker.BlackOutline2.Name = "BlackLine"
                colorpicker.BlackOutline2.ZIndex = 4
                colorpicker.BlackOutline2.Size = colorpicker.Main.Size + UDim2.fromOffset(6, 6)
                colorpicker.BlackOutline2.BorderSizePixel = 0
                colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                colorpicker.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.BlackOutline2.BackgroundColor3 = Window.OpenedColorPickers[colorpicker.MainPicker] and Theme.AccentColor or Theme.SecondOutlineColor
                end)
                
                colorpicker.Outline = Instance.new("Frame", colorpicker.Main)
                colorpicker.Outline.Name = "BlackLine"
                colorpicker.Outline.ZIndex = 4
                colorpicker.Outline.Size = colorpicker.Main.Size + UDim2.fromOffset(4, 4)
                colorpicker.Outline.BorderSizePixel = 0
                colorpicker.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                colorpicker.Outline.Position = UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.Outline.BackgroundColor3 = Theme.OutlineColor
                end)

                colorpicker.BlackOutline = Instance.new("Frame", colorpicker.Main)
                colorpicker.BlackOutline.Name = "BlackLine"
                colorpicker.BlackOutline.ZIndex = 4
                colorpicker.BlackOutline.Size = colorpicker.Main.Size + UDim2.fromOffset(2, 2)
                colorpicker.BlackOutline.BorderSizePixel = 0
                colorpicker.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                colorpicker.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                colorpicker.BlackOutline2.MouseEnter:Connect(function()
                    colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                end)
                colorpicker.BlackOutline2.MouseLeave:Connect(function()
                    if not Window.OpenedColorPickers[colorpicker.MainPicker] then
                        colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    end
                end)

                colorpicker.MainPicker = Instance.new("TextButton", colorpicker.Main)
                colorpicker.MainPicker.Name = "picker"
                colorpicker.MainPicker.ZIndex = 100
                colorpicker.MainPicker.Visible = false
                colorpicker.MainPicker.AutoButtonColor = false
                colorpicker.MainPicker.Text = ""
                Window.OpenedColorPickers[colorpicker.MainPicker] = false
                colorpicker.MainPicker.Size = UDim2.fromOffset(180, 196)
                colorpicker.MainPicker.BorderSizePixel = 0
                colorpicker.MainPicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                colorpicker.MainPicker.Rotation = 0.000000000000001
                colorpicker.MainPicker.Position = UDim2.fromOffset(-colorpicker.MainPicker.AbsoluteSize.X + colorpicker.Main.AbsoluteSize.X, 15)

                colorpicker.BlackOutline3 = Instance.new("Frame", colorpicker.MainPicker)
                colorpicker.BlackOutline3.Name = "BlackLine"
                colorpicker.BlackOutline3.ZIndex = 98
                colorpicker.BlackOutline3.Size = colorpicker.MainPicker.Size + UDim2.fromOffset(6, 6)
                colorpicker.BlackOutline3.BorderSizePixel = 0
                colorpicker.BlackOutline3.BackgroundColor3 = Window.Theme.SecondOutlineColor
                colorpicker.BlackOutline3.Position = UDim2.fromOffset(-3, -3)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.BlackOutline3.BackgroundColor3 = Theme.SecondOutlineColor
                end)
                
                colorpicker.Outline2 = Instance.new("Frame", colorpicker.MainPicker)
                colorpicker.Outline2.Name = "BlackLine"
                colorpicker.Outline2.ZIndex = 98
                colorpicker.Outline2.Size = colorpicker.MainPicker.Size + UDim2.fromOffset(4, 4)
                colorpicker.Outline2.BorderSizePixel = 0
                colorpicker.Outline2.BackgroundColor3 = Window.Theme.OutlineColor
                colorpicker.Outline2.Position = UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.Outline2.BackgroundColor3 = Theme.OutlineColor
                end)

                colorpicker.BlackOutline3 = Instance.new("Frame", colorpicker.MainPicker)
                colorpicker.BlackOutline3.Name = "BlackLine"
                colorpicker.BlackOutline3.ZIndex = 98
                colorpicker.BlackOutline3.Size = colorpicker.MainPicker.Size + UDim2.fromOffset(2, 2)
                colorpicker.BlackOutline3.BorderSizePixel = 0
                colorpicker.BlackOutline3.BackgroundColor3 = Window.Theme.SecondOutlineColor
                colorpicker.BlackOutline3.Position = UDim2.fromOffset(-1, -1)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.BlackOutline3.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                colorpicker.hue = Instance.new("ImageLabel", colorpicker.MainPicker)
                colorpicker.hue.ZIndex = 101
                colorpicker.hue.Position = UDim2.new(0,3,0,3)
                colorpicker.hue.Size = UDim2.new(0,172,0,172)
                colorpicker.hue.Image = "rbxassetid://4155801252"
                colorpicker.hue.ScaleType = Enum.ScaleType.Stretch
                colorpicker.hue.BackgroundColor3 = Color3.new(1,0,0)
                colorpicker.hue.BorderColor3 = Window.Theme.SecondOutlineColor
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.hue.BorderColor3 = Theme.SecondOutlineColor
                end)

                colorpicker.hueselectorpointer = Instance.new("ImageLabel", colorpicker.MainPicker)
                colorpicker.hueselectorpointer.ZIndex = 101
                colorpicker.hueselectorpointer.BackgroundTransparency = 1
                colorpicker.hueselectorpointer.BorderSizePixel = 0
                colorpicker.hueselectorpointer.Position = UDim2.new(0, 0, 0, 0)
                colorpicker.hueselectorpointer.Size = UDim2.new(0, 7, 0, 7)
                colorpicker.hueselectorpointer.Image = "rbxassetid://6885856475"

                colorpicker.selector = Instance.new("TextLabel", colorpicker.MainPicker)
                colorpicker.selector.ZIndex = 100
                colorpicker.selector.Position = UDim2.new(0,3,0,181)
                colorpicker.selector.Size = UDim2.new(0,173,0,10)
                colorpicker.selector.BackgroundColor3 = Color3.fromRGB(255,255,255)
                colorpicker.selector.BorderColor3 = Window.Theme.SecondOutlineColor
                colorpicker.selector.Text = ""
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    colorpicker.selector.BorderColor3 = Theme.SecondOutlineColor
                end)
    
                colorpicker.gradient = Instance.new("UIGradient", colorpicker.selector)
                colorpicker.gradient.Color = ColorSequence.new({ 
                    ColorSequenceKeypoint.new(0, Color3.new(1,0,0)), 
                    ColorSequenceKeypoint.new(0.17, Color3.new(1,0,1)), 
                    ColorSequenceKeypoint.new(0.33,Color3.new(0,0,1)), 
                    ColorSequenceKeypoint.new(0.5,Color3.new(0,1,1)), 
                    ColorSequenceKeypoint.new(0.67, Color3.new(0,1,0)), 
                    ColorSequenceKeypoint.new(0.83, Color3.new(1,1,0)), 
                    ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
                })

                colorpicker.pointer = Instance.new("Frame", colorpicker.selector)
                colorpicker.pointer.ZIndex = 101
                colorpicker.pointer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                colorpicker.pointer.Position = UDim2.new(0,0,0,0)
                colorpicker.pointer.Size = UDim2.new(0,2,0,10)
                colorpicker.pointer.BorderColor3 = Color3.fromRGB(255, 255, 255)

                if colorpicker.flag and colorpicker.flag ~= "" then
                    Library.Flags[colorpicker.flag] = colorpicker.default
                end

                function colorpicker:RefreshSelector()
                    local pos = math.clamp((game:GetService("Players").LocalPlayer:GetMouse().X - colorpicker.hue.AbsolutePosition.X) / colorpicker.hue.AbsoluteSize.X, 0, 1)
                    colorpicker.color = 1 - pos
                    colorpicker.pointer:TweenPosition(UDim2.new(pos, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.05)
                    colorpicker.hue.BackgroundColor3 = Color3.fromHSV(1 - pos, 1, 1)
                end

                function colorpicker:RefreshHue()
                    local x = (game:GetService("Players").LocalPlayer:GetMouse().X - colorpicker.hue.AbsolutePosition.X) / colorpicker.hue.AbsoluteSize.X
                    local y = (game:GetService("Players").LocalPlayer:GetMouse().Y - colorpicker.hue.AbsolutePosition.Y) / colorpicker.hue.AbsoluteSize.Y
                    colorpicker.hueselectorpointer:TweenPosition(UDim2.new(math.clamp(x * colorpicker.hue.AbsoluteSize.X, 0.5, 0.952 * colorpicker.hue.AbsoluteSize.X) / colorpicker.hue.AbsoluteSize.X, 0, math.clamp(y * colorpicker.hue.AbsoluteSize.Y, 0.5, 0.885 * colorpicker.hue.AbsoluteSize.Y) / colorpicker.hue.AbsoluteSize.Y, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.05)
                    colorpicker:Set(Color3.fromHSV(colorpicker.color, math.clamp(x * colorpicker.hue.AbsoluteSize.X, 0.5, 1 * colorpicker.hue.AbsoluteSize.X) / colorpicker.hue.AbsoluteSize.X, 1 - (math.clamp(y * colorpicker.hue.AbsoluteSize.Y, 0.5, 1 * colorpicker.hue.AbsoluteSize.Y) / colorpicker.hue.AbsoluteSize.Y)))
                end

                function colorpicker:Set(value)
                    local color = Color3.new(math.clamp(value.r, 0, 1), math.clamp(value.g, 0, 1), math.clamp(value.b, 0, 1))
                    colorpicker.value = color
                    if colorpicker.flag and colorpicker.flag ~= "" then
                        Library.Flags[colorpicker.flag] = color
                    end
                    local clr = Color3.new(math.clamp(color.R / 1.7, 0, 1), math.clamp(color.G / 1.7, 0, 1), math.clamp(color.B / 1.7, 0, 1))
                    colorpicker.Gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, color), ColorSequenceKeypoint.new(1.00, clr) })
                    pcall(colorpicker.callback, color)
                end
                function colorpicker:Get()
                    return colorpicker.value
                end
                colorpicker:Set(colorpicker.default)

                function colorpicker:AddDropdown(Items, default, multichoice, callback, flag)
                    local dropdown = { }

                    dropdown.defaultitems = Items or { }
                    dropdown.default = default
                    dropdown.callback = callback or function() end
                    dropdown.multichoice = multichoice or false
                    dropdown.values = { }
                    dropdown.flag = flag or ((colorpicker.text or "") .. tostring( #(sector.Items:GetChildren()) ))
    
                    dropdown.Main = Instance.new("TextButton", sector.Items)
                    dropdown.Main.Name = "dropdown"
                    dropdown.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.Main.BorderSizePixel = 0
                    dropdown.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 16)
                    dropdown.Main.Position = UDim2.fromOffset(0, 0)
                    dropdown.Main.ZIndex = 5
                    dropdown.Main.AutoButtonColor = false
                    dropdown.Main.Font = Window.Theme.Font
                    dropdown.Main.Text = ""
                    dropdown.Main.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.Main.TextSize = 15
                    dropdown.Main.TextXAlignment = Enum.TextXAlignment.Left
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.Main.Font = Theme.Font
                    end)
    
                    dropdown.Gradient = Instance.new("UIGradient", dropdown.Main)
                    dropdown.Gradient.Rotation = 90
                    dropdown.Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(49, 49, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))}
    
                    dropdown.SelectedLabel = Instance.new("TextLabel", dropdown.Main)
                    dropdown.SelectedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.SelectedLabel.BackgroundTransparency = 1
                    dropdown.SelectedLabel.Position = UDim2.fromOffset(5, 2)
                    dropdown.SelectedLabel.Size = UDim2.fromOffset(130, 13)
                    dropdown.SelectedLabel.Font = Window.Theme.Font
                    dropdown.SelectedLabel.Text = colorpicker.text
                    dropdown.SelectedLabel.ZIndex = 5
                    dropdown.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dropdown.SelectedLabel.TextSize = 15
                    dropdown.SelectedLabel.TextStrokeTransparency = 1
                    dropdown.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.SelectedLabel.Font = Theme.Font
                    end)

                    dropdown.Nav = Instance.new("ImageButton", dropdown.Main)
                    dropdown.Nav.Name = "navigation"
                    dropdown.Nav.BackgroundTransparency = 1
                    dropdown.Nav.LayoutOrder = 10
                    dropdown.Nav.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 26, 5)
                    dropdown.Nav.Rotation = 90
                    dropdown.Nav.ZIndex = 5
                    dropdown.Nav.Size = UDim2.fromOffset(8, 8)
                    dropdown.Nav.Image = "rbxassetid://4918373417"
                    dropdown.Nav.ImageColor3 = Color3.fromRGB(210, 210, 210)
    
                    dropdown.BlackOutline2 = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutline2.Name = "BlackLine"
                    dropdown.BlackOutline2.ZIndex = 4
                    dropdown.BlackOutline2.Size = dropdown.Main.Size + UDim2.fromOffset(6, 6)
                    dropdown.BlackOutline2.BorderSizePixel = 0
                    dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    dropdown.Outline = Instance.new("Frame", dropdown.Main)
                    dropdown.Outline.Name = "BlackLine"
                    dropdown.Outline.ZIndex = 4
                    dropdown.Outline.Size = dropdown.Main.Size + UDim2.fromOffset(4, 4)
                    dropdown.Outline.BorderSizePixel = 0
                    dropdown.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                    dropdown.Outline.Position = UDim2.fromOffset(-2, -2)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.Outline.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    dropdown.BlackOutline = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutline.Name = "BlackLine"
                    dropdown.BlackOutline.ZIndex = 4
                    dropdown.BlackOutline.Size = dropdown.Main.Size + UDim2.fromOffset(2, 2)
                    dropdown.BlackOutline.BorderSizePixel = 0
                    dropdown.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    dropdown.ItemsFrame = Instance.new("ScrollingFrame", dropdown.Main)
                    dropdown.ItemsFrame.Name = "itemsframe"
                    dropdown.ItemsFrame.BorderSizePixel = 0
                    dropdown.ItemsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    dropdown.ItemsFrame.Position = UDim2.fromOffset(0, dropdown.Main.Size.Y.Offset + 8)
                    dropdown.ItemsFrame.ScrollBarThickness = 2
                    dropdown.ItemsFrame.ZIndex = 8
                    dropdown.ItemsFrame.ScrollingDirection = "Y"
                    dropdown.ItemsFrame.Visible = false
                    dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.Main.AbsoluteSize.X, 0)
    
                    dropdown.ListLayout = Instance.new("UIListLayout", dropdown.ItemsFrame)
                    dropdown.ListLayout.FillDirection = Enum.FillDirection.Vertical
                    dropdown.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
                    dropdown.ListPadding = Instance.new("UIPadding", dropdown.ItemsFrame)
                    dropdown.ListPadding.PaddingTop = UDim.new(0, 2)
                    dropdown.ListPadding.PaddingBottom = UDim.new(0, 2)
                    dropdown.ListPadding.PaddingLeft = UDim.new(0, 2)
                    dropdown.ListPadding.PaddingRight = UDim.new(0, 2)
    
                    dropdown.BlackOutline2Items = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutline2Items.Name = "BlackLine"
                    dropdown.BlackOutline2Items.ZIndex = 7
                    dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                    dropdown.BlackOutline2Items.BorderSizePixel = 0
                    dropdown.BlackOutline2Items.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutline2Items.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-3, -3)
                    dropdown.BlackOutline2Items.Visible = false
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutline2Items.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
                    
                    dropdown.OutlineItems = Instance.new("Frame", dropdown.Main)
                    dropdown.OutlineItems.Name = "BlackLine"
                    dropdown.OutlineItems.ZIndex = 7
                    dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                    dropdown.OutlineItems.BorderSizePixel = 0
                    dropdown.OutlineItems.BackgroundColor3 = Window.Theme.OutlineColor
                    dropdown.OutlineItems.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-2, -2)
                    dropdown.OutlineItems.Visible = false
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.OutlineItems.BackgroundColor3 = Theme.OutlineColor
                    end)
    
                    dropdown.BlackOutlineItems = Instance.new("Frame", dropdown.Main)
                    dropdown.BlackOutlineItems.Name = "BlackLine"
                    dropdown.BlackOutlineItems.ZIndex = 7
                    dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(-2, -2)
                    dropdown.BlackOutlineItems.BorderSizePixel = 0
                    dropdown.BlackOutlineItems.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    dropdown.BlackOutlineItems.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-1, -1)
                    dropdown.BlackOutlineItems.Visible = false
                    Instance.new("BindableEvent").Event:Connect(function(Theme)
                        dropdown.BlackOutlineItems.BackgroundColor3 = Theme.SecondOutlineColor
                    end)
    
                    dropdown.IgnoreBackButtons = Instance.new("TextButton", dropdown.Main)
                    dropdown.IgnoreBackButtons.BackgroundTransparency = 1
                    dropdown.IgnoreBackButtons.BorderSizePixel = 0
                    dropdown.IgnoreBackButtons.Position = UDim2.fromOffset(0, dropdown.Main.Size.Y.Offset + 8)
                    dropdown.IgnoreBackButtons.Size = UDim2.new(0, 0, 0, 0)
                    dropdown.IgnoreBackButtons.ZIndex = 7
                    dropdown.IgnoreBackButtons.Text = ""
                    dropdown.IgnoreBackButtons.Visible = false
                    dropdown.IgnoreBackButtons.AutoButtonColor = false

                    if dropdown.flag and dropdown.flag ~= "" then
                        Library.Flags[dropdown.flag] = dropdown.multichoice and { dropdown.default or dropdown.defaultitems[1] or "" } or (dropdown.default or dropdown.defaultitems[1] or "")
                    end

                    function dropdown:isSelected(item)
                        for i, v in pairs(dropdown.values) do
                            if v == item then
                                return true
                            end
                        end
                        return false
                    end
    
                    function dropdown:updateText(text)
                        if #text >= 27 then
                            text = text:sub(1, 25) .. ".."
                        end
                        dropdown.SelectedLabel.Text = text
                    end
    
                    dropdown.Changed = Instance.new("BindableEvent")
                    function dropdown:Set(value)
                        if type(value) == "table" then
                            dropdown.values = value
                            dropdown:updateText(table.concat(value, ", "))
                            pcall(dropdown.callback, value)
                        else
                            dropdown:updateText(value)
                            dropdown.values = { value }
                            pcall(dropdown.callback, value)
                        end
                        
                        dropdown.Changed:Fire(value)
                        if dropdown.flag and dropdown.flag ~= "" then
                            Library.Flags[dropdown.flag] = dropdown.multichoice and dropdown.values or dropdown.values[1]
                        end
                    end
    
                    function dropdown:Get()
                        return dropdown.multichoice and dropdown.values or dropdown.values[1]
                    end
    
                    dropdown.Items = { }
                    function dropdown:Add(v)
                        local Item = Instance.new("TextButton", dropdown.ItemsFrame)
                        Item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Item.BorderSizePixel = 0
                        Item.Position = UDim2.fromOffset(0, 0)
                        Item.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset - 4, 20)
                        Item.ZIndex = 9
                        Item.Text = v
                        Item.Name = v
                        Item.AutoButtonColor = false
                        Item.Font = Window.Theme.Font
                        Item.TextSize = 15
                        Item.TextXAlignment = Enum.TextXAlignment.Left
                        Item.TextStrokeTransparency = 1
                        dropdown.ItemsFrame.CanvasSize = dropdown.ItemsFrame.CanvasSize + UDim2.fromOffset(0, Item.AbsoluteSize.Y)
    
                        Item.MouseButton1Down:Connect(function()
                            if dropdown.multichoice then
                                if dropdown:isSelected(v) then
                                    for i2, v2 in pairs(dropdown.values) do
                                        if v2 == v then
                                            table.remove(dropdown.values, i2)
                                        end
                                    end
                                    dropdown:Set(dropdown.values)
                                else
                                    table.insert(dropdown.values, v)
                                    dropdown:Set(dropdown.values)
                                end
    
                                return
                            else
                                dropdown.Nav.Rotation = 90
                                dropdown.ItemsFrame.Visible = false
                                dropdown.ItemsFrame.Active = false
                                dropdown.OutlineItems.Visible = false
                                dropdown.BlackOutlineItems.Visible = false
                                dropdown.BlackOutline2Items.Visible = false
                                dropdown.IgnoreBackButtons.Visible = false
                                dropdown.IgnoreBackButtons.Active = false
                            end
    
                            dropdown:Set(v)
                            return
                        end)
    
                        game:GetService("RunService").RenderStepped:Connect(function()
                            if dropdown.multichoice and dropdown:isSelected(v) or dropdown.values[1] == v then
                                Item.BackgroundColor3 = Color3.fromRGB(64, 64, 64)
                                Item.TextColor3 = Window.Theme.AccentColor
                                Item.Text = " " .. v
                            else
                                Item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                                Item.Text = v
                            end
                        end)
    
                        table.insert(dropdown.Items, v)
                        dropdown.ItemsFrame.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset, math.clamp(#dropdown.Items * Item.AbsoluteSize.Y, 20, 156) + 4)
                        dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.ItemsFrame.AbsoluteSize.X, (#dropdown.Items * Item.AbsoluteSize.Y) + 4)
    
                        dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                        dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(2, 2)
                        dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                        dropdown.IgnoreBackButtons.Size = dropdown.ItemsFrame.Size
                    end
    
                    function dropdown:Remove(value)
                        local item = dropdown.ItemsFrame:FindFirstChild(value)
                        if item then
                            for i,v in pairs(dropdown.Items) do
                                if v == value then
                                    table.remove(dropdown.Items, i)
                                end
                            end
    
                            dropdown.ItemsFrame.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset, math.clamp(#dropdown.Items * item.AbsoluteSize.Y, 20, 156) + 4)
                            dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.ItemsFrame.AbsoluteSize.X, (#dropdown.Items * item.AbsoluteSize.Y) + 4)
        
                            dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(2, 2)
                            dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                            dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                            dropdown.IgnoreBackButtons.Size = dropdown.ItemsFrame.Size
    
                            item:Remove()
                        end
                    end 
    
                    for i,v in pairs(dropdown.defaultitems) do
                        dropdown:Add(v)
                    end
    
                    if dropdown.default then
                        dropdown:Set(dropdown.default)
                    end
    
                    local MouseButton1Down = function()
                        if dropdown.Nav.Rotation == 90 then
                            dropdown.ItemsFrame.ScrollingEnabled = true
                            sector.Main.Parent.ScrollingEnabled = false
                            game:GetService("TweenService"):Create(dropdown.Nav, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { Rotation = -90 }):Play()
                            dropdown.ItemsFrame.Visible = true
                            dropdown.ItemsFrame.Active = true
                            dropdown.IgnoreBackButtons.Visible = true
                            dropdown.IgnoreBackButtons.Active = true
                            dropdown.OutlineItems.Visible = true
                            dropdown.BlackOutlineItems.Visible = true
                            dropdown.BlackOutline2Items.Visible = true
                        else
                            dropdown.ItemsFrame.ScrollingEnabled = false
                            sector.Main.Parent.ScrollingEnabled = true
                            game:GetService("TweenService"):Create(dropdown.Nav, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { Rotation = 90 }):Play()
                            dropdown.ItemsFrame.Visible = false
                            dropdown.ItemsFrame.Active = false
                            dropdown.IgnoreBackButtons.Visible = false
                            dropdown.IgnoreBackButtons.Active = false
                            dropdown.OutlineItems.Visible = false
                            dropdown.BlackOutlineItems.Visible = false
                            dropdown.BlackOutline2Items.Visible = false
                        end
                    end
    
                    dropdown.Main.MouseButton1Down:Connect(MouseButton1Down)
                    dropdown.Nav.MouseButton1Down:Connect(MouseButton1Down)
    
                    dropdown.BlackOutline2.MouseEnter:Connect(function()
                        dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                    end)
                    dropdown.BlackOutline2.MouseLeave:Connect(function()
                        dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                    end)
    
                    sector:FixSize()
                    table.insert(Library.Items, dropdown)
                    return dropdown
                end

                local dragging_selector = false
                local dragging_hue = false

                colorpicker.selector.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging_selector = true
                        colorpicker:RefreshSelector()
                    end
                end)

                colorpicker.selector.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging_selector = false
                        colorpicker:RefreshSelector()
                    end
                end)

                colorpicker.hue.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging_hue = true
                        colorpicker:RefreshHue()
                    end
                end)

                colorpicker.hue.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging_hue = false
                        colorpicker:RefreshHue()
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(Input)
                    if dragging_selector and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        colorpicker:RefreshSelector()
                    end
                    if dragging_hue and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        colorpicker:RefreshHue()
                    end
                end)

                local inputBegan = function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        for i,v in pairs(Window.OpenedColorPickers) do
                            if v and i ~= colorpicker.MainPicker then
                                i.Visible = false
                                Window.OpenedColorPickers[i] = false
                            end
                        end

                        colorpicker.MainPicker.Visible = not colorpicker.MainPicker.Visible
                        Window.OpenedColorPickers[colorpicker.MainPicker] = colorpicker.MainPicker.Visible
                        if Window.OpenedColorPickers[colorpicker.MainPicker] then
                            colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                        else
                            colorpicker.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                        end
                    end
                end

                colorpicker.Main.InputBegan:Connect(inputBegan)
                colorpicker.Outline.InputBegan:Connect(inputBegan)
                colorpicker.BlackOutline2.InputBegan:Connect(inputBegan)

                sector:FixSize()
                table.insert(Library.Items, colorpicker)
                return colorpicker
            end

            function sector:AddKeybind(text,default,newkeycallback,callback,flag)
                local keybind = { }

                keybind.text = text or ""
                keybind.default = default or "None"
                keybind.callback = callback or function() end
                keybind.newkeycallback = newkeycallback or function(key) end
                keybind.flag = flag or text or ""

                keybind.value = keybind.default

                keybind.Main = Instance.new("TextLabel", sector.Items)
                keybind.Main.BackgroundTransparency = 1
                keybind.Main.Size = UDim2.fromOffset(156, 10)
                keybind.Main.ZIndex = 4
                keybind.Main.Font = Window.Theme.Font
                keybind.Main.Text = keybind.text
                keybind.Main.TextColor3 = Window.Theme.ItemsColor
                keybind.Main.TextSize = 15
                keybind.Main.TextStrokeTransparency = 1
                keybind.Main.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    keybind.Main.Font = Theme.Font
                    keybind.Main.TextColor3 = Theme.ItemsColor
                end)

                keybind.Bind = Instance.new("TextButton", keybind.Main)
                keybind.Bind.Name = "keybind"
                keybind.Bind.BackgroundTransparency = 1
                keybind.Bind.BorderColor3 = Window.Theme.OutlineColor
                keybind.Bind.ZIndex = 5
                keybind.Bind.BorderSizePixel = 0
                keybind.Bind.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 10, 0)
                keybind.Bind.Font = Window.Theme.Font
                keybind.Bind.TextColor3 = Color3.fromRGB(136, 136, 136)
                keybind.Bind.TextSize = 15
                keybind.Bind.TextXAlignment = Enum.TextXAlignment.Right
                keybind.Bind.MouseButton1Down:Connect(function()
                    keybind.Bind.Text = "[...]"
                    keybind.Bind.TextColor3 = Window.Theme.AccentColor
                end)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    keybind.Bind.BorderColor3 = Theme.OutlineColor
                    keybind.Bind.Font = Theme.Font
                end)

                if keybind.flag and keybind.flag ~= "" then
                    Library.Flags[keybind.flag] = keybind.default
                end

                local shorter_keycodes = {
                    ["LeftShift"] = "LSHIFT",
                    ["RightShift"] = "RSHIFT",
                    ["LeftControl"] = "LCTRL",
                    ["RightControl"] = "RCTRL",
                    ["LeftAlt"] = "LALT",
                    ["RightAlt"] = "RALT"
                }

                function keybind:Set(value)
                    if value == "None" then
                        keybind.value = value
                        keybind.Bind.Text = "[" .. value .. "]"
    
                        local Size = game:GetService("TextService"):GetTextSize(keybind.Bind.Text, keybind.Bind.TextSize, keybind.Bind.Font, Vector2.new(2000, 2000))
                        keybind.Bind.Size = UDim2.fromOffset(Size.X, Size.Y)
                        keybind.Bind.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 10 - keybind.Bind.AbsoluteSize.X, 0)
                        if keybind.flag and keybind.flag ~= "" then
                            Library.Flags[keybind.flag] = value
                        end
                        pcall(keybind.newkeycallback, value)
                    end

                    keybind.value = value
                    keybind.Bind.Text = "[" .. (shorter_keycodes[value.Name or value] or (value.Name or value)) .. "]"

                    local Size = game:GetService("TextService"):GetTextSize(keybind.Bind.Text, keybind.Bind.TextSize, keybind.Bind.Font, Vector2.new(2000, 2000))
                    keybind.Bind.Size = UDim2.fromOffset(Size.X, Size.Y)
                    keybind.Bind.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 10 - keybind.Bind.AbsoluteSize.X, 0)
                    if keybind.flag and keybind.flag ~= "" then
                        Library.Flags[keybind.flag] = value
                    end
                    pcall(keybind.newkeycallback, value)
                end
                keybind:Set(keybind.default and keybind.default or "None")

                function keybind:Get()
                    return keybind.value
                end

                game:GetService("UserInputService").InputBegan:Connect(function(Input, gameProcessed)
                    if not gameProcessed then
                        if keybind.Bind.Text == "[...]" then
                            keybind.Bind.TextColor3 = Color3.fromRGB(136, 136, 136)
                            if Input.UserInputType == Enum.UserInputType.Keyboard then
                                keybind:Set(Input.KeyCode)
                            else
                                keybind:Set("None")
                            end
                        else
                            if keybind.value ~= "None" and Input.KeyCode == keybind.value then
                                pcall(keybind.callback)
                            end
                        end
                    end
                end)

                sector:FixSize()
                table.insert(Library.Items, keybind)
                return keybind
            end

            function sector:AddDropdown(text, Items, default, multichoice, callback, flag)
                local dropdown = { }

                dropdown.text = text or ""
                dropdown.defaultitems = Items or { }
                dropdown.default = default
                dropdown.callback = callback or function() end
                dropdown.multichoice = multichoice or false
                dropdown.values = { }
                dropdown.flag = flag or text or ""

                dropdown.MainBack = Instance.new("Frame", sector.Items)
                dropdown.MainBack.Name = "backlabel"
                dropdown.MainBack.ZIndex = 7
                dropdown.MainBack.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 34)
                dropdown.MainBack.BorderSizePixel = 0
                dropdown.MainBack.BackgroundTransparency = 1

                dropdown.Label = Instance.new("TextLabel", dropdown.MainBack)
                dropdown.Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.Label.BackgroundTransparency = 1
                dropdown.Label.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 10)
                dropdown.Label.Position = UDim2.fromOffset(0, 0)
                dropdown.Label.Font = Window.Theme.Font
                dropdown.Label.Text = dropdown.text
                dropdown.Label.ZIndex = 4
                dropdown.Label.TextColor3 = Window.Theme.ItemsColor
                dropdown.Label.TextSize = 15
                dropdown.Label.TextStrokeTransparency = 1
                dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left

                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.Label.Font = Theme.Font
                    dropdown.Label.TextColor3 = Theme.ItemsColor
                end)

                dropdown.Main = Instance.new("TextButton", dropdown.MainBack)
                dropdown.Main.Name = "dropdown"
                dropdown.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.Main.BorderSizePixel = 0
                dropdown.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 16)
                dropdown.Main.Position = UDim2.fromOffset(0, 17)
                dropdown.Main.ZIndex = 5
                dropdown.Main.AutoButtonColor = false
                dropdown.Main.Font = Window.Theme.Font
                dropdown.Main.Text = ""
                dropdown.Main.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.Main.TextSize = 15
                dropdown.Main.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.Main.Font = Theme.Font
                end)

                dropdown.Gradient = Instance.new("UIGradient", dropdown.Main)
                dropdown.Gradient.Rotation = 90
                dropdown.Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(49, 49, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))}

                dropdown.SelectedLabel = Instance.new("TextLabel", dropdown.Main)
                dropdown.SelectedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.SelectedLabel.BackgroundTransparency = 1
                dropdown.SelectedLabel.Position = UDim2.fromOffset(5, 2)
                dropdown.SelectedLabel.Size = UDim2.fromOffset(130, 13)
                dropdown.SelectedLabel.Font = Window.Theme.Font
                dropdown.SelectedLabel.Text = dropdown.text
                dropdown.SelectedLabel.ZIndex = 5
                dropdown.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.SelectedLabel.TextSize = 15
                dropdown.SelectedLabel.TextStrokeTransparency = 1
                dropdown.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.SelectedLabel.Font = Theme.Font
                end)

                dropdown.Nav = Instance.new("ImageButton", dropdown.Main)
                dropdown.Nav.Name = "navigation"
                dropdown.Nav.BackgroundTransparency = 1
                dropdown.Nav.LayoutOrder = 10
                dropdown.Nav.Position = UDim2.fromOffset(sector.Main.Size.X.Offset - 26, 5)
                dropdown.Nav.Rotation = 90
                dropdown.Nav.ZIndex = 5
                dropdown.Nav.Size = UDim2.fromOffset(8, 8)
                dropdown.Nav.Image = "rbxassetid://4918373417"
                dropdown.Nav.ImageColor3 = Color3.fromRGB(210, 210, 210)

                dropdown.BlackOutline2 = Instance.new("Frame", dropdown.Main)
                dropdown.BlackOutline2.Name = "BlackLine"
                dropdown.BlackOutline2.ZIndex = 4
                dropdown.BlackOutline2.Size = dropdown.Main.Size + UDim2.fromOffset(6, 6)
                dropdown.BlackOutline2.BorderSizePixel = 0
                dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                dropdown.BlackOutline2.Position = UDim2.fromOffset(-3, -3)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.BlackOutline2.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                dropdown.Outline = Instance.new("Frame", dropdown.Main)
                dropdown.Outline.Name = "BlackLine"
                dropdown.Outline.ZIndex = 4
                dropdown.Outline.Size = dropdown.Main.Size + UDim2.fromOffset(4, 4)
                dropdown.Outline.BorderSizePixel = 0
                dropdown.Outline.BackgroundColor3 = Window.Theme.OutlineColor
                dropdown.Outline.Position = UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.Outline.BackgroundColor3 = Theme.OutlineColor
                end)

                dropdown.BlackOutline = Instance.new("Frame", dropdown.Main)
                dropdown.BlackOutline.Name = "BlackLine"
                dropdown.BlackOutline.ZIndex = 4
                dropdown.BlackOutline.Size = dropdown.Main.Size + UDim2.fromOffset(2, 2)
                dropdown.BlackOutline.BorderSizePixel = 0
                dropdown.BlackOutline.BackgroundColor3 = Window.Theme.SecondOutlineColor
                dropdown.BlackOutline.Position = UDim2.fromOffset(-1, -1)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.BlackOutline.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                dropdown.ItemsFrame = Instance.new("ScrollingFrame", dropdown.Main)
                dropdown.ItemsFrame.Name = "itemsframe"
                dropdown.ItemsFrame.BorderSizePixel = 0
                dropdown.ItemsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                dropdown.ItemsFrame.Position = UDim2.fromOffset(0, dropdown.Main.Size.Y.Offset + 8)
                dropdown.ItemsFrame.ScrollBarThickness = 2
                dropdown.ItemsFrame.ZIndex = 8
                dropdown.ItemsFrame.ScrollingDirection = "Y"
                dropdown.ItemsFrame.Visible = false
                dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.Main.AbsoluteSize.X, 0)

                dropdown.ListLayout = Instance.new("UIListLayout", dropdown.ItemsFrame)
                dropdown.ListLayout.FillDirection = Enum.FillDirection.Vertical
                dropdown.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

                dropdown.ListPadding = Instance.new("UIPadding", dropdown.ItemsFrame)
                dropdown.ListPadding.PaddingTop = UDim.new(0, 2)
                dropdown.ListPadding.PaddingBottom = UDim.new(0, 2)
                dropdown.ListPadding.PaddingLeft = UDim.new(0, 2)
                dropdown.ListPadding.PaddingRight = UDim.new(0, 2)

                dropdown.BlackOutline2Items = Instance.new("Frame", dropdown.Main)
                dropdown.BlackOutline2Items.Name = "BlackLine"
                dropdown.BlackOutline2Items.ZIndex = 7
                dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                dropdown.BlackOutline2Items.BorderSizePixel = 0
                dropdown.BlackOutline2Items.BackgroundColor3 = Window.Theme.SecondOutlineColor
                dropdown.BlackOutline2Items.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-3, -3)
                dropdown.BlackOutline2Items.Visible = false
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.BlackOutline2Items.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                dropdown.OutlineItems = Instance.new("Frame", dropdown.Main)
                dropdown.OutlineItems.Name = "BlackLine"
                dropdown.OutlineItems.ZIndex = 7
                dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                dropdown.OutlineItems.BorderSizePixel = 0
                dropdown.OutlineItems.BackgroundColor3 = Window.Theme.OutlineColor
                dropdown.OutlineItems.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-2, -2)
                dropdown.OutlineItems.Visible = false
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.OutlineItems.BackgroundColor3 = Theme.OutlineColor
                end)

                dropdown.BlackOutlineItems = Instance.new("Frame", dropdown.Main)
                dropdown.BlackOutlineItems.Name = "BlackLine"
                dropdown.BlackOutlineItems.ZIndex = 7
                dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(-2, -2)
                dropdown.BlackOutlineItems.BorderSizePixel = 0
                dropdown.BlackOutlineItems.BackgroundColor3 = Window.Theme.SecondOutlineColor
                dropdown.BlackOutlineItems.Position = dropdown.ItemsFrame.Position + UDim2.fromOffset(-1, -1)
                dropdown.BlackOutlineItems.Visible = false
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    dropdown.BlackOutlineItems.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                dropdown.IgnoreBackButtons = Instance.new("TextButton", dropdown.Main)
                dropdown.IgnoreBackButtons.BackgroundTransparency = 1
                dropdown.IgnoreBackButtons.BorderSizePixel = 0
                dropdown.IgnoreBackButtons.Position = UDim2.fromOffset(0, dropdown.Main.Size.Y.Offset + 8)
                dropdown.IgnoreBackButtons.Size = UDim2.new(0, 0, 0, 0)
                dropdown.IgnoreBackButtons.ZIndex = 7
                dropdown.IgnoreBackButtons.Text = ""
                dropdown.IgnoreBackButtons.Visible = false
                dropdown.IgnoreBackButtons.AutoButtonColor = false

                if dropdown.flag and dropdown.flag ~= "" then
                    Library.Flags[dropdown.flag] = dropdown.multichoice and { dropdown.default or dropdown.defaultitems[1] or "" } or (dropdown.default or dropdown.defaultitems[1] or "")
                end

                function dropdown:isSelected(item)
                    for i, v in pairs(dropdown.values) do
                        if v == item then
                            return true
                        end
                    end
                    return false
                end

                function dropdown:GetOptions()
                    return dropdown.values
                end

                function dropdown:updateText(text)
                    if #text >= 27 then
                        text = text:sub(1, 25) .. ".."
                    end
                    dropdown.SelectedLabel.Text = text
                end

                dropdown.Changed = Instance.new("BindableEvent")
                function dropdown:Set(value)
                    if type(value) == "table" then
                        dropdown.values = value
                        dropdown:updateText(table.concat(value, ", "))
                        pcall(dropdown.callback, value)
                    else
                        dropdown:updateText(value)
                        dropdown.values = { value }
                        pcall(dropdown.callback, value)
                    end
                    
                    dropdown.Changed:Fire(value)
                    if dropdown.flag and dropdown.flag ~= "" then
                        Library.Flags[dropdown.flag] = dropdown.multichoice and dropdown.values or dropdown.values[1]
                    end
                end

                function dropdown:Get()
                    return dropdown.multichoice and dropdown.values or dropdown.values[1]
                end

                dropdown.Items = { }
                function dropdown:Add(v)
                    local Item = Instance.new("TextButton", dropdown.ItemsFrame)
                    Item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Item.BorderSizePixel = 0
                    Item.Position = UDim2.fromOffset(0, 0)
                    Item.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset - 4, 20)
                    Item.ZIndex = 9
                    Item.Text = v
                    Item.Name = v
                    Item.AutoButtonColor = false
                    Item.Font = Window.Theme.Font
                    Item.TextSize = 15
                    Item.TextXAlignment = Enum.TextXAlignment.Left
                    Item.TextStrokeTransparency = 1
                    dropdown.ItemsFrame.CanvasSize = dropdown.ItemsFrame.CanvasSize + UDim2.fromOffset(0, Item.AbsoluteSize.Y)

                    Item.MouseButton1Down:Connect(function()
                        if dropdown.multichoice then
                            if dropdown:isSelected(v) then
                                for i2, v2 in pairs(dropdown.values) do
                                    if v2 == v then
                                        table.remove(dropdown.values, i2)
                                    end
                                end
                                dropdown:Set(dropdown.values)
                            else
                                table.insert(dropdown.values, v)
                                dropdown:Set(dropdown.values)
                            end

                            return
                        else
                            dropdown.Nav.Rotation = 90
                            dropdown.ItemsFrame.Visible = false
                            dropdown.ItemsFrame.Active = false
                            dropdown.OutlineItems.Visible = false
                            dropdown.BlackOutlineItems.Visible = false
                            dropdown.BlackOutline2Items.Visible = false
                            dropdown.IgnoreBackButtons.Visible = false
                            dropdown.IgnoreBackButtons.Active = false
                        end

                        dropdown:Set(v)
                        return
                    end)

                    game:GetService("RunService").RenderStepped:Connect(function()
                        if dropdown.multichoice and dropdown:isSelected(v) or dropdown.values[1] == v then
                            Item.BackgroundColor3 = Color3.fromRGB(64, 64, 64)
                            Item.TextColor3 = Window.Theme.AccentColor
                            Item.Text = " " .. v
                        else
                            Item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                            Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                            Item.Text = v
                        end
                    end)

                    table.insert(dropdown.Items, v)
                    dropdown.ItemsFrame.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset, math.clamp(#dropdown.Items * Item.AbsoluteSize.Y, 20, 156) + 4)
                    dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.ItemsFrame.AbsoluteSize.X, (#dropdown.Items * Item.AbsoluteSize.Y) + 4)

                    dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                    dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(2, 2)
                    dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                    dropdown.IgnoreBackButtons.Size = dropdown.ItemsFrame.Size
                end

                function dropdown:Remove(value)
                    local item = dropdown.ItemsFrame:FindFirstChild(value)
                    if item then
                        for i,v in pairs(dropdown.Items) do
                            if v == value then
                                table.remove(dropdown.Items, i)
                            end
                        end

                        dropdown.ItemsFrame.Size = UDim2.fromOffset(dropdown.Main.Size.X.Offset, math.clamp(#dropdown.Items * item.AbsoluteSize.Y, 20, 156) + 4)
                        dropdown.ItemsFrame.CanvasSize = UDim2.fromOffset(dropdown.ItemsFrame.AbsoluteSize.X, (#dropdown.Items * item.AbsoluteSize.Y) + 4)
    
                        dropdown.OutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(2, 2)
                        dropdown.BlackOutlineItems.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(4, 4)
                        dropdown.BlackOutline2Items.Size = dropdown.ItemsFrame.Size + UDim2.fromOffset(6, 6)
                        dropdown.IgnoreBackButtons.Size = dropdown.ItemsFrame.Size

                        item:Remove()
                    end
                end 

                for i,v in pairs(dropdown.defaultitems) do
                    dropdown:Add(v)
                end

                if dropdown.default then
                    dropdown:Set(dropdown.default)
                end

                local MouseButton1Down = function()
                    if dropdown.Nav.Rotation == 90 then
                        game:GetService("TweenService"):Create(dropdown.Nav, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { Rotation = -90 }):Play()
                        if dropdown.Items and #dropdown.Items ~= 0 then
                            dropdown.ItemsFrame.ScrollingEnabled = true
                            sector.Main.Parent.ScrollingEnabled = false
                            dropdown.ItemsFrame.Visible = true
                            dropdown.ItemsFrame.Active = true
                            dropdown.IgnoreBackButtons.Visible = true
                            dropdown.IgnoreBackButtons.Active = true
                            dropdown.OutlineItems.Visible = true
                            dropdown.BlackOutlineItems.Visible = true
                            dropdown.BlackOutline2Items.Visible = true
                        end
                    else
                        game:GetService("TweenService"):Create(dropdown.Nav, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { Rotation = 90 }):Play()
                        dropdown.ItemsFrame.ScrollingEnabled = false
                        sector.Main.Parent.ScrollingEnabled = true
                        dropdown.ItemsFrame.Visible = false
                        dropdown.ItemsFrame.Active = false
                        dropdown.IgnoreBackButtons.Visible = false
                        dropdown.IgnoreBackButtons.Active = false
                        dropdown.OutlineItems.Visible = false
                        dropdown.BlackOutlineItems.Visible = false
                        dropdown.BlackOutline2Items.Visible = false
                    end
                end

                dropdown.Main.MouseButton1Down:Connect(MouseButton1Down)
                dropdown.Nav.MouseButton1Down:Connect(MouseButton1Down)

                dropdown.BlackOutline2.MouseEnter:Connect(function()
                    dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.AccentColor
                end)
                dropdown.BlackOutline2.MouseLeave:Connect(function()
                    dropdown.BlackOutline2.BackgroundColor3 = Window.Theme.SecondOutlineColor
                end)

                sector:FixSize()
                table.insert(Library.Items, dropdown)
                return dropdown
            end

            function sector:AddSeperator(text)
                local seperator = { }
                seperator.text = text or ""

                seperator.Main = Instance.new("Frame", sector.Items)
                seperator.Main.Name = "Main"
                seperator.Main.ZIndex = 5
                seperator.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 10)
                seperator.Main.BorderSizePixel = 0
                seperator.Main.BackgroundTransparency = 1

                seperator.Line = Instance.new("Frame", seperator.Main)
                seperator.Line.Name = "Line"
                seperator.Line.ZIndex = 7
                seperator.Line.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                seperator.Line.BorderSizePixel = 0
                seperator.Line.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 26, 1)
                seperator.Line.Position = UDim2.fromOffset(7, 5)

                seperator.OutLine = Instance.new("Frame", seperator.Line)
                seperator.OutLine.Name = "Outline"
                seperator.OutLine.ZIndex = 6
                seperator.OutLine.BorderSizePixel = 0
                seperator.OutLine.BackgroundColor3 = Window.Theme.SecondOutlineColor
                seperator.OutLine.Position = UDim2.fromOffset(-1, -1)
                seperator.OutLine.Size = seperator.Line.Size - UDim2.fromOffset(-2, -2)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    seperator.OutLine.BackgroundColor3 = Theme.SecondOutlineColor
                end)

                seperator.label = Instance.new("TextLabel", seperator.Main)
                seperator.label.Name = "Label"
                seperator.label.BackgroundTransparency = 1
                seperator.label.Size = seperator.Main.Size
                seperator.label.Font = Window.Theme.Font
                seperator.label.ZIndex = 8
                seperator.label.Text = seperator.text
                seperator.label.TextColor3 = Color3.fromRGB(255, 255, 255)
                seperator.label.TextSize = Window.Theme.FontSize
                seperator.label.TextStrokeTransparency = 1
                seperator.label.TextXAlignment = Enum.TextXAlignment.Center
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    seperator.label.Font = Theme.Font
                    seperator.label.TextSize = Theme.FontSize
                end)

                local textSize = game:GetService("TextService"):GetTextSize(seperator.text, Window.Theme.FontSize, Window.Theme.Font, Vector2.new(2000, 2000))
                local textStart = seperator.Main.AbsoluteSize.X / 2 - (textSize.X / 2)

                sector.LabelBackFrame = Instance.new("Frame", seperator.Main)
                sector.LabelBackFrame.Name = "LabelBack"
                sector.LabelBackFrame.ZIndex = 7
                sector.LabelBackFrame.Size = UDim2.fromOffset(textSize.X + 12, 10)
                sector.LabelBackFrame.BorderSizePixel = 0
                sector.LabelBackFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                sector.LabelBackFrame.Position = UDim2.new(0, textStart - 6, 0, 0)
                Instance.new("BindableEvent").Event:Connect(function(Theme)
                    textSize = game:GetService("TextService"):GetTextSize(seperator.text, Theme.FontSize, Theme.Font, Vector2.new(2000, 2000))
                    textStart = seperator.Main.AbsoluteSize.X / 2 - (textSize.X / 2)

                    sector.LabelBackFrame.Size = UDim2.fromOffset(textSize.X + 12, 10)
                    sector.LabelBackFrame.Position = UDim2.new(0, textStart - 6, 0, 0)
                end)

                sector:FixSize()
                return seperator
            end

            return sector
        end

        function Tab:CreateConfigSystem(side)
            local configSystem = { }

            configSystem.configFolder = Window.Name .. "/" .. tostring(game.PlaceId)
            if (not isfolder(configSystem.configFolder)) then
                makefolder(configSystem.configFolder)
            end

            configSystem.sector = Tab:CreateSector("Configs", side or "left")

            local ConfigName = configSystem.sector:AddTextbox("Config Name", "", ConfigName, function() end, "")
            local default = tostring(listfiles(configSystem.configFolder)[1] or ""):gsub(configSystem.configFolder .. "\\", ""):gsub(".txt", "")
            local Config = configSystem.sector:AddDropdown("Configs", {}, default, false, function() end, "")
            for i,v in pairs(listfiles(configSystem.configFolder)) do
                if v:find(".txt") then
                    Config:Add(tostring(v):gsub(configSystem.configFolder .. "\\", ""):gsub(".txt", ""))
                end
            end

            configSystem.Create = configSystem.sector:AddButton("Create", function()
                for i,v in pairs(listfiles(configSystem.configFolder)) do
                    Config:Remove(tostring(v):gsub(configSystem.configFolder .. "\\", ""):gsub(".txt", ""))
                end

                if ConfigName:Get() and ConfigName:Get() ~= "" then
                    local config = {}
    
                    for i,v in pairs(Library.Flags) do
                        if (v ~= nil and v ~= "") then
                            if (typeof(v) == "Color3") then
                                config[i] = { v.R, v.G, v.B }
                            elseif (tostring(v):find("Enum.KeyCode")) then
                                config[i] = v.Name
                            elseif (typeof(v) == "table") then
                                config[i] = { v }
                            else
                                config[i] = v
                            end
                        end
                    end
    
                    writefile(configSystem.configFolder .. "/" .. ConfigName:Get() .. ".txt", game:GetService("HttpService"):JSONEncode(config))
    
                    for i,v in pairs(listfiles(configSystem.configFolder)) do
                        if v:find(".txt") then
                            Config:Add(tostring(v):gsub(configSystem.configFolder .. "\\", ""):gsub(".txt", ""))
                        end
                    end
                end
            end)

            configSystem.Save = configSystem.sector:AddButton("Save", function()
                local config = {}
                if Config:Get() and Config:Get() ~= "" then
                    for i,v in pairs(Library.Flags) do
                        if (v ~= nil and v ~= "") then
                            if (typeof(v) == "Color3") then
                                config[i] = { v.R, v.G, v.B }
                            elseif (tostring(v):find("Enum.KeyCode")) then
                                config[i] = "Enum.KeyCode." .. v.Name
                            elseif (typeof(v) == "table") then
                                config[i] = { v }
                            else
                                config[i] = v
                            end
                        end
                    end

                    configSystem.configFolderMainMenu = Window.Name .. "/" .. tostring("1730877806")
                    if (not isfolder(configSystem.configFolderMainMenu)) then
                        makefolder(configSystem.configFolderMainMenu)
                    end
                    writefile(configSystem.configFolder .. "/" .. Config:Get() .. ".txt", game:GetService("HttpService"):JSONEncode(config))
                    writefile(configSystem.configFolderMainMenu .. "/" .. Config:Get() .. ".txt", game:GetService("HttpService"):JSONEncode(config))
                end
            end)

            configSystem.Load = configSystem.sector:AddButton("Load", function()
                local Success = pcall(readfile, configSystem.configFolder .. "/" .. Config:Get() .. ".txt")
                if (Success) then
                    pcall(function() 
                        local ReadConfig = game:GetService("HttpService"):JSONDecode(readfile(configSystem.configFolder .. "/" .. Config:Get() .. ".txt"))
                        local NewConfig = {}
    
                        for i,v in pairs(ReadConfig) do
                            if (typeof(v) == "table") then
                                if (typeof(v[1]) == "number") then
                                    NewConfig[i] = Color3.new(v[1], v[2], v[3])
                                elseif (typeof(v[1]) == "table") then
                                    NewConfig[i] = v[1]
                                end
                            elseif (tostring(v):find("Enum.KeyCode.")) then
                                NewConfig[i] = Enum.KeyCode[tostring(v):gsub("Enum.KeyCode.", "")]
                            else
                                NewConfig[i] = v
                            end
                        end
    
                        Library.Flags = NewConfig
    
                        for i,v in pairs(Library.Flags) do
                            for i2,v2 in pairs(Library.Items) do
                                if (i ~= nil and i ~= "" and i ~= "Configs_Name" and i ~= "Configs" and v2.flag ~= nil) then
                                    if (v2.flag == i) then
                                        pcall(function() 
                                            v2:Set(v)
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                end
            end)

            configSystem.Delete = configSystem.sector:AddButton("Delete", function()
                for i,v in pairs(listfiles(configSystem.configFolder)) do
                    Config:Remove(tostring(v):gsub(configSystem.configFolder .. "\\", ""):gsub(".txt", ""))
                end

                if (not Config:Get() or Config:Get() == "") then return end
                if (not isfile(configSystem.configFolder .. "/" .. Config:Get() .. ".txt")) then return end
                delfile(configSystem.configFolder .. "/" .. Config:Get() .. ".txt")

                for i,v in pairs(listfiles(configSystem.configFolder)) do
                    if v:find(".txt") then
                        Config:Add(tostring(v):gsub(configSystem.configFolder .. "\\", ""):gsub(".txt", ""))
                    end
                end
            end)

            return configSystem
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    return Window
end

return Library
