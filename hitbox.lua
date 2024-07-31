local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HBOX = {}

local hitboxEnabled = false
local headSize = 2
local connection
local counter = 0

local function CreateHitbox(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.new(0, 1, 0)
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
        highlights[player] = highlight
    end
end

local function RemoveHitbox(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

function HBOX:EnableHitbox(size)
    hitboxEnabled = true
    headSize = size or headSize

    if connection then
        connection:Disconnect()
    end

    connection = RunService.RenderStepped:Connect(function()
        for i, v in pairs(Players:GetPlayers()) do
            if v.Name ~= Players.LocalPlayer.Name then
                pcall(function()
                    local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(headSize, headSize, headSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really blue")
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    end
                end)
            end
        end
    end)
end

function HBOX:DisableHitbox()
    hitboxEnabled = false
    if connection then
        connection:Disconnect()
        connection = nil
    end

    for i, v in pairs(Players:GetPlayers()) do
        if v.Name ~= Players.LocalPlayer.Name then
            pcall(function()
                local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 0
                    hrp.BrickColor = BrickColor.new("Medium stone grey")
                    hrp.Material = Enum.Material.Plastic
                    hrp.CanCollide = true
                end
            end)
        end
    end
end

function HBOX:ToggleHitbox(size)
    if hitboxEnabled then
        self:DisableHitbox()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hitbox",
            Text = "Hitbox Disabled!",
        })
    else
        self:EnableHitbox(size)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hitbox",
            Text = "Hitbox Enabled!",
        })
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if hitboxEnabled then
            CreateHitbox(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveHitbox(player)
end)

return HBOX
