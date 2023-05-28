local ESP = {
    Enabled = false,
    Boxes = true,
    Color = Color3.fromRGB(255, 255, 255),
    FaceCamera = false,
    Names = true,
    TeamColor = false,
    TeamMates = true,
    Players = true,
    
    Objects = {},
    Overrides = {},
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Drawing = Drawing or Drawing.new
local Vector2 = Vector2 or Vector2.new
local Vector3 = Vector3 or Vector3.new

local function WorldToViewportPoint(cam, position)
    return cam:WorldToViewportPoint(position)
end

local function CreateDrawingObject(obj, props)
    local drawingObject = Drawing(obj)
    props = props or {}
    for i, v in pairs(props) do
        drawingObject[i] = v
    end
    return drawingObject
end

local function GetTeam(esp, player)
    local override = esp.Overrides.GetTeam
    if override then
        return override(player)
    end
    return player and player.Team
end

local function IsTeamMate(esp, player)
    local override = esp.Overrides.IsTeamMate
    if override then
        return override(player)
    end
    local localPlayerTeam = GetTeam(esp, LocalPlayer)
    local playerTeam = GetTeam(esp, player)
    return playerTeam == localPlayerTeam
end

local function GetColor(esp, object)
    local override = esp.Overrides.GetColor
    if override then
        return override(object)
    end
    local player = esp:GetPlayerFromCharacter(object)
    if esp.TeamColor and player and player.Team then
        return player.Team.TeamColor.Color
    end
    return esp.Color
end

local function GetPlayerFromCharacter(esp, character)
    local override = esp.Overrides.GetPlayerFromChar
    if override then
        return override(character)
    end
    return Players:GetPlayerFromCharacter(character)
end

local function Toggle(esp, enabled)
    esp.Enabled = enabled
    if not enabled then
        for _, object in pairs(esp.Objects) do
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

local function GetBox(esp, object)
    return esp.Objects[object]
end

local function AddObjectListener(esp, parent, options)
    local function NewListener(child)
        if (type(options.Type) == "string" and child:IsA(options.Type)) or options.Type == nil then
            if (type(options.Name) == "string" and child.Name == options.Name) or options.Name == nil then
                if not options.Validator or options.Validator(child) then
                    local box = esp:Add(child, {
                        PrimaryPart = type(options.PrimaryPart) == "string" and child:WaitForChild(options.PrimaryPart) or
                            type(options.PrimaryPart) == "function" and options.PrimaryPart(child),
                        Color = type(options.Color) == "function" and options.Color(child) or options.Color,
                        ColorDynamic = options.ColorDynamic,
                        Name = type(options.CustomName) == "function" and options.CustomName(child) or options.CustomName,
                        IsEnabled = options.IsEnabled,
                        RenderInNil = options.RenderInNil,
                        Temporary = options.Temporary,
                        Components = {},
                        Type = "Box",
                    })
                    if options.Events then
                        for i, v in pairs(options.Events) do
                            box[i]:Connect(v)
                        end
                    end
                    if options.Callback then
                        options.Callback(child, box)
                    end
                end
            end
        end
    end

    NewListener(options.Instance)
    if not options.RenderInNil then
        for _, child in ipairs(parent:GetChildren()) do
            NewListener(child)
        end
    end

    parent.ChildAdded:Connect(NewListener)
end

local function AddEsp(esp, object)
    local player = esp:GetPlayerFromCharacter(object)
    if player and not esp.Players then
        return
    end
    if player and esp.TeamMates and esp:HasTeam(player) then
        return
    end

    local box = esp:GetBox(object)
    if not box then
        local color = esp:GetColor(object)
        box = esp:AddObject(object, {
            Color = color,
            ColorDynamic = esp.ColorDynamic,
            Name = esp.Names and esp:GetName(object) or nil,
            IsEnabled = esp.Enabled,
            RenderInNil = esp.RenderInNil,
            Temporary = false,
            Components = {},
            Type = "Box",
        })
    end

    return box
end

local function UpdateEsp(esp)
    local cam = Workspace.CurrentCamera
    if not cam then
        return
    end

    for _, object in pairs(esp.Objects) do
        if object.Type == "Box" then
            local component = object.Components.Box
            if component then
                if object.Temporary then
                    component.Visible = true
                else
                    component.Visible = esp.Enabled
                end

                local pos = object.PrimaryPart and object.PrimaryPart.Position or object.Position
                local _, onScreen = WorldToViewportPoint(cam, pos)
                if object.FaceCamera then
                    local camPos = cam.CFrame.Position
                    local lookVector = (pos - camPos).Unit
                    local ray = Ray.new(camPos, lookVector * 2048)
                    local _, hit = Workspace:FindPartOnRay(ray, cam.IgnoreList, false, true)
                    if hit and hit:IsDescendantOf(object) then
                        onScreen = false
                    end
                end

                if onScreen then
                    local topLeft, bottomRight = WorldToViewportPoint(cam, component.CFrame)
                    component.Size = Vector2.new(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
                    component.Position = topLeft
                    component.Color = object.Color
                end
            end
        end
    end
end

local function AddBoxComponent(esp, object, componentType, properties)
    local box = esp:GetBox(object)
    if box then
        local component = box.Components[componentType]
        if component then
            for i, v in pairs(properties) do
                component[i] = v
            end
        else
            component = CreateDrawingObject(componentType, properties)
            box.Components[componentType] = component
        end
        return component
    end
end

local function AddBox(esp, object)
    local box = esp:AddObject(object, {
        Color = esp:GetColor(object),
        ColorDynamic = esp.ColorDynamic,
        Name = esp.Names and esp:GetName(object) or nil,
        IsEnabled = esp.Enabled,
        RenderInNil = esp.RenderInNil,
        Temporary = false,
        Components = {},
        Type = "Box",
    })
    if box then
        box.Components.Box = AddBoxComponent(esp, object, "Box", {
            Visible = box.Temporary or esp.Enabled,
            Thickness = 1,
            Color = box.Color,
        })
    end
end

local function EnableEsp(esp)
    esp.Enabled = true
    for _, object in pairs(esp.Objects) do
        if object.Type == "Box" then
            if object.Temporary then
                object.Components.Box.Visible = true
            else
                object.Components.Box.Visible = esp.Enabled
            end
        end
    end
end

local function DisableEsp(esp)
    esp.Enabled = false
    for _, object in pairs(esp.Objects) do
        if object.Type == "Box" then
            if object.Temporary then
                object:Remove()
            else
                object.Components.Box.Visible = false
            end
        end
    end
end

ESP.Add = AddEsp
ESP.GetBox = GetBox
ESP.AddObjectListener = AddObjectListener
ESP.Update = UpdateEsp
ESP.AddBoxComponent = AddBoxComponent
ESP.AddBox = AddBox
ESP.Enable = EnableEsp
ESP.Disable = DisableEsp

return ESP
