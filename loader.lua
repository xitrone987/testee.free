--[[
    Cerberus Loader - Versão Livre (com Patch Premium)
    Força todas as opções premium a ficarem liberadas
]]

-- ===== CONFIGURAÇÕES =====
local CORES = {
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

local BASE_URL = "https://raw.githubusercontent.com/safetrademarketplace/scripts/refs/heads/main/"
local UNIVERSAL_URL = "https://api.luarmor.net/files/v4/loaders/1acad587672d96c8afb9c5bbc36bf921.lua"

-- Mapeamento de jogos
local GAME_SCRIPTS = {
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

-- ===== SERVIÇOS =====
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

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

local function tween(obj, duration, style, direction, props)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
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

local function label(props)
    local obj = Instance.new("TextLabel")
    obj.BackgroundTransparency = 1
    obj.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
    obj.TextColor3 = CORES.text
    obj.TextSize = 13
    obj.TextXAlignment = Enum.TextXAlignment.Left
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function formatarNome(nome)
    nome = (nome or ""):gsub("%.lua$", "")
    nome = nome:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")
    if #nome == 0 then return "Cerberus" end
    return nome:sub(1,1):upper() .. nome:sub(2)
end

local function obterGUI()
    local success, result = pcall(function() return CoreGui end)
    if success and result then return result end
    
    local player = Players.LocalPlayer
    if player then
        local gui = player:FindFirstChildOfClass("PlayerGui")
        if gui then return gui end
    end
    
    local newGui = criar("ScreenGui", {
        Name = "CerberusLoader",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999999
    })
    pcall(function() newGui.Parent = CoreGui end)
    if not newGui.Parent then
        pcall(function()
            local player = Players.LocalPlayer
            if player then
                local pg = player:FindFirstChildOfClass("PlayerGui")
                if pg then newGui.Parent = pg end
            end
        end)
    end
    return newGui
end

-- ===== PATCH PREMIUM =====
-- Função que será injetada no script para burlar verificações
local function aplicarPatch()
    -- Aguarda o script carregar e tenta patch
    local tentativas = 0
    local function patchLoop()
        tentativas = tentativas + 1
        if tentativas > 50 then return end
        
        -- Procura por objetos que indicam que o menu Cerberus está ativo
        local cerberusGui = nil
        pcall(function()
            for _, gui in ipairs(CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and (gui.Name:find("Cerberus") or gui.Name:find("cerberus") or gui.Name:find("Cérbero")) then
                    cerberusGui = gui
                    break
                end
            end
        end)
        
        if cerberusGui then
            -- Tenta encontrar e modificar verificações de premium
            pcall(function()
                -- Procura por botões/opções premium e os libera
                for _, child in ipairs(cerberusGui:GetDescendants()) do
                    if child:IsA("TextButton") or child:IsA("ImageButton") then
                        -- Libera botões que parecem premium
                        if child.Text and (child.Text:find("Premium") or child.Text:find("premium") or
                           child.Text:find("Paga") or child.Text:find("paga") or
                           child.Text:find("VIP") or child.Text:find("vip")) then
                            child.Visible = true
                            child.Active = true
                            child.Selectable = true
                            child.AutoButtonColor = true
                            child.BackgroundTransparency = 0.7
                        end
                    end
                    
                    -- Remove telas de bloqueio premium
                    if child:IsA("Frame") and child.Visible and child:FindFirstChild("TextLabel") then
                        local text = child:FindFirstChildOfClass("TextLabel")
                        if text and text.Text and (text.Text:find("premium") or text.Text:find("Premium") or
                           text.Text:find("key") or text.Text:find("Key") or
                           text.Text:find("pricing") or text.Text:find("Pricing")) then
                            child.Visible = false
                            child:Destroy()
                        end
                    end
                end
            end)
            
            -- Tenta modificar variáveis globais
            pcall(function()
                if _G.Cerberus then
                    if type(_G.Cerberus) == "table" then
                        _G.Cerberus.Premium = true
                        _G.Cerberus.HasKey = true
                        _G.Cerberus.Unlocked = true
                    end
                end
                if _G.cerberus then
                    if type(_G.cerberus) == "table" then
                        _G.cerberus.Premium = true
                        _G.cerberus.HasKey = true
                        _G.cerberus.Unlocked = true
                    end
                end
                if _G.CerberusSettings then
                    _G.CerberusSettings.Premium = true
                    _G.CerberusSettings.Unlocked = true
                end
            end)
        end
        
        task.wait(0.5)
        if cerberusGui then
            -- Se encontrou o menu, continua monitorando
            task.spawn(patchLoop)
        else
            -- Se não encontrou, tenta novamente
            task.wait(1)
            task.spawn(patchLoop)
        end
    end
    
    -- Inicia o patch
    task.spawn(patchLoop)
end

-- ===== CLASSE LOADER =====
local Loader = {}
Loader.__index = Loader

function Loader.new()
    local self = setmetatable({ conexoes = {}, pulseTween = nil }, Loader)
    
    -- Limpa UIs antigas
    pcall(function()
        for _, child in ipairs(CoreGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == "CerberusLoader" then
                child:Destroy()
            end
        end
    end)
    
    local guiParent = obterGUI()
    if not guiParent then
        guiParent = criar("ScreenGui", { Name = "CerberusLoader", Parent = CoreGui })
    end
    
    local screenGui = criar("ScreenGui", {
        Name = "CerberusLoader",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999999,
        Parent = guiParent
    })
    
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(screenGui)
        elseif protectgui then protectgui(screenGui) end
    end)
    
    self.gui = screenGui
    
    -- Container principal
    local W, H = 460, 300
    local holder = criar("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(W, H),
        Parent = screenGui
    })
    self.holder = holder
    
    local scale = criar("UIScale", { Scale = 0.94, Parent = holder })
    self.scale = scale
    
    -- Janela
    local win = criar("CanvasGroup", {
        BackgroundColor3 = CORES.bg,
        GroupTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 1,
        Parent = holder
    })
    roundCorner(win, 16)
    stroke(win, CORES.white, 0.9)
    self.win = win
    
    -- Header
    local header = criar("Frame", {
        BackgroundTransparency = 1,
        Active = true,
        Size = UDim2.new(1, 0, 0, 56),
        Parent = win
    })
    self.header = header
    
    -- Dot
    local dot = criar("Frame", {
        BackgroundColor3 = CORES.accent,
        Position = UDim2.fromOffset(22, 25),
        Size = UDim2.fromOffset(8, 8),
        Parent = header
    })
    roundCorner(dot, 4)
    
    -- Título
    local title = label({
        Text = "CERBERUS",
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
        TextSize = 16,
        Position = UDim2.fromOffset(40, 0),
        Size = UDim2.fromOffset(140, 56),
        Parent = header
    })
    criar("UIGradient", {
        Color = ColorSequence.new(CORES.accent, CORES.accentHi),
        Rotation = 90,
        Parent = title
    })
    
    -- Pill "FREE"
    local pillWrap = criar("Frame", {
        BackgroundColor3 = CORES.accent,
        Position = UDim2.fromOffset(140, 20),
        Size = UDim2.fromOffset(84, 18),
        Parent = header
    })
    roundCorner(pillWrap, 6)
    local pillStroke = stroke(pillWrap, CORES.accent, 0.25)
    
    local pillLbl = label({
        Text = "PREMIUM",
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.SemiBold),
        TextSize = 10,
        TextColor3 = CORES.accentDk,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromScale(1, 1),
        Parent = pillWrap
    })
    self.pill, self.pillStroke, self.pillLbl = pillWrap, pillStroke, pillLbl
    
    -- Close
    local closeBtn = criar("TextButton", {
        Text = "×",
        TextSize = 20,
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
        TextColor3 = CORES.subtext,
        AutoButtonColor = false,
        BackgroundColor3 = CORES.white,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0, 28),
        Size = UDim2.fromOffset(30, 30),
        Parent = header
    })
    roundCorner(closeBtn, 8)
    self:track(closeBtn.MouseButton1Click:Connect(function() self:destroy() end))
    
    -- Linha
    criar("Frame", {
        BackgroundColor3 = CORES.white,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 56),
        Size = UDim2.new(1, 0, 0, 1),
        Parent = win
    })
    
    -- Ícone
    local iconWrap = criar("Frame", {
        BackgroundColor3 = CORES.accent,
        BackgroundTransparency = 0.86,
        Position = UDim2.fromOffset(22, 78),
        Size = UDim2.fromOffset(46, 46),
        Parent = win
    })
    roundCorner(iconWrap, 12)
    local iconStroke = stroke(iconWrap, CORES.accent, 0.4)
    
    local logo = criar("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxassetid://136497541793809",
        ImageColor3 = CORES.accent,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(26, 26),
        Parent = iconWrap
    })
    self.iconWrap, self.iconStroke, self.logo = iconWrap, iconStroke, logo
    
    -- Main Title
    local mainTitle = label({
        Text = "Cerberus Loader",
        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
        TextSize = 18,
        Position = UDim2.fromOffset(84, 76),
        Size = UDim2.new(1, -106, 0, 26),
        Parent = win
    })
    self.title = mainTitle
    
    -- Body
    local scroll = criar("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CORES.faint,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Position = UDim2.fromOffset(84, 104),
        Size = UDim2.new(1, -106, 0, 92),
        Parent = win
    })
    
    local body = label({
        Text = "Carregando... (Patch Premium Ativo)",
        TextSize = 14,
        TextColor3 = CORES.subtext,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, -6, 0, 0),
        Parent = scroll
    })
    self.body = body
    
    -- Progresso
    local progWrap = criar("Frame", {
        BackgroundColor3 = CORES.track,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(22, 210),
        Size = UDim2.new(1, -44, 0, 5),
        Parent = win
    })
    roundCorner(progWrap, 3)
    
    local fill = criar("Frame", {
        BackgroundColor3 = CORES.accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = progWrap
    })
    roundCorner(fill, 3)
    self.fill = fill
    
    -- Status
    local statusRow = criar("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(22, 224),
        Size = UDim2.new(1, -44, 0, 16),
        Parent = win
    })
    
    local statusDot = criar("Frame", {
        BackgroundColor3 = CORES.accent,
        Position = UDim2.fromOffset(0, 5),
        Size = UDim2.fromOffset(6, 6),
        Parent = statusRow
    })
    roundCorner(statusDot, 3)
    
    local statusLbl = label({
        Text = "Pronto",
        TextSize = 12,
        TextColor3 = CORES.faint,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -14, 1, 0),
        Parent = statusRow
    })
    self.statusDot, self.statusLbl = statusDot, statusLbl
    
    -- Botões
    local btnRow = criar("Frame", {
        BackgroundTransparency = 1,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -16),
        Size = UDim2.new(1, -44, 0, 38),
        Parent = win
    })
    criar("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = btnRow
    })
    self.btnRow = btnRow
    
    -- Anima entrada
    tween(self.win, 0.22, nil, nil, { GroupTransparency = 0 })
    tween(self.scale, 0.32, Enum.EasingStyle.Back, nil, { Scale = 1 })
    
    -- Drag
    self:setupDrag()
    
    return self
