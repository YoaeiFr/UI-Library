local ESP = {}

ESP.Enabled = true
ESP.Boxes = true
ESP.BoxShift = CFrame.new(0, -1.5, 0)
ESP.BoxSize = Vector3.new(4, 6, 0)
ESP.Color = Color3.fromRGB(255, 255, 255)
ESP.FaceCamera = false
ESP.Names = true
ESP.TeamColor = false
ESP.Thickness = 2
ESP.AttachShift = 1
ESP.TeamMates = true
ESP.Players = true
ESP.Objects = {}
ESP.Overrides = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local Vector2_new = Vector2.new

local function DrawRectangle(size, position, color, thickness)
    local rect = Drawing.new("Quad")
    rect.Visible = true
    rect.PointA = Vector2_new(position.X - size.X / 2, position.Y - size.Y / 2)
    rect.PointB = Vector2_new(position.X + size.X / 2, position.Y - size.Y / 2)
    rect.PointC = Vector2_new(position.X + size.X / 2, position.Y + size.Y / 2)
    rect.PointD = Vector2_new(position.X - size.X / 2, position.Y + size.Y / 2)
    rect.Color = color
    rect.Thickness = thickness
    return rect
end

local function DrawText(position, text, color)
    local textLabel = Drawing.new("Text")
    textLabel.Visible = true
    textLabel.Position = position
    textLabel.Text = text
    textLabel.Color = color
    textLabel.Size = 16
    textLabel.Center = true
    textLabel.Outline = true
    return textLabel
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

    local player = self:GetPlayerFromChar(object)
    return player and (self.TeamColor and player.Team and player.Team.TeamColor.Color or self.Color)
end

function ESP:GetPlayerFromChar(character)
    local override = self.Overrides.GetPlrFromChar
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
                for _, component in pairs(object.Components) do
                    component:Remove()
                end
            end
        end
    end
end

function ESP:GetBox(object)
    return self.Objects[object]
end

function ESP:AddObjectListener(parent, options)
    local function NewListener(c)
        if type(options.Type) == "string" and c:IsA(options.Type) or options.Type == nil then
            if type(options.Name) == "string" and c.Name == options.Name or options.Name == nil then
                if not options.Validator or options.Validator(c) then
                    local box = ESP:Add(c, {
                        PrimaryPart = type(options.PrimaryPart) == "string" and c:WaitForChild(options.PrimaryPart) or type(options.PrimaryPart) == "function" and options.PrimaryPart(c),
                        Color = type(options.Color) == "function" and options.Color(c) or options.Color,
                        ColorDynamic = options.ColorDynamic,
                        Name = type(options.CustomName) == "function" and options.CustomName(c) or options.CustomName,
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

    if options.RenderInNil then
        NewListener(parent)
    end

    return parent.ChildAdded:Connect(NewListener)
end

function ESP:Add(object, options)
    if self.Objects[object] then
        return self.Objects[object]
    end

    if type(options) ~= "table" then
        options = {}
    end

    local box = {}
    box.Type = "Box"
    box.Object = object
    box.Options = options
    box.Components = {}

    local function checkRender()
        if not options.RenderInNil and (not object.Parent or not ESP.Enabled or not box.IsEnabled) then
            return false
        end
        if not box.PrimaryPart or box.PrimaryPart:IsDescendantOf(workspace) then
            for _, component in pairs(box.Components) do
                if component.Visible then
                    return false
                end
            end
            return true
        end
        return false
    end

    function box:Remove()
        self.PrimaryPart = nil
        for _, component in pairs(self.Components) do
            component:Remove()
        end
        ESP.Objects[self.Object] = nil
    end

    function box:SetComponentVisible(name, visible)
        if self.Components[name] then
            self.Components[name].Visible = visible
        end
    end

    function box:Update()
        local prop = ESP.BoxShift.p
        local visible = checkRender()
        local cframe = self.PrimaryPart.CFrame * ESP.BoxShift
        local componentColor = self.Options.ColorDynamic and ESP:GetColor(self.Object) or ESP.Color

        if visible then
            local pos = Camera:WorldToViewportPoint(cframe.Position)
            local display = ESP.Boxes and not ESP.FaceCamera or ESP.Boxes and ESP.FaceCamera and pos.Z > 0
            local o = self.Components.Box
            o.Visible = display

            if display then
                local size = self.Options.Size or ESP.BoxSize
                local thickness = self.Options.Thickness or ESP.Thickness

                local sizeX = size.X / pos.Z
                local sizeY = size.Y / pos.Z
                local thickness = thickness / pos.Z

                o.Size = Vector2_new(sizeX, sizeY)
                o.Position = Vector2_new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                o.Color = componentColor
                o.Thickness = thickness
                o.Transparency = 0.8

                if self.Options.Name then
                    local name = self.Components.Name
                    name.Visible = ESP.Names
                    name.Position = Vector2_new(o.Position.X, o.Position.Y - 20)
                    name.Text = self.Options.Name
                    name.Color = componentColor
                    name.Transparency = 1
                end
            end
        else
            for _, component in pairs(self.Components) do
                component.Visible = false
            end
        end
    end

    self.Objects[object] = box

    local components = {
        Box = DrawRectangle(Vector2.new(0, 0), Vector2.new(0, 0), ESP.Color, ESP.Thickness),
        Name = DrawText(Vector2.new(0, 0), "", ESP.Color)
    }

    for _, component in pairs(components) do
        component.Visible = false
    end

    box.Components = components

    if options.IsEnabled == nil then
        box.IsEnabled = true
    else
        box.IsEnabled = options.IsEnabled
    end

    box:Update()

    return box
end
