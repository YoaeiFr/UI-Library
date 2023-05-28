local ESP = {}

-- Default settings
ESP.Enabled = true
ESP.Boxes = false
ESP.BoxShift = CFrame.new(0, -1.5, 0)
ESP.BoxSize = Vector3.new(4, 6, 0)
ESP.Color = Color3.fromRGB(255, 255, 255)
ESP.FaceCamera = false
ESP.Names = true
ESP.TeamColor = false
ESP.Thickness = 2
ESP.AttachShift = 1
ESP.TeamMates = false
ESP.Players = false
ESP.Objects = {}
ESP.Overrides = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local WorldToViewportPoint = Camera.WorldToViewportPoint
local Drawing = Drawing or Drawing.new

local function CreateDrawingObject(class, properties)
    local object = Drawing(class)
    for property, value in pairs(properties) do
        object[property] = value
    end
    return object
end

function ESP:GetTeam(player)
    local override = self.Overrides.GetTeam
    if override then
        return override(player)
    end
    return player and player.Team
end

function ESP:IsTeamMate(player)
    local override = self.Overrides.IsTeamMate
    if override then
        return override(player)
    end
    return self:GetTeam(player) == self:GetTeam(LocalPlayer)
end

function ESP:GetColor(object)
    local override = self.Overrides.GetColor
    if override then
        return override(object)
    end
    local player = self:GetPlayerFromCharacter(object)
    return player and self.TeamColor and player.Team and player.Team.TeamColor.Color or self.Color
end

function ESP:GetPlayerFromCharacter(character)
    local override = self.Overrides.GetPlayerFromCharacter
    if override then
        return override(character)
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
    local function CheckInstance(instance)
        if type(options.Type) == "string" and instance:IsA(options.Type) or options.Type == nil then
            if type(options.Name) == "string" and instance.Name == options.Name or options.Name == nil then
                if not options.Validator or options.Validator(instance) then
                    local box = self:Add(instance, {
                        PrimaryPart = type(options.PrimaryPart) == "string" and instance:WaitForChild(options.PrimaryPart) or type(options.PrimaryPart) == "function" and options.PrimaryPart(instance),
                        Color = type(options.Color) == "function" and options.Color(instance) or options.Color,
                        ColorDynamic = options.ColorDynamic,
                        Name = type(options.CustomName) == "function" and options.CustomName(instance) or options.CustomName,
                        IsEnabled = options.IsEnabled,
                        RenderInNil = options.RenderInNil
                    })
                    if options.OnAdded then
                        coroutine.wrap(options.OnAdded)(box)
                    end
                end
            end
        end
    end

    if options.Recursive then
        parent.DescendantAdded:Connect(CheckInstance)
    end

    parent.ChildAdded:Connect(CheckInstance)
    for _, instance in pairs(parent:GetChildren()) do
        CheckInstance(instance)
    end
end

function ESP:RemoveObjectListener(parent)
    parent.ChildAdded:Disconnect()
    parent.DescendantAdded:Disconnect()
end

function ESP:Add(instance, options)
    if not instance or self:GetBox(instance) then
        return
    end

    local box = {}
    self.Objects[instance] = box

    local function UpdateColor()
        if box.Components then
            for _, component in pairs(box.Components) do
                if component and component:IsA("BasePart") then
                    component.Color = self:GetColor(instance)
                end
            end
        end
    end

    local function UpdateName()
        if box.Components and box.NameLabel then
            if box.Name then
                box.NameLabel.Text = box.Name
                box.NameLabel.Visible = true
            else
                box.NameLabel.Visible = false
            end
        end
    end

    local function CreateComponents()
        box.Components = {}

        local function CreateBox(part)
            local boxComponent = CreateDrawingObject("Box", {
                Visible = false,
                Color = self:GetColor(instance),
                Thickness = self.Thickness
            })

            if self.Boxes then
                boxComponent.Visible = true
                table.insert(box.Components, boxComponent)
            end

            if self.Names then
                local nameLabel = CreateDrawingObject("Text", {
                    Visible = false,
                    Size = 16,
                    Color = self:GetColor(instance),
                    Outline = true,
                    Center = true
                })
                box.NameLabel = nameLabel
                table.insert(box.Components, nameLabel)
            end
        end

        if options.PrimaryPart and options.PrimaryPart:IsA("BasePart") then
            CreateBox(options.PrimaryPart)
        elseif instance:IsA("BasePart") then
            CreateBox(instance)
        end

        if self.AttachShift ~= 0 then
            local attachment = Instance.new("Attachment")
            attachment.Position = Vector3.new(0, self.AttachShift, 0)
            attachment.Parent = instance
            table.insert(box.Components, attachment)
        end
    end

    local function UpdateComponents()
        if box.Components then
            for _, component in pairs(box.Components) do
                if component and component:IsA("BasePart") then
                    component.Visible = self.Enabled and instance.Parent ~= nil or self.Enabled and options.RenderInNil
                    if self.TeamMates or not self.TeamMates and not self:IsTeamMate(instance) then
                        component.Color = self:GetColor(instance)
                    else
                        component.Color = Color3.new(0, 1, 0)
                    end
                    component.Thickness = self.Thickness
                elseif component and component:IsA("Text") then
                    component.Visible = self.Enabled and instance.Parent ~= nil or self.Enabled and options.RenderInNil
                    component.Color = self:GetColor(instance)
                elseif component and component:IsA("Attachment") then
                    component.Position = Vector3.new(0, self.AttachShift, 0)
                end
            end
        end
    end

    if options.IsEnabled ~= false then
        if options.ColorDynamic then
            box.DynamicColorConnection = instance:GetPropertyChangedSignal("Color"):Connect(UpdateColor)
        end
        box.NameConnection = instance:GetPropertyChangedSignal("Name"):Connect(UpdateName)

        CreateComponents()
        UpdateComponents()
    end

    return box
end

function ESP:Remove(instance)
    local box = self:GetBox(instance)
    if box then
        if box.DynamicColorConnection then
            box.DynamicColorConnection:Disconnect()
            box.DynamicColorConnection = nil
        end
        if box.NameConnection then
            box.NameConnection:Disconnect()
            box.NameConnection = nil
        end
        for _, component in pairs(box.Components) do
            component:Remove()
        end
        self.Objects[instance] = nil
    end
end

return ESP