end

function Loader:track(conn)
    table.insert(self.conexoes, conn)
    return conn
end

function Loader:setupDrag()
    local dragging, startPos, holderPos
    self:track(self.header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            holderPos = self.holder.Position
        end
    end))
    self:track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            self.holder.Position = UDim2.new(
                holderPos.X.Scale, holderPos.X.Offset + delta.X,
                holderPos.Y.Scale, holderPos.Y.Offset + delta.Y
            )
        end
    end))
    self:track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

function Loader:setStatus(text, dotColor)
    self.statusLbl.Text = text
    if dotColor then self.statusDot.BackgroundColor3 = dotColor end
end

function Loader:setTitle(text)
    self.title.Text = text
end

function Loader:setBody(text)
    self.body.Text = text
end

function Loader:setPill(text, color)
    self.pillLbl.Text = text
    self.pillLbl.TextColor3 = color
    self.pillStroke.Color = color
    self.pillStroke.Transparency = color == CORES.faint and 0.4 or 0.25
end

function Loader:setProgress(value)
    tween(self.fill, 0.35, nil, nil, {
        Size = UDim2.new(math.clamp(value, 0, 1), 0, 1, 0)
    })
end

function Loader:showButtons(buttons)
    for _, btn in ipairs(self.btnRow:GetChildren()) do
        if btn:IsA("TextButton") then btn:Destroy() end
    end
    if not buttons or #buttons == 0 then
        self.btnRow.Visible = false
        return
    end
    for i, config in ipairs(buttons) do
        local primary = config.kind == "primary"
        local w = primary and 158 or 116
        local btn = criar("TextButton", {
            Text = config.text,
            FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json",
                primary and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium),
            TextSize = 13,
            TextColor3 = primary and CORES.accentDk or CORES.subtext,
            AutoButtonColor = false,
            BackgroundColor3 = primary and CORES.accent or CORES.surface2,
            LayoutOrder = i,
            Size = UDim2.fromOffset(w, 36),
            Parent = self.btnRow
        })
        roundCorner(btn, 10)
        if not primary then stroke(btn, CORES.white, 0.9) end
        
        self:track(btn.MouseButton1Click:Connect(function()
            if config.cb then config.cb() end
        end))
    end
    self.btnRow.Visible = true
