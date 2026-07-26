--[[
    Cerberus Loader - Versão Livre Completa
    Todas as funcionalidades premium desbloqueadas
    Sem verificações de chave, sem cooldowns, sem restrições
]]

local a = game:GetService("UserInputService")
local b = game:GetService("TweenService")
local c = game:GetService("Players")
local d = game:GetService("CoreGui")

-- URLs dos scripts (mantidas as originais)
local e = "https://raw.githubusercontent.com/safetrademarketplace/scripts/refs/heads/main/"
local f = "https://api.luarmor.net/files/v4/loaders/1acad587672d96c8afb9c5bbc36bf921.lua"
local g = "https://getcerberus.com/discord"
local h = "rbxassetid://136497541793809"

-- Cores do tema (mantidas)
local i = {
    bg = Color3.fromRGB(12,15,21),
    surface = Color3.fromRGB(20,25,33),
    surface2 = Color3.fromRGB(27,33,43),
    track = Color3.fromRGB(38,44,56),
    text = Color3.fromRGB(233,240,250),
    subtext = Color3.fromRGB(140,150,166),
    faint = Color3.fromRGB(92,102,118),
    accent = Color3.fromRGB(90,255,140),
    accentHi = Color3.fromRGB(150,255,190),
    accentDk = Color3.fromRGB(6,28,16),
    danger = Color3.fromRGB(255,96,96),
    amber = Color3.fromRGB(255,184,70),
    white = Color3.fromRGB(255,255,255)
}

-- Mapeamento de jogos (mantido)
local j = {
    ["3764534614"] = "runeSlayer.lua",
    ["6115988515"] = "animeSaga.lua",
    ["7095682825"] = "beaks.lua",
    ["4777817887"] = "bladeBall.lua",
    ["18668065416"] = "blueLock.lua",
    ["85896571713843"] = "bgsi.lua",
    ["7018190066"] = "deadRails.lua",
    ["2880808628"] = "ffo.lua",
    ["5750914919"] = "fisch.lua",
    ["6331902150"] = "foresaken.lua",
    ["7436755782"] = "gag.lua",
    ["2535080489"] = "herosOnline.lua",
    ["7314989375"] = "hunters.lua",
    ["6048923315"] = "kaizen.lua",
    ["7513130835"] = "untitledDrillGame.lua",
    ["6931042565"] = "volleyballLegends.lua",
    ["4931927012"] = "basketballLegends.lua",
    ["6770632849"] = "mugen.lua",
    ["7218065222"] = "dig.lua",
    ["4737765103"] = "murimCultivation.lua",
    ["4871329703"] = "typeSoul.lua",
    ["5569032992"] = "dandysWorld.lua",
    ["7709344486"] = "stealABrainrot.lua",
    ["5677613211"] = "eatTheWorld.lua",
    ["7822444776"] = "buildAPlane.lua",
    ["7326934954"] = "99NITF.lua",
    ["4862269388"] = "archived.lua",
    ["8051387991"] = "rebornCultivation.lua",
    ["7882829745"] = "animeEternal.lua",
    ["7219654364"] = "murderersVsSheriffs.lua",
    ["1946714362"] = "bloodlines.lua",
    ["7718422952"] = "newMoon.lua",
    ["7671049560"] = "theForge.lua",
    ["6490954291"] = "ghoulRe.lua",
    ["9391202356"] = "ghoulRe.lua",
    ["7440311707"] = "demonHunter.lua",
    ["7024319539"] = "reawakened.lua",
    ["9363735110"] = "tsunamiBrainrot.lua",
    ["9344307274"] = "breakALuckyBlock.lua",
    ["5831253580"] = "sorcererAscent.lua",
    ["1828997286"] = "excry.lua",
    ["8144728961"] = "abyss.lua",
    ["6701277882"] = "fishIt.lua",
    ["9649298941"] = "ELFB.lua",
    ["9563386957"] = "CFB.lua",
    ["7048187681"] = "slayerbound.lua",
    ["9484779066"] = "SAB.lua",
    ["7983308985"] = "lastLetter.lua",
    ["648454481"] = "GPO.lua",
    ["9509842868"] = "gardenHorizons.lua",
    ["5130394318"] = "bizzareLineage.lua",
    ["9663968307"] = "hooked.lua",
    ["9872691883"] = "everwind.lua",
    ["4818959878"] = "mashle.lua",
    ["3726919761"] = "cursedGear.lua",
    ["8524572339"] = "bridger.lua",
    ["8202280624"] = "bbn.lua",
    ["9186719164"] = "sailor.lua",
    ["6161049307"] = "pixelBlade.lua",
    ["3646793294"] = "paradox.lua",
    ["4658598196"] = "aotr.lua",
    ["10016841656"] = "noobTD.lua",
    ["1359573625"] = "deepwoken.lua",
    ["9792947201"] = "slime.lua",
    ["6409513651"] = "animeWarriors3.lua",
    ["10006104044"] = "wizardsAlchemy.lua",
    ["2309918273"] = "vv.lua",
    ["9826885587"] = "evomon.lua",
    ["10200395747"] = "gag2.lua",
    ["2644656496"] = "hazeSeas.lua",
    ["9199655655"] = "gakuran.lua",
    ["7613921865"] = "animeExpeditions.lua",
    ["4827308727"] = "havoc.lua",
    ["7395930870"] = "sellLemons.lua",
    ["10148749921"] = "animalHospital.lua",
    ["1511883870"] = "shindoLife.lua"
}

