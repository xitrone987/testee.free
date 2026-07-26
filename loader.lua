--[[
    Shadow Loader v1.0
    UI própria, funções independentes
    No Cooldown incluso
]]

-- ===== SERVIÇOS =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ===== CORES =====
local Colors = {
    bg = Color3.fromRGB(15, 18, 25),
    surface = Color3.fromRGB(22, 26, 36),
    surface2 = Color3.fromRGB(30, 36, 48),
    accent = Color3.fromRGB(90, 255, 140),
    accentDk = Color3.fromRGB(6, 28, 16),
    text = Color3.fromRGB(240, 245, 255),
    subtext = Color3.fromRGB(150, 160, 180),
    danger = Color3.fromRGB(255, 80, 80),
    amber = Color3.fromRGB(255, 200, 50),
    white = Color3.fromRGB(255, 255, 255),
}

-- ===== ESTADO GLOBAL =====
local State = {
    NoCooldown = false,
    AutoFarm = false,
    AutoClick = false,
    AutoSell = false,
    AutoQuest = false,
    AutoRebirth = false,
    SpeedHack = false,
    WalkSpeed = 16,
    JumpPower = 50,
    TeleportToNPC = false,
    TargetNPC = nil,
}

-- ===== FUNÇÕES AUXILIARES =====
local function criar(className, props)
    local obj = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then obj[k] = v end
        end
        if props.Parent then obj.Parent = props.Parent end
    end
    return obj
end

local function roundCorner(obj, radius)
    return criar("UICorner", { CornerRadius = UDim.new(0, radius), Parent = obj })
end

local function stroke(obj, color, transparency, thickness)
    return criar("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj
    })
end

local function label(text, size, color, parent)
    local obj = Instance.new("TextLabel")
    obj.BackgroundTransparency = 1
    obj.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
    obj.Text = text
    obj.TextSize = size or 13
    obj.TextColor3 = color or Colors.text
    obj.TextXAlignment = Enum.TextXAlignment.Left
    obj.Parent = parent
    return obj
end

local function button(text, callback, parent)
    local obj = Instance.new("TextButton")
    obj.Text = text
    obj.TextSize = 13
    obj.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.SemiBold)
    obj.TextColor3 = Colors.text
    obj.BackgroundColor3 = Colors.surface2
    obj.AutoButtonColor = false
    obj.Size = UDim2.fromOffset(120, 30)
    roundCorner(obj, 6)
    stroke(obj, Colors.white, 0.9)
    obj.Parent = parent
    obj.MouseButton1Click:Connect(callback)
    obj.MouseEnter:Connect(function()
        TweenService:Create(obj, TweenInfo.new(0.1), { BackgroundColor3 = Colors.surface }):Play()
    end)
    obj.MouseLeave:Connect(function()
        TweenService:Create(obj, TweenInfo.new(0.1), { BackgroundColor3 = Colors.surface2 }):Play()
    end)
    return obj
end

local function toggle(text, defaultValue, callback, parent)
    local frame = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = parent
    })
    local lbl = label(text, 13, Colors.text, frame)
    lbl.Position = UDim2.fromOffset(0, 6)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    
    local bg = criar("Frame", {
        BackgroundColor3 = defaultValue and Colors.accent or Colors.surface2,
        BackgroundTransparency = 0.3,
        Position = UDim2.new(0.8, 0, 0.15, 0),
        Size = UDim2.fromOffset(40, 22),
        Parent = frame
    })
    roundCorner(bg, 11)
    
    local knob = criar("Frame", {
        BackgroundColor3 = Colors.white,
        Position = defaultValue and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0),
        Size = UDim2.fromOffset(18, 18),
        Parent = bg
    })
    roundCorner(knob, 9)
    
    local toggled = defaultValue
    bg.MouseButton1Click:Connect(function()
        toggled = not toggled
        bg.BackgroundColor3 = toggled and Colors.accent or Colors.surface2
        knob.Position = toggled and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0)
        callback(toggled)
    end)
    return frame
