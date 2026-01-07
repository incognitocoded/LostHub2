local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ АНИМАЦИЯ ПОЯВЛЕНИЯ LOSTHUB (БЕЗ БЛЮРА) ]] --
local function PlayIntro()
    local ts = game:GetService("TweenService")
    local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local text = Instance.new("TextLabel", screenGui)
    
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "LostHub"
    text.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
    text.Font = Enum.Font.GothamBold
    text.TextSize = 1
    text.TextTransparency = 1
    text.ZIndex = 10

    -- Анимация появления
    text.TextTransparency = 0
    ts:Create(text, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 80}):Play()
    
    task.wait(1.5)
    
    -- Анимация исчезновения
    ts:Create(text, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1, TextSize = 120}):Play()
    
    task.wait(1)
    screenGui:Destroy()
end

-- Запуск интро
PlayIntro()

-- [[ СОЗДАНИЕ ОКНА FLUENT ]] --
local Window = Fluent:CreateWindow({
    Title = "LOST",
    SubTitle = "Hub Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Прозрачный футер
local Footer = Instance.new("TextLabel")
Footer.Parent = Window.Root 
Footer.Position = UDim2.new(0, 20, 1, -30)
Footer.Size = UDim2.new(0, 200, 0, 20)
Footer.BackgroundTransparency = 1
Footer.Text = "TG : @LostHubScript"
Footer.TextColor3 = Color3.fromRGB(255, 255, 255)
Footer.TextTransparency = 0.5
Footer.TextXAlignment = Enum.TextXAlignment.Left
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 14

local Tabs = {
    Main = Window:AddTab({ Title = "Visuals", Icon = "eye" })
}

local Options = Fluent.Options
local lp = game:GetService("Players").LocalPlayer

-- [[ НАДЕЖНАЯ ЛОГИКА ESP ]] --
local EspToggle = Tabs.Main:AddToggle("ESPToggle", {Title = "ESP Silhouette (Обводка)", Default = false})

-- Используем RunService для постоянного обновления
game:GetService("RunService").RenderStepped:Connect(function()
    -- Проверяем, существует ли опция, чтобы не было ошибок
    local isEnabled = false
    if Fluent.Options.ESPToggle then
        isEnabled = Fluent.Options.ESPToggle.Value
    end
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= lp and player.Character then
            local char = player.Character
            local hl = char:FindFirstChild("LostHighlight")
            
            if isEnabled then
                if not hl then
                    local newHl = Instance.new("Highlight")
                    newHl.Name = "LostHighlight"
                    newHl.FillColor = Color3.fromRGB(255, 0, 0) -- Красный силуэт
                    newHl.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
                    newHl.FillTransparency = 0.5
                    newHl.OutlineTransparency = 0
                    newHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    newHl.Parent = char
                end
            else
                if hl then
                    hl:Destroy()
                end
            end
        end
    end
end)

-- Уведомление при переключении
EspToggle:OnChanged(function()
    local state = Fluent.Options.ESPToggle.Value
    Fluent:Notify({
        Title = "LostHub",
        Content = state and "ESP Активирован" or "ESP Деактивирован",
        Duration = 2
    })
end)

Window:SelectTab(1)
