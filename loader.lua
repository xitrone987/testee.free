--[[
    Cerberus Loader com Patch Premium (Shindo Life 2)
    Baixa o script original e modifica para liberar todas as funções
]]

-- ===== SERVIÇOS =====
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- ===== URL DO SCRIPT ORIGINAL =====
local CERBERUS_URL = "https://raw.githubusercontent.com/safetrademarketplace/scripts/refs/heads/main/shindoLife.lua"
-- (se esse link não funcionar, use o link do loader original que tem o mapeamento)

-- ===== FUNÇÃO PARA BAIXAR O SCRIPT =====
local function getScript(url)
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    if success and type(content) == "string" and #content > 10 then
        return content
    end
    -- Fallback para outros métodos
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

-- ===== PATCH NO CÓDIGO FONTE =====
local function patchScript(original)
    -- 1. Remove verificações de chave
    local patched = original
        :gsub("check_key%([^)]*%)", "function() return true end")
        :gsub("KEY_VALID", "true")
        :gsub("script_key", '"FREE_PREMIUM"')
        :gsub('"NO_KEY"', '"KEY_VALID"')
        :gsub('"KEY_INVALID"', '"KEY_VALID"')
        :gsub('"EXPIRED"', '"KEY_VALID"')
    
    -- 2. Força variáveis globais
    local header = [[
        -- PATCH INJETADO
        _G.Cerberus = { Premium = true, HasKey = true, Unlocked = true, NoCooldown = true }
        _G.cerberus = { Premium = true, HasKey = true, Unlocked = true, NoCooldown = true }
        _G.CERBERUS_ALLOW_NO_KEY = true
        _G.inDiscord = true
        script_key = "FREE_PREMIUM"
        getgenv().script_key = "FREE_PREMIUM"
        
        -- Substitui funções de verificação
        local oldCheck = check_key or function() return false end
        check_key = function() return true end
        getgenv().check_key = function() return true end
        
        print("[PATCH] Premium liberado com sucesso!")
    ]]
    
    return header .. "\n\n" .. patched
end

-- ===== UI SIMPLES DE CARREGAMENTO =====
local function criarUI()
    -- Remove UI antiga
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name == "CerberusPatch" then
            child:Destroy()
        end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CerberusPatch"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999
    screenGui.Parent = CoreGui

    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(screenGui)
        elseif protectgui then protectgui(screenGui) end
    end)

    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    frame.Size = UDim2.fromOffset(300, 120)
    frame.Position = UDim2.new(0.5, -150, 0.5, -60)
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.Parent = screenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
    title.Text = "Cerberus Patch"
    title.TextColor3 = Color3.fromRGB(90, 255, 140)
    title.TextSize = 18
    title.Position = UDim2.new(0, 16, 0, 12)
    title.Size = UDim2.new(1, -32, 0, 30)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
    status.Text = "Carregando script..."
    status.TextColor3 = Color3.fromRGB(240, 245, 255)
    status.TextSize = 14
    status.Position = UDim2.new(0, 16, 0, 48)
    status.Size = UDim2.new(1, -32, 0, 24)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame

    return screenGui, status
end

-- ===== MAIN =====
local ui, statusLabel = criarUI()

task.spawn(function()
    statusLabel.Text = "Baixando script original..."
    local original = getScript(CERBERUS_URL)
    
    if not original then
        statusLabel.Text = "Erro: não foi possível baixar o script."
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(3)
        ui:Destroy()
        return
    end

    statusLabel.Text = "Aplicando patch premium..."
    task.wait(0.5)
    
    local patched = patchScript(original)
    
    statusLabel.Text = "Carregando script modificado..."
    task.wait(0.5)
    
    local fn, err = loadstring(patched)
    if not fn then
        statusLabel.Text = "Erro ao compilar: " .. tostring(err)
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(3)
        ui:Destroy()
        return
    end

    statusLabel.Text = "Executando... (todas as funções liberadas)"
    statusLabel.TextColor3 = Color3.fromRGB(90, 255, 140)
    task.wait(1)
    
    -- Fecha a UI e executa o script
    ui:Destroy()
    pcall(fn)
end)

print("Cerberus Patch carregado. Aguarde...")