-- Scripts gratuitos (mantido)
local k = {
    ["animeExpeditions.lua"] = true,
    ["gag2.lua"] = true,
    ["slime.lua"] = true,
    ["deepwoken.lua"] = true,
    ["sellLemons.lua"] = true,
    ["animalHospital.lua"] = true,
    ["animeWarriors3.lua"] = true,
    ["bbn.lua"] = true,
    ["shindoLife.lua"] = true
}

-- Funções auxiliares (mantidas)
local function q(tipo, props)
    local obj = Instance.new(tipo)
    if props then
        for prop, valor in pairs(props) do
            if prop ~= "Parent" then
                obj[prop] = valor
            end
        end
        if props.Parent then
            obj.Parent = props.Parent
        end
    end
    return obj
end

local function r(duracao, estilo, direcao)
    return TweenInfo.new(
        duracao,
        estilo or Enum.EasingStyle.Quad,
        direcao or Enum.EasingDirection.Out
    )
end

local function s(obj, info, props)
    local tween = b:Create(obj, info, props)
    tween:Play()
    return tween
end

local function borda(obj, raio)
    return q("UICorner", {
        CornerRadius = UDim.new(0, raio),
        Parent = obj
    })
end

local function contorno(obj, cor, transparencia, espessura)
    return q("UIStroke", {
        Color = cor,
        Transparency = transparencia or 0,
        Thickness = espessura or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj
    })
end

local function gradiente(obj, cor1, cor2, rotacao)
    return q("UIGradient", {
        Color = ColorSequence.new(cor1, cor2),
        Rotation = rotacao or 0,
        Parent = obj
    })
end

local function texto(props)
    local obj = Instance.new("TextLabel")
    obj.BackgroundTransparency = 1
    obj.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
    obj.TextColor3 = i.text
    obj.TextSize = 13
    obj.TextXAlignment = Enum.TextXAlignment.Left
    for prop, valor in pairs(props) do
        if prop ~= "Parent" then
            obj[prop] = valor
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function obterGui()
    local sucesso, resultado = pcall(function()
        return gethui and gethui()
    end)
    if sucesso and typeof(resultado) == "Instance" then
        return resultado
    end
    if d then return d end
    local jogador = c.LocalPlayer
    return jogador and jogador:FindFirstChildOfClass("PlayerGui")
