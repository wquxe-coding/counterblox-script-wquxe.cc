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

local function createHeadInfo(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local bill = Instance.new("BillboardGui")
    bill.Name = "EnemyInfo"
    bill.Size = UDim2.new(0, 120, 0, 45)
    bill.StudsOffset = Vector3.new(0, 2.5, 0)
    bill.AlwaysOnTop = true
    bill.Parent = head
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = bill

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Parent = frame

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthText"
    healthLabel.Size = UDim2.new(1, 0, 0, 16)
    healthLabel.Position = UDim2.new(0, 0, 0, 18)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "HP: 100"
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 12
    healthLabel.Parent = frame

    local barFrame = Instance.new("Frame")
    barFrame.Name = "HealthBarFrame"
    barFrame.Size = UDim2.new(1, -20, 0, 4)
    barFrame.Position = UDim2.new(0, 10, 0, 36)
    barFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    barFrame.BorderSizePixel = 0
    barFrame.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Name = "HealthBar"
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    bar.BorderSizePixel = 0
    bar.Parent = barFrame
end

RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    watermark.Position = Vector2.new(screenSize.X / 2, screenSize.Y - 30)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            
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
                
                local info = head:FindFirstChild("EnemyInfo")
                if not info then
                    createHeadInfo(player)
                end
                    
                info = head:FindFirstChild("EnemyInfo")
                if info and info.Frame and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    local health = math.floor(humanoid.Health)
                    local healthPercent = health / 100
                    
                    local healthLabel = info.Frame:FindFirstChild("HealthText")
                    if healthLabel then
                        healthLabel.Text = "HP: " .. health .. "/100"
                        if health > 70 then
                            healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        elseif health > 30 then
                            healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                    
                    local healthBar = info.Frame:FindFirstChild("HealthBarFrame")
                    if healthBar then
                        local bar = healthBar:FindFirstChild("HealthBar")
                        if bar then
                            bar.Size = UDim2.new(healthPercent, 0, 1, 0)
                            if health > 70 then
                                bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            elseif health > 30 then
                                bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                            else
                                bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
            else

                local highlight = player.Character:FindFirstChild("EnemyHighlight")
                if highlight then highlight:Destroy() end
                
                local info = head:FindFirstChild("EnemyInfo")
                if info then info:Destroy() end
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