end

-- ===== UI PRINCIPAL =====
local function criarUI()
    -- Limpa UIs antigas
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name == "ShadowLoader" then
            child:Destroy()
        end
    end
    
    local screenGui = criar("ScreenGui", {
        Name = "ShadowLoader",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999999,
        Parent = CoreGui
    })
    
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(screenGui)
        elseif protectgui then protectgui(screenGui) end
    end)
    
    -- Container principal
    local holder = criar("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(480, 400),
        Parent = screenGui
    })
    
    local mainFrame = criar("Frame", {
        BackgroundColor3 = Colors.bg,
        Size = UDim2.fromScale(1, 1),
        Parent = holder
    })
    roundCorner(mainFrame, 12)
    stroke(mainFrame, Colors.white, 0.9)
    
    -- Header
    local header = criar("Frame", {
        BackgroundColor3 = Colors.surface,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = mainFrame
    })
    roundCorner(header, 12)
    criar("UICorner", { CornerRadius = UDim.new(0, 12), Parent = header })
    
    local title = label("Shadow Loader", 18, Colors.accent, header)
    title.Position = UDim2.fromOffset(16, 8)
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeBtn = criar("TextButton", {
        Text = "×",
        TextSize = 18,
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
        TextColor3 = Colors.subtext,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        Parent = header
    })
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Abas
    local tabFrame = criar("Frame", {
        BackgroundColor3 = Colors.surface,
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 40),
        Parent = mainFrame
    })
    
    local tabs = {"Principal", "Auto", "Diversos", "Config"}
    local tabButtons = {}
    local currentTab = nil
    
    local function switchTab(tabName)
        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = Colors.surface
            btn.TextColor3 = Colors.subtext
        end
        for _, btn in ipairs(tabButtons) do
            if btn.Text == tabName then
                btn.BackgroundColor3 = Colors.surface2
                btn.TextColor3 = Colors.accent
            end
        end
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = (child.Name == tabName)
            end
        end
        currentTab = tabName
    end
    
    for i, name in ipairs(tabs) do
        local btn = criar("TextButton", {
            Text = name,
            TextSize = 13,
            FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.SemiBold),
            TextColor3 = i == 1 and Colors.accent or Colors.subtext,
            BackgroundColor3 = i == 1 and Colors.surface2 or Colors.surface,
            AutoButtonColor = false,
            Size = UDim2.new(0.25, 0, 1, 0),
            Position = UDim2.new((i-1) * 0.25, 0, 0, 0),
            Parent = tabFrame
        })
        btn.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
        table.insert(tabButtons, btn)
    end
    
    -- Content
    local contentFrame = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -90),
        Position = UDim2.new(0, 10, 0, 80),
        Parent = mainFrame
    })
    
    -- ===== ABA PRINCIPAL =====
    local principalTab = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Name = "Principal",
        Parent = contentFrame,
        Visible = true
    })
    
    local scrollP = criar("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.subtext,
        CanvasSize = UDim2.new(0, 0, 0, 300),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromScale(1, 1),
        Parent = principalTab
    })
    
    local layoutP = criar("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollP
    })
    
    -- No Cooldown
    toggle("No Cooldown", State.NoCooldown, function(val)
        State.NoCooldown = val
        if val then
            -- Tenta aplicar no cooldown em habilidades
            pcall(function()
                local char = Player.Character
                if char then
                    for _, child in ipairs(char:GetDescendants()) do
                        if child:IsA("NumberValue") and child.Name:lower():find("cooldown") then
                            child.Value = 0
                        end
                        if child:IsA("BoolValue") and child.Name:lower():find("cooldown") then
                            child.Value = false
                        end
                        if child:IsA("IntValue") and child.Name:lower():find("cooldown") then
                            child.Value = 0
                        end
                    end
                end
            end)
        end
    end, scrollP)
    
    -- Auto Farm
    toggle("Auto Farm", State.AutoFarm, function(val)
        State.AutoFarm = val
        if val then
            -- Simples auto-farm: ataca NPCs próximos
            task.spawn(function()
                while State.AutoFarm and screenGui.Parent do
                    pcall(function()
                        local char = Player.Character
                        if char and char:FindFirstChild("Humanoid") then
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if root then
                                -- Procura por NPCs próximos
                                for _, obj in ipairs(workspace:GetChildren()) do
                                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= char then
                                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                                        if hrp and (hrp.Position - root.Position).Magnitude < 50 then
                                            -- Simula ataque (depende do jogo)
                                            local hum = obj:FindFirstChildOfClass("Humanoid")
                                            if hum and hum.Health > 0 then
                                                -- Tenta usar ferramenta ou ataque
                                                local tool = char:FindFirstChildOfClass("Tool")
                                                if tool then
                                                    tool:Activate()
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end, scrollP)
    
    -- Auto Click
    toggle("Auto Click", State.AutoClick, function(val)
        State.AutoClick = val
        if val then
            task.spawn(function()
                while State.AutoClick and screenGui.Parent do
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end, scrollP)
    
    -- Auto Sell
    toggle("Auto Sell", State.AutoSell, function(val)
        State.AutoSell = val
        -- Implementação depende do jogo
    end, scrollP)
    
    -- ===== ABA AUTO =====
    local autoTab = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Name = "Auto",
        Parent = contentFrame,
        Visible = false
    })
    
    local scrollA = criar("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.subtext,
        CanvasSize = UDim2.new(0, 0, 0, 300),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromScale(1, 1),
        Parent = autoTab
    })
    
    local layoutA = criar("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollA
    })
    
    toggle("Auto Quest", State.AutoQuest, function(val)
        State.AutoQuest = val
    end, scrollA)
    
    toggle("Auto Rebirth", State.AutoRebirth, function(val)
        State.AutoRebirth = val
    end, scrollA)
    
    -- Teleport para NPC
    label("Teleport para NPC:", 13, Colors.subtext, scrollA)
    local npcFrame = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = scrollA
    })
    local npcInput = criar("TextBox", {
        PlaceholderText = "Nome do NPC",
        Text = "",
        BackgroundColor3 = Colors.surface2,
        TextColor3 = Colors.text,
        TextSize = 13,
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
        Size = UDim2.new(0.7, 0, 1, 0),
        Parent = npcFrame
    })
    roundCorner(npcInput, 6)
    local npcBtn = button("Ir", function()
        local targetName = npcInput.Text
        if targetName and targetName ~= "" then
            pcall(function()
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj.Name:lower():find(targetName:lower()) then
                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                        if hrp and Player.Character then
                            local root = Player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                            end
                        end
                    end
                end
            end)
        end
    end, npcFrame)
    npcBtn.Position = UDim2.new(0.75, 0, 0, 0)
    npcBtn.Size = UDim2.new(0.22, 0, 1, 0)
    
    -- ===== ABA DIVERSOS =====
    local diversosTab = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Name = "Diversos",
        Parent = contentFrame,
        Visible = false
    })
    
    local scrollD = criar("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.subtext,
        CanvasSize = UDim2.new(0, 0, 0, 300),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromScale(1, 1),
        Parent = diversosTab
    })
    
    local layoutD = criar("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollD
    })
    
    -- Speed Hack
    toggle("Speed Hack", State.SpeedHack, function(val)
        State.SpeedHack = val
        if val then
            pcall(function()
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    Player.Character.Humanoid.WalkSpeed = 50
                end
            end)
        else
            pcall(function()
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    Player.Character.Humanoid.WalkSpeed = 16
                end
            end)
        end
    end, scrollD)
    
    -- Jump Power
    label("Salto:", 13, Colors.subtext, scrollD)
    local jumpSlider = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = scrollD
    })
    local sliderBg = criar("Frame", {
        BackgroundColor3 = Colors.surface2,
        Size = UDim2.new(0.8, 0, 0.4, 0),
        Position = UDim2.new(0, 0, 0.3, 0),
        Parent = jumpSlider
    })
    roundCorner(sliderBg, 4)
    local sliderFill = criar("Frame", {
        BackgroundColor3 = Colors.accent,
        Size = UDim2.new(0.5, 0, 1, 0),
        Parent = sliderBg
    })
    roundCorner(sliderFill, 4)
    local jumpVal = label("50", 13, Colors.text, jumpSlider)
    jumpVal.Position = UDim2.new(0.85, 0, 0, 0)
    jumpVal.Size = UDim2.new(0.15, 0, 1, 0)
    jumpVal.TextXAlignment = Enum.TextXAlignment.Center
    
    sliderBg.MouseButton1Down:Connect(function()
        local pos = UserInputService:GetMouseLocation()
        local relX = (pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
        relX = math.clamp(relX, 0, 1)
        sliderFill.Size = UDim2.new(relX, 0, 1, 0)
        local val = math.floor(relX * 80 + 20)
        jumpVal.Text = tostring(val)
        State.JumpPower = val
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.JumpPower = val
            end
        end)
    end)
    
    -- ===== ABA CONFIG =====
    local configTab = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Name = "Config",
        Parent = contentFrame,
        Visible = false
    })
    
    local scrollC = criar("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.subtext,
        CanvasSize = UDim2.new(0, 0, 0, 300),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromScale(1, 1),
        Parent = configTab
    })
    
    local layoutC = criar("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollC
    })
    
    label("Shadow Loader v1.0", 16, Colors.accent, scrollC)
    label("Feito para jogos de anime", 13, Colors.subtext, scrollC)
    label("Use com responsabilidade.", 13, Colors.subtext, scrollC)
    
    button("Fechar UI", function()
        screenGui:Destroy()
    end, scrollC)
    
    -- Inicializa a primeira aba
    switchTab("Principal")
    
    -- Drag
    local dragging, dragStart, dragPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            dragPos = holder.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            holder.Position = UDim2.new(
                dragPos.X.Scale, dragPos.X.Offset + delta.X,
                dragPos.Y.Scale, dragPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return screenGui
end

-- ===== LOOP DE NO COOLDOWN =====
task.spawn(function()
    while true do
        task.wait(0.5)
        if State.NoCooldown then
            pcall(function()
                local char = Player.Character
                if char then
                    -- Procura por valores de cooldown em todo o character
                    for _, child in ipairs(char:GetDescendants()) do
                        if child:IsA("NumberValue") and child.Name:lower():find("cooldown") then
                            child.Value = 0
                        end
                        if child:IsA("BoolValue") and child.Name:lower():find("cooldown") then
                            child.Value = false
                        end
                        if child:IsA("IntValue") and child.Name:lower():find("cooldown") then
                            child.Value = 0
                        end
                        -- Para objetos de habilidade
                        if child:IsA("ModuleScript") and child.Name:lower():find("cooldown") then
                            -- Tenta modificar o módulo (avançado)
                        end
                    end
                    -- Tenta resetar atributos
                    if char:FindFirstChild("Attributes") then
                        for _, attr in ipairs(char.Attributes:GetAttributes()) do
                            if type(attr) == "number" and tostring(attr):lower():find("cooldown") then
                                char.Attributes[attr] = 0
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ===== ATALHO PARA ABRIR =====
local ui = nil
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if ui and ui.Parent then
            ui:Destroy()
            ui = nil
        else
            ui = criarUI()
        end
    end
end)

-- Abre automaticamente
ui = criarUI()

print("Shadow Loader carregado! Pressione RightControl para abrir/fechar.")