end

local function formatarNome(nome)
    local nome = (nome or ""):gsub("%.lua$", "")
    nome = nome:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")
    if #nome == 0 then return "Cerberus" end
    return nome:sub(1,1):upper() .. nome:sub(2)
end

-- CLASSE PRINCIPAL DO LOADER (MODIFICADA - SEM VERIFICAÇÃO DE CHAVE)
local Loader = {}
Loader.__index = Loader

function Loader.new()
    local gui = obterGui()
    local existente = gui and gui:FindFirstChild("CerberusLoaderGui")
    if existente then existente:Destroy() end

    local self = setmetatable({
        conexoes = {},
        sweepTween = nil,
        pulseTween = nil
    }, Loader)

    -- Criar GUI principal
    local screenGui = q("ScreenGui", {
        Name = "CerberusLoaderGui",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999999
    })
    
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(screenGui)
        elseif protectgui then
            protectgui(screenGui)
        end
    end)
    
    screenGui.Parent = gui
    self.gui = screenGui

    -- Container principal
    local largura, altura = 460, 300
    local holder = q("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(largura, altura),
        Parent = screenGui
    })
    self.holder = holder
    
    local scale = q("UIScale", {
        Scale = 0.94,
        Parent = holder
    })
    self.scale = scale

    -- Janela principal
    local win = q("CanvasGroup", {
        BackgroundColor3 = i.bg,
        GroupTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 1,
        Parent = holder
    })
    borda(win, 16)
    contorno(win, i.white, 0.9)
    self.win = win

    -- HEADER
    local header = q("Frame", {
        BackgroundTransparency = 1,
        Active = true,
        Size = UDim2.new(1, 0, 0, 56),
        Parent = win
    })
    self.header = header

    -- Ícone do header
    local dot = q("Frame", {
        BackgroundColor3 = i.accent,
        Position = UDim2.fromOffset(22, 25),
        Size = UDim2.fromOffset(8, 8),
        Parent = header
    })
    borda(dot, 4)

    -- Título
    local titulo = texto({
        Text = "CERBERUS",
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
        TextSize = 16,
        Position = UDim2.fromOffset(40, 0),
        Size = UDim2.fromOffset(140, 56),
        Parent = header
    })
    gradiente(titulo, i.accent, i.accentHi, 90)

    -- Pill "FREE" (modificado)
    local pillWrap = q("Frame", {
        BackgroundColor3 = i.accent,
        Position = UDim2.fromOffset(140, 20),
        Size = UDim2.fromOffset(84, 18),
        Parent = header
    })
    borda(pillWrap, 6)
    local pillStroke = contorno(pillWrap, i.accent, 0.25)
    
    local pillLbl = texto({
        Text = "FREE",
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.SemiBold),
        TextSize = 10,
        TextColor3 = i.accentDk,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromScale(1, 1),
        Parent = pillWrap
    })
    self.pill, self.pillStroke, self.pillLbl = pillWrap, pillStroke, pillLbl

    -- Botão fechar
    local closeBtn = q("TextButton", {
        Text = "×",
        TextSize = 20,
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
        TextColor3 = i.subtext,
        AutoButtonColor = false,
        BackgroundColor3 = i.white,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0, 28),
        Size = UDim2.fromOffset(30, 30),
        Parent = header
    })
    borda(closeBtn, 8)
    
    self:track(closeBtn.MouseEnter:Connect(function()
        s(closeBtn, r(0.1), {
            BackgroundTransparency = 0.92,
            TextColor3 = i.danger
        })
    end))
    self:track(closeBtn.MouseLeave:Connect(function()
        s(closeBtn, r(0.16), {
            BackgroundTransparency = 1,
            TextColor3 = i.subtext
        })
    end))
    self:track(closeBtn.MouseButton1Click:Connect(function()
        self:destroy()
    end))

    -- Linha divisória
    q("Frame", {
        BackgroundColor3 = i.white,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 56),
        Size = UDim2.new(1, 0, 0, 1),
        Parent = win
    })

    -- Ícone central (logo)
    local iconWrap = q("Frame", {
        BackgroundColor3 = i.accent,
        BackgroundTransparency = 0.86,
        Position = UDim2.fromOffset(22, 78),
        Size = UDim2.fromOffset(46, 46),
        Parent = win
    })
    borda(iconWrap, 12)
    local iconStroke = contorno(iconWrap, i.accent, 0.4)
    
    local logo = q("ImageLabel", {
        BackgroundTransparency = 1,
        Image = h,
        ImageColor3 = i.accent,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(26, 26),
        Parent = iconWrap
    })
    
    local glyph = texto({
        Text = "",
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
        TextSize = 24,
        TextColor3 = i.accent,
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
        Size = UDim2.fromScale(1, 1),
        Parent = iconWrap
    })
    
    self.iconWrap, self.iconStroke, self.logo, self.glyph = iconWrap, iconStroke, logo, glyph

    -- Título principal
    local mainTitle = texto({
        Text = "Cerberus Loader",
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
        TextSize = 18,
        Position = UDim2.fromOffset(84, 76),
        Size = UDim2.new(1, -106, 0, 26),
        Parent = win
    })
    self.title = mainTitle

    -- Corpo do texto (rolável)
    local scroll = q("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = i.faint,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Position = UDim2.fromOffset(84, 104),
        Size = UDim2.new(1, -106, 0, 92),
        Parent = win
    })
    
    local body = texto({
        Text = "Carregando Cerberus...",
        TextSize = 14,
        TextColor3 = i.subtext,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, -6, 0, 0),
        Parent = scroll
    })
    self.body = body

    -- Barra de progresso
    local progWrap = q("Frame", {
        BackgroundColor3 = i.track,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(22, 210),
        Size = UDim2.new(1, -44, 0, 5),
        Parent = win
    })
    borda(progWrap, 3)
    
    local fill = q("Frame", {
        BackgroundColor3 = i.accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = progWrap
    })
    borda(fill, 3)
    
    local sweep = q("Frame", {
        BackgroundColor3 = i.accent,
        BorderSizePixel = 0,
        Visible = false,
        Size = UDim2.new(0.32, 0, 1, 0),
        Position = UDim2.new(-0.35, 0, 0, 0),
        Parent = progWrap
    })
    borda(sweep, 3)
    q("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = sweep
    })
    
    self.progWrap, self.fill, self.sweep = progWrap, fill, sweep

    -- Status
    local statusRow = q("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(22, 224),
        Size = UDim2.new(1, -44, 0, 16),
        Parent = win
    })
    
    local statusDot = q("Frame", {
        BackgroundColor3 = i.accent,
        Position = UDim2.fromOffset(0, 5),
        Size = UDim2.fromOffset(6, 6),
        Parent = statusRow
    })
    borda(statusDot, 3)
    
    local statusLbl = texto({
        Text = "Pronto",
        TextSize = 12,
        TextColor3 = i.faint,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -14, 1, 0),
        Parent = statusRow
    })
    
    self.statusRow, self.statusDot, self.statusLbl = statusRow, statusDot, statusLbl

    -- Botões (linha)
    local btnRow = q("Frame", {
        BackgroundTransparency = 1,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -16),
        Size = UDim2.new(1, -44, 0, 38),
        Parent = win
    })
    q("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = btnRow
    })
    self.btnRow = btnRow

    -- Inicializar
    self:entrar()
    self:arrastar()
    self:teclas()
    self:iniciarPulso()
    
    return self
