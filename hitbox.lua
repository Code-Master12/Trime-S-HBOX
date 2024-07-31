local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HBOX = {}

local hitboxEnabled = false
local hitboxVisible = true
local headSize = 2
local connection

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
                        hrp.Transparency = hitboxVisible and 0.7 or 1
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

function HBOX:SetHBVisible(visible)
    hitboxVisible = visible
    for i, v in pairs(Players:GetPlayers()) do
        if v.Name ~= Players.LocalPlayer.Name then
            pcall(function()
                local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Transparency = hitboxVisible and 0.7 or 1
                end
            end)
        end
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Hitbox",
        Text = hitboxVisible and "Hitbox Visible!" or "Hitbox Hidden!",
    })
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if hitboxEnabled then
            HBOX:EnableHitbox(headSize)
        end
    end)
end)

return HBOX
