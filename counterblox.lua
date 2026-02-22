if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

repeat wait() until LocalPlayer and LocalPlayer.Character

local watermark = Drawing.new("Text")
watermark.Visible = true
watermark.Center = true
watermark.Text = "wquxe.cc"
watermark.Color = Color3.fromRGB(255, 255, 255)
watermark.Size = 18
watermark.Outline = true
watermark.OutlineColor = Color3.fromRGB(255, 0, 0)

local function isEnemy(player)
    return player.Team ~= LocalPlayer.Team
end

local function createNameTag(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("NameTag")
    if old then old:Destroy() end
    local bill = Instance.new("BillboardGui")
    bill.Name = "NameTag"
    bill.Size = UDim2.new(0, 120, 0, 20)
    bill.StudsOffset = Vector3.new(0, 2.5, 0)
    bill.AlwaysOnTop = true
    bill.Parent = head
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Parent = bill
end

local healthBars = {}

RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    watermark.Position = Vector2.new(screenSize.X / 2, screenSize.Y - 30)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")

            if isEnemy(player) then
                local highlight = player.Character:FindFirstChild("EnemyHighlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "EnemyHighlight"
                    highlight.Adornee = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.OutlineTransparency = 0.2
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                end

                if head then
                    local tag = head:FindFirstChild("NameTag")
                    if not tag then
                        createNameTag(player)
                    end
                end

                if root and humanoid then
                    local health = humanoid.Health
                    local maxHealth = 100
                    local percent = health / maxHealth

                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(2.5, 0, 0))

                    if onScreen then
                        if not healthBars[player] then
                            healthBars[player] = {
                                bg = Drawing.new("Square"),
                                fill = Drawing.new("Square"),
                                text = Drawing.new("Text")
                            }
                        end

                        local bar = healthBars[player]
                        local x, y = screenPos.X, screenPos.Y
                        local width = 6
                        local height = 50

                        bar.bg.Visible = true
                        bar.bg.Position = Vector2.new(x - width/2, y - height/2)
                        bar.bg.Size = Vector2.new(width, height)
                        bar.bg.Color = Color3.fromRGB(0, 0, 0)
                        bar.bg.Transparency = 0.3
                        bar.bg.Filled = true

                        bar.fill.Visible = true
                        bar.fill.Position = Vector2.new(x - width/2, y - height/2 + height * (1 - percent))
                        bar.fill.Size = Vector2.new(width, height * percent)
                        if health > 70 then
                            bar.fill.Color = Color3.fromRGB(0, 255, 0)
                        elseif health > 30 then
                            bar.fill.Color = Color3.fromRGB(255, 255, 0)
                        else
                            bar.fill.Color = Color3.fromRGB(255, 0, 0)
                        end
                        bar.fill.Filled = true

                        bar.text.Visible = true
                        bar.text.Position = Vector2.new(x + 10, y - 10)
                        bar.text.Text = tostring(math.floor(health))
                        bar.text.Color = Color3.fromRGB(255, 255, 255)
                        bar.text.Size = 14
                        bar.text.Outline = true
                    else
                        if healthBars[player] then
                            healthBars[player].bg.Visible = false
                            healthBars[player].fill.Visible = false
                            healthBars[player].text.Visible = false
                        end
                    end
                end
            else
                if head then
                    local tag = head:FindFirstChild("NameTag")
                    if tag then tag:Destroy() end
                end
                local highlight = player.Character:FindFirstChild("EnemyHighlight")
                if highlight then highlight:Destroy() end
                if healthBars[player] then
                    healthBars[player].bg:Remove()
                    healthBars[player].fill:Remove()
                    healthBars[player].text:Remove()
                    healthBars[player] = nil
                end
            end
        end
    end

    for player, bar in pairs(healthBars) do
        if not player or not player.Parent then
            bar.bg:Remove()
            bar.fill:Remove()
            bar.text:Remove()
            healthBars[player] = nil
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid.Jump = true
            end
        end
    end
end)
