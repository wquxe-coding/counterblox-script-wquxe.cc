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

local bars = {}

local function isEnemy(p)
    return p.Team ~= LocalPlayer.Team
end

local function makeBar(p)
    if bars[p] then return end
    bars[p] = {
        bg = Drawing.new("Square"),
        fill = Drawing.new("Square"),
        text = Drawing.new("Text")
    }
end

local function hideBar(p)
    if not bars[p] then return end
    bars[p].bg.Visible = false
    bars[p].fill.Visible = false
    bars[p].text.Visible = false
end

local function killBar(p)
    if not bars[p] then return end
    bars[p].bg:Remove()
    bars[p].fill:Remove()
    bars[p].text:Remove()
    bars[p] = nil
end

RunService.RenderStepped:Connect(function()
    local sz = Camera.ViewportSize
    watermark.Position = Vector2.new(sz.X / 2, sz.Y - 30)

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then goto next end
        if not p.Character then goto next end

        local root = p.Character:FindFirstChild("HumanoidRootPart")
        local head = p.Character:FindFirstChild("Head")
        local hum = p.Character:FindFirstChild("Humanoid")

        if isEnemy(p) then
            if not p.Character:FindFirstChild("EnemyHighlight") then
                local h = Instance.new("Highlight")
                h.Name = "EnemyHighlight"
                h.Adornee = p.Character
                h.FillColor = Color3.fromRGB(255,0,0)
                h.OutlineColor = Color3.new(1,1,1)
                h.FillTransparency = 0.4
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = p.Character
            end

            if head and not head:FindFirstChild("NameTag") then
                local bill = Instance.new("BillboardGui")
                bill.Name = "NameTag"
                bill.Size = UDim2.new(0,120,0,20)
                bill.StudsOffset = Vector3.new(0,2.5,0)
                bill.AlwaysOnTop = true
                bill.Parent = head
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.Text = p.Name
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 13
                lbl.TextStrokeTransparency = 0.3
                lbl.Parent = bill
            end

            if root and hum then
                local pos, vis = Camera:WorldToViewportPoint(root.Position + Vector3.new(2.5,0,0))
                if vis then
                    makeBar(p)
                    local bar = bars[p]
                    local x, y = pos.X, pos.Y
                    local w, h = 6, 50
                    local hp = math.clamp(hum.Health / 100, 0, 1)

                    bar.bg.Visible = true
                    bar.bg.Position = Vector2.new(x - w/2, y - h/2)
                    bar.bg.Size = Vector2.new(w, h)
                    bar.bg.Color = Color3.new(0,0,0)
                    bar.bg.Transparency = 0.3
                    bar.bg.Filled = true

                    bar.fill.Visible = true
                    bar.fill.Position = Vector2.new(x - w/2, y - h/2 + h * (1 - hp))
                    bar.fill.Size = Vector2.new(w, h * hp)
                    bar.fill.Filled = true
                    if hp > 0.7 then
                        bar.fill.Color = Color3.new(0,1,0)
                    elseif hp > 0.3 then
                        bar.fill.Color = Color3.new(1,1,0)
                    else
                        bar.fill.Color = Color3.new(1,0,0)
                    end

                    bar.text.Visible = true
                    bar.text.Position = Vector2.new(x + 10, y - 10)
                    bar.text.Text = tostring(math.floor(hum.Health))
                    bar.text.Color = Color3.new(1,1,1)
                    bar.text.Size = 14
                    bar.text.Outline = true
                else
                    if bars[p] then hideBar(p) end
                end
            end
        else
            if head and head:FindFirstChild("NameTag") then head.NameTag:Destroy() end
            if p.Character:FindFirstChild("EnemyHighlight") then p.Character.EnemyHighlight:Destroy() end
            if bars[p] then killBar(p) end
        end
        ::next::
    end

    for p, bar in pairs(bars) do
        if not p or not p.Parent then killBar(p) end
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end
    end
end)