end

-- MÉTODOS DA CLASSE (MODIFICADOS - SEM VERIFICAÇÃO DE CHAVE)

function Loader:track(conexao)
    table.insert(self.conexoes, conexao)
    return conexao
end

function Loader:entrar()
    s(self.win, r(0.22), { GroupTransparency = 0 })
    s(self.scale, r(0.32, Enum.EasingStyle.Back), { Scale = 1 })
end

function Loader:arrastar()
    local arrastando, posInicial, posHolder
    self:track(self.header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            arrastando = true
            posInicial = input.Position
            posHolder = self.holder.Position
        end
    end))
    
    self:track(a.InputChanged:Connect(function(input)
        if arrastando and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - posInicial
            self.holder.Position = UDim2.new(
                posHolder.X.Scale,
                posHolder.X.Offset + delta.X,
                posHolder.Y.Scale,
                posHolder.Y.Offset + delta.Y
            )
        end
    end))
    
    self:track(a.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            arrastando = false
        end
    end))
end

function Loader:teclas()
    self:track(a.InputBegan:Connect(function(input, processado)
        if not processado and input.KeyCode == Enum.KeyCode.Return then
            self:destroy()
        end
    end))
end

function Loader:iniciarPulso()
    if self.pulseTween then return end
    self.iconStroke.Transparency = 0.4
    self.pulseTween = s(
        self.iconStroke,
        TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Transparency = 0.8 }
    )
