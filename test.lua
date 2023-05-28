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
    return player and self.TeamColor and player.Team and player.Team.TeamColor.Color or self.Color
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
                    self:Remove(object.Object)
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
                    local box = self:Add(child, {
                        PrimaryPart = type(options.PrimaryPart) == "string" and child:WaitForChild(options.PrimaryPart) or
                            (type(options.PrimaryPart) == "function" and options.PrimaryPart(child)),
                        Color = type(options.Color) == "function" and options.Color(child) or options.Color,
                        ColorDynamic = options.ColorDynamic,
                        Name = type(options.CustomName) == "function" and options.CustomName(child) or options.CustomName,
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

    parent.ChildAdded:Connect(NewListener)
    for _, child in ipairs(parent:GetChildren()) do
        NewListener(child)
    end
end

function ESP:Add(object, options)
    options = options or {}

    if self.Objects[object] then
        return self.Objects[object]
    end

    local box = {
        Type = "Box",
        Object = object,
        Components = {},
        Color = options.Color or self:GetColor(object),
        ColorDynamic = options.ColorDynamic or false,
        Name = options.Name or (options.CustomName and options.CustomName(object)),
        IsEnabled = options.IsEnabled or true,
        RenderInNil = options.RenderInNil or false,
        Temporary = options.Temporary or false
    }

    local primaryPart = options.PrimaryPart or (object.PrimaryPart and object.PrimaryPart:IsA("BasePart") and object.PrimaryPart)
    if primaryPart then
        local component = Draw("Quad")
        component.Visible = false
        component.PointA = Vector2_new(0, 0)
        component.PointB = Vector2_new(0, 0)
        component.PointC = Vector2_new(0, 0)
        component.PointD = Vector2_new(0, 0)
        component.Color = box.Color
        component.Filled = false
        component.Thickness = self.Thickness
        component.Transparency = 1
        component.Visible = true
        box.Components[#box.Components + 1] = component

        local function UpdateComponent()
            local size = primaryPart.Size + self.BoxShift
            local cf = primaryPart.CFrame * CFrame.new(0, -size.Y / 2, 0)
            local points = {
                WorldToViewportPoint(Camera, (cf * CFrame.new(-size.X / 2, -size.Y / 2, -size.Z / 2)).p),
                WorldToViewportPoint(Camera, (cf * CFrame.new(size.X / 2, -size.Y / 2, -size.Z / 2)).p),
                WorldToViewportPoint(Camera, (cf * CFrame.new(size.X / 2, -size.Y / 2, size.Z / 2)).p),
                WorldToViewportPoint(Camera, (cf * CFrame.new(-size.X / 2, -size.Y / 2, size.Z / 2)).p)
            }

            component.PointA = points[1]
            component.PointB = points[2]
            component.PointC = points[3]
            component.PointD = points[4]
            component.Visible = self.Enabled and box.IsEnabled and (self.Players and self:GetPlayerFromChar(object) or not self.Players)
        end

        box.UpdateComponent = UpdateComponent
        UpdateComponent()
    end

    self.Objects[object] = box
    return box
end

function ESP:Remove(object)
    local box = self:GetBox(object)
    if box then
        self.Objects[object] = nil
        for _, component in pairs(box.Components) do
            component:Remove()
        end
    end
end

function ESP:Override(name, func)
    self.Overrides[name] = func
end

ESP:Toggle(true)

return ESP
