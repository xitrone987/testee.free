--[[
    Shadow Loader v3.0 - Especializado para Shindo Life 2
    Funções focadas no grinding do jogo: Auto Farm, Auto Spin, No Cooldown e mais.
]]

-- ===== SERVIÇOS =====
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

-- ===== CORES =====
local C = {
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

-- ===== ESTADO =====
local State = {
    NoCooldown = false,
    AutoFarm = false,
    AutoSpin = false,
    AutoQuest = false,
    SpeedHack = false,
}

-- ===== FUNÇÕES AUXILIARES =====
local function criar(cls, props)
    local obj = Instance.new(cls)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then obj[k] = v end
        end
        if props.Parent then obj.Parent = props.Parent end
    end
    return obj
end

local function round(obj, r)
    return criar("UICorner", { CornerRadius = UDim.new(0, r), Parent = obj })
end

local function stroke(obj, color, transp)
    return criar("UIStroke", {
        Color = color,
        Transparency = transp or 0.8,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj
    })
end

-- ===== CRIAÇÃO DA UI =====
local function criarUI()
    -- Limpa UI antiga
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name == "ShadowUI" then
            child:Destroy()
        end
    end

    local screenGui = criar("ScreenGui", {
        Name = "ShadowUI",
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
        Size = UDim2.fromOffset(340, 420),
        Parent = screenGui
    })

    local main = criar("Frame", {
        BackgroundColor3 = C.bg,
        Size = UDim2.fromScale(1, 1),
        Parent = holder
    })
    round(main, 12)
    stroke(main, C.white, 0.85)

    -- Header (arrastável)
    local header = criar("Frame", {
        BackgroundColor3 = C.surface,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = main
    })
    round(header, 12)
    criar("UICorner", { CornerRadius = UDim.new(0, 12), Parent = header })

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
    title.Text = "Shadow Loader [SL2]"
    title.TextColor3 = C.accent
    title.TextSize = 18
    title.Position = UDim2.fromOffset(16, 8)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = criar("TextButton", {
        Text = "×",
        TextSize = 18,
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
        TextColor3 = C.subtext,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        Parent = header
    })
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Área de conteúdo
    local content = criar("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -55),
        Position = UDim2.new(0, 10, 0, 45),
        Parent = main
    })

    local layout = criar("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = content
    })

    criar("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = content
    })

    -- ===== FUNÇÃO PARA CRIAR TOGGLE =====
    local function criarToggle(texto, estadoInicial, callback)
        local frame = criar("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 34),
            Parent = content
        })

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
        label.Text = texto
        label.TextColor3 = C.text
        label.TextSize = 14
        label.Position = UDim2.fromOffset(0, 6)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local bg = criar("Frame", {
            BackgroundColor3 = estadoInicial and C.accent or C.surface2,
            BackgroundTransparency = 0.2,
            Position = UDim2.new(0.82, 0, 0.15, 0),
            Size = UDim2.fromOffset(44, 24),
            Parent = frame
        })
        round(bg, 12)

        local knob = criar("Frame", {
            BackgroundColor3 = C.white,
            Position = estadoInicial and UDim2.new(0.55, 0, 0.08, 0) or UDim2.new(0.05, 0, 0.08, 0),
            Size = UDim2.fromOffset(20, 20),
            Parent = bg
        })
        round(knob, 10)

        local ativo = estadoInicial

        local function alternar()
            ativo = not ativo
            bg.BackgroundColor3 = ativo and C.accent or C.surface2
            knob.Position = ativo and UDim2.new(0.55, 0, 0.08, 0) or UDim2.new(0.05, 0, 0.08, 0)
            callback(ativo)
        end

        bg.MouseButton1Click:Connect(alternar)
        knob.MouseButton1Click:Connect(alternar)

        return frame
    end

    -- ===== OPÇÕES ESPECÍFICAS PARA SHINDO LIFE 2 =====

    -- 1. No Cooldown
    criarToggle("⚡ No Cooldown", State.NoCooldown, function(val)
        State.NoCooldown = val
        print("[Shadow] No Cooldown:", val and "ATIVADO" or "DESATIVADO")
    end)

    -- 2. Auto Farm (Farm de RELL Coins e EXP)
    criarToggle("⚔️ Auto Farm", State.AutoFarm, function(val)
        State.AutoFarm = val
        print("[Shadow] Auto Farm:", val and "ATIVADO" or "DESATIVADO")
        if val then
            task.spawn(function()
                while State.AutoFarm and screenGui.Parent do
                    pcall(function()
                        local char = Player.Character
                        if char then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                -- Procura por inimigos/NPCs próximos (Spirits, Bosses)
                                for _, obj in ipairs(workspace:GetChildren()) do
                                    if obj:IsA("Model") and obj ~= char and obj:FindFirstChild("Humanoid") then
                                        local targetHrp = obj:FindFirstChild("HumanoidRootPart")
                                        if targetHrp and (targetHrp.Position - hrp.Position).Magnitude < 50 then
                                            local hum = obj:FindFirstChildOfClass("Humanoid")
                                            if hum and hum.Health > 0 then
                                                -- Tenta usar a ferramenta equipada (ataque)
                                                local tool = char:FindFirstChildOfClass("Tool")
                                                if tool then
                                                    tool:Activate()
                                                end
                                                -- Alternativa: usar o clique do mouse para atacar
                                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                                task.wait(0.05)
                                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.3)
                end
            end)
        end
    end)

    -- 3. Auto Spin (Gira automaticamente as Bloodlines)
    criarToggle("🌀 Auto Spin", State.AutoSpin, function(val)
        State.AutoSpin = val
        print("[Shadow] Auto Spin:", val and "ATIVADO" or "DESATIVADO")
        if val then
            task.spawn(function()
                while State.AutoSpin and screenGui.Parent do
                    pcall(function()
                        -- Tenta encontrar o botão de spin na UI do jogo
                        local spinButton = nil
                        for _, gui in ipairs(CoreGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then
                                for _, btn in ipairs(gui:GetDescendants()) do
                                    if btn:IsA("TextButton") and btn.Visible and btn.Active then
                                        local text = btn.Text or ""
                                        if text:lower():find("spin") or text:lower():find("girar") then
                                            spinButton = btn
                                            break
                                        end
                                    end
                                end
                            end
                            if spinButton then break end
                        end

                        -- Se não encontrou, tenta usar RemoteEvents
                        if not spinButton then
                            for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and remote.Name:lower():find("spin") then
                                    remote:FireServer()
                                    break
                                end
                            end
                        elseif spinButton then
                            spinButton:Click()
                        end
                    end)
                    task.wait(1) -- Aguarda 1 segundo entre cada spin
                end
            end)
        end
    end)

    -- 4. Auto Quest (Aceita e completa missões automaticamente)
    criarToggle("📜 Auto Quest", State.AutoQuest, function(val)
        State.AutoQuest = val
        print("[Shadow] Auto Quest:", val and "ATIVADO" or "DESATIVADO")
        if val then
            task.spawn(function()
                while State.AutoQuest and screenGui.Parent do
                    pcall(function()
                        -- Procura por botões de missão na UI
                        for _, gui in ipairs(CoreGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then
                                for _, btn in ipairs(gui:GetDescendants()) do
                                    if btn:IsA("TextButton") and btn.Visible and btn.Active then
                                        local text = btn.Text or ""
                                        if text:lower():find("quest") or text:lower():find("missão") or text:lower():find("accept") or text:lower():find("complete") then
                                            btn:Click()
                                            task.wait(0.5)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        end
    end)

    -- 5. Speed Hack
    criarToggle("🏃 Speed Hack", State.SpeedHack, function(val)
        State.SpeedHack = val
        print("[Shadow] Speed Hack:", val and "ATIVADO" or "DESATIVADO")
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = val and 50 or 16
            end
        end)
    end)

    -- ===== LOOP DO NO COOLDOWN =====
    task.spawn(function()
        while true do
            task.wait(0.5)
            if State.NoCooldown then
                pcall(function()
                    local char = Player.Character
                    if char then
                        -- Zera valores de cooldown no personagem
                        for _, child in ipairs(char:GetDescendants()) do
                            if child:IsA("NumberValue") and tostring(child.Name):lower():find("cooldown") then
                                child.Value = 0
                            end
                            if child:IsA("BoolValue") and tostring(child.Name):lower():find("cooldown") then
                                child.Value = false
                            end
                            if child:IsA("IntValue") and tostring(child.Name):lower():find("cooldown") then
                                child.Value = 0
                            end
                        end
                        -- Tenta via atributos
                        if char:FindFirstChild("Attributes") then
                            for attr, value in pairs(char.Attributes:GetAttributes()) do
                                if type(value) == "number" and tostring(attr):lower():find("cooldown") then
                                    char.Attributes[attr] = 0
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- ===== DRAG =====
    local dragging, startPos, startHolder
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startHolder = holder.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            holder.Position = UDim2.new(
                startHolder.X.Scale, startHolder.X.Offset + delta.X,
                startHolder.Y.Scale, startHolder.Y.Offset + delta.Y
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

-- ===== ATALHO =====
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

print("Shadow Loader v3.0 [Shindo Life 2] carregado!")
print("Pressione RightControl para abrir/fechar.")
