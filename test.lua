local ESP = {}

ESP.Enabled = false
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
ESP.Objects = setmetatable({}, { __mode = "kv" })
ESP.Overrides = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local Vector2_new = Vector2.new
local WorldToViewportPoint = Camera.WorldToViewportPoint

local function Draw(obj, props)
    local new = Drawing.new(obj)

    props = props or {}
    for i, v in pairs(props) do
        new[i] = v
    end
    return new
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
            local _, pos = WorldToViewportPoint(Camera, cframe.p)
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
                    name.Transparency = 0.8
                end
            end
        else
            local o = self.Components.Box
            o.Visible = false

            if self.Options.Name then
                local name = self.Components.Name
                name.Visible = false
            end
        end
    end

    local function NewComponent(name, props)
        local component = Draw(name, props)
        component.Visible = false
        self.Components[name] = component
        return component
    end

    if ESP.Boxes then
        box.Components.Box = NewComponent("Rectangle", {
            Thickness = 2,
            Filled = false
        })
    end

    if ESP.Names then
        box.Components.Name = NewComponent("Text", {
            Size = 16,
            Outline = true,
            Center = true,
            Visible = false
        })
    end

    self.Objects[object] = box
    return box
end

function ESP:Init()
    ESP.Toggle(true)

    ESP:AddObjectListener(workspace, {
        Type = "Model",
        Name = "Humanoid",
        Validator = function(c)
            return c:FindFirstChildOfClass("Humanoid") and not c:FindFirstChildOfClass("Tool")
        end,
        PrimaryPart = function(c)
            return c:FindFirstChild("Head") or c.PrimaryPart
        end,
        CustomName = function(c)
            return c:FindFirstChildOfClass("Humanoid").Parent.Name
        end,
        Color = function(c)
            return ESP:GetColor(ESP:GetPlayerFromChar(c))
        end,
        IsEnabled = function(c)
            return not ESP:IsTeamMate(ESP:GetPlayerFromChar(c)) or ESP.TeamMates
        end
    })

    Players.PlayerAdded:Connect(function(player)
        ESP:AddObjectListener(player.Character, {
            Type = "Model",
            Name = "Humanoid",
            Validator = function(c)
                return c:FindFirstChildOfClass("Humanoid") and not c:FindFirstChildOfClass("Tool")
            end,
            PrimaryPart = function(c)
                return c:FindFirstChild("Head") or c.PrimaryPart
            end,
            CustomName = function(c)
                return c:FindFirstChildOfClass("Humanoid").Parent.Name
            end,
            Color = function(c)
                return ESP:GetColor(player)
            end,
            IsEnabled = function(c)
                return not ESP:IsTeamMate(player) or ESP.TeamMates
            end,
            OnAdded = function(box)
                player.CharacterAdded:Connect(function(char)
                    box:Remove()
                    ESP:AddObjectListener(char, {
                        Type = "Model",
                        Name = "Humanoid",
                        Validator = function(c)
                            return c:FindFirstChildOfClass("Humanoid") and not c:FindFirstChildOfClass("Tool")
                        end,
                        PrimaryPart = function(c)
                            return c:FindFirstChild("Head") or c.PrimaryPart
                        end,
                        CustomName = function(c)
                            return c:FindFirstChildOfClass("Humanoid").Parent.Name
                        end,
                        Color = function(c)
                            return ESP:GetColor(player)
                        end,
                        IsEnabled = function(c)
                            return not ESP:IsTeamMate(player) or ESP.TeamMates
                        end
                    })
                end)
            end
        })
    end)
end

ESP:Init()
