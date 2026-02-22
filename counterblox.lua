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

local function createSideHealthBar(player)
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local old = root:FindFirstChild("SideHealth")
    if old then old:Destroy() end

    local bill = Instance.new("BillboardGui")
    bill.Name = "SideHealth"
    bill.Size = UDim2.new(0, 8, 0, 70) -- Тонкая ширина 8
    bill.StudsOffset = Vector3.new(2.5, 0, 0) -- Сбоку
    bill.AlwaysOnTop = true
    bill.Parent = root

    local bg = Instance.new("Frame")
    bg.Name = "Background"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.3 -- Чуть прозрачный
    bg.BorderSizePixel = 0
    bg.Parent = bill

    local bar = Instance.new("Frame")
    bar.Name = "HealthBar"
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    bar.BorderSizePixel = 0
    bar.Parent = bg

    local text = Instance.new("TextLabel")
    text.Name = "HealthText"
    text.Size = UDim2.new(3, 0, 0, 14) -- Чуть шире, чтобы текст помещался
    text.Position = UDim2.new(1.2, 0, 0.5, -7) -- Справа от полоски
    text.BackgroundTransparency = 1
    text.Text = "100"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextStrokeTransparency = 0.3
    text.Parent = bill
end

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

                if root then
                    local side = root:FindFirstChild("SideHealth")
                    if not side then
                        createSideHealthBar(player)
                    else
                        if humanoid then
                            local health = math.floor(humanoid.Health)
                            local percent = health / 100

                            local bg = side:FindFirstChild("Background")
                            if bg then
                                local bar = bg:FindFirstChild("HealthBar")
                                if bar then
                                    bar.Size = UDim2.new(1, 0, percent, 0)
                                    bar.Position = UDim2.new(0, 0, 1 - percent, 0)
                                    if health > 70 then
                                        bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                                    elseif health > 30 then
                                        bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                                    else
                                        bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                                    end
                                end
                            end

                            local text = side:FindFirstChild("HealthText")
                            if text then
                                text.Text = tostring(health)
                            end
                        end
                    end
                end
            else
                if head then
                    local tag = head:FindFirstChild("NameTag")
                    if tag then tag:Destroy() end
                end
                if root then
                    local side = root:FindFirstChild("SideHealth")
                    if side then side:Destroy() end
                end
                local highlight = player.Character:FindFirstChild("EnemyHighlight")
                if highlight then highlight:Destroy() end
            end
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
