local ESP = {
    Enabled = false,
    Boxes = true,
    BoxShift = CFrame.new(0, -1.5, 0),
    BoxSize = Vector3.new(4, 6, 0),
    Color = Color3.fromRGB(255, 255, 255),
    FaceCamera = false,
    Names = true,
    TeamColor = false,
    Thickness = 2,
    AttachShift = 1,
    TeamMates = true,
    Players = true,

    Objects = {},
    Overrides = {}
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local RenderStepped = RunService.RenderStepped
local Drawing = Drawing or loadstring(game:HttpGet("https://raw.githubusercontent.com/1ForeverHD/RbxDrawing/main/README.md"))()

local WorldToViewportPoint = Workspace.CurrentCamera.WorldToViewportPoint

local function Draw(obj, props)
    local new = Drawing.new(obj)

    props = props or {}
    for i, v in pairs(props) do
        new[i] = v
    end
    return new
end

function ESP:GetTeam(player)
    local ov = self.Overrides.GetTeam
    if ov then
        return ov(player)
    end

    return player and player.Team
end

function ESP:IsTeamMate(player)
    local ov = self.Overrides.IsTeamMate
    if ov then
        return ov(player)
    end

    return self:GetTeam(player) == self:GetTeam(LocalPlayer)
end

function ESP:GetColor(object)
    local ov = self.Overrides.GetColor
    if ov then
        return ov(object)
    end

    local player = self:GetPlrFromChar(object)
    return player and self.TeamColor and player.Team and player.Team.TeamColor.Color or self.Color
end

function ESP:GetPlrFromChar(character)
    local ov = self.Overrides.GetPlrFromChar
    if ov then
        return ov(character)
    end

    return Players:GetPlayerFromCharacter(character)
end

function ESP:Toggle(enabled)
    self.Enabled = enabled
    if not enabled then
        for _, object in pairs(self.Objects) do
            if object.Type == "Box" then
                if object.Temporary then
                    object:Remove()
                else
                    for _, component in pairs(object.Components) do
                        component.Visible = false
                    end
                end
            end
        end
    end
end

function ESP:GetBox(object)
    return self.Objects[object]
end

function ESP:AddObjectListener(parent, options)
    local function NewListener(child)
        if (type(options.Type) == "string" and child:IsA(options.Type)) or options.Type == nil then
            if (type(options.Name) == "string" and child.Name == options.Name) or options.Name == nil then
                if not options.Validator or options.Validator(child) then
                    local primaryPart = type(options.PrimaryPart) == "string" and child:WaitForChild(options.PrimaryPart) or
                                         type(options.PrimaryPart) == "function" and options.PrimaryPart(child)

                    if primaryPart then
                        local box = ESP:Add(child, {
                            PrimaryPart = primaryPart,
                            Color = type(options.Color) == "function" and options.Color(child) or options.Color,
                            ColorDynamic = options.ColorDynamic,
                            Name = type(options.CustomName) == "function" and options.CustomName(child) or options.CustomName,
                            BoxSize = type(options.BoxSize) == "function" and options.BoxSize(child) or options.BoxSize,
                            Thickness = type(options.Thickness) == "function" and options.Thickness(child) or options.Thickness
                        })

                        if options.Listener then
                            options.Listener(box, child)
                        end
                    end
                end
            end
        end
    end

    NewListener(parent)

    return parent.ChildAdded:Connect(NewListener)
end

function ESP:Add(player, options)
    if not self.Objects[player] then
        local function Calculate()
            if not player:IsDescendantOf(Workspace) then
                self:Remove(player)
                return
            end

            if not self.Enabled or not player:IsDescendantOf(Workspace) or not player:FindFirstChild("HumanoidRootPart") or not player.HumanoidRootPart:IsA("BasePart") then
                for _, component in pairs(box.Components) do
                    component.Visible = false
                end
                return
            end

            local humanoidRootPart = player.HumanoidRootPart
            local vector, visible = WorldToViewportPoint(Workspace.CurrentCamera, humanoidRootPart.Position)

            local box = self:GetBox(player)
            if not box then
                box = {
                    Components = {},
                    Type = "Box",
                    Temporary = options.Temporary or false
                }

                local boxOutline = Draw("Square", {
                    Thickness = options.Thickness or self.Thickness,
                    Transparency = 1,
                    Visible = self.Boxes,
                    Color = options.Color or self:GetColor(player),
                    Filled = false
                })
                table.insert(box.Components, boxOutline)

                local boxFill = Draw("Square", {
                    Thickness = options.Thickness or self.Thickness,
                    Transparency = 0.3,
                    Visible = self.Boxes,
                    Color = options.Color or self:GetColor(player),
                    Filled = true
                })
                table.insert(box.Components, boxFill)

                self.Objects[player] = box
            end

            local boxOutline, boxFill = box.Components[1], box.Components[2]

            if self.Boxes then
                local size = options.BoxSize or self.BoxSize
                local cf = humanoidRootPart.CFrame * (options.BoxShift or self.BoxShift)
                local topLeft, topRight, bottomLeft, bottomRight =
                    WorldToViewportPoint(Workspace.CurrentCamera, (cf * CFrame.new(size.X / 2, size.Y / 2, 0)).p),
                    WorldToViewportPoint(Workspace.CurrentCamera, (cf * CFrame.new(-size.X / 2, size.Y / 2, 0)).p),
                    WorldToViewportPoint(Workspace.CurrentCamera, (cf * CFrame.new(size.X / 2, -size.Y / 2, 0)).p),
                    WorldToViewportPoint(Workspace.CurrentCamera, (cf * CFrame.new(-size.X / 2, -size.Y / 2, 0)).p)

                if visible then
                    if self.FaceCamera then
                        boxOutline.From = Vector2.new(topLeft.X, topLeft.Y)
                        boxOutline.To = Vector2.new(topRight.X, topRight.Y)
                        boxOutline.Visible = true

                        boxOutline.From = Vector2.new(topLeft.X, topLeft.Y)
                        boxOutline.To = Vector2.new(bottomLeft.X, bottomLeft.Y)
                        boxOutline.Visible = true

                        boxOutline.From = Vector2.new(bottomLeft.X, bottomLeft.Y)
                        boxOutline.To = Vector2.new(bottomRight.X, bottomRight.Y)
                        boxOutline.Visible = true

                        boxOutline.From = Vector2.new(bottomRight.X, bottomRight.Y)
                        boxOutline.To = Vector2.new(topRight.X, topRight.Y)
                        boxOutline.Visible = true
                    else
                        boxOutline.Visible = true
                        boxOutline.From = Vector2.new(topLeft.X, topLeft.Y)
                        boxOutline.To = Vector2.new(topRight.X, topRight.Y)

                        boxOutline.Visible = true
                        boxOutline.From = Vector2.new(topRight.X, topRight.Y)
                        boxOutline.To = Vector2.new(bottomRight.X, bottomRight.Y)

                        boxOutline.Visible = true
                        boxOutline.From = Vector2.new(bottomRight.X, bottomRight.Y)
                        boxOutline.To = Vector2.new(bottomLeft.X, bottomLeft.Y)

                        boxOutline.Visible = true
                        boxOutline.From = Vector2.new(bottomLeft.X, bottomLeft.Y)
                        boxOutline.To = Vector2.new(topLeft.X, topLeft.Y)
                    end

                    boxFill.Visible = true
                    boxFill.PointA = Vector2.new(topLeft.X, topLeft.Y)
                    boxFill.PointB = Vector2.new(topRight.X, topRight.Y)
                    boxFill.PointC = Vector2.new(bottomRight.X, bottomRight.Y)
                    boxFill.PointD = Vector2.new(bottomLeft.X, bottomLeft.Y)
                else
                    boxOutline.Visible = false
                    boxFill.Visible = false
                end
            else
                boxOutline.Visible = false
                boxFill.Visible = false
            end

            local name = player.Name
            local displayName = player.DisplayName
            if self.Names then
                local text = displayName ~= name and displayName or name
                local textSize = options.TextSize or 16
                local textShift = options.TextShift or Vector2.new(0, 0)

                local textObject = Draw("Text", {
                    Position = vector + textShift,
                    Text = text,
                    Size = textSize,
                    Center = true,
                    Outline = true,
                    Color = options.Color or self:GetColor(player),
                    Visible = visible
                })
                table.insert(box.Components, textObject)
            end

            for _, component in pairs(box.Components) do
                component.Visible = self.Enabled and visible
            end
        end

        local function GetOverride(obj, name)
            local ov = self.Overrides[name]
            if ov then
                return ov(obj)
            end
        end

        local function OnCharacterAdded(character)
            if GetOverride(player, "CharacterAdded") ~= false then
                ESP:Add(character, options)
            end
        end

        local function OnCharacterRemoving(character)
            if GetOverride(player, "CharacterRemoving") ~= false then
                ESP:Remove(character)
            end
        end

        local function OnCharacterChildAdded(child)
            if GetOverride(player, "CharacterChildAdded") ~= false then
                ESP:Add(child, options)
            end
        end

        local function OnCharacterChildRemoving(child)
            if GetOverride(player, "CharacterChildRemoving") ~= false then
                ESP:Remove(child)
            end
        end

        local function OnCharacterDescendantAdded(child)
            if GetOverride(player, "CharacterDescendantAdded") ~= false then
                ESP:Add(child, options)
            end
        end

        local function OnCharacterDescendantRemoving(child)
            if GetOverride(player, "CharacterDescendantRemoving") ~= false then
                ESP:Remove(child)
            end
        end

        local function OnPlayerRemoving()
            if GetOverride(player, "PlayerRemoving") ~= false then
                ESP:Remove(player)
            end
        end

        local function OnPlayerChildAdded(child)
            if GetOverride(player, "PlayerChildAdded") ~= false then
                ESP:Add(child, options)
            end
        end

        local function OnPlayerChildRemoving(child)
            if GetOverride(player, "PlayerChildRemoving") ~= false then
                ESP:Remove(child)
            end
        end

        local function OnPlayerDescendantAdded(child)
            if GetOverride(player, "PlayerDescendantAdded") ~= false then
                ESP:Add(child, options)
            end
        end

        local function OnPlayerDescendantRemoving(child)
            if GetOverride(player, "PlayerDescendantRemoving") ~= false then
                ESP:Remove(child)
            end
        end

        local function OnCharacterPropertyChanged(property)
            if GetOverride(player, "CharacterPropertyChanged") ~= false then
                if property == "HumanoidRootPart" then
                    Calculate()
                end
            end
        end

        local function OnPlayerPropertyChanged(property)
            if GetOverride(player, "PlayerPropertyChanged") ~= false then
                if property == "Team" then
                    local box = self:GetBox(player)
                    if box then
                        for _, component in pairs(box.Components) do
                            component.Color = self:GetColor(player)
                        end
                    end
                end
            end
        end

        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                if GetOverride(player, "Died") ~= false then
                    ESP:Remove(player)
                end
            end)
        end

        if GetOverride(player, "CharacterAdded") ~= false then
            player.CharacterAdded:Connect(OnCharacterAdded)
        end

        if GetOverride(player, "CharacterRemoving") ~= false then
            player.CharacterRemoving:Connect(OnCharacterRemoving)
        end

        if GetOverride(player, "PlayerRemoving") ~= false then
            player.AncestryChanged:Connect(OnPlayerRemoving)
        end

        if GetOverride(player, "PlayerChildAdded") ~= false then
            player.ChildAdded:Connect(OnPlayerChildAdded)
        end

        if GetOverride(player, "PlayerChildRemoving") ~= false then
            player.ChildRemoving:Connect(OnPlayerChildRemoving)
        end

        if GetOverride(player, "PlayerDescendantAdded") ~= false then
            player.DescendantAdded:Connect(OnPlayerDescendantAdded)
        end

        if GetOverride(player, "PlayerDescendantRemoving") ~= false then
            player.DescendantRemoving:Connect(OnPlayerDescendantRemoving)
        end

        if GetOverride(player, "CharacterPropertyChanged") ~= false then
            player:GetPropertyChangedSignal("HumanoidRootPart"):Connect(OnCharacterPropertyChanged)
        end

        if GetOverride(player, "PlayerPropertyChanged") ~= false then
            player:GetPropertyChangedSignal("Team"):Connect(OnPlayerPropertyChanged)
        end

        if player.Character then
            if GetOverride(player, "CharacterAdded") ~= false then
                OnCharacterAdded(player.Character)
            end

            if GetOverride(player, "CharacterDescendantAdded") ~= false then
                player.Character.DescendantAdded:Connect(OnCharacterDescendantAdded)
            end

            if GetOverride(player, "CharacterDescendantRemoving") ~= false then
                player.Character.DescendantRemoving:Connect(OnCharacterDescendantRemoving)
            end
        end

        if GetOverride(player, "CharacterChildAdded") ~= false then
            player.ChildAdded:Connect(OnCharacterChildAdded)
        end

        if GetOverride(player, "CharacterChildRemoving") ~= false then
            player.ChildRemoving:Connect(OnCharacterChildRemoving)
        end

        if GetOverride(player, "CharacterDescendantAdded") ~= false then
            player.DescendantAdded:Connect(OnCharacterDescendantAdded)
        end

        if GetOverride(player, "CharacterDescendantRemoving") ~= false then
            player.DescendantRemoving:Connect(OnCharacterDescendantRemoving)
        end

        Calculate()
    end

    return self.Objects[player]
end

function ESP:Remove(player)
    local object = self.Objects[player]
    if object then
        if object.Type == "Box" then
            if object.Temporary then
                object:Remove()
            else
                for _, component in pairs(object.Components) do
                    component.Visible = false
                end
            end
        end

        self.Objects[player] = nil
    end
end

function ESP:Override(name, func)
    self.Overrides[name] = func
end

function ESP:ClearOverrides()
    self.Overrides = {}
end

function ESP:Clear()
    for player in pairs(self.Objects) do
        self:Remove(player)
    end
end

ESP:Toggle(true) -- Enable ESP by default

return ESP