end

function Loader:pararPulso()
    if self.pulseTween then
        self.pulseTween:Cancel()
        self.pulseTween = nil
    end
    self.iconStroke.Transparency = 0.4
end

function Loader:modo(texto, cor)
    self.pillLbl.Text = texto
    self.pillLbl.TextColor3 = cor
    self.pillStroke.Color = cor
    self.pillStroke.Transparency = cor == i.faint and 0.4 or 0.25
end

function Loader:icone(cor, simbolo)
    self.iconWrap.BackgroundColor3 = cor
    self.iconStroke.Color = cor
    if simbolo then
        self.logo.Visible = false
        self.glyph.Visible = true
        self.glyph.Text = simbolo
        self.glyph.TextColor3 = cor
    else
        self.glyph.Visible = false
        self.logo.Visible = true
        self.logo.ImageColor3 = cor
    end
end

function Loader:definir(props)
    if props.title then self.title.Text = props.title end
    if props.titleColor then self.title.TextColor3 = props.titleColor end
    if props.body then self.body.Text = props.body end
    if props.status then self.statusLbl.Text = props.status end
    if props.statusDot then self.statusDot.BackgroundColor3 = props.statusDot end
end

function Loader:working(ativo)
    self.progWrap.Visible = ativo
    self.statusRow.Visible = ativo
    self.btnRow.Visible = not ativo
    if ativo then
        self:iniciarPulso()
    else
        self:pararPulso()
    end
end

function Loader:progresso(valor)
    self.sweep.Visible = false
    if self.sweepTween then
        self.sweepTween:Cancel()
        self.sweepTween = nil
    end
    s(self.fill, r(0.35), {
        Size = UDim2.new(math.clamp(valor, 0, 1), 0, 1, 0)
    })
end

function Loader:ocupado()
    self:working(true)
    self.fill.Size = UDim2.new(0, 0, 1, 0)
    self.sweep.Visible = true
    if self.sweepTween then
        self.sweepTween:Cancel()
    end
    self.sweep.Position = UDim2.new(-0.35, 0, 0, 0)
    self.sweepTween = s(
        self.sweep,
        TweenInfo.new(1.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Position = UDim2.new(1.03, 0, 0, 0) }
    )
end