end

function Loader:showError(title, body, buttons)
    self:setPill("ERRO", CORES.danger)
    self:setTitle(title)
    self:setBody(body)
    self:setStatus("Falhou", CORES.danger)
    self.iconWrap.BackgroundColor3 = CORES.danger
    self.iconStroke.Color = CORES.danger
    self.logo.ImageColor3 = CORES.danger
    if buttons then self:showButtons(buttons) end
end

function Loader:fadeOut(callback)
    if self.pulseTween then
        self.pulseTween:Cancel()
        self.pulseTween = nil
    end
    tween(self.scale, 0.2, nil, nil, { Scale = 0.96 })
    local tw = tween(self.win, 0.2, nil, nil, { GroupTransparency = 1 })
    tw.Completed:Connect(function()
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

-- ===== FUNÇÕES DE CARREGAMENTO =====
local function getScript(url, nocache)
    local url = nocache and (url .. "?t=" .. tostring(math.random())) or url
    local success, content = pcall(function() return game:HttpGet(url) end)
    if success and type(content) == "string" and #content > 10 then
        return content
    end
    local req = (type(request) == "function" and request) or
                (type(http_request) == "function" and http_request) or
                (type(syn) == "table" and type(syn.request) == "function" and syn.request)
    if req then
        local ok, res = pcall(function()
            return req({ Url = url, Method = "GET" })
        end)
        if ok and res and res.Body and #res.Body > 10 then
            return res.Body
        end
    end
    return nil
end

-- ===== PATCH QUE É INJETADO NO SCRIPT =====
local function gerarPatchScript()
    return [[
        -- PATCH PREMIUM INJETADO
        local function patchPremium()
            -- Libera variáveis globais
            _G.Cerberus = _G.Cerberus or {}
            _G.Cerberus.Premium = true
            _G.Cerberus.HasKey = true
            _G.Cerberus.Unlocked = true
            _G.Cerberus.Key = "FREE_PREMIUM"
            
            _G.cerberus = _G.cerberus or {}
            _G.cerberus.Premium = true
            _G.cerberus.HasKey = true
            _G.cerberus.Unlocked = true
            
            -- Tenta patch no jogo
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if v.Premium ~= nil then v.Premium = true end
                        if v.HasKey ~= nil then v.HasKey = true end
                        if v.Unlocked ~= nil then v.Unlocked = true end
                        if v.IsPremium ~= nil then v.IsPremium = true end
                        if v.isPremium ~= nil then v.isPremium = true end
                        if v.isKeyValid ~= nil then v.isKeyValid = true end
                        if v.KeyValid ~= nil then v.KeyValid = true end
                        if v.keyValid ~= nil then v.keyValid = true end
                    end
                end
            end)
            
            -- Tenta patch na UI
            pcall(function()
                for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        for _, child in ipairs(gui:GetDescendants()) do
                            if child:IsA("TextLabel") and child.Text then
                                if child.Text:find("premium") or child.Text:find("Premium") then
                                    child.Text = child.Text:gsub("premium", "LIVRE"):gsub("Premium", "LIVRE")
                                end
                            end
                            if child:IsA("TextButton") and child.Text then
                                if child.Text:find("premium") or child.Text:find("Premium") then
                                    child.Text = child.Text:gsub("premium", "LIVRE"):gsub("Premium", "LIVRE")
                                end
                            end
                            if child:IsA("Frame") and child.Visible then
                                if child:FindFirstChild("TextLabel") then
                                    local txt = child:FindFirstChildOfClass("TextLabel")
                                    if txt and txt.Text and (txt.Text:find("key") or txt.Text:find("Key") or
                                       txt.Text:find("pricing") or txt.Text:find("Pricing")) then
                                        child.Visible = false
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            
            print("[PATCH] Premium liberado com sucesso!")
        end
        
        -- Executa o patch imediatamente e depois em loop
        patchPremium()
        task.spawn(function()
            while task.wait(5) do
                patchPremium()
            end
        end)
    ]]
end

local function loadAndRun(loader, url, name, nocache)
    loader:setStatus("Carregando " .. name, CORES.accent)
    loader:setProgress(0.5)
    
    local content = getScript(url, nocache)
    if not content then
        loader:showError("Falha no carregamento",
            "Não foi possível carregar " .. name .. ".\nVerifique sua conexão.",
            { { text = "Fechar", kind = "ghost", cb = function() loader:destroy() end } }
        )
        return
    end
    
    loader:setProgress(0.7)
    
    -- === INJETA O PATCH NO SCRIPT ===
    local patchCode = gerarPatchScript()
    local scriptCompleto = patchCode .. "\n\n-- Script original\n" .. content
    
    local fn, err = loadstring(scriptCompleto)
    if not fn then
        loader:showError("Erro no script",
            "O script não compilou.\n\n" .. tostring(err),
            { { text = "Fechar", kind = "ghost", cb = function() loader:destroy() end } }
        )
        return
    end
    
    loader:setStatus("Carregado! (Premium Patch Ativo)", CORES.accent)
    loader:setProgress(1)
    task.wait(0.3)
    loader:fadeOut(function()
        pcall(fn)
    end)
end

-- ===== INÍCIO =====
local loader = Loader.new()
loader:setTitle("Iniciando")
loader:setBody("Preparando Cerberus com Patch Premium...")
loader:setStatus("Detectando jogo", CORES.accent)
loader:setPill("PREMIUM", CORES.accent)

task.spawn(function()
    task.wait(0.35)
    
    local gameId = tostring(game.GameId)
    local scriptName = GAME_SCRIPTS[gameId]
    
    if not scriptName then
        loader:setPill("UNIVERSAL", CORES.amber)
        loader:setTitle("Modo Universal")
        loader:setBody("Este jogo não está no catálogo. Carregando script universal.")
        loader:setStatus("Universal", CORES.amber)
        loader.iconWrap.BackgroundColor3 = CORES.amber
        loader.iconStroke.Color = CORES.amber
        loader.logo.ImageColor3 = CORES.amber
        task.wait(0.5)
        loadAndRun(loader, UNIVERSAL_URL, "Universal", false)
        return
    end
    
    local formatted = formatarNome(scriptName)
    loader:setTitle(formatted)
    loader:setBody("Script dedicado encontrado. Patch Premium será aplicado.")
    loader:setStatus("Jogo detectado", CORES.accent)
    loader:setProgress(0.3)
    task.wait(0.3)
    
    -- Sempre premium
    loader:setPill("PREMIUM", CORES.accent)
    loader:setStatus("✅ Premium liberado via patch", CORES.accent)
    loader:setProgress(0.6)
    task.wait(0.2)
    
    local url = BASE_URL .. scriptName
    loadAndRun(loader, url, formatted, true)
end)