function Loader:botoes(lista)
    for _, btn in ipairs(self.btnRow:GetChildren()) do
        if btn:IsA("TextButton") then
            btn:Destroy()
        end
    end
    
    if not lista or #lista == 0 then
        self.btnRow.Visible = false
        return
    end
    
    for indice, config in ipairs(lista) do
        local primario = config.kind == "primary"
        local largura = primario and 158 or 116
        
        local btn = q("TextButton", {
            Text = config.text,
            FontFace = Font.new(
                "rbxasset://fonts/families/BuilderSans.json",
                primario and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium
            ),
            TextSize = 13,
            TextColor3 = primario and i.accentDk or i.subtext,
            AutoButtonColor = false,
            BackgroundColor3 = primario and i.accent or i.surface2,
            LayoutOrder = indice,
            Size = UDim2.fromOffset(largura, 36),
            Parent = self.btnRow
        })
        borda(btn, 10)
        if not primario then
            contorno(btn, i.white, 0.9)
        end
        
        self:track(btn.MouseEnter:Connect(function()
            s(btn, r(0.1), primario and
                { BackgroundColor3 = i.accentHi } or
                { TextColor3 = i.text, BackgroundColor3 = i.track }
            )
        end))
        
        self:track(btn.MouseLeave:Connect(function()
            s(btn, r(0.16), primario and
                { BackgroundColor3 = i.accent } or
                { TextColor3 = i.subtext, BackgroundColor3 = i.surface2 }
            )
        end))
        
        self:track(btn.MouseButton1Click:Connect(function()
            if config.flash then
                local resultado = config.cb and config.cb()
                btn.Text = (resultado == false) and "Indisponível" or config.flash
                task.delay(1.4, function()
                    if btn.Parent then
                        btn.Text = config.text
                    end
                end)
            elseif config.cb then
                config.cb()
            end
        end))
    end
    
    self.btnRow.Visible = true
end

function Loader:erro(props)
    self:pararPulso()
    self:working(false)
    self:modo(props.pill or "ERRO", props.color or i.danger)
    self:icone(props.color or i.danger, props.glyph or "!")
    self:definir({
        title = props.title,
        titleColor = props.color or i.danger,
        body = props.body
    })
    self:botoes(props.buttons)
end

function Loader:desaparecer(callback)
    self:pararPulso()
    if self.sweepTween then
        self.sweepTween:Cancel()
        self.sweepTween = nil
    end
    
    s(self.scale, r(0.2), { Scale = 0.96 })
    local tween = s(self.win, r(0.2), { GroupTransparency = 1 })
    tween.Completed:Connect(function()
        self:destroy()
        if callback then callback() end
    end)
end

function Loader:destroy()
    for _, conn in ipairs(self.conexoes) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(self.conexoes)
    if self.gui then
        self.gui:Destroy()
        self.gui = nil
    end
end

-- FUNÇÕES DE CARREGAMENTO (MODIFICADAS - SEM VERIFICAÇÃO)

local function copiar(texto)
    if setclipboard then
        setclipboard(texto)
        return true
    end
    return false
end

local function obterScript(url, semCache)
    local url = semCache and (url .. "?t=" .. tostring(math.random(1, 1000000))) or url
    
    local sucesso, conteudo = pcall(function()
        return game:HttpGet(url)
    end)
    
    if sucesso and type(conteudo) == "string" and #conteudo > 10 then
        return conteudo
    end
    
    -- Fallback para outras APIs
    local requisicao = (type(request) == "function" and request) or
                      (type(http_request) == "function" and http_request) or
                      (type(syn) == "table" and type(syn.request) == "function" and syn.request)
    
    if requisicao then
        local sucesso, resposta = pcall(function()
            return requisicao({
                Url = url,
                Method = "GET"
            })
        end)
        if sucesso and resposta and resposta.Body and #resposta.Body > 10 then
            return resposta.Body
        end
    end
    
    return nil
end

local function carregarScript(url, nome, semCache)
    local loader = loaderInstance
    loader:definir({
        status = "Carregando " .. nome,
        statusDot = i.accent
    })
    loader:ocupado()
    
    local scriptContent = obterScript(url, semCache)
    
    if not scriptContent then
        loader:erro({
            title = "Não foi possível conectar",
            pill = "OFFLINE",
            body = "Não foi possível carregar " .. nome .. ". Verifique sua conexão e tente novamente.",
            buttons = {
                {
                    text = "Tentar novamente",
                    kind = "primary",
                    cb = function()
                        task.spawn(carregarScript, url, nome, semCache)
                    end
                },
                {
                    text = "Fechar",
                    kind = "ghost",
                    cb = function()
                        loader:destroy()
                    end
                }
            }
        })
        return
    end
    
    local funcao, erro = loadstring(scriptContent)
    
    if not funcao then
        loader:erro({
            title = "Erro no script",
            pill = "ERRO",
            body = "O script carregou mas não compilou. Tente novamente.\n\n" .. tostring(erro),
            buttons = {
                {
                    text = "Tentar novamente",
                    kind = "primary",
                    cb = function()
                        task.spawn(carregarScript, url, nome, semCache)
                    end
                },
                {
                    text = "Fechar",
                    kind = "ghost",
                    cb = function()
                        loader:destroy()
                    end
                }
            }
        })
        return
    end
    
    loader:definir({
        title = "Pronto",
        body = "Iniciando " .. nome .. ".",
        status = "Carregado",
        statusDot = i.accent
    })
    loader:progresso(1)
    
    task.wait(0.2)
    loader:desaparecer(function()
        pcall(funcao)
    end)
end

-- INÍCIO DO SCRIPT (MODIFICADO - SEM VERIFICAÇÃO DE CHAVE)

local loaderInstance = Loader.new()
local loader = loaderInstance

task.spawn(function()
    loader:definir({
        title = "Iniciando",
        body = "Preparando Cerberus.",
        status = "Detectando jogo",
        statusDot = i.accent
    })
    loader:ocupado()
    
    task.wait(0.35)
    
    local gameId = tostring(game.GameId)
    local scriptName = j[gameId]
    
    if not scriptName then
        loader:modo("UNIVERSAL", i.amber)
        loader:icone(i.amber, "∞")
        loader:definir({
            title = "Modo Universal",
            titleColor = i.amber,
            body = "Este jogo não está no catálogo Cerberus. Carregando script universal.",
            status = "Usando universal",
            statusDot = i.amber
        })
        loader:ocupado()
        task.wait(1.1)
        carregarScript(f, "script universal", false)
        return
    end
    
    local nomeFormatado = formatarNome(scriptName)
    local nomeArquivo = scriptName
    
    -- Verifica variação
    local variacao = _G.VARIANT
    if type(variacao) == "string" and variacao ~= "" then
        nomeArquivo = nomeArquivo:gsub("%.lua$", "") .. "." .. variacao .. ".lua"
    end
    
    loader:definir({
        title = nomeFormatado,
        body = "Script Cerberus dedicado encontrado para este jogo.",
        status = "Jogo detectado",
        statusDot = i.accent
    })
    loader:progresso(0.25)
    task.wait(0.3)
    
    -- Verifica se é script gratuito
    local isFree = k[scriptName] == true
    local allowNoKey = _G.CERBERUS_ALLOW_NO_KEY
    
    if isFree then
        loader:modo("FREE", i.accent)
        loader:definir({
            status = "Sem chave necessária",
            statusDot = i.accent
        })
    elseif allowNoKey then
        loader:modo("NO-KEY", i.amber)
        loader:definir({
            status = "Verificação de chave ignorada",
            statusDot = i.amber
        })
    else
        -- 🔥 MUDANÇA PRINCIPAL: SEMPRE LIBERA O SCRIPT 🔥
        loader:modo("FREE", i.accent)
        loader:definir({
            status = "✅ Premium desbloqueado",
            statusDot = i.accent
        })
    end
    
    loader:progresso(0.6)
    task.wait(0.2)
    
    -- Carrega o script
    local url = e .. nomeArquivo
    carregarScript(url, nomeFormatado, true)
end)
